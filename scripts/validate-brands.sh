#!/usr/bin/env bash
# Validate the firm identity registries: brand homes in workspace/firm/brands/,
# the multi-brand layout, people in workspace/firm/people/, and the distribution
# channels registry.
#
# Usage:
#   scripts/validate-brands.sh
#
# The mode is detected from the registry, never configured (Brand Scope Gate in
# AGENTS.md): 0 or 1 brand home means single-brand and the layout stays flat —
# exactly the pre-brand layout, no new fields anywhere. 2+ brand homes mean
# multi-brand: each brand's definitional entities (services, icp with personas,
# proof, channels) live inside firm/brands/{slug}/, working pipelines carry a
# {brand}/ segment in their Maister areas, and every flat straggler from before
# the migration is an error.
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

# --- Brand homes --------------------------------------------------------------
# firm/brands/{slug}/ with !_brand.md inside. A flat firm/brands/{slug}.md is
# the pre-directory shape and errors in any mode, because the mode detection
# would silently ignore it.

while IFS= read -r file; do
  [[ -n "${file}" ]] || continue
  error "${file}: brands are directories now — move to $(brands_dir)/$(slug_from_path "${file}")/!_brand.md"
done < <(non_gitkeep_md_files "$(brands_dir)")

BRAND_HOME_DIRS="services icp proof channels"

