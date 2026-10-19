#!/usr/bin/env bash
# Validate positioning records written by marketing-positioning.
#
# Usage:
#   scripts/validate-positioning.sh
#
# Checks every record in workspace/firm/positioning/ — multi-brand: in each
# brand home's positioning/ — against the schema in docs/WORKSPACE.md,
# "Positioning record": scope and filename agree, services and ICP resolve in the
# record's own brand, every difference has a proof record (Proof Gate), at most
# two differences, at least one alternative, and no second source of the same
# statement (profile prose, or a brand's positioning: field, next to all.md).
#
# Set B2BFORCE_ROOT to validate a workspace other than workspace/ — used by
# scripts/demo-check.sh against the demo fixtures in examples/.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

source "${ROOT_DIR}/scripts/lib/workspace.sh"
require_workspace

STALE_DAYS=365
errors=()
warnings=()
records=0

error() {
  errors+=("$1")
}

warn() {
  warnings+=("$1")
}

# Prints the rows of the "## Parts" table as "label<TAB>source", header and
# separator rows skipped.
parts_rows() {
  section_body "$1" "Parts" | awk -F'|' '
    /^[[:space:]]*\|/ {
      label = $2; source = $4
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", label)
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", source)
      if (label == "Part" || label ~ /^-+$/ || label == "") next
      print label "\t" source
    }
  '
}

