#!/usr/bin/env bash
# Validate a proposal written by sales-proposal.
#
# Usage:
#   scripts/validate-proposal.sh workspace/sales/opportunities/acme--migration--2026-07/proposal.md
#
# Enforces the Proposal Gate (a qualified brief must exist), the Proof Gate (every
# client claim resolves to a record in workspace/firm/proof/), the mandatory scope
# boundaries, one pricing table consistent with the service definition, and the
# length limit.
#
# In multi-brand mode (Brand Scope Gate in AGENTS.md) the opportunity lives at
# workspace/sales/opportunities/{brand}/{opportunity}/ — the brand is read from
# the path, and service/icp/persona must resolve inside that brand's segment.
#
# Set B2BFORCE_ROOT to validate a workspace other than workspace/ — used by
# scripts/demo-check.sh against the demo firm in examples/.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

source "${ROOT_DIR}/scripts/lib/workspace.sh"
require_workspace

PROPOSAL_FILE="${1:-}"
PROOF_DIR="${WS}/firm/proof"
MAX_WORDS=3000
errors=()

error() {
  errors+=("$1")
}

if [[ -z "${PROPOSAL_FILE}" ]]; then
  error "Missing proposal path. Usage: scripts/validate-proposal.sh {proposal-path}"
elif [[ ! -f "${PROPOSAL_FILE}" ]]; then
  error "Proposal file does not exist: ${PROPOSAL_FILE}"
fi

