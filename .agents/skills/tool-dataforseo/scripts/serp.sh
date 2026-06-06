#!/usr/bin/env bash
# Google SERP organic results via DataForSEO. Usage: serp.sh "<phrase>" "<location_name>"
set -euo pipefail

PHRASE="${1:?usage: serp.sh \"<phrase>\" \"<location_name>\"}"
LOCATION="${2:-United States}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)"
[ -f "$ROOT/.env" ] && set -a && . "$ROOT/.env" && set +a
: "${DATAFORSEO_LOGIN:?set DATAFORSEO_LOGIN in .env}"
: "${DATAFORSEO_PASSWORD:?set DATAFORSEO_PASSWORD in .env}"

curl -fsS -X POST "https://api.dataforseo.com/v3/serp/google/organic/live/advanced" \
  -u "$DATAFORSEO_LOGIN:$DATAFORSEO_PASSWORD" \
  -H "Content-Type: application/json" \
  -d "$(jq -n --arg kw "$PHRASE" --arg loc "$LOCATION" \
        '[{keyword:$kw, location_name:$loc, language_name:"English", depth:10}]')" \
  | jq -r '.tasks[0].result[0].items[]? | select(.type=="organic") | "\(.url)\t\(.title)"'
