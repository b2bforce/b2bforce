#!/usr/bin/env bash
# Keyword search-volume data via DataForSEO. Usage: keyword.sh "<keyword>" "<location_name>"
set -euo pipefail

KEYWORD="${1:?usage: keyword.sh \"<keyword>\" \"<location_name>\"}"
LOCATION="${2:-United States}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)"
[ -f "$ROOT/.env" ] && set -a && . "$ROOT/.env" && set +a
: "${DATAFORSEO_LOGIN:?set DATAFORSEO_LOGIN in .env}"
: "${DATAFORSEO_PASSWORD:?set DATAFORSEO_PASSWORD in .env}"

curl -fsS -X POST "https://api.dataforseo.com/v3/keywords_data/google_ads/search_volume/live" \
  -u "$DATAFORSEO_LOGIN:$DATAFORSEO_PASSWORD" \
  -H "Content-Type: application/json" \
  -d "$(jq -n --arg kw "$KEYWORD" --arg loc "$LOCATION" \
        '[{keywords:[$kw], location_name:$loc, language_name:"English"}]')" \
  | jq '.tasks[0].result'
