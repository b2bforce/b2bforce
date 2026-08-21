#!/usr/bin/env bash
# Validate a PDCA cycle file written by firm-pdca-cycle.
#
# Usage:
#   scripts/validate-pdca-cycle.sh workspace/pdca/content-to-pipeline/cycles/2026-W31--coverage.md
#
# Enforces the structural discipline the loop depends on: acceptance criteria
# exist before any work is logged, a closed cycle carries an explicit decision
# backed by an evaluation, and only an outcome-cadence cycle may scale or stop.
#
# Set B2BFORCE_ROOT to validate a workspace other than workspace/ — used by
# scripts/demo-check.sh against the demo firm in examples/.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

source "${ROOT_DIR}/scripts/lib/workspace.sh"
require_workspace

CYCLE_FILE="${1:-}"
errors=()

error() {
  errors+=("$1")
}

if [[ -z "${CYCLE_FILE}" ]]; then
  error "Missing cycle path. Usage: scripts/validate-pdca-cycle.sh {cycle-path}"
elif [[ ! -f "${CYCLE_FILE}" ]]; then
  error "Cycle file does not exist: ${CYCLE_FILE}"
fi

if [[ -f "${CYCLE_FILE}" ]]; then
  case "${CYCLE_FILE}" in
    "${WS}"/pdca/*/cycles/*.md) ;;
    *) error "${CYCLE_FILE}: cycles must live in ${WS}/pdca/{area}/cycles/" ;;
  esac

  base_name="$(basename "${CYCLE_FILE}")"
  if ! [[ "${base_name}" =~ ^[0-9]{4}-W[0-9]{2}--[a-z0-9-]+\.md$ ]]; then
    error "${CYCLE_FILE}: filename must be {YYYY}-W{ww}--{slug}.md"
  fi

  for key in area cycle_id cadence status baseline_quality opened check_due; do
    value="$(frontmatter_value "${CYCLE_FILE}" "${key}")"
    if is_empty_value "${value}"; then
      error "${CYCLE_FILE}: missing or empty frontmatter '${key}'"
    fi
  done

  cadence="$(frontmatter_value "${CYCLE_FILE}" "cadence")"
  case "${cadence}" in
    fast | outcome | "") ;;
    *) error "${CYCLE_FILE}: invalid cadence '${cadence}' (fast | outcome)" ;;
  esac

  status="$(frontmatter_value "${CYCLE_FILE}" "status")"
  case "${status}" in
    planning | doing | evaluating | closed | blocked | waiting_for_data | "") ;;
    *) error "${CYCLE_FILE}: invalid status '${status}'" ;;
  esac

  baseline_quality="$(frontmatter_value "${CYCLE_FILE}" "baseline_quality")"
  case "${baseline_quality}" in
    high | medium | low | waiting | "") ;;
    *) error "${CYCLE_FILE}: invalid baseline_quality '${baseline_quality}'" ;;
  esac

  # All eleven sections must be present, even when short.
  for heading in "Goal" "Baseline" "Hypothesis" "Acceptance Criteria" "Plan" \
    "Do Log" "Eval Results" "Check" "Act" "Blockers" "Next Cycle Inputs"; do
    if ! grep -qE "^## ${heading}[[:space:]]*$" "${CYCLE_FILE}"; then
      error "${CYCLE_FILE}: missing section '## ${heading}'"
    fi
  done

  # The rule the loop exists to enforce: criteria precede the work.
  if ! section_is_empty "${CYCLE_FILE}" "Do Log"; then
    if section_is_empty "${CYCLE_FILE}" "Acceptance Criteria"; then
      error "${CYCLE_FILE}: Do Log has entries but Acceptance Criteria is empty — criteria must be written before Do"
    fi
  fi

  if [[ "${status}" == "closed" ]]; then
    decision="$(frontmatter_value "${CYCLE_FILE}" "decision")"
    closed_at="$(frontmatter_value "${CYCLE_FILE}" "closed")"

    if is_empty_value "${closed_at}"; then
      error "${CYCLE_FILE}: closed cycle must set 'closed' date"
    fi

    case "${decision}" in
      maintain | standardize | scale | change | stop | observe_longer | ask_owner) ;;
      "") error "${CYCLE_FILE}: closed cycle must set 'decision'" ;;
      *) error "${CYCLE_FILE}: invalid decision '${decision}'" ;;
    esac

    if [[ "${decision}" == "scale" || "${decision}" == "stop" ]]; then
      if [[ "${cadence}" != "outcome" ]]; then
        error "${CYCLE_FILE}: decision '${decision}' requires cadence 'outcome'"
      fi
    fi

    if section_is_empty "${CYCLE_FILE}" "Eval Results"; then
      error "${CYCLE_FILE}: closed cycle must record Eval Results — run firm-pdca-eval"
    fi

    if section_is_empty "${CYCLE_FILE}" "Check"; then
      error "${CYCLE_FILE}: closed cycle must record Check"
    fi

    if section_is_empty "${CYCLE_FILE}" "Next Cycle Inputs"; then
      error "${CYCLE_FILE}: closed cycle must record Next Cycle Inputs"
    fi
  fi

  if [[ "${status}" == "blocked" ]] && section_is_empty "${CYCLE_FILE}" "Blockers"; then
    error "${CYCLE_FILE}: blocked cycle must describe the blocker and the decision the owner has to make"
  fi
fi

if [[ "${#errors[@]}" -gt 0 ]]; then
  echo "PDCA cycle validation: FAIL"
  echo ""
  for item in "${errors[@]}"; do
    echo "- ${item}"
  done
  exit 1
fi

echo "PDCA cycle validation: OK"
