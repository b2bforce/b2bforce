#!/usr/bin/env bash
# Validate the demo firm in examples/demo-firm/ against every workspace gate.
#
# Usage:
#   scripts/demo-check.sh
#
# The demo is both a readable example and the regression fixture for the validators.
# It is checked on a copy in tmp/ rather than in place, because two rules in
# scripts/validate-account.sh compare dates against today: a stale reviewed_at with
# health: green is an error, and a passed renewal_date is a warning. Committed ISO
# dates would therefore start failing on their own after 90 days. The offsets below
# are the single source of truth for the dates those rules read.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

DEMO_SRC="examples/demo-firm"
DEMO_TMP="tmp/demo-firm"

# Frontmatter date fields the validators compare against today, and how far from
# today they should sit while the demo is being checked.
DATE_OFFSETS=(
  "reviewed_at:-14"
  "last_contact:-9"
  "renewal_date:+120"
)

SERVICE_SLUG="platform-migration"
ICP_SLUG="mid-market-logistics"
PERSONA_SLUG="cto-mid-market-logistics"
BLOG_DRAFT="marketing/content/drafts/blog/why-your-monthly-release-still-takes-a-weekend.md"
PROPOSAL="sales/opportunities/northwind-logistics--platform-migration--2026-05/proposal.md"
PDCA_CYCLE="pdca/content-to-pipeline/cycles/2026-W29--buyer-question-coverage.md"

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

run_check() {
  local label="$1"
  shift
  if B2BFORCE_ROOT="${DEMO_TMP}" "$@" >/dev/null 2>&1; then
    echo "  OK    ${label}"
  else
    echo "  FAIL  ${label}"
    failures+=("${label}")
    # Re-run visibly so the reason is in the log rather than only the verdict.
    B2BFORCE_ROOT="${DEMO_TMP}" "$@" 2>&1 | sed 's/^/        /' || true
  fi
}

if [[ ! -d "${DEMO_SRC}" ]]; then
  echo "Demo check: FAIL"
  echo ""
  echo "- missing ${DEMO_SRC}/"
  exit 1
fi

# --- Every demo file must be marked as a fixture ------------------------------
echo "Fixture markers:"
unmarked=()
while IFS= read -r file; do
  frontmatter_has_fixture_flag "${file}" || unmarked+=("${file}")
done < <(find "${DEMO_SRC}" -type f -name '*.md' | sort)

if [[ "${#unmarked[@]}" -gt 0 ]]; then
  echo "  FAIL  every file in ${DEMO_SRC} needs 'fixture: true' in its frontmatter"
  for file in "${unmarked[@]}"; do
    echo "        ${file}"
  done
  failures+=("fixture markers")
else
  echo "  OK    all demo files carry fixture: true"
fi

# --- Materialize a dated copy -------------------------------------------------
rm -rf "${DEMO_TMP}"
mkdir -p "$(dirname "${DEMO_TMP}")"
cp -R "${DEMO_SRC}" "${DEMO_TMP}"

for entry in "${DATE_OFFSETS[@]}"; do
  key="${entry%%:*}"
  offset="${entry##*:}"
  value="$(shift_date "${offset}")"
  while IFS= read -r file; do
    grep -q "^${key}:" "${file}" || continue
    set_frontmatter_date "${file}" "${key}" "${value}"
  done < <(find "${DEMO_TMP}" -type f -name '*.md')
done

# --- Every gate, against the demo --------------------------------------------
echo "Workspace gates:"
run_check "content readiness" bash scripts/validate-content-readiness.sh \
  "${SERVICE_SLUG}" "${ICP_SLUG}" "${PERSONA_SLUG}"
run_check "content ideas" bash scripts/validate-content-ideas.sh
run_check "content draft" bash scripts/validate-content-draft.sh "${DEMO_TMP}/${BLOG_DRAFT}"
run_check "proposal" bash scripts/validate-proposal.sh "${DEMO_TMP}/${PROPOSAL}"
run_check "client account" bash scripts/validate-account.sh
run_check "pdca cycle" bash scripts/validate-pdca-cycle.sh "${DEMO_TMP}/${PDCA_CYCLE}"

echo ""
if [[ "${#failures[@]}" -gt 0 ]]; then
  echo "Demo check: FAIL"
  echo ""
  for item in "${failures[@]}"; do
    echo "- ${item}"
  done
  echo ""
  echo "The demo is the fixture for these gates. Either the demo needs updating for a"
  echo "deliberate schema change, or the change broke something real."
  exit 1
fi

echo "Demo check: OK"
