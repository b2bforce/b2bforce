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
| Account | `POST /appendix/user_data` | Check balance / credentials |

`location_name` uses DataForSEO format, e.g. `"Poland"`, `"United States"`.

## Scripts

```bash
# Top 10 organic results for a phrase + country (prints url + title list)
bash .agents/skills/tool-dataforseo/scripts/serp.sh "drupal migration agency" "Poland"

# Keyword search volume (prints JSON)
bash .agents/skills/tool-dataforseo/scripts/keyword.sh "drupal migration" "Poland"
```

## Rules

1. Credentials from `.env` only.
2. Paid API — cache results in `workspace/` where possible; don't re-query.
3. For competitor discovery, dedupe by **root domain** after fetching.
4. Degrade gracefully if unset — calling skills should fall back to AI research.

## Used by

`intel-competitor-discovery` (SERP), `marketing-seo-research` (keywords),
`marketing-service-page` (SERP).
