#!/usr/bin/env bash
# Validate that the workspace has enough context to generate B2B content ideas.
#
# Usage:
#   scripts/validate-content-readiness.sh
#   scripts/validate-content-readiness.sh service-slug
#   scripts/validate-content-readiness.sh service-slug icp-slug
#   scripts/validate-content-readiness.sh service-slug icp-slug persona-slug
#
# Set B2BFORCE_ROOT to validate a workspace other than workspace/ — used by
# scripts/demo-check.sh against the demo firm in examples/.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

WS="${B2BFORCE_ROOT:-workspace}"
[[ -d "${WS}" ]] || {
  echo "B2BFORCE_ROOT is not a directory: ${WS}"
  exit 1
}

SERVICE_SLUG="${1:-}"
ICP_SLUG="${2:-}"
PERSONA_SLUG="${3:-}"

errors=()

error() {
  errors+=("$1")
}

non_gitkeep_md_files() {
  local dir="$1"
  find "${dir}" -maxdepth 1 -type f -name '*.md' ! -name '.gitkeep' | sort
}

slug_from_path() {
  basename "$1" .md
}

frontmatter_value() {
  local file="$1"
  local key="$2"
  awk -v key="${key}" '
    BEGIN { in_fm = 0; seen = 0 }
    /^---[[:space:]]*$/ {
      if (!seen) { in_fm = 1; seen = 1; next }
      if (in_fm) { exit }
    }
    in_fm && $0 ~ "^" key ":" {
      sub("^" key ":[[:space:]]*", "")
      print
      exit
    }
  ' "${file}"
}

normalize_list_value() {
  tr -d '[]",' | tr "'" " " | tr ',' ' ' | xargs
}

file_has_real_content() {
  local file="$1"
  [[ -s "${file}" ]] && ! grep -qi 'status.*template' "${file}"
}

if [[ ! -f "${WS}/firm/profile.md" ]]; then
  error "Missing ${WS}/firm/profile.md"
elif ! file_has_real_content "${WS}/firm/profile.md"; then
  error "${WS}/firm/profile.md still looks like a template"
fi

service_files=()
while IFS= read -r file; do
  service_files+=("${file}")
done < <(non_gitkeep_md_files "${WS}/firm/services")

if [[ -z "${SERVICE_SLUG}" ]]; then
  if [[ "${#service_files[@]}" -eq 1 ]]; then
    SERVICE_SLUG="$(slug_from_path "${service_files[0]}")"
  elif [[ "${#service_files[@]}" -eq 0 ]]; then
    error "Missing service file in ${WS}/firm/services/{slug}.md"
  else
    error "Multiple services found; pass the service slug explicitly"
  fi
fi

SERVICE_FILE="${WS}/firm/services/${SERVICE_SLUG}.md"
if [[ -n "${SERVICE_SLUG}" ]]; then
  if [[ ! -f "${SERVICE_FILE}" ]]; then
    error "Missing service file: ${SERVICE_FILE}"
  elif ! file_has_real_content "${SERVICE_FILE}"; then
    error "${SERVICE_FILE} still looks like a template"
  fi
fi

if [[ -z "${ICP_SLUG}" && -f "${SERVICE_FILE}" ]]; then
  target_icps="$(frontmatter_value "${SERVICE_FILE}" "target_icps" | normalize_list_value || true)"
  for candidate in ${target_icps}; do
    if [[ -f "${WS}/marketing/icp/${candidate}.md" ]]; then
      ICP_SLUG="${candidate}"
      break
    fi
  done
fi

if [[ -z "${ICP_SLUG}" && -n "${SERVICE_SLUG}" ]]; then
    error "Selected service has no linked ICP. Add target_icps in ${SERVICE_FILE} or run marketing-icp"
fi

ICP_FILE="${WS}/marketing/icp/${ICP_SLUG}.md"
if [[ -n "${ICP_SLUG}" ]]; then
  if [[ ! -f "${ICP_FILE}" ]]; then
    error "Missing ICP file: ${ICP_FILE}"
  elif ! file_has_real_content "${ICP_FILE}"; then
    error "${ICP_FILE} still looks like a template"
  fi
fi

if [[ -n "${ICP_SLUG}" && -f "${SERVICE_FILE}" ]]; then
  target_icps="$(frontmatter_value "${SERVICE_FILE}" "target_icps" | normalize_list_value || true)"
  if ! grep -Eq "(^|[[:space:]])${ICP_SLUG}($|[[:space:]])" <<<"${target_icps}"; then
    error "${SERVICE_FILE} does not link ICP '${ICP_SLUG}' via target_icps"
  fi
fi

persona_files=()
while IFS= read -r file; do
  persona_files+=("${file}")
done < <(find "${WS}/marketing/icp/personas" -maxdepth 1 -type f -name '*.md' ! -name '.gitkeep' 2>/dev/null | sort)
matching_personas=()

if [[ -n "${ICP_SLUG}" ]]; then
  for persona_file in "${persona_files[@]}"; do
    persona_icp="$(frontmatter_value "${persona_file}" "icp" | normalize_list_value || true)"
    if [[ "${persona_icp}" == "${ICP_SLUG}" ]]; then
      matching_personas+=("${persona_file}")
    fi
  done
fi

if [[ -z "${PERSONA_SLUG}" && -n "${ICP_SLUG}" ]]; then
  if [[ "${#matching_personas[@]}" -eq 1 ]]; then
    PERSONA_SLUG="$(slug_from_path "${matching_personas[0]}")"
  elif [[ "${#matching_personas[@]}" -eq 0 ]]; then
    error "Missing persona for ICP '${ICP_SLUG}' in ${WS}/marketing/icp/personas/"
  else
    error "Multiple personas found for ICP '${ICP_SLUG}'; pass the persona slug explicitly"
  fi
fi

PERSONA_FILE="${WS}/marketing/icp/personas/${PERSONA_SLUG}.md"
if [[ -n "${PERSONA_SLUG}" ]]; then
  if [[ ! -f "${PERSONA_FILE}" ]]; then
    error "Missing persona file: ${PERSONA_FILE}"
  elif ! file_has_real_content "${PERSONA_FILE}"; then
    error "${PERSONA_FILE} still looks like a template"
  else
    persona_icp="$(frontmatter_value "${PERSONA_FILE}" "icp" | normalize_list_value || true)"
    if [[ "${persona_icp}" != "${ICP_SLUG}" ]]; then
      error "${PERSONA_FILE} does not point to ICP '${ICP_SLUG}'"
    fi
  fi
fi

if [[ "${#errors[@]}" -gt 0 ]]; then
  echo "Content readiness: FAIL"
  echo ""
  for item in "${errors[@]}"; do
    echo "- ${item}"
  done
  echo ""
  echo "Next step: complete firm/service setup, then run marketing-icp."
  exit 1
fi

echo "Content readiness: OK"
echo "Service: ${SERVICE_SLUG}"
echo "ICP: ${ICP_SLUG}"
echo "Persona: ${PERSONA_SLUG}"
