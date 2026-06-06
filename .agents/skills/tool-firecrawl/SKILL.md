---
name: tool-firecrawl
description: >-
  Scrape a web page to clean markdown or map a site's URLs using the Firecrawl
  API. Use when another skill needs page content from a URL (company/service
  extraction, competitor crawl, ICP from URL). Reads FIRECRAWL_API_KEY from .env.
license: MIT
metadata:
  version: 1.0.0
  category: tool
---

# Tool: Firecrawl

Thin wrapper for the [Firecrawl](https://firecrawl.dev) API — turn a URL into
clean markdown, or discover a site's URLs. Other skills call this instead of
re-describing the API.

## Requirements

- `curl`
- `jq`
- `.env` credentials listed below

## Auth

`.env`:

```bash
FIRECRAWL_API_KEY=fc-...
```

Header: `Authorization: Bearer $FIRECRAWL_API_KEY`. Base: `https://api.firecrawl.dev/v1`.

## Endpoints

| Action | Endpoint | Use |
|--------|----------|-----|
| Scrape | `POST /scrape` | One URL → markdown/html |
| Map | `POST /map` | Discover URLs on a domain (sitemap-like) |

## Scripts

```bash
# Scrape one URL to markdown (prints markdown to stdout)
bash .agents/skills/tool-firecrawl/scripts/scrape.sh https://example.com

# Map a site's URLs (prints JSON array of links)
bash .agents/skills/tool-firecrawl/scripts/map.sh https://example.com
```

## Request shape (scrape)

```json
{ "url": "https://example.com", "formats": ["markdown"], "onlyMainContent": true }
```

## Rules

1. Key comes from `.env` only — never inline it or ask for it in chat.
2. Truncate very large pages (~15000 chars) before feeding to an LLM.
3. Handle non-200 / timeouts gracefully; report and let the calling skill degrade.
4. Respect target sites' robots and rate limits.

## Used by

`marketing-company-profile`, `marketing-service`,
`intel-competitor-monitoring`,
`marketing-service-page`.
