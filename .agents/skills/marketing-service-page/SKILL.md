---
name: marketing-service-page
description: >-
  Create or refresh a standalone B2B service page from a service brief, URL,
  existing service file, or a mix of inputs. Use when the user wants a landing
  page/service page without first creating a content idea. Output to
  workspace/marketing/landing-pages/{slug}/.
license: MIT
metadata:
  version: 1.0.0
  category: marketing
---

# Service Page

Standalone service-page workflow. **Does not** use the content idea backlog.

## When to Use

- User says "add landing page", "create service page", or "write landing page"
- User provides a service brief, URL, existing service slug, or any combination
- Need competitor-informed differentiation (optional SERP/scrape)
- No prior content idea exists

## Prerequisites

**Brand scope.** In a multi-brand workspace (2+ files in `workspace/firm/brands/`), every workspace path this skill reads or writes gains a `{brand}/` segment directly under its entity root, and the working brand comes from the user's choice or `B2BFORCE_BRAND` — never guessed. Rules: Brand Scope Gate in `AGENTS.md`; paths: `docs/WORKSPACE.md`.

- `workspace/firm/profile.md`
- Service name/slug, existing service file, URL, description, or both
- Current agent/LLM session
- Optional APIs for competitor research: `FIRECRAWL_API_KEY`,
  `DATAFORSEO_LOGIN`/`PASSWORD`, or `EXA_API_KEY`

If the service context is missing or thin, run `marketing-service` first or
create `service-context.md` inside the service-page folder from the user brief.

## Pipeline

### 1. Resolve service context

Input priority:

1. User-provided description
2. Existing `workspace/firm/services/{slug}.md`
3. URL page content
4. Firm profile

If a URL and description conflict, user description wins. Do not invent proof,
metrics, clients, or pricing.

A service page is public material. Client results may only come from
`workspace/firm/proof/` records with `usable_publicly: true`, named only when
`client_public: true` — see the Proof Gate in `AGENTS.md`.

Write or update:

`workspace/marketing/landing-pages/{slug}/service-context.md`

### 2. Generate SEO phrases

Generate commercial-intent B2B keyword candidates for the service. If
DataForSEO/Exa is unavailable, mark them as draft keywords, not validated search
data.

### 3. Optional competitor research

**Primary:** Exa search (5 results, take top **3**) for competitor service pages  
**Fallback:** DataForSEO SERP top 10 organic results → scrape top **3** pages with Firecrawl (each truncated to 15k chars)

If no research tool is available, continue from firm/service context and mark the
page as `research_mode: dry_run`.

Write: `workspace/marketing/landing-pages/{slug}/competitor-research.md`

Include: URL, title, key messaging, gaps/opportunities

### 4. Generate service page

**System prompt:** inline 8-section structure (Hero, Problem, Solution, Benefits, How It Works, Social Proof, FAQ, CTA) — see `references/system-prompt.md`

Input: service context + competitor analysis + SEO phrases

Differentiation: fresh angles competitors miss; anti-AI-slop rules. Do not claim
external competitor validation unless competitor research was actually run.

### 5. Write outputs

```text
workspace/marketing/landing-pages/{slug}/
├── page.md              # Final service page Markdown
├── service-context.md     # Generated service definition
└── competitor-research.md # SERP/scrape summary
```

Optionally create content idea stub with `content_type: landing_page`, `buying_stage: vendor` for tracking.

## Anti-slop rules

- No "In today's world..."
- No buzzwords without substance
- Hook with data, story, or provocative statement
- No rhetorical question openings

## Related Skills

| Skill | When |
|-------|------|
| `marketing-service` | Create/enrich service context first |
