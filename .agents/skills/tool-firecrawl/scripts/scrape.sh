#!/usr/bin/env bash
# Scrape a URL to markdown via Firecrawl. Usage: scrape.sh <url>
set -euo pipefail

URL="${1:?usage: scrape.sh <url>}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)"
[ -f "$ROOT/.env" ] && set -a && . "$ROOT/.env" && set +a
: "${FIRECRAWL_API_KEY:?set FIRECRAWL_API_KEY in .env}"

curl -fsS -X POST "https://api.firecrawl.dev/v1/scrape" \
  -H "Authorization: Bearer $FIRECRAWL_API_KEY" \
  -H "Content-Type: application/json" \
  -d "$(jq -n --arg url "$URL" '{url:$url, formats:["markdown"], onlyMainContent:true}')" \
  | jq -r '.data.markdown // .markdown // "no markdown in response"'
