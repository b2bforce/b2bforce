#!/usr/bin/env bash
# Validate the demo fixtures in examples/ against every workspace gate.
#
# Usage:
#   scripts/demo-check.sh
#
# Two demos, one script:
#   examples/demo-firm/  — single-brand: the default layout, exactly as documented
#   examples/demo-group/ — multi-brand: two brands, {brand}/ segments, a shared
#                          client, cross-brand proof, and the people registry
#
# Each demo is both a readable example and the regression fixture for the
# validators — the group demo is additionally the regression test that the
# single-brand layout stays untouched: demo-firm must pass with no brand fields
# anywhere. Both are checked on a copy in tmp/ rather than in place, because two
# rules in scripts/validate-account.sh compare dates against today: a stale
# reviewed_at with health: green is an error, and a passed renewal_date is a
# warning. Committed ISO dates would therefore start failing on their own after
# 90 days. The offsets below are the single source of truth for the dates those
# rules read.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

# Frontmatter date fields the validators compare against today, and how far from
# today they should sit while a demo is being checked.
DATE_OFFSETS=(
  "reviewed_at:-14"
  "last_contact:-9"
  "renewal_date:+120"
)

failures=()

shift_date() {
  local offset="$1"
  date -v"${offset}d" "+%Y-%m-%d" 2>/dev/null ||
    date -d "${offset} days" "+%Y-%m-%d"
}

# Rewrites one frontmatter key in place, leaving the body untouched.
set_frontmatter_date() {
  local file="$1" key="$2" value="$3"
  awk -v key="${key}" -v value="${value}" '
    BEGIN { in_fm = 0; seen = 0 }
    /^---[[:space:]]*$/ {
      if (!seen) { in_fm = 1; seen = 1; print; next }
      if (in_fm) { in_fm = 0; print; next }
    }
    in_fm && $0 ~ "^" key ":" { print key ": " value; next }
    { print }
  ' "${file}" >"${file}.tmp" && mv "${file}.tmp" "${file}"
}

frontmatter_has_fixture_flag() {
  awk '
    BEGIN { in_fm = 0; seen = 0; found = 0 }
    /^---[[:space:]]*$/ {
      if (!seen) { in_fm = 1; seen = 1; next }
      if (in_fm) { exit }
    }
    in_fm && $0 ~ /^fixture:[[:space:]]*true[[:space:]]*$/ { found = 1 }
    END { exit found ? 0 : 1 }
  ' "$1"
}

# --- Every demo file must be marked as a fixture ------------------------------
check_fixture_markers() {
  local src="$1"
  local unmarked=()
  while IFS= read -r file; do
    frontmatter_has_fixture_flag "${file}" || unmarked+=("${file}")
  done < <(find "${src}" -type f -name '*.md' | sort)

  if [[ "${#unmarked[@]}" -gt 0 ]]; then
    echo "  FAIL  every file in ${src} needs 'fixture: true' in its frontmatter"
    for file in "${unmarked[@]}"; do
      echo "        ${file}"
    done
    failures+=("${src}: fixture markers")
  else
    echo "  OK    all files in ${src} carry fixture: true"
  fi
}

# --- Materialize a dated copy -------------------------------------------------
materialize() {
  local src="$1" tmp="$2"
  rm -rf "${tmp}"
  mkdir -p "$(dirname "${tmp}")"
  cp -R "${src}" "${tmp}"

  local entry key offset value file
  for entry in "${DATE_OFFSETS[@]}"; do
    key="${entry%%:*}"
    offset="${entry##*:}"
    value="$(shift_date "${offset}")"
    while IFS= read -r file; do
      grep -q "^${key}:" "${file}" || continue
      set_frontmatter_date "${file}" "${key}" "${value}"
    done < <(find "${tmp}" -type f -name '*.md')
  done
}