if [[ -f "${PROPOSAL_FILE}" ]]; then
  # In multi-brand mode the opportunity sits one brand segment deeper and the
  # brand is read from the path (Brand Scope Gate in AGENTS.md).
  PROPOSAL_BRAND=""
  if is_multi_brand; then
    case "${PROPOSAL_FILE}" in
      "${WS}"/sales/opportunities/*/*/proposal.md)
        PROPOSAL_BRAND="$(brand_from_path "${PROPOSAL_FILE}" "${WS}/sales/opportunities" || true)"
        if ! brand_exists "${PROPOSAL_BRAND}"; then
          error "${PROPOSAL_FILE}: '${PROPOSAL_BRAND}' is not a brand in $(brands_dir)/"
          PROPOSAL_BRAND=""
        fi
        ;;
      *) error "${PROPOSAL_FILE}: multi-brand mode — proposals must be at ${WS}/sales/opportunities/{brand}/{opportunity}/proposal.md" ;;
    esac
  else
    case "${PROPOSAL_FILE}" in
      "${WS}"/sales/opportunities/*/proposal.md) ;;
      *) error "${PROPOSAL_FILE}: proposals must be at ${WS}/sales/opportunities/{opportunity}/proposal.md" ;;
    esac
  fi

  opportunity_dir="$(dirname "${PROPOSAL_FILE}")"
  discovery_file="${opportunity_dir}/!_discovery.md"

  # --- Frontmatter -----------------------------------------------------------
  for key in opportunity account service icp persona price_model currency status generated_at; do
    value="$(frontmatter_value "${PROPOSAL_FILE}" "${key}")"
    if is_empty_value "${value}"; then
      error "${PROPOSAL_FILE}: missing or empty frontmatter '${key}'"
    fi
  done

  status="$(frontmatter_value "${PROPOSAL_FILE}" "status")"
  case "${status}" in
    draft | sent | withdrawn | "") ;;
    *) error "${PROPOSAL_FILE}: invalid status '${status}' (draft | sent | withdrawn)" ;;
  esac

  proof_needed="$(frontmatter_value "${PROPOSAL_FILE}" "proof_needed")"
  case "${proof_needed}" in
    true | false) ;;
    *) error "${PROPOSAL_FILE}: frontmatter 'proof_needed' must be true or false" ;;
  esac

  # --- Proposal Gate: a qualified brief must exist --------------------------
  if [[ ! -f "${discovery_file}" ]]; then
    error "${PROPOSAL_FILE}: missing ${discovery_file} — run sales-discovery-brief first"
  else
    bid_decision="$(frontmatter_value "${discovery_file}" "bid_decision")"
    case "${bid_decision}" in
      bid | conditional) ;;
      "") error "${discovery_file}: missing 'bid_decision' — run sales-bid-qualification first" ;;
      *) error "${discovery_file}: bid_decision '${bid_decision}' does not allow a proposal (need bid or conditional)" ;;
    esac

    brief_quality="$(frontmatter_value "${discovery_file}" "brief_quality")"
    case "${brief_quality}" in
      workable | strong) ;;
      *) error "${discovery_file}: brief_quality '${brief_quality}' is too weak for a proposal (need workable or strong)" ;;
    esac
  fi

  # --- Required sections ----------------------------------------------------
  for heading in "Situation" "Outcomes" "Approach" "Scope" "Out of scope" \
    "Assumptions" "Change control" "Proof" "Commercials" "Next step"; do
    if ! grep -qE "^## ${heading}[[:space:]]*$" "${PROPOSAL_FILE}"; then
      error "${PROPOSAL_FILE}: missing section '## ${heading}'"
    elif section_is_empty "${PROPOSAL_FILE}" "${heading}"; then
      error "${PROPOSAL_FILE}: section '## ${heading}' is empty"
    fi
  done

  # --- Length ---------------------------------------------------------------
  words="$(body_text "${PROPOSAL_FILE}" | wc -w | tr -d ' ')"
  if [[ "${words}" -gt "${MAX_WORDS}" ]]; then
    error "${PROPOSAL_FILE}: ${words} words exceeds the ${MAX_WORDS}-word limit; target 2000-2500"
  fi

  # --- One pricing table ----------------------------------------------------
  commercials="$(section_body "${PROPOSAL_FILE}" "Commercials")"
  table_rows="$(printf "%s\n" "${commercials}" | grep -cE '^\|' || true)"
  if [[ "${table_rows}" -lt 3 ]]; then
    error "${PROPOSAL_FILE}: '## Commercials' needs one pricing table (header, separator, at least one option)"
  fi

  # --- price_model must match the service definition ------------------------
  service="$(frontmatter_value "${PROPOSAL_FILE}" "service")"
  price_model="$(frontmatter_value "${PROPOSAL_FILE}" "price_model")"

  if is_multi_brand; then
    # Bare slugs only, resolved in the opportunity's own brand — the same-brand
    # rule of the Brand Scope Gate.
    for kind in service icp persona; do
      ref="$(frontmatter_value "${PROPOSAL_FILE}" "${kind}")"
      is_empty_value "${ref}" && continue
      case "${ref}" in
        */*) error "${PROPOSAL_FILE}: ${kind} '${ref}' — path-scoped artifacts use bare slugs, resolved in their own brand" ;;
      esac
    done
    if [[ -n "${PROPOSAL_BRAND}" ]]; then
      for kind in icp persona; do
        ref="$(frontmatter_value "${PROPOSAL_FILE}" "${kind}")"
        is_empty_value "${ref}" && continue
        case "${ref}" in */*) continue ;; esac
        ref_file="$(resolve_ref "${kind}" "${ref}" "${PROPOSAL_BRAND}")"
        if [[ ! -f "${ref_file}" ]]; then
          error "${PROPOSAL_FILE}: ${kind} '${ref}' does not resolve in brand '${PROPOSAL_BRAND}' (expected ${ref_file})"
        fi
      done
    fi
  fi

  service_file="$(resolve_ref service "${service}" "${PROPOSAL_BRAND:-}" 2>/dev/null || true)"
  if [[ -z "${service_file}" ]]; then
    service_file="${WS}/firm/services/${service}.md"
  fi

  if [[ -n "${service}" && ! -f "${service_file}" ]]; then
    error "${PROPOSAL_FILE}: service '${service}' has no definition at ${service_file}"
  elif [[ -f "${service_file}" ]]; then
    service_type="$(frontmatter_value "${service_file}" "service_type")"
    case "${service_type}" in
      project | package)
        case "${price_model}" in
          project | fixed) ;;
          *) error "${PROPOSAL_FILE}: price_model '${price_model}' does not match service_type '${service_type}' (expected project or fixed)" ;;
        esac
        ;;
      retainer | subscription | support)
        case "${price_model}" in
          retainer) ;;
          *) error "${PROPOSAL_FILE}: price_model '${price_model}' does not match service_type '${service_type}' (expected retainer)" ;;
        esac
        ;;
      consulting | training)
        case "${price_model}" in
          project | day_rate | retainer) ;;
          *) error "${PROPOSAL_FILE}: price_model '${price_model}' does not match service_type '${service_type}' (expected project, day_rate, or retainer)" ;;
        esac
        ;;
    esac
  fi

  # --- Proof Gate -----------------------------------------------------------
  proof_refs="$(frontmatter_list "${PROPOSAL_FILE}" "proof_refs" || true)"
  proof_files=""
  proof_quote_approved="no"

  for ref in ${proof_refs}; do
    # Multi-brand: a bare ref is the proposal's own brand's record; the
    # qualified {brand}/{slug} form cites a sibling brand's record and needs
    # its cross_brand consent (Brand Scope Gate in AGENTS.md).
    proof_file="$(resolve_ref proof "${ref}" "${PROPOSAL_BRAND:-}" 2>/dev/null || true)"
    [[ -z "${proof_file}" ]] && proof_file="${PROOF_DIR}/${ref}.md"
    if [[ ! -f "${proof_file}" ]]; then
      error "${PROPOSAL_FILE}: proof_refs '${ref}' has no record at ${proof_file}"
      continue
    fi
    proof_files="${proof_files} ${proof_file}"

    if [[ "$(frontmatter_value "${proof_file}" "quote_approved")" == "true" ]]; then
      proof_quote_approved="yes"
    fi

    if is_multi_brand && [[ -n "${PROPOSAL_BRAND:-}" ]]; then
      case "${ref}" in
        */*) ref_brand="${ref%%/*}" ;;
        *) ref_brand="${PROPOSAL_BRAND}" ;;
      esac
      if [[ "${ref_brand}" != "${PROPOSAL_BRAND}" ]]; then
        if [[ "$(frontmatter_value "${proof_file}" "cross_brand")" != "true" ]]; then
          error "${PROPOSAL_FILE}: cites proof '${ref}' delivered by brand '${ref_brand}' — needs cross_brand: true on ${proof_file}"
        fi
      fi
    fi

    # A client that is not public must never be named in the proposal.
    if [[ "$(frontmatter_value "${proof_file}" "client_public")" != "true" ]]; then
      client="$(frontmatter_value "${proof_file}" "client")"
      if [[ -n "${client}" ]]; then
        if body_text "${PROPOSAL_FILE}" | grep -qiE "$(slug_to_regex "${client}")"; then
          error "${PROPOSAL_FILE}: names client '${client}' but ${proof_file} has client_public: false"
        fi
      fi
    fi
  done

  if [[ -z "${proof_refs}" && "${proof_needed}" != "true" ]]; then
    error "${PROPOSAL_FILE}: no proof_refs — set proof_needed: true and keep client claims out of '## Proof'"
  fi

  proof_section="$(section_body "${PROPOSAL_FILE}" "Proof")"

  # A client quote requires an approved quote on a referenced record.
  if printf "%s\n" "${proof_section}" | grep -qE '^[[:space:]]*>' && [[ "${proof_quote_approved}" != "yes" ]]; then
    error "${PROPOSAL_FILE}: '## Proof' contains a quote but no referenced proof record has quote_approved: true"
  fi

  # Every number claimed in Proof must be traceable to a referenced record.
  claims="$(printf "%s\n" "${proof_section}" |
    grep -oE '[0-9][0-9.,]*%?' |
    sed 's/[.,]$//' |
    grep -vE '^(19|20)[0-9]{2}$' |
    sort -u || true)"

  for claim in ${claims}; do
    found="no"
    for proof_file in ${proof_files}; do
      if grep -qF "${claim}" "${proof_file}"; then
        found="yes"
        break
      fi
    done
    if [[ "${found}" == "no" ]]; then
      error "${PROPOSAL_FILE}: '## Proof' claims '${claim}' with no matching value in any referenced proof record"
    fi
  done
fi

if [[ "${#errors[@]}" -gt 0 ]]; then
  echo "Proposal validation: FAIL"
  echo ""
  for item in "${errors[@]}"; do
    echo "- ${item}"
  done
  exit 1
fi

echo "Proposal validation: OK"
