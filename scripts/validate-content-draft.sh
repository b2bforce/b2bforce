#!/usr/bin/env bash
# Validate a generated content draft after an idea -> draft skill runs.
#
# Usage:
#   scripts/validate-content-draft.sh workspace/marketing/content/drafts/blog/example.md
#   scripts/validate-content-draft.sh --reviewed workspace/marketing/content/drafts/blog/example.md
#
# A draft's sidecars sit beside it: {slug}.sources.md (claims -> sources) and
# {slug}.review.md (review pass verdicts). Support markers <!-- S1, S2 --> in the
# draft must resolve to rows in the sources file. --reviewed is the publish gate for
# long-form: every review pass passed or was waived by a human, and no [ASK:] is
# left. Rules: docs/content-generation.md, "Sources and support markers" and
# "Review passes".
#
# In multi-brand mode (Brand Scope Gate in AGENTS.md) drafts live at
# workspace/marketing/content/{brand}/drafts/{type}/ — the brand is read from the
# path, and service/icp/persona must resolve inside that brand's segment.
#
# Set B2BFORCE_ROOT to validate a workspace other than workspace/ — used by
# scripts/demo-check.sh against the demo firm in examples/.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

source "${ROOT_DIR}/scripts/lib/workspace.sh"
require_workspace

DRAFT_FILE=""
REVIEWED=""
for arg in "$@"; do
  case "${arg}" in
    --reviewed) REVIEWED="yes" ;;
    *) DRAFT_FILE="${arg}" ;;
  esac
done
errors=()

error() {
  errors+=("$1")
}

# Body without single-line HTML comments, so support markers <!-- S1 --> do not
# count as words.
prose_text() {
  body_text "$1" | sed -E 's/<!--[^>]*-->//g'
}

word_count() {
  prose_text "$1" | wc -w | tr -d ' '
}

# Words in the first real paragraph of prose, skipping headings, HTML comments, and
# blockquotes. Used for the answer-first opening rule in docs/content-generation.md.
opening_paragraph_words() {
  prose_text "$1" | awk '
    /^[[:space:]]*$/ { if (started) exit; next }
    /^[[:space:]]*(#|<!--|>|!\[|\||-{3,})/ { if (started) exit; next }
    { started = 1; print }
  ' | wc -w | tr -d ' '
}

char_count() {
  printf "%s" "$1" | wc -m | tr -d ' '
}

expected_dir_for_type() {
  local type="$1" brand="${2:-}"
  local base="${WS}/marketing/content/drafts"
  [[ -n "${brand}" ]] && base="${WS}/marketing/content/${brand}/drafts"
  case "${type}" in
    blog_post) echo "${base}/blog/" ;;
    linkedin_post) echo "${base}/linkedin/" ;;
    x_post) echo "${base}/x/" ;;
    case_study) echo "${base}/case-studies/" ;;
    *) echo "" ;;
  esac
}

if [[ -z "${DRAFT_FILE}" ]]; then
  error "Missing draft path. Usage: scripts/validate-content-draft.sh [--reviewed] {draft-path}"
elif [[ "${DRAFT_FILE}" == *.sources.md || "${DRAFT_FILE}" == *.review.md ]]; then
  error "${DRAFT_FILE}: is a draft sidecar — pass the draft itself"
  DRAFT_FILE=""
elif [[ ! -f "${DRAFT_FILE}" ]]; then
  error "Draft file does not exist: ${DRAFT_FILE}"
fi

required_keys=(idea content_type buying_stage service icp persona generated_at)

