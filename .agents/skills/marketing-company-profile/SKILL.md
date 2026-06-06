---
name: marketing-company-profile
description: >-
  Create, enrich, or refresh workspace/firm/profile.md from a company website URL.
  Use during setup after firm-context interview, or later when the firm's website,
  positioning, proof points, or target market changed.
license: MIT
metadata:
  version: 1.0.0
  category: marketing
---

# Company Profile from URL

Creates, enriches, or refreshes the firm profile from a website.

## When to Use

- Setup: user provides company website URL during `firm-context`
- Create: `workspace/firm/profile.md` is missing or still a template
- Enrich: interview-based `workspace/firm/profile.md` exists and should be improved
  with website facts
- Refresh: the firm changed its website, positioning, proof points, target market,
  or services and the profile should be checked again

## Prerequisites

- Company website URL
- Current agent/LLM session
- Read existing `workspace/firm/profile.md` if it exists
- Optional website access through the current agent/browser, or `tool-firecrawl`
  if configured

## Workflow

### 1. Choose mode

Use one of three modes:

- `create` — no real `workspace/firm/profile.md` exists.
- `enrich` — setup already created an interview-based profile.
- `refresh` — profile exists and the user wants a later website re-audit.

### 2. Read current context

Read `workspace/firm/profile.md` first. Treat it as the source of truth for
user-provided facts.

### 3. Fetch website content

Fetch the website's most relevant pages: homepage, about, services, case studies,
industries, and contact if available.

Use the current agent/browser when available. If the workflow is being automated
and `tool-firecrawl` is configured, use Firecrawl scrape/map scripts. If no
website access is available, stop this skill and keep the interview-based profile;
do not invent website facts.

Truncate page content to the minimum useful evidence. Keep source URLs in notes
only when they support a changed field.

### 4. Extract profile facts

Extraction priorities, in order:

1. What the firm does
2. Who it serves
3. Services and specializations
4. Positioning and brand voice
5. Proof points and credibility signals
6. Operating regions and objective firmographics

Possible fields: name, website_url, tagline, description, industry, target market,
brand_voice, words_to_avoid if stated, specializations, proof_points, flagship
clients, certifications, country, city, operating_regions, employee_count,
founded_year.

Use `null` or omit fields that cannot be determined. Do not guess revenue,
headcount, clients, certifications, or founding year.

**Enums:**

- `industry`: digital_agency, software_house, saas, consulting, ecommerce, fintech, healthcare, education, manufacturing, retail, media, real_estate, logistics, energy, nonprofit, government, other
- `target_market_segment`: smb, mid_market, enterprise, all
- `messaging_style`: educational, authoritative, conversational, technical, inspirational
- `employee_count`: 1-10, 11-50, 51-200, 201-500, 501-1000, 1000+
- `annual_revenue`: <1M, 1-5M, 5-20M, 20-100M, >100M

Country names may be mapped to ISO codes when the existing profile uses codes.
Do not default to `US` unless the website or user said so.

### 5. Merge into profile

Write only:

`workspace/firm/profile.md`

Merge rules:

- User-provided facts from the existing profile win over website extraction.
- Fill blank/template fields with website evidence.
- On refresh, update objective facts only when the website is clearly current.
- If the website conflicts with an important existing fact, do not silently
  overwrite it. Add a short `!_verify` note in `workspace/firm/profile.md` or ask
  the user if the workflow can pause.
- Do not create `data/firm.json` or duplicate firm context elsewhere.
- Keep the profile concise; remove generic website boilerplate.

### 6. Refresh behavior

For refresh, re-read the current website and compare against the profile. Focus on
meaningful changes: positioning, services, target markets, proof points, regions,
and brand voice. Ignore navigation labels, generic marketing copy, and minor page
wording changes.

## Quality rules

- Specific over generic taglines (e.g. "AI-powered content for B2B service companies", not "We help businesses grow")
- brand_voice: detailed, actionable tone guidance (formal/casual, technical/business, confidence level, recurring phrases) — not "professional and friendly"
- description: lead with what they DO, not who they ARE
- Use the closest enum match only when the profile schema uses enums; use null
  or omit when unknown
- Flag low-confidence fields with `!_verify` comment
- Never ask the user to paste API keys in chat. If a tool key is needed, tell the
  user to fill `.env` locally.

## Related Skills

| Skill | When |
|-------|------|
| `firm-context` | Setup interview and manual profile before enrichment |
| `marketing-service` | Next: create or enrich primary services |
| `marketing-icp` | After services exist |
