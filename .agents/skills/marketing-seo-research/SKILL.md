---
name: marketing-seo-research
description: >-
  Research SEO keywords and search metrics for a topic (DataForSEO with AI
  research fallback), then produce an SEO context block and a target keyword for
  content. Use when the user wants keyword research, SEO data, or a target
  keyword for a content idea or draft. Read firm profile for industry/location.
license: MIT
metadata:
  version: 1.0.0
  category: marketing
---

# SEO Research

Keyword research + search metrics to enrich content ideas and drafts with a
`target_keyword` and an SEO context block.

## When to Use

- User wants **keyword research** or **SEO data** for a topic
- Picking a **target_keyword** for a content idea (`content/ideas/{slug}.md`)
- Generating an **SEO context block** to feed into a blog draft or service page

## Read First

`workspace/firm/profile.md` — `industry` and geography/`location` (DataForSEO
location name format, e.g. "Poland", "United States"). Default location: Poland.

## Workflow

### 1. Keyword research (with fallback)

`researchKeywords(topic, industry, location)`:

1. **DataForSEO** (preferred) — `getKeywordData(keyword, location)` →
   `{ keyword, search_volume, cpc, competition, competition_level }`
   (default location `Poland`). Stored as the `primary_keyword`, `source: dataforseo`.
2. **Fallback: AI research** (Exa/Perplexity) when DataForSEO is unset/fails —
   ask for 5 high-value B2B keywords for the topic (one per line). `source: ai`.

AI keyword query (verbatim shape):

```text
Suggest 5 high-value SEO keywords for B2B content about "{topic}"
[in the {industry} industry]. Format: one keyword per line, no numbering,
just the keyword phrases.
```

Dry-run (no keys): propose keywords from topic + industry knowledge, mark
`source: dry-run`.

### 2. Pick a target keyword

Choose the most relevant, realistic keyword (intent + achievable competition).
Prefer specific long-tail over generic head terms for PSF/B2B.

### 3. Build SEO context block

`generateSeoContext(topic, targetKeyword)` → a short block for content prompts.
It starts with a `SEO Context:` header, the target keyword, and (only when
DataForSEO is available) one metrics line with monthly search volume and
competition level — CPC is **not** included here:

```text
SEO Context:
Target keyword: {target_keyword}
Keyword metrics: {search_volume} monthly searches, competition: {competition_level}
```

When the keyword research feeds idea generation, the prompt also nudges the model
to "include target keywords naturally in content titles where appropriate" — it
does not prescribe specific placements (title / first paragraph / H2).

### 4. Write outputs

- Set `target_keyword:` in the relevant `content/ideas/{slug}.md` frontmatter.
- Save full research to
  `workspace/marketing/seo/{topic-slug}.md`:

```yaml
---
topic:
location:
source: dataforseo | ai | dry-run
primary_keyword:
search_volume:
competition:
suggestions: []
date: 2026-06-01
---
```

## Integration with content pipeline

- `marketing-content-ideas` can call this to attach `target_keyword` per idea.
- `marketing-content-blog-post` should weave the SEO context block into blog
  drafts.
- `marketing-service-page` should use SEO context for standalone service pages.
  LinkedIn/X do **not** use SEO research.

## Rules

1. Always degrade gracefully: DataForSEO → AI → dry-run; never hard-fail.
2. One primary `target_keyword` per content piece; keep secondary as suggestions.
3. Write for humans — flag and avoid keyword stuffing.
4. Location/industry come from firm-context, not guessed per call.

## Environment Variables

```bash
DATAFORSEO_LOGIN=
DATAFORSEO_PASSWORD=
EXA_API_KEY=        # or Perplexity — AI keyword fallback
```

## Related Skills

| Skill | When |
|-------|------|
| `marketing-content-ideas` | Attach target keywords to ideas |
| `marketing-content-blog-post` | Consume SEO context in blog drafts |
| `marketing-service-page` | Consume SEO context in standalone service pages |
| `firm-context` | Industry + target location |
