#!/usr/bin/env bash
# Validate content idea files after marketing-content-ideas generation.
#
# Usage:
#   scripts/validate-content-ideas.sh
#   scripts/validate-content-ideas.sh workspace/marketing/content/ideas
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

IDEAS_DIR="${1:-${WS}/marketing/content/ideas}"
errors=()

error() {
  errors+=("$1")
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
      gsub(/^"|"$/, "")
      print
      exit
    }
  ' "${file}"
}

is_empty_value() {
  local value="$1"
  [[ -z "${value}" || "${value}" == "null" || "${value}" == "~" ]]
}

expected_skill_for_type() {
  case "$1" in
    blog_post) echo "marketing-content-blog-post" ;;
    linkedin_post) echo "marketing-content-linkedin-post" ;;
    x_post) echo "marketing-content-x-post" ;;
    case_study) echo "marketing-content-case-study" ;;
    landing_page) echo "marketing-service-page" ;;
    prospecting_sequence) echo "sales-prospecting-sequence" ;;
    *) echo "" ;;
  esac
}

if [[ ! -d "${IDEAS_DIR}" ]]; then
  error "Missing ideas directory: ${IDEAS_DIR}"
else
  idea_count="$(find "${IDEAS_DIR}" -maxdepth 1 -type f -name '*.md' ! -name '.gitkeep' | wc -l | tr -d ' ')"
  if [[ "${idea_count}" == "0" ]]; then
    error "No content idea files found in ${IDEAS_DIR}"
  fi
fi

required_keys=(
  title
  content_type
  buying_stage
  status
  language
  service
  icp
  persona
  buyer_question
  hook_type
  unique_angle
  proof_source
  next_action
  recommended_next_skill
  research_mode
)

if [[ -d "${IDEAS_DIR}" ]]; then
  while IFS= read -r file; do
    base="$(basename "${file}")"
    content_type="$(frontmatter_value "${file}" "content_type")"
    buying_stage="$(frontmatter_value "${file}" "buying_stage")"
    target_keyword="$(frontmatter_value "${file}" "target_keyword")"
    proof_source="$(frontmatter_value "${file}" "proof_source")"
    title="$(frontmatter_value "${file}" "title")"
    recommended_next_skill="$(frontmatter_value "${file}" "recommended_next_skill")"
    research_mode="$(frontmatter_value "${file}" "research_mode")"

    for key in "${required_keys[@]}"; do
      value="$(frontmatter_value "${file}" "${key}")"
      if is_empty_value "${value}"; then
        error "${file}: missing or empty frontmatter '${key}'"
      fi
    done

    case "${content_type}" in
      blog_post|linkedin_post|x_post|case_study|landing_page|prospecting_sequence) ;;
      *) error "${file}: invalid content_type '${content_type}'" ;;
    esac

    case "${buying_stage}" in
      problem|concept|education|decision|vendor) ;;
      *) error "${file}: invalid buying_stage '${buying_stage}'" ;;
    esac

    case "${research_mode}" in
      dry_run|market_informed) ;;
      *) error "${file}: invalid research_mode '${research_mode}'" ;;
    esac

    if [[ -n "${content_type}" && -n "${buying_stage}" ]]; then
      expected_prefix="${content_type}--${buying_stage}--"
      case "${base}" in
        "${expected_prefix}"*.md) ;;
        *) error "${file}: filename must start with '${expected_prefix}'" ;;
      esac
    fi

    case "${content_type}:${buying_stage}" in
      landing_page:vendor|case_study:decision|case_study:vendor) ;;
      landing_page:*|case_study:*) error "${file}: ${content_type} cannot use buying_stage '${buying_stage}'" ;;
    esac

    expected_skill="$(expected_skill_for_type "${content_type}")"
    if [[ -n "${expected_skill}" && "${recommended_next_skill}" != "${expected_skill}" ]]; then
      error "${file}: recommended_next_skill should be '${expected_skill}'"
    fi

    case "${content_type}" in
      blog_post|landing_page) ;;
      *)
        if ! is_empty_value "${target_keyword}"; then
          error "${file}: target_keyword is only allowed for blog_post and landing_page"
        fi
        ;;
    esac

    if [[ "${content_type}" == "case_study" ]]; then
      if grep -qi 'needs real client proof before draft' <<<"${proof_source}"; then
        if ! grep -q '\[Client\]' <<<"${title}"; then
          error "${file}: placeholder case study proof requires '[Client]' in title"
        fi
      fi
      if grep -q '\[Client\]' <<<"${title}" && ! grep -qi 'needs real client proof before draft' <<<"${proof_source}"; then
        error "${file}: '[Client]' title needs proof_source 'needs real client proof before draft'"
      fi
    fi
  done < <(find "${IDEAS_DIR}" -maxdepth 1 -type f -name '*.md' ! -name '.gitkeep' | sort)
fi

if [[ "${#errors[@]}" -gt 0 ]]; then
  echo "Content ideas validation: FAIL"
  echo ""
  for item in "${errors[@]}"; do
    echo "- ${item}"
  done
  exit 1
fi

echo "Content ideas validation: OK"