check_record() {
  local file="$1" brand="$2" scope_dir="$3"
  local slug services count icp icp_file status reviewed age

  slug="$(slug_from_path "${file}")"
  records=$((records + 1))

  for key in services icp status reviewed_at; do
    if [[ "${key}" == "services" ]]; then
      [[ -n "$(frontmatter_list "${file}" "services" | head -1 || true)" ]] && continue
    elif ! is_empty_value "$(frontmatter_value "${file}" "${key}")"; then
      continue
    fi
    error "${file}: missing or empty frontmatter '${key}'"
  done

  if [[ -n "$(frontmatter_value "${file}" "brand")" ]]; then
    error "${file}: drop 'brand:' — a positioning record's brand is its path (Brand Scope Gate)"
  fi

  status="$(frontmatter_value "${file}" "status")"
  case "${status}" in
    draft | active | retired | "") ;;
    *) error "${file}: invalid status '${status}' (draft | active | retired)" ;;
  esac

  # --- Scope: services list and filename agree -------------------------------
  services="$(frontmatter_list "${file}" "services" || true)"
  count="$(printf "%s\n" "${services}" | grep -c '[^[:space:]]' || true)"

  if [[ "${services}" == "all" ]]; then
    [[ "${slug}" == "all" ]] || error "${file}: services: all belongs in all.md"
  elif [[ "${slug}" == "all" ]]; then
    error "${file}: all.md must declare services: all"
  else
    local svc svc_file
    while IFS= read -r svc; do
      [[ -n "${svc}" ]] || continue
      case "${svc}" in
        */*)
          error "${file}: service '${svc}' — a positioning record covers its own brand's services only, as bare slugs"
          continue
          ;;
        all)
          error "${file}: 'all' cannot be combined with other services"
          continue
          ;;
      esac
      svc_file="$(resolve_ref service "${svc}" "${brand}" || true)"
      if [[ -z "${svc_file}" || ! -f "${svc_file}" ]]; then
        error "${file}: service '${svc}' has no definition at ${svc_file:-$(entity_dir services "${brand}")${svc}.md}"
      fi
    done <<<"${services}"

    if [[ "${count}" -eq 1 ]]; then
      [[ "${slug}" == "${services}" ]] ||
        error "${file}: a single-service record is named after its service — expected ${services}.md"
    elif [[ "${count}" -ge 2 ]]; then
      is_empty_value "$(frontmatter_value "${file}" "label")" &&
        error "${file}: a department record (several services) needs a 'label'"
      if [[ -f "$(entity_dir services "${brand}")${slug}.md" ]]; then
        error "${file}: '${slug}' is a service slug — a department record is named after its label"
      fi
      if [[ "${status}" != "retired" ]]; then
        while IFS= read -r svc; do
          [[ -n "${svc}" ]] || continue
          dept_index="${dept_index}${scope_dir}|${svc}|${file}"$'\n'
        done <<<"${services}"
      fi
    fi
  fi

  # --- ICP: exists, and every service in scope targets it -------------------
  icp="$(frontmatter_value "${file}" "icp")"
  if ! is_empty_value "${icp}"; then
    icp_file="$(resolve_ref icp "${icp}" "${brand}" || true)"
    if [[ -z "${icp_file}" || ! -f "${icp_file}" ]]; then
      error "${file}: icp '${icp}' has no file at ${icp_file:-$(entity_dir icp "${brand}")${icp}.md}"
    fi

    local svc svc_file targeted="no"
    local scope_services="${services}"
    if [[ "${services}" == "all" ]]; then
      scope_services="$(non_gitkeep_md_files "$(entity_dir services "${brand}")" |
        while IFS= read -r f; do slug_from_path "${f}"; done)"
    fi
    while IFS= read -r svc; do
      [[ -n "${svc}" && "${svc}" != */* ]] || continue
      svc_file="$(resolve_ref service "${svc}" "${brand}" || true)"
      [[ -f "${svc_file}" ]] || continue
      if frontmatter_list "${svc_file}" "target_icps" | grep -qxF "${icp}"; then
        targeted="yes"
      elif [[ "${services}" != "all" ]]; then
        error "${file}: icp '${icp}' is not in target_icps of service '${svc}' — the scope is wider than one client group; split it"
      fi
    done <<<"${scope_services}"
    if [[ "${services}" == "all" && "${targeted}" == "no" ]]; then
      error "${file}: icp '${icp}' is not targeted by any service in scope"
    fi
  fi

  # --- Body sections -------------------------------------------------------
  if ! section_body "${file}" "Statement" | grep -qE '^[[:space:]]*>[[:space:]]*[^[:space:]]'; then
    error "${file}: '## Statement' needs the sentence as a '>' quote"
  fi

  if ! section_body "${file}" "Alternatives" | grep -qE '^[[:space:]]*-[[:space:]]+[^[:space:]]'; then
    error "${file}: '## Alternatives' needs at least one alternative — positioning starts from what the buyer would do without you"
  fi

  # --- Parts: one or two differences, each with a proof record --------------
  local rows label n differences=0 fixture_record
  rows="$(parts_rows "${file}")"
  if [[ -z "${rows}" ]]; then
    error "${file}: '## Parts' table is missing or empty"
  fi

  if section_body "${file}" "Parts" | grep -qi 'proof_needed'; then
    error "${file}: '## Parts' holds a difference marked proof_needed — move it to '## Dropped differences'"
  fi

  fixture_record="$(frontmatter_value "${file}" "fixture")"

  while IFS=$'\t' read -r label _; do
    [[ -n "${label}" ]] || continue
    [[ "${label}" =~ ^Difference[[:space:]]+([0-9]+)$ ]] || continue
    n="${BASH_REMATCH[1]}"
    differences=$((differences + 1))

    local proof_source ref proof_file ref_brand
    proof_source="$(awk -F'\t' -v want="Proof ${n}" '$1 == want { print $2; exit }' <<<"${rows}")"
    ref="$(grep -oE 'proof:[[:space:]]*[a-z0-9][a-z0-9/-]*' <<<"${proof_source}" | head -1 | sed -E 's/^proof:[[:space:]]*//' || true)"
    if [[ -z "${ref}" ]]; then
      error "${file}: 'Difference ${n}' has no 'Proof ${n}' row with 'proof: {slug}' — no record, no difference (Proof Gate)"
      continue
    fi

    proof_file="$(resolve_ref proof "${ref}" "${brand}" || true)"
    if [[ -z "${proof_file}" || ! -f "${proof_file}" ]]; then
      error "${file}: proof '${ref}' has no record at ${proof_file:-$(entity_dir proof "${brand}")${ref}.md}"
      continue
    fi

    if [[ "$(frontmatter_value "${proof_file}" "fixture")" == "true" && "${fixture_record}" != "true" ]]; then
      error "${file}: proof '${ref}' is a demo fixture — fiction is never evidence (Firm Context Gate)"
    fi

    ref_brand="${brand}"
    [[ "${ref}" == */* ]] && ref_brand="${ref%%/*}"
    if [[ "${ref_brand}" != "${brand}" ]]; then
      if [[ "$(frontmatter_value "${proof_file}" "cross_brand")" != "true" ]]; then
        error "${file}: cites proof '${ref}' delivered by brand '${ref_brand}' — needs cross_brand: true on ${proof_file}"
      fi
    elif [[ "${services}" != "all" ]]; then
      local proof_service
      proof_service="$(frontmatter_value "${proof_file}" "service")"
      if ! grep -qxF "${proof_service}" <<<"${services}"; then
        error "${file}: proof '${ref}' is for service '${proof_service}', outside this record's scope"
      fi
    fi
  done <<<"${rows}"

  if [[ -n "${rows}" && "${differences}" -eq 0 ]]; then
    error "${file}: '## Parts' has no 'Difference 1' row"
  elif [[ "${differences}" -gt 2 ]]; then
    error "${file}: ${differences} differences — one or two; needing more means the client group is too wide"
  fi

  # --- Staleness ------------------------------------------------------------
  reviewed="$(frontmatter_value "${file}" "reviewed_at")"
  if [[ "${status}" == "active" ]] && ! is_empty_value "${reviewed}"; then
    if age="$(days_since "${reviewed}")"; then
      if [[ "${age}" -gt "${STALE_DAYS}" ]]; then
        warn "${file}: reviewed ${age} days ago — alternatives change as outcomes accumulate"
      fi
    else
      error "${file}: reviewed_at '${reviewed}' is not an ISO date"
    fi
  fi
}

# --- One source: all.md replaces the old prose --------------------------------

check_single_source() {
  local brand="$1" dir="$2"
  [[ -f "${dir}all.md" ]] || return 0

  if [[ -n "${brand}" ]]; then
    local brand_file
    brand_file="$(brand_home "${brand}")/!_brand.md"
    if ! is_empty_value "$(frontmatter_value "${brand_file}" "positioning")"; then
      error "${brand_file}: remove 'positioning:' — ${dir}all.md is the brand's positioning now"
    fi
  else
    local profile="${WS}/firm/profile.md" body lines
    [[ -f "${profile}" ]] || return 0
    body="$(section_body "${profile}" "Positioning" | sed -e '/^[[:space:]]*$/d')"
    [[ -n "${body}" ]] || return 0
    lines="$(printf "%s\n" "${body}" | grep -c . || true)"
    if [[ "${lines}" -gt 1 ]] || ! grep -q 'positioning/all\.md' <<<"${body}"; then
      error "${profile}: '## Positioning' must be one line pointing at firm/positioning/all.md — two sources drift"
    fi
  fi
}

dept_index=""

validate_scope() {
  local brand="$1" dir file
  dir="$(entity_dir positioning "${brand}")"
  [[ -d "${dir}" ]] || return 0
  while IFS= read -r file; do
    [[ -n "${file}" ]] || continue
    check_record "${file}" "${brand}" "${dir}"
  done < <(non_gitkeep_md_files "${dir%/}")
  check_single_source "${brand}" "${dir}"
}

if is_multi_brand; then
  while IFS= read -r brand; do
    [[ -n "${brand}" ]] || continue
    validate_scope "${brand}"
  done < <(list_brands)
else
  validate_scope ""
fi

# A service sits in at most one department record.
if [[ -n "${dept_index}" ]]; then
  while IFS='|' read -r dir svc; do
    [[ -n "${svc}" ]] || continue
    files="$(awk -F'|' -v d="${dir}" -v s="${svc}" '$1 == d && $2 == s { print $3 }' <<<"${dept_index}" | xargs)"
    error "${dir}: service '${svc}' is in more than one department record (${files})"
  done < <(awk -F'|' 'NF == 3 { print $1 "|" $2 }' <<<"${dept_index}" | sort | uniq -d)
fi

if [[ "${#warnings[@]}" -gt 0 ]]; then
  echo "Warnings:"
  for item in "${warnings[@]}"; do
    echo "- ${item}"
  done
  echo ""
fi

if [[ "${#errors[@]}" -gt 0 ]]; then
  echo "Positioning validation: FAIL"
  echo ""
  for item in "${errors[@]}"; do
    echo "- ${item}"
  done
  exit 1
fi

echo "Positioning validation: OK (${records} records)"
