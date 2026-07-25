#!/usr/bin/env bash
# Answer-engine response + cited sources via the DataForSEO AI Optimization API.
#
# Usage:
#   llm-response.sh <engine> "<prompt>" [country_iso] [model_name]
#   llm-response.sh --models <engine>
#   llm-response.sh --json <engine> "<prompt>" [country_iso] [model_name]
#
#   engine: chat_gpt | claude | gemini | perplexity
#
# Model names drift. If a request fails on model_name, run --models to list what the
# engine currently accepts and pass one explicitly.
set -euo pipefail

BASE="https://api.dataforseo.com/v3/ai_optimization"
JSON_OUT="false"

usage() {
  awk 'NR > 1 { if ($0 !~ /^#/) exit; sub(/^# ?/, ""); print }' "${BASH_SOURCE[0]}"
  exit "${1:-1}"
}

[ "${1:-}" = "--json" ] && JSON_OUT="true" && shift

MODE="response"
if [ "${1:-}" = "--models" ]; then
  MODE="models"
  shift
fi

ENGINE="${1:-}"
[ -z "$ENGINE" ] && usage 1
case "$ENGINE" in
  chat_gpt | claude | gemini | perplexity) ;;
  -h | --help) usage 0 ;;
  *)
    echo "error: unknown engine '$ENGINE' (chat_gpt | claude | gemini | perplexity)" >&2
    exit 1
    ;;
esac

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)"
# shellcheck disable=SC1091
[ -f "$ROOT/.env" ] && set -a && . "$ROOT/.env" && set +a
: "${DATAFORSEO_LOGIN:?set DATAFORSEO_LOGIN in .env}"
: "${DATAFORSEO_PASSWORD:?set DATAFORSEO_PASSWORD in .env}"

if [ "$MODE" = "models" ]; then
  curl -fsS -X POST "$BASE/$ENGINE/llm_responses/models" \
    -u "$DATAFORSEO_LOGIN:$DATAFORSEO_PASSWORD" \
    -H "Content-Type: application/json" |
    jq -r '.tasks[0].result[0].items[]?.model_name // empty'
  exit 0
fi

PROMPT="${2:?usage: llm-response.sh <engine> \"<prompt>\" [country_iso] [model_name]}"
COUNTRY="${3:-}"
MODEL="${4:-}"

# The API caps user_prompt at 500 characters; fail loudly rather than send a truncated
# prompt, because a silently shortened prompt makes runs incomparable.
if [ "${#PROMPT}" -gt 500 ]; then
  echo "error: prompt is ${#PROMPT} characters; the API limit is 500" >&2
  exit 1
fi

if [ -z "$MODEL" ]; then
  case "$ENGINE" in
    chat_gpt) MODEL="gpt-4.1-mini" ;;
    claude) MODEL="claude-sonnet-4-5" ;;
    gemini) MODEL="gemini-2.5-flash" ;;
    perplexity) MODEL="sonar" ;;
  esac
fi

# web_search is what makes the answer reflect the live web and produce citations.
# Without it there are no annotations and the run says nothing about visibility.
payload="$(jq -n \
  --arg prompt "$PROMPT" \
  --arg model "$MODEL" \
  --arg country "$COUNTRY" \
  '[{
     user_prompt: $prompt,
     model_name: $model,
     web_search: true,
     force_web_search: true
   } + (if $country == "" then {} else {web_search_country_iso_code: $country} end)]')"

response="$(curl -fsS -X POST "$BASE/$ENGINE/llm_responses/live" \
  -u "$DATAFORSEO_LOGIN:$DATAFORSEO_PASSWORD" \
  -H "Content-Type: application/json" \
  -d "$payload")"

status="$(printf "%s" "$response" | jq -r '.tasks[0].status_message // "unknown"')"
code="$(printf "%s" "$response" | jq -r '.tasks[0].status_code // 0')"
if [ "$code" != "20000" ]; then
  echo "error: DataForSEO task failed (${code}): ${status}" >&2
  echo "hint: if this mentions the model, run: llm-response.sh --models ${ENGINE}" >&2
  exit 1
fi

if [ "$JSON_OUT" = "true" ]; then
  printf "%s" "$response"
  exit 0
fi

# Only items of type "message" are the answer. Reasoning items must never be
# treated as the response. "none" is printed explicitly for an empty citation list,
# so that no citations is distinguishable from a failed extraction.
printf "%s" "$response" | jq -r '
  .tasks[0].result[0] as $r
  | ([$r.items[]? | select(.type == "message") | .sections[]?
      | select(.type == "text") | .text] | join("\n\n")) as $answer
  | ([$r.items[]? | select(.type == "message") | .sections[]?
      | .annotations[]? | "\(.url)\t\(.title // "")"] | unique) as $cites
  | "engine_model: \($r.model_name // "unknown")",
    "web_search: \($r.web_search // false)",
    "money_spent: \($r.money_spent // 0)",
    "datetime: \($r.datetime // "unknown")",
    "citation_count: \($cites | length)",
    "",
    "--- ANSWER ---",
    (if ($answer | length) == 0 then "none" else $answer end),
    "",
    "--- CITED SOURCES ---",
    (if ($cites | length) == 0 then "none" else ($cites | join("\n")) end)
'
