#!/usr/bin/env bash
# Discover URLs on a domain via Firecrawl map. Usage: map.sh <url>
set -euo pipefail

URL="${1:?usage: map.sh <url>}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)"
[ -f "$ROOT/.env" ] && set -a && . "$ROOT/.env" && set +a
: "${FIRECRAWL_API_KEY:?set FIRECRAWL_API_KEY in .env}"

curl -fsS -X POST "https://api.firecrawl.dev/v1/map" \
  -H "Authorization: Bearer $FIRECRAWL_API_KEY" \
  -H "Content-Type: application/json" \
  -d "$(jq -n --arg url "$URL" '{url:$url}')" \
  | jq -r '.links // .data.links // []'
