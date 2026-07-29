#!/usr/bin/env bash
# Validate client account records.
#
# Usage:
#   scripts/validate-account.sh                              # every account
#   scripts/validate-account.sh workspace/clients/northwind   # one account
#
# Set B2BFORCE_ROOT to validate a workspace other than workspace/ — used by
# scripts/demo-check.sh against the demo firm in examples/.
#
# Enforces the Client Context Gate (a real engagement model and at least one named
# contact), the account schema, and the staleness rules from workspace/clients/README.md.
#
# Errors exit non-zero. Warnings are reported and do not fail, because a bookkeeping
# lapse should not block a QBR — with one exception. A stale review combined with
# `health: green` is an error, not a warning: that combination is an assertion the firm
# can no longer support, and a human will act on it.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

WS="${B2BFORCE_ROOT:-workspace}"
[[ -d "${WS}" ]] || {
  echo "B2BFORCE_ROOT is not a directory: ${WS}"
  exit 1
}

CLIENTS_DIR="${WS}/clients"
STALE_DAYS=90
QUIET_DAYS=42
errors=()
warnings=()

error() { errors+=("$1"); }
warn() { warnings+=("$1"); }

frontmatter_value() {
  awk -v key="$2" '
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
  ' "$1"
}

# Counts items of a YAML block list, or of an inline [a, b] list.
frontmatter_list_count() {
  awk -v key="$2" '
    BEGIN { in_fm = 0; seen = 0; in_list = 0; n = 0 }
    /^---[[:space:]]*$/ {
      if (!seen) { in_fm = 1; seen = 1; next }
      if (in_fm) { exit }
    }
    !in_fm { next }
    $0 ~ "^" key ":" {
      rest = $0
      sub("^" key ":[[:space:]]*", "", rest)
      gsub(/[][]/, "", rest)
      if (rest != "") {
        n = split(rest, parts, ",")
        for (i = 1; i <= n; i++) if (parts[i] ~ /[^[:space:]]/) count++
        print count + 0
        exit
      }
      in_list = 1
      next
    }
    in_list && /^[[:space:]]*-[[:space:]]/ { count++; next }
    in_list && /^[^[:space:]]/ { in_list = 0 }
    END { if (in_list || count > 0) print count + 0; else print 0 }
  ' "$1"
}

is_empty_value() {
  [[ -z "$1" || "$1" == "null" || "$1" == "~" ]]
}

# Whole days between an ISO date and today. Negative means the date is in the future.
days_since() {
  local date_str="$1" then now
  then="$(date -j -f "%Y-%m-%d" "${date_str}" "+%s" 2>/dev/null ||
    date -d "${date_str}" "+%s" 2>/dev/null || echo "")"
  [[ -z "${then}" ]] && return 1
  now="$(date "+%s")"
  echo $(((now - then) / 86400))
}

