#!/usr/bin/env bash
# Cited answer via Exa. Usage: answer.sh "<question>"
set -euo pipefail

QUESTION="${1:?usage: answer.sh \"<question>\"}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)"
[ -f "$ROOT/.env" ] && set -a && . "$ROOT/.env" && set +a
: "${EXA_API_KEY:?set EXA_API_KEY in .env}"

curl -fsS -X POST "https://api.exa.ai/answer" \
  -H "x-api-key: $EXA_API_KEY" \
  -H "Content-Type: application/json" \
  -d "$(jq -n --arg q "$QUESTION" '{query:$q, text:true}')" \
  | jq -r '.answer // "no answer", (.citations[]? | "- \(.url)")'
