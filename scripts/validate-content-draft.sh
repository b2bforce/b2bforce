#!/usr/bin/env bash
# Validate a generated content draft after an idea -> draft skill runs.
#
# Usage:
#   scripts/validate-content-draft.sh workspace/marketing/content/drafts/blog/example.md

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

DRAFT_FILE="${1:-}"
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

body_text() {
  local file="$1"
  awk '
    BEGIN { in_fm = 0; seen = 0; done_fm = 0 }
    /^---[[:space:]]*$/ {
      if (!seen) { in_fm = 1; seen = 1; next }
      if (in_fm) { in_fm = 0; done_fm = 1; next }
    }
    done_fm || !seen { print }
  ' "${file}"
}

word_count() {
  body_text "$1" | wc -w | tr -d ' '
}

# Words in the first real paragraph of prose, skipping headings, HTML comments, and
# blockquotes. Used for the answer-first opening rule in docs/content-generation.md.
opening_paragraph_words() {
  body_text "$1" | awk '
    /^[[:space:]]*$/ { if (started) exit; next }
    /^[[:space:]]*(#|<!--|>|!\[|\||-{3,})/ { if (started) exit; next }
    { started = 1; print }
  ' | wc -w | tr -d ' '
}

char_count() {
  printf "%s" "$1" | wc -m | tr -d ' '
}

expected_dir_for_type() {
  case "$1" in
    blog_post) echo "workspace/marketing/content/drafts/blog/" ;;
    linkedin_post) echo "workspace/marketing/content/drafts/linkedin/" ;;
    x_post) echo "workspace/marketing/content/drafts/x/" ;;
    case_study) echo "workspace/marketing/content/drafts/case-studies/" ;;
    *) echo "" ;;
  esac
}

if [[ -z "${DRAFT_FILE}" ]]; then
  error "Missing draft path. Usage: scripts/validate-content-draft.sh {draft-path}"
elif [[ ! -f "${DRAFT_FILE}" ]]; then
  error "Draft file does not exist: ${DRAFT_FILE}"
fi

required_keys=(idea content_type buying_stage service icp persona generated_at)

if [[ -f "${DRAFT_FILE}" ]]; then
  content_type="$(frontmatter_value "${DRAFT_FILE}" "content_type")"
  buying_stage="$(frontmatter_value "${DRAFT_FILE}" "buying_stage")"
  words="$(word_count "${DRAFT_FILE}")"
  body="$(body_text "${DRAFT_FILE}")"

  for key in "${required_keys[@]}"; do
    value="$(frontmatter_value "${DRAFT_FILE}" "${key}")"
    if is_empty_value "${value}"; then
      error "${DRAFT_FILE}: missing or empty frontmatter '${key}'"
    fi
  done

  expected_dir="$(expected_dir_for_type "${content_type}")"
  if [[ -z "${expected_dir}" ]]; then
    error "${DRAFT_FILE}: invalid content_type '${content_type}'"
  elif [[ "${DRAFT_FILE}" != "${expected_dir}"*.md ]]; then
    error "${DRAFT_FILE}: ${content_type} drafts must be in ${expected_dir}"
  fi

  case "${buying_stage}" in
    problem|concept|education|decision|vendor) ;;
    *) error "${DRAFT_FILE}: invalid buying_stage '${buying_stage}'" ;;
  esac

  case "${content_type}:${buying_stage}" in
    case_study:decision|case_study:vendor) ;;
    landing_page:*) error "${DRAFT_FILE}: landing_page is handled by marketing-service-page, not content draft validation" ;;
    case_study:*) error "${DRAFT_FILE}: ${content_type} cannot use buying_stage '${buying_stage}'" ;;
  esac

  case "${content_type}" in
    blog_post)
      if [[ "${words}" -lt 800 || "${words}" -gt 1500 ]]; then
        error "${DRAFT_FILE}: blog_post should be 800-1500 words; got ${words}"
      fi
      if ! grep -q '^## ' "${DRAFT_FILE}"; then
        error "${DRAFT_FILE}: blog_post should use Markdown H2 sections"
      fi
      if grep -qiE '^(#|## )[[:space:]]*(summary|conclusion|conclusions)[[:space:]]*$|in conclusion' "${DRAFT_FILE}"; then
        error "${DRAFT_FILE}: avoid generic summary/conclusion sections"
      fi
      # Answer-first opening: target 40-60 words. The window is wider than the target
      # because this is a proxy for "answers the buyer_question up front" — it catches a
      # one-line teaser and a rambling wind-up, and leaves the rest to judgment.
      opening="$(opening_paragraph_words "${DRAFT_FILE}")"
      if [[ "${opening}" -lt 25 || "${opening}" -gt 90 ]]; then
        error "${DRAFT_FILE}: opening paragraph is ${opening} words; answer the buyer_question directly in 40-60 (see docs/content-generation.md)"
      fi
      ;;
    linkedin_post)
      if [[ "${words}" -gt 300 ]]; then
        error "${DRAFT_FILE}: linkedin_post should be at most 300 words; got ${words}"
      fi
      if printf "%s\n" "${body}" | grep -qE '^#{1,6}[[:space:]]'; then
        error "${DRAFT_FILE}: linkedin_post body should not use Markdown headers"
      fi
      hashtags="$(printf "%s\n" "${body}" | grep -o '#[A-Za-z0-9_][A-Za-z0-9_]*' | wc -l | tr -d ' ' || true)"
      if [[ "${hashtags}" -lt 2 || "${hashtags}" -gt 3 ]]; then
        error "${DRAFT_FILE}: linkedin_post should end with 2-3 hashtags; got ${hashtags}"
      fi
      ;;
    x_post)
      if grep -qiE 'https?://' "${DRAFT_FILE}"; then
        error "${DRAFT_FILE}: x_post should not include external links in the body"
      fi
      current=""
      while IFS= read -r line || [[ -n "${line}" ]]; do
        if [[ "${line}" == "---" ]]; then
          count="$(char_count "${current}")"
          if [[ "${count}" -gt 280 ]]; then
            error "${DRAFT_FILE}: tweet exceeds 280 characters (${count})"
          fi
          current=""
        else
          current="${current}${line}
"
        fi
      done <<<"${body}"
      count="$(char_count "${current}")"
      if [[ "${count}" -gt 280 ]]; then
        error "${DRAFT_FILE}: tweet exceeds 280 characters (${count})"
      fi
      ;;
    case_study)
      if [[ "${words}" -lt 500 || "${words}" -gt 1500 ]]; then
        error "${DRAFT_FILE}: case_study should be 500-1500 words; got ${words}"
      fi
      if ! grep -qiE 'problem|challenge|solution|transformation|result|response|cta' "${DRAFT_FILE}"; then
        error "${DRAFT_FILE}: case_study should show PASTOR-style sections or equivalent flow"
      fi
      ;;
  esac
fi

if [[ "${#errors[@]}" -gt 0 ]]; then
  echo "Content draft validation: FAIL"
  echo ""
  for item in "${errors[@]}"; do
    echo "- ${item}"
  done
  exit 1
fi

echo "Content draft validation: OK"