run_check() {
  local tmp="$1" label="$2"
  shift 2
  if B2BFORCE_ROOT="${tmp}" "$@" >/dev/null 2>&1; then
    echo "  OK    ${label}"
  else
    echo "  FAIL  ${label}"
    failures+=("${label}")
    # Re-run visibly so the reason is in the log rather than only the verdict.
    B2BFORCE_ROOT="${tmp}" "$@" 2>&1 | sed 's/^/        /' || true
  fi
}

# =============================================================================
# Demo 1 — single-brand firm
# =============================================================================
FIRM_SRC="examples/demo-firm"
FIRM_TMP="tmp/demo-firm"

if [[ ! -d "${FIRM_SRC}" ]]; then
  echo "Demo check: FAIL"
  echo ""
  echo "- missing ${FIRM_SRC}/"
  exit 1
fi

echo "Fixture markers:"
check_fixture_markers "${FIRM_SRC}"

materialize "${FIRM_SRC}" "${FIRM_TMP}"

echo "Workspace gates (single-brand, ${FIRM_SRC}):"
run_check "${FIRM_TMP}" "content readiness" bash scripts/validate-content-readiness.sh \
  "platform-migration" "mid-market-logistics" "cto-mid-market-logistics"
run_check "${FIRM_TMP}" "content ideas" bash scripts/validate-content-ideas.sh
run_check "${FIRM_TMP}" "content draft" bash scripts/validate-content-draft.sh \
  "${FIRM_TMP}/marketing/content/drafts/blog/why-your-monthly-release-still-takes-a-weekend.md"
run_check "${FIRM_TMP}" "proposal" bash scripts/validate-proposal.sh \
  "${FIRM_TMP}/sales/opportunities/northwind-logistics--platform-migration--2026-05/proposal.md"
run_check "${FIRM_TMP}" "client account" bash scripts/validate-account.sh
run_check "${FIRM_TMP}" "pdca cycle" bash scripts/validate-pdca-cycle.sh \
  "${FIRM_TMP}/pdca/content-to-pipeline/cycles/2026-W29--buyer-question-coverage.md"
run_check "${FIRM_TMP}" "brands (single-brand mode)" bash scripts/validate-brands.sh

# =============================================================================
# Demo 2 — multi-brand group
# =============================================================================
GROUP_SRC="examples/demo-group"
GROUP_TMP="tmp/demo-group"

if [[ ! -d "${GROUP_SRC}" ]]; then
  echo "Demo check: FAIL"
  echo ""
  echo "- missing ${GROUP_SRC}/"
  exit 1
fi

echo "Fixture markers:"
check_fixture_markers "${GROUP_SRC}"

materialize "${GROUP_SRC}" "${GROUP_TMP}"

echo "Workspace gates (multi-brand, ${GROUP_SRC}):"
run_check "${GROUP_TMP}" "brands (multi-brand mode)" bash scripts/validate-brands.sh
run_check "${GROUP_TMP}" "content readiness (--brand)" bash scripts/validate-content-readiness.sh \
  --brand bramblegate "erp-integration" "mid-market-distributors" "coo-mid-market-distribution"
run_check "${GROUP_TMP}" "content ideas (brand sweep)" bash scripts/validate-content-ideas.sh
run_check "${GROUP_TMP}" "content draft (brand path)" bash scripts/validate-content-draft.sh \
  "${GROUP_TMP}/marketing/content/bramblegate/drafts/linkedin/the-stock-number-nobody-orders-against.md"
run_check "${GROUP_TMP}" "proposal (cross-brand proof)" bash scripts/validate-proposal.sh \
  "${GROUP_TMP}/sales/opportunities/ledgerline/harrowmere-distribution--reporting-retainer--2026-06/proposal.md"
run_check "${GROUP_TMP}" "client account (shared, qualified services)" bash scripts/validate-account.sh

echo ""
if [[ "${#failures[@]}" -gt 0 ]]; then
  echo "Demo check: FAIL"
  echo ""
  for item in "${failures[@]}"; do
    echo "- ${item}"
  done
  echo ""
  echo "The demos are the fixtures for these gates. Either a demo needs updating for a"
  echo "deliberate schema change, or the change broke something real."
  exit 1
fi

echo "Demo check: OK"