while IFS= read -r brand; do
  [[ -n "${brand}" ]] || continue
  home="$(brand_home "${brand}")"
  file="${home}/!_brand.md"

  for key in brand website status; do
    value="$(frontmatter_value "${file}" "${key}")"
    if is_empty_value "${value}"; then
      error "${file}: missing or empty frontmatter '${key}'"
    fi
  done

  fm_brand="$(frontmatter_value "${file}" "brand")"
  if [[ -n "${fm_brand}" && "${fm_brand}" != "${brand}" ]]; then
    error "${file}: brand '${fm_brand}' does not match directory '${brand}'"
  fi

  if ! [[ "${brand}" =~ ^[a-z0-9][a-z0-9-]*$ ]]; then
    error "${home}: brand slug must be kebab-case"
  fi

  status="$(frontmatter_value "${file}" "status")"
  case "${status}" in
    active | sunset | "") ;;
    *) error "${file}: invalid status '${status}' (active | sunset)" ;;
  esac

  # Only definitional entities live in a brand home. Working pipelines (content,
  # opportunities, prospecting…) stay in their Maister areas — a content/ folder
  # appearing here is the drift this check exists to catch.
  for dir in "${home}"/*/; do
    [[ -d "${dir}" ]] || continue
    name="$(basename "${dir}")"
    if ! grep -qE "(^| )${name}( |$)" <<<"${BRAND_HOME_DIRS}" && dir_has_md "${dir}"; then
      error "${dir%/}: '${name}' does not belong in a brand home (${BRAND_HOME_DIRS// /, }) — working pipelines stay in their Maister areas"
    fi
  done
done < <(list_brands)

# --- Multi-brand layout -------------------------------------------------------

if is_multi_brand; then
  # Definitional roots are empty in multi-brand mode — everything moved into
  # the brand homes. Any markdown left behind is a pre-migration straggler.
  check_empty_root() {
    local root="$1" kind="$2"
    [[ -d "${root}" ]] || return 0
    while IFS= read -r file; do
      [[ -n "${file}" ]] || continue
      error "${file}: multi-brand mode — ${kind} live in $(brands_dir)/{brand}/${kind}/ (see Brand Scope Gate in AGENTS.md)"
    done < <(find "${root}" -type f -name '*.md' ! -name '.gitkeep' 2>/dev/null | sort)
  }

  check_empty_root "${WS}/firm/services" "services"
  check_empty_root "${WS}/firm/proof" "proof"
  check_empty_root "${WS}/marketing/icp" "icp"
  check_empty_root "${WS}/marketing/channels" "channels"

  # Working-pipeline roots hold brand segments only.
  check_segment_root() {
    local root="$1"
    [[ -d "${root}" ]] || return 0

    while IFS= read -r file; do
      [[ -n "${file}" ]] || continue
      error "${file}: multi-brand mode — move into a {brand}/ segment (see Brand Scope Gate in AGENTS.md)"
    done < <(non_gitkeep_md_files "${root%/}")

    local dir name
    for dir in "${root%/}"/*/; do
      [[ -d "${dir}" ]] || continue
      name="$(basename "${dir}")"
      if ! brand_exists "${name}" && dir_has_md "${dir}"; then
        error "${dir%/}: '${name}' is not a brand in $(brands_dir)/ — multi-brand roots hold brand segments only"
      fi
    done
  }

  check_segment_root "${WS}/marketing/content/"
  check_segment_root "${WS}/marketing/placements/"
  check_segment_root "${WS}/marketing/landing-pages/"
  check_segment_root "${WS}/sales/opportunities/"
  check_segment_root "${WS}/sales/prospecting/"
  check_segment_root "${WS}/intelligence/ai-visibility/"

  # --- Proof in brand homes --------------------------------------------------
  # The path names the delivering brand, so a brand: field would be the copy
  # that drifts. cross_brand gates whether a sibling brand may cite the record.

  while IFS= read -r brand; do
    [[ -n "${brand}" ]] || continue
    while IFS= read -r file; do
      [[ -n "${file}" ]] || continue
      if [[ -n "$(frontmatter_value "${file}" "brand")" ]]; then
        error "${file}: drop 'brand:' — the proof record's brand is its path (Brand Scope Gate)"
      fi
      cross_brand="$(frontmatter_value "${file}" "cross_brand")"
      case "${cross_brand}" in
        true | false | "") ;;
        *) error "${file}: cross_brand must be true or false, got '${cross_brand}'" ;;
      esac
    done < <(non_gitkeep_md_files "$(brand_home "${brand}")/proof")
  done < <(list_brands)

  # --- Competitors stay shared and declare their brands ----------------------

  if [[ -d "${WS}/intelligence/competitors" ]]; then
    for comp_dir in "${WS}/intelligence/competitors"/*/; do
      [[ -d "${comp_dir}" ]] || continue
      profile="${comp_dir}!_profile.md"
      [[ -f "${profile}" ]] || continue
      comp_brands="$(frontmatter_list "${profile}" "brands" || true)"
      if [[ -z "${comp_brands}" ]]; then
        error "${profile}: multi-brand mode — declare 'brands: [...]' (which brands this competitor competes with)"
      else
        while IFS= read -r brand_item; do
          [[ -n "${brand_item}" ]] || continue
          if ! brand_exists "${brand_item}"; then
            error "${profile}: brand '${brand_item}' has no home at $(brand_home "${brand_item}")/!_brand.md"
          fi
        done <<<"${comp_brands}"
      fi
    done
  fi
fi

# --- Distribution channels ----------------------------------------------------
# The OWNED distribution surfaces — the brand's blog, X, LinkedIn, newsletter,
# Medium — the mirror of placements/, which holds third-party ones. One file per
# channel: the URL, which draft types feed it, how publishing happens, and on
# what schedule. Single-brand: workspace/marketing/channels/; multi-brand:
# firm/brands/{brand}/channels/.

KNOWN_CONTENT_TYPES="blog_post linkedin_post x_post case_study landing_page prospecting_sequence"

check_channel_file() {
  local file="$1"
  local slug
  slug="$(slug_from_path "${file}")"

  for key in channel platform url status content_types publish_via schedule; do
    value="$(frontmatter_value "${file}" "${key}")"
    if [[ "${key}" == "content_types" ]]; then
      value="$(frontmatter_list "${file}" "content_types" | head -1 || true)"
    fi
    if is_empty_value "${value}"; then
      error "${file}: missing or empty frontmatter '${key}'"
    fi
  done

  channel="$(frontmatter_value "${file}" "channel")"
  if [[ -n "${channel}" && "${channel}" != "${slug}" ]]; then
    error "${file}: channel '${channel}' does not match filename '${slug}'"
  fi

  url="$(frontmatter_value "${file}" "url")"
  if [[ -n "${url}" ]] && ! [[ "${url}" =~ ^https?:// ]]; then
    error "${file}: url must start with http:// or https://, got '${url}'"
  fi

  status="$(frontmatter_value "${file}" "status")"
  case "${status}" in
    active | paused | retired | "") ;;
    *) error "${file}: invalid status '${status}' (active | paused | retired)" ;;
  esac

  while IFS= read -r ctype; do
    [[ -n "${ctype}" ]] || continue
    if ! grep -qE "(^| )${ctype}( |$)" <<<"${KNOWN_CONTENT_TYPES}"; then
      error "${file}: unknown content_types value '${ctype}' (${KNOWN_CONTENT_TYPES// /, })"
    fi
  done < <(frontmatter_list "${file}" "content_types" || true)
}

if is_multi_brand; then
  while IFS= read -r brand; do
    [[ -n "${brand}" ]] || continue
    while IFS= read -r file; do
      [[ -n "${file}" ]] || continue
      check_channel_file "${file}"
    done < <(non_gitkeep_md_files "$(brand_home "${brand}")/channels")
  done < <(list_brands)
else
  while IFS= read -r file; do
    [[ -n "${file}" ]] || continue
    check_channel_file "${file}"
  done < <(non_gitkeep_md_files "${WS}/marketing/channels")
fi

# --- People -------------------------------------------------------------------
# workspace/firm/people/ is optional in both modes: the shared team, one file per
# person. It is an assignment registry, never a PSA — rates, hours, utilization,
# capacity, and salary are rejected outright, the same guard as exact money in
# workspace/clients/. Once people exist, every 'owner:' in placements, channels,
# and PDCA area READMEs must resolve to a person slug — free-text owners stop
# being checkable the day two brands share one team.

PEOPLE_DIR="${WS}/firm/people"
people_slugs=""

while IFS= read -r file; do
  [[ -n "${file}" ]] || continue
  slug="$(slug_from_path "${file}")"
  people_slugs="${people_slugs} ${slug}"

  for key in person name role; do
    value="$(frontmatter_value "${file}" "${key}")"
    if is_empty_value "${value}"; then
      error "${file}: missing or empty frontmatter '${key}'"
    fi
  done

  person="$(frontmatter_value "${file}" "person")"
  if [[ -n "${person}" && "${person}" != "${slug}" ]]; then
    error "${file}: person '${person}' does not match filename '${slug}'"
  fi

  status="$(frontmatter_value "${file}" "status")"
  case "${status}" in
    active | inactive | "") ;;
    *) error "${file}: invalid status '${status}' (active | inactive)" ;;
  esac

  for banned in rate hours hours_logged utilization capacity salary cost; do
    if grep -qE "^${banned}:[[:space:]]*[^[:space:]]" "${file}"; then
      error "${file}: '${banned}' does not belong in ${PEOPLE_DIR}/ — this is an assignment registry, not a PSA"
    fi
  done

  if is_multi_brand; then
    while IFS= read -r brand_item; do
      [[ -n "${brand_item}" ]] || continue
      [[ "${brand_item}" == "all" ]] && continue
      if ! brand_exists "${brand_item}"; then
        error "${file}: brand '${brand_item}' has no home at $(brand_home "${brand_item}")/!_brand.md"
      fi
    done < <(frontmatter_list "${file}" "brands" || true)
  fi
done < <(non_gitkeep_md_files "${PEOPLE_DIR}")

if [[ -n "${people_slugs}" ]]; then
  check_owner() {
    local file="$1" owner
    owner="$(frontmatter_value "${file}" "owner")"
    is_empty_value "${owner}" && return 0
    if ! grep -qE "(^| )${owner}( |$)" <<<"${people_slugs}"; then
      error "${file}: owner '${owner}' is not a person in ${PEOPLE_DIR}/"
    fi
  }

  while IFS= read -r file; do
    [[ -n "${file}" ]] || continue
    check_owner "${file}"
  done < <(find "${WS}/marketing/placements" "${WS}/marketing/channels" \
    "$(brands_dir)" -type f -name '*.md' ! -name '.gitkeep' 2>/dev/null | sort)

  while IFS= read -r file; do
    [[ -n "${file}" ]] || continue
    check_owner "${file}"
  done < <(find "${WS}/pdca" -mindepth 2 -maxdepth 2 -type f -name 'README.md' 2>/dev/null | sort)
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
