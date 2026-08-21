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
# In multi-brand mode (Brand Scope Gate in AGENTS.md) also enforces brand membership:
# 'brands: [...]' names existing brands and 'services' uses qualified {brand}/{slug}.
#
# Errors exit non-zero. Warnings are reported and do not fail, because a bookkeeping
# lapse should not block a QBR — with one exception. A stale review combined with
# `health: green` is an error, not a warning: that combination is an assertion the firm
# can no longer support, and a human will act on it.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

source "${ROOT_DIR}/scripts/lib/workspace.sh"
require_workspace

CLIENTS_DIR="${WS}/clients"
STALE_DAYS=90
QUIET_DAYS=42
errors=()
warnings=()

error() { errors+=("$1"); }
warn() { warnings+=("$1"); }

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

  # --- Brand membership (multi-brand only) ----------------------------------
  # The account is shared — one record however many brands sell to the client —
  # and declares its brands in frontmatter. Its services references use the
  # qualified {brand}/{slug} form, the only place references are qualified
  # (Brand Scope Gate in AGENTS.md).
  if is_multi_brand; then
    local account_brands brand_item svc_ref svc_brand svc_file
    account_brands="$(frontmatter_list "${file}" "brands" || true)"
    if [[ -z "${account_brands}" ]]; then
      error "${file}: multi-brand mode — declare 'brands: [...]' (which brands sell to this client)"
    else
      while IFS= read -r brand_item; do
        [[ -n "${brand_item}" ]] || continue
        if ! brand_exists "${brand_item}"; then
          error "${file}: brand '${brand_item}' has no file at $(brands_dir)/${brand_item}.md"
        fi
      done <<<"${account_brands}"
    fi

    while IFS= read -r svc_ref; do
      [[ -n "${svc_ref}" ]] || continue
      case "${svc_ref}" in
        */*)
          svc_brand="${svc_ref%%/*}"
          svc_file="$(resolve_ref service "${svc_ref}")"
          if [[ ! -f "${svc_file}" ]]; then
            error "${file}: services '${svc_ref}' does not resolve (expected ${svc_file})"
          fi
          if [[ -n "${account_brands}" ]] && ! grep -qx "${svc_brand}" <<<"${account_brands}"; then
            error "${file}: services '${svc_ref}' names brand '${svc_brand}' missing from 'brands'"
          fi
          ;;
        *)
          error "${file}: multi-brand mode — services entries use the qualified {brand}/{slug} form, got '${svc_ref}'"
          ;;
      esac
    done < <(frontmatter_list "${file}" "services" || true)
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
