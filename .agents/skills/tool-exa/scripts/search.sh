#!/usr/bin/env bash
# Neural web search via Exa. Usage: search.sh "<query>" [num_results]
set -euo pipefail

QUERY="${1:?usage: search.sh \"<query>\" [num_results]}"
NUM="${2:-10}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)"
[ -f "$ROOT/.env" ] && set -a && . "$ROOT/.env" && set +a
: "${EXA_API_KEY:?set EXA_API_KEY in .env}"

curl -fsS -X POST "https://api.exa.ai/search" \
  -H "x-api-key: $EXA_API_KEY" \
  -H "Content-Type: application/json" \
  -d "$(jq -n --arg q "$QUERY" --argjson n "$NUM" \
        '{query:$q, numResults:$n, type:"auto"}')" \
  | jq -r '.results[]? | "\(.url)\t\(.title)"'