if [[ -n "${DRAFT_FILE}" && -f "${DRAFT_FILE}" ]]; then
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

  # --- Brand scope (multi-brand only) ---------------------------------------
  # The path is the draft's only source of brand; service/icp/persona refs are
  # bare slugs and must resolve inside that same brand (Brand Scope Gate).
  DRAFT_BRAND=""
  if is_multi_brand; then
    DRAFT_BRAND="$(brand_from_path "${DRAFT_FILE}" "${WS}/marketing/content" || true)"
    if [[ -z "${DRAFT_BRAND}" ]]; then
      error "${DRAFT_FILE}: multi-brand mode — drafts live at ${WS}/marketing/content/{brand}/drafts/{type}/"
    elif ! brand_exists "${DRAFT_BRAND}"; then
      error "${DRAFT_FILE}: '${DRAFT_BRAND}' is not a brand in $(brands_dir)/ — multi-brand drafts live at ${WS}/marketing/content/{brand}/drafts/{type}/"
      DRAFT_BRAND=""
    else
      for kind in service icp persona; do
        ref="$(frontmatter_value "${DRAFT_FILE}" "${kind}")"
        is_empty_value "${ref}" && continue
        case "${ref}" in
          */*)
            error "${DRAFT_FILE}: ${kind} '${ref}' — path-scoped artifacts use bare slugs, resolved in their own brand"
            continue
            ;;
        esac
        ref_file="$(resolve_ref "${kind}" "${ref}" "${DRAFT_BRAND}")"
        if [[ ! -f "${ref_file}" ]]; then
          error "${DRAFT_FILE}: ${kind} '${ref}' does not resolve in brand '${DRAFT_BRAND}' (expected ${ref_file})"
        fi
      done
    fi
  fi

  expected_dir="$(expected_dir_for_type "${content_type}" "${DRAFT_BRAND}")"
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

  # --- Sources and support markers ------------------------------------------
  # Every <!-- S… --> marker resolves to a row in {slug}.sources.md; proof and
  # workspace rows point at files that exist; public drafts cite only proof that
  # is usable publicly; T4/T5 sources never support a claim.
  SOURCES_FILE="${DRAFT_FILE%.md}.sources.md"
  marker_ids="$(grep -oE '<!--[[:space:]]*S[0-9][^>]*-->' "${DRAFT_FILE}" |
    grep -oE 'S[0-9]+(-[a-z]{2})?' | sort -u || true)"

  if [[ -n "${marker_ids}" && ! -f "${SOURCES_FILE}" ]]; then
    error "${DRAFT_FILE}: has support markers but no sources file at ${SOURCES_FILE}"
  fi

  if [[ -f "${SOURCES_FILE}" ]]; then
    # One row per line: ID<TAB>source<TAB>type<TAB>tier<TAB>accessed.
    source_rows="$(awk -F'|' '
      /^\|[[:space:]]*S[0-9]+(-[a-z][a-z])?[[:space:]]*\|/ {
        for (i = 2; i <= 8; i++) { gsub(/^[[:space:]]+|[[:space:]]+$/, "", $i) }
        printf "%s\t%s\t%s\t%s\t%s\n", $2, $4, $6, $7, $8
      }
    ' "${SOURCES_FILE}")"
    row_ids="$(printf "%s\n" "${source_rows}" | cut -f1 | sed '/^$/d')"

    duplicates="$(printf "%s\n" "${row_ids}" | sort | uniq -d)"
    for id in ${duplicates}; do
      error "${SOURCES_FILE}: row ID ${id} is used twice — IDs are never reused"
    done

    while IFS=$'\t' read -r id src type tier accessed; do
      [[ -z "${id}" ]] && continue
      where="${SOURCES_FILE}: ${id}"
      if ! [[ "${accessed}" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        error "${where}: 'Accessed' must be a YYYY-MM-DD date"
      fi
      case "${tier}" in
        T4|T5) error "${where}: tier ${tier} never supports a claim — move it to '## Rejected sources'" ;;
      esac
      case "${type}" in
        primary|secondary|competitor|author) ;;
        workspace)
          if [[ ! -f "${WS}/${src}" ]]; then
            error "${where}: workspace source '${src}' does not exist under ${WS}/"
          fi
          ;;
        proof)
          proof_file="$(resolve_ref proof "${src}" "${DRAFT_BRAND}" 2>/dev/null || true)"
          if [[ -z "${proof_file}" || ! -f "${proof_file}" ]]; then
            error "${where}: proof record '${src}' does not exist"
          elif [[ "$(frontmatter_value "${proof_file}" "usable_publicly")" != "true" ]]; then
            error "${where}: proof '${src}' has usable_publicly: false — public content may not cite it"
          elif is_multi_brand && [[ "${src}" == */* && "${src%%/*}" != "${DRAFT_BRAND}" ]] &&
            [[ "$(frontmatter_value "${proof_file}" "cross_brand")" != "true" ]]; then
            error "${where}: proof '${src}' belongs to brand '${src%%/*}' — needs cross_brand: true on ${proof_file}"
          fi
          ;;
        derived)
          for dep in $(printf "%s" "${src}" | grep -oE 'S[0-9]+(-[a-z]{2})?' || true); do
            if ! printf "%s\n" "${row_ids}" | grep -qx "${dep}"; then
              error "${where}: derived from ${dep}, which has no row"
            fi
          done
          ;;
        *) error "${where}: invalid type '${type}' (primary, secondary, workspace, proof, author, competitor, derived)" ;;
      esac
    done <<<"${source_rows}"

    for id in ${marker_ids}; do
      if ! printf "%s\n" "${row_ids}" | grep -qx "${id}"; then
        error "${DRAFT_FILE}: marker ${id} has no row in ${SOURCES_FILE}"
      fi
    done
  fi

  # --- Publish gate (--reviewed) --------------------------------------------
  if [[ -n "${REVIEWED}" ]]; then
    REVIEW_FILE="${DRAFT_FILE%.md}.review.md"
    case "${content_type}" in
      blog_post|case_study) ;;
      *) error "${DRAFT_FILE}: --reviewed applies to blog_post and case_study only" ;;
    esac

    if [[ ! -f "${SOURCES_FILE}" ]]; then
      error "${DRAFT_FILE}: no sources file at ${SOURCES_FILE} — run marketing-content-sources"
    fi
    if grep -q '\[ASK:' "${DRAFT_FILE}"; then
      error "${DRAFT_FILE}: [ASK:] markers left — answer them before publishing"
    fi

    if [[ ! -f "${REVIEW_FILE}" ]]; then
      error "${DRAFT_FILE}: no review file at ${REVIEW_FILE} — run the review passes"
    else
      draft_slug="$(slug_from_path "${DRAFT_FILE}")"
      if [[ "$(frontmatter_value "${REVIEW_FILE}" "draft")" != "${draft_slug}" ]]; then
        error "${REVIEW_FILE}: 'draft' must be '${draft_slug}'"
      fi
      round="$(frontmatter_value "${REVIEW_FILE}" "round")"
      if ! [[ "${round}" =~ ^[1-3]$ ]]; then
        error "${REVIEW_FILE}: 'round' must be 1-3 (after round 3 a human takes over); got '${round}'"
      fi

      waived=""
      for pass in factcheck consistency deslop reader_test; do
        verdict="$(frontmatter_value "${REVIEW_FILE}" "${pass}")"
        case "${verdict}" in
          pass) ;;
          waived) waived="yes" ;;
          *) error "${REVIEW_FILE}: ${pass} is '${verdict:-missing}' — must be pass, or waived by a human" ;;
        esac
      done
      if [[ -n "${waived}" ]] && is_empty_value "$(frontmatter_value "${REVIEW_FILE}" "waived_by")"; then
        error "${REVIEW_FILE}: a pass is waived but 'waived_by' names no one — only a human may waive"
      fi

      if [[ "$(frontmatter_value "${REVIEW_FILE}" "deslop")" == "pass" ]]; then
        score="$(frontmatter_value "${REVIEW_FILE}" "deslop_score")"
        if ! [[ "${score}" =~ ^[0-9]+$ ]] || [[ "${score}" -lt 35 || "${score}" -gt 50 ]]; then
          error "${REVIEW_FILE}: deslop passed but deslop_score is '${score}' — needs 35-50"
        fi
      fi

      for section in "Factcheck" "Consistency" "Deslop" "Reader test"; do
        if section_is_empty "${REVIEW_FILE}" "${section}"; then
          error "${REVIEW_FILE}: missing or empty '## ${section}'"
        fi
      done
    fi
  fi
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
