---
name: tool-exa
description: >-
  Run neural web search, fetch page contents, find similar pages, or get a cited
  answer via the Exa API. Use when a skill needs market research, reference
  articles, or a content landscape. Reads EXA_API_KEY from .env.
license: MIT
metadata:
  version: 1.0.0
  category: tool
---

# Tool: Exa

Thin wrapper for the [Exa](https://exa.ai) API — neural search, content
retrieval, similar-page lookup, and cited answers. Other skills call this for
research enrichment.

## Requirements

- `curl`
- `jq`
- `.env` credentials listed below

## Auth

`.env`:

```bash
EXA_API_KEY=
```

Header: `x-api-key: $EXA_API_KEY`. Base: `https://api.exa.ai`.

## Endpoints

| Action | Endpoint | Use |
|--------|----------|-----|
| Search | `POST /search` | Neural/keyword search, optional date filter |
| Contents | `POST /contents` | Full text for result IDs/URLs |
| Find similar | `POST /findSimilar` | Pages similar to a URL |
| Answer | `POST /answer` | Cited answer to a question |

## Scripts

```bash
# Search (prints url + title list). Optional 3rd arg = number of results
bash .agents/skills/tool-exa/scripts/search.sh "B2B drupal migration trends" 10

# Cited answer to a question (prints answer text + sources)
bash .agents/skills/tool-exa/scripts/answer.sh "What do buyers ask before a platform migration?"
```

## Rules

1. Key from `.env` only.
2. Use for **research only** (blog, case study, service page, ICP, content ideas)
   — do **not** attach long Exa blocks to LinkedIn/X drafts.
3. Prefer date-filtered search (last 12 months) for content-landscape queries.
4. Degrade gracefully if unset.

## Used by

`marketing-content-ideas` (content landscape), `marketing-content-blog-post`
and `-case-study` (reference articles), `marketing-icp` and
`marketing-service-page` (market research).
