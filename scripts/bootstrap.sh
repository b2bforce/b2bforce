#!/usr/bin/env bash
# Bootstrap a new firm skills + workspace repo from this template.
#
# Usage:
#   curl -fsSL .../scripts/bootstrap.sh | bash
#   FIRM_SLUG=acme-agency bash scripts/bootstrap.sh
#   REPO_URL=git@github.com:b2bforce/b2bforce.git FIRM_SLUG=acme-agency bash scripts/bootstrap.sh
#
# Creates ../${FIRM_SLUG}-workspace (or BOOTSTRAP_TARGET) and optionally re-inits git.

set -euo pipefail

REPO_URL="${REPO_URL:-git@github.com:b2bforce/b2bforce.git}"
FIRM_SLUG="${FIRM_SLUG:-my-firm}"
BOOTSTRAP_TARGET="${BOOTSTRAP_TARGET:-../${FIRM_SLUG}-workspace}"
REINIT_GIT="${REINIT_GIT:-1}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

# If run from inside the template repo, clone to sibling directory.
if [[ -d "${TEMPLATE_DIR}/.git" && "${REPO_URL}" == "git@github.com:b2bforce/b2bforce.git" ]]; then
  echo "Cloning from local template: ${TEMPLATE_DIR}"
  if [[ -d "${BOOTSTRAP_TARGET}" ]]; then
    echo "ERROR: Target already exists: ${BOOTSTRAP_TARGET}" >&2
    exit 1
  fi
  cp -R "${TEMPLATE_DIR}" "${BOOTSTRAP_TARGET}"
  rm -rf "${BOOTSTRAP_TARGET}/.git"
else
  if [[ -d "${BOOTSTRAP_TARGET}" ]]; then
    echo "ERROR: Target already exists: ${BOOTSTRAP_TARGET}" >&2
    exit 1
  fi
  git clone "${REPO_URL}" "${BOOTSTRAP_TARGET}"
  rm -rf "${BOOTSTRAP_TARGET}/.git"
fi

if [[ "${REINIT_GIT}" == "1" ]]; then
  git -C "${BOOTSTRAP_TARGET}" init -q
  git -C "${BOOTSTRAP_TARGET}" add -A
  git -C "${BOOTSTRAP_TARGET}" commit -q -m "chore: bootstrap B2BForce skills workspace" || true
fi

echo ""
echo "OK: B2BForce skills + workspace repo created at ${BOOTSTRAP_TARGET}"
echo ""
echo "Next steps:"
echo "  1. cd ${BOOTSTRAP_TARGET}"
echo "  2. Open docs/SETUP-PROMPT.md in Cursor / Claude Code / Codex"
echo "  3. cp .env.example .env  # fill API keys locally"
echo ""
