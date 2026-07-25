---
name: tool-dataforseo
description: >-
  Fetch Google SERP results or keyword search-volume data via the DataForSEO
  API. Use when a skill needs competitor discovery (SERP), keyword research, or
  search metrics. Reads DATAFORSEO_LOGIN and DATAFORSEO_PASSWORD from .env.
license: MIT
metadata:
  version: 1.0.0
  category: tool
---

# Tool: DataForSEO

Thin wrapper for the [DataForSEO](https://dataforseo.com) API — SERP results and
keyword data. Other skills call this instead of re-describing the API.

## Requirements

- `curl`
- `jq`
- `.env` credentials listed below

## Auth

`.env`:

```bash
DATAFORSEO_LOGIN=
DATAFORSEO_PASSWORD=
```

HTTP Basic auth (`login:password`). Base: `https://api.dataforseo.com/v3`.
Request bodies are an **array of task objects**.

## Endpoints

| Action | Endpoint | Use |
|--------|----------|-----|
| SERP | `POST /serp/google/organic/live/advanced` | Top organic results for a phrase |
| Keyword volume | `POST /keywords_data/google_ads/search_volume/live` | Search volume / CPC / competition |
| LLM response | `POST /ai_optimization/{engine}/llm_responses/live` | Answer-engine response + cited sources |
| LLM models | `POST /ai_optimization/{engine}/llm_responses/models` | Model names the engine currently accepts |
| Account | `POST /appendix/user_data` | Check balance / credentials |

`location_name` uses DataForSEO format, e.g. `"Poland"`, `"United States"`.

`{engine}` is `chat_gpt`, `claude`, `gemini`, or `perplexity`. The request shape is the
same across engines; only some optional parameters differ.

## Scripts

```bash
# Top 10 organic results for a phrase + country (prints url + title list)
bash .agents/skills/tool-dataforseo/scripts/serp.sh "drupal migration agency" "Poland"

# Keyword search volume (prints JSON)
bash .agents/skills/tool-dataforseo/scripts/keyword.sh "drupal migration" "Poland"

# Answer-engine response + cited sources (prints answer, citations, model, cost)
bash .agents/skills/tool-dataforseo/scripts/llm-response.sh chat_gpt \
  "best drupal migration agency for mid-market retail" PL

# Which models this engine currently accepts — run this first, names drift
bash .agents/skills/tool-dataforseo/scripts/llm-response.sh --models chat_gpt

# Raw JSON passthrough
bash .agents/skills/tool-dataforseo/scripts/llm-response.sh --json perplexity "..." PL
```

### `llm-response.sh` notes

- `web_search` is forced on. Without it the answer is not grounded in the live web and
  returns no citations, which makes the run useless for visibility work.
- Prompts are capped at **500 characters** by the API. The script fails on a longer
  prompt rather than truncating it, because a silently shortened prompt makes runs
  incomparable across batches.
- Only response items of type `message` are the answer. Reasoning items are excluded.
- An empty citation list prints `none`, so "no citations" is distinguishable from a
  failed extraction.
- Model names change. If a call fails on `model_name`, run `--models` and pass one.

## Rules

1. Credentials from `.env` only.
2. Paid API — cache results in `workspace/` where possible; don't re-query.
3. For competitor discovery, dedupe by **root domain** after fetching.
4. Degrade gracefully if unset — calling skills should fall back to AI research.
5. Answer engines are non-deterministic. One LLM response is a sample, not a fact; the
   calling skill decides how many runs make a finding.

## Used by

`intel-competitor-discovery` (SERP), `marketing-seo-research` (keywords),
`marketing-service-page` (SERP), `intel-ai-visibility` (LLM responses).