validate_account() {
  local dir="$1"
  local file="${dir}/!_account.md"
  local slug
  slug="$(basename "${dir}")"

  if [[ ! -f "${file}" ]]; then
    error "${dir}: missing !_account.md — run client-onboarding"
    return
  fi

  # --- Required frontmatter -------------------------------------------------
  local client engagement_type start_date status health
  for key in client engagement_type start_date status health; do
    local value
    value="$(frontmatter_value "${file}" "${key}")"
    if is_empty_value "${value}"; then
      error "${file}: missing or empty frontmatter '${key}'"
    fi
  done

  client="$(frontmatter_value "${file}" "client")"
  engagement_type="$(frontmatter_value "${file}" "engagement_type")"
  start_date="$(frontmatter_value "${file}" "start_date")"
  status="$(frontmatter_value "${file}" "status")"
  health="$(frontmatter_value "${file}" "health")"

  if [[ -n "${client}" && "${client}" != "${slug}" ]]; then
    error "${file}: client '${client}' does not match folder name '${slug}'"
  fi

  case "${engagement_type}" in
    retainer | project | mixed | "") ;;
    *) error "${file}: invalid engagement_type '${engagement_type}' (retainer | project | mixed)" ;;
  esac

  case "${status}" in
    active | paused | ended | "") ;;
    *) error "${file}: invalid status '${status}' (active | paused | ended)" ;;
  esac

  case "${health}" in
    green | amber | red | "") ;;
    *) error "${file}: invalid health '${health}' (green | amber | red)" ;;
  esac

  # --- Client Context Gate: at least one named contact ----------------------
  local contacts
  contacts="$(frontmatter_list_count "${file}" "contacts")"
  if [[ "${contacts}" -lt 1 ]]; then
    error "${file}: Client Context Gate — needs at least one named contact in 'contacts'"
  fi

  # A declared problem without a stated cause cannot be acted on.
  if [[ "${health}" == "amber" || "${health}" == "red" ]]; then
    if is_empty_value "$(frontmatter_value "${file}" "health_reason")"; then
      error "${file}: health '${health}' requires a 'health_reason'"
    fi
  fi

  # --- No exact money in this folder ---------------------------------------
  for banned in contract_value mrr arr margin utilization hours_logged rate; do
    if grep -qE "^${banned}:[[:space:]]*[^[:space:]]" "${file}"; then
      error "${file}: '${banned}' does not belong in ${CLIENTS_DIR}/ — use mrr_band (see workspace/clients/README.md)"
    fi
  done

  [[ "${status}" != "active" ]] && return

  # --- Success definition: the leading indicator ---------------------------
  local onboarding="${dir}/onboarding.md"
  if [[ ! -f "${onboarding}" ]]; then
    warn "${dir}: active account with no onboarding.md — no written success definition"
  elif is_empty_value "$(frontmatter_value "${onboarding}" "success_definition")"; then
    warn "${onboarding}: empty 'success_definition' — the strongest leading indicator in this folder"
  fi

  # --- Staleness -----------------------------------------------------------
  local reviewed_at age
  reviewed_at="$(frontmatter_value "${file}" "reviewed_at")"
  if is_empty_value "${reviewed_at}"; then
    error "${file}: missing 'reviewed_at' on an active account — health cannot be trusted without it"
  elif age="$(days_since "${reviewed_at}")"; then
    if [[ "${age}" -gt "${STALE_DAYS}" ]]; then
      if [[ "${health}" == "green" ]]; then
        error "${file}: health 'green' last reviewed ${age} days ago — verify or downgrade (stale green is worse than no file)"
      else
        warn "${file}: reviewed_at is ${age} days old"
      fi
    fi
  else
    error "${file}: reviewed_at '${reviewed_at}' is not a YYYY-MM-DD date"
  fi

  local last_contact
  last_contact="$(frontmatter_value "${file}" "last_contact")"
  if ! is_empty_value "${last_contact}" && age="$(days_since "${last_contact}")"; then
    if [[ "${age}" -gt "${QUIET_DAYS}" ]]; then
      warn "${file}: no contact for ${age} days"
    fi
  fi

  # --- Renewal ------------------------------------------------------------
  local renewal_date
  renewal_date="$(frontmatter_value "${file}" "renewal_date")"
  if is_empty_value "${renewal_date}"; then
    if [[ "${engagement_type}" == "retainer" ]]; then
      warn "${file}: retainer with no 'renewal_date' — the renewal review rule cannot fire"
    fi
  elif age="$(days_since "${renewal_date}")"; then
    if [[ "${age}" -gt 0 ]]; then
      warn "${file}: renewal_date passed ${age} days ago — renew, or set status to ended"
    elif [[ "${age}" -gt -60 ]]; then
      local quarters
      quarters="$(find "${dir}/qbr" -name '*.md' 2>/dev/null | wc -l | tr -d ' ')"
      if [[ "${quarters}" -eq 0 ]]; then
        warn "${file}: renewal in $((-age)) days with no QBR on record — run client-qbr first"
      fi
    fi
  else
    error "${file}: renewal_date '${renewal_date}' is not a YYYY-MM-DD date"
  fi
}

if [[ ! -d "${CLIENTS_DIR}" ]]; then
  echo "Account validation: no ${CLIENTS_DIR}/ directory"
  exit 0
fi

target="${1:-}"
if [[ -n "${target}" ]]; then
  target="${target%/}"
  if [[ ! -d "${target}" ]]; then
    echo "Account validation: FAIL"
    echo ""
    echo "- not a directory: ${target}"
    exit 1
  fi
  validate_account "${target}"
else
  found=0
  for dir in "${CLIENTS_DIR}"/*/; do
    [[ -d "${dir}" ]] || continue
    [[ "$(basename "${dir}")" == "reports" ]] && continue
    found=1
    validate_account "${dir%/}"
  done
  if [[ "${found}" -eq 0 ]]; then
    echo "Account validation: no accounts yet — run client-onboarding for an active client"
    exit 0
  fi
fi

if [[ "${#warnings[@]}" -gt 0 ]]; then
  echo "Warnings:"
  for item in "${warnings[@]}"; do
    echo "- ${item}"
  done
  echo ""
fi

if [[ "${#errors[@]}" -gt 0 ]]; then
  echo "Account validation: FAIL"
  echo ""
  for item in "${errors[@]}"; do
    echo "- ${item}"
  done
  exit 1
fi

echo "Account validation: OK"
