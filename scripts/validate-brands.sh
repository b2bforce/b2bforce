#!/usr/bin/env bash
# Validate the brand registry in workspace/firm/brands/ and the brand layout.
#
# Usage:
#   scripts/validate-brands.sh
#
# The mode is detected from the registry, never configured (Brand Scope Gate in
# AGENTS.md): 0 or 1 brand file means single-brand and the layout stays flat —
# exactly the pre-brand layout, no new fields anywhere. 2+ brand files mean
# multi-brand: every market-side entity root must hold only brand-slug segments,
# and every flat straggler from before the migration is an error.
#
# Set B2BFORCE_ROOT to validate a workspace other than workspace/ — used by
# scripts/demo-check.sh against the demo fixtures in examples/.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

source "${ROOT_DIR}/scripts/lib/workspace.sh"
require_workspace

errors=()

error() {
  errors+=("$1")
}

dir_has_md() {
  find "$1" -type f -name '*.md' 2>/dev/null | head -1 | grep -q .
}

# --- Brand files --------------------------------------------------------------

brand_slugs=()
while IFS= read -r file; do
  [[ -n "${file}" ]] || continue
  slug="$(slug_from_path "${file}")"
  brand_slugs+=("${slug}")

  for key in brand website status; do
    value="$(frontmatter_value "${file}" "${key}")"
    if is_empty_value "${value}"; then
      error "${file}: missing or empty frontmatter '${key}'"
    fi
  done

  brand="$(frontmatter_value "${file}" "brand")"
  if [[ -n "${brand}" && "${brand}" != "${slug}" ]]; then
    error "${file}: brand '${brand}' does not match filename '${slug}'"
  fi

  if ! [[ "${slug}" =~ ^[a-z0-9][a-z0-9-]*$ ]]; then
    error "${file}: brand slug must be kebab-case"
  fi

  status="$(frontmatter_value "${file}" "status")"
  case "${status}" in
    active | sunset | "") ;;
    *) error "${file}: invalid status '${status}' (active | sunset)" ;;
  esac
done < <(non_gitkeep_md_files "$(brands_dir)")

# --- Multi-brand layout -------------------------------------------------------
# Each market-side root may contain only brand segments. Flat .md files are
# pre-migration stragglers. A non-brand subdirectory is tolerated only while it
# holds no markdown — the committed .gitkeep skeleton stays harmless.

if is_multi_brand; then
  check_root() {
    local root="$1"
    [[ -d "${root}" ]] || return 0

    while IFS= read -r file; do
      [[ -n "${file}" ]] || continue
      error "${file}: multi-brand mode — move into a {brand}/ segment (see Brand Scope Gate in AGENTS.md)"
    done < <(non_gitkeep_md_files "${root}")

    local dir name
    for dir in "${root}"*/; do
      [[ -d "${dir}" ]] || continue
      name="$(basename "${dir}")"
      if ! brand_exists "${name}" && dir_has_md "${dir}"; then
        error "${dir%/}: '${name}' is not a brand in $(brands_dir)/ — multi-brand roots hold brand segments only"
      fi
    done
  }

  check_root "${WS}/firm/services/"
  check_root "${WS}/marketing/icp/"
  check_root "${WS}/marketing/content/"
  check_root "${WS}/marketing/placements/"
  check_root "${WS}/marketing/landing-pages/"
  check_root "${WS}/sales/opportunities/"
  check_root "${WS}/sales/prospecting/"
  check_root "${WS}/intelligence/ai-visibility/"
fi

if [[ "${#errors[@]}" -gt 0 ]]; then
  echo "Brand validation: FAIL"
  echo ""
  for item in "${errors[@]}"; do
    echo "- ${item}"
  done
  exit 1
fi

count="$(brand_count)"
if is_multi_brand; then
  echo "Brand validation: OK (multi-brand, ${count} brands)"
else
  echo "Brand validation: OK (single-brand)"
fi
