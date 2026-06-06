---
name: marketing-content-ideas
description: >-
  Generate B2B content ideas across buying stages and content types (blog,
  LinkedIn, X, case study, service-page opportunity). Use when planning a content
  calendar from ICP and service context. Requires firm profile, service, ICP, and
  persona files. For writing drafts use marketing-content-* skills per type.
license: MIT
metadata:
  version: 1.0.0
  category: marketing
---

# Content Ideas Generator

Generates **15–25 content ideas** mapped to B2B buying stages and content types.

## When to Use

- User wants content calendar, ideation, or kanban backlog
- After ICP + personas exist for a service
- User specifies counts per type (e.g. 5 LinkedIn, 3 blog, 2 case study)

## Prerequisites

1. `workspace/firm/profile.md`
2. `workspace/firm/services/{service-slug}.md`
3. `workspace/marketing/icp/{icp-slug}.md` + at least one persona
4. Optional APIs: `EXA_API_KEY` (content landscape), `DATAFORSEO_*` (keywords), research for service-page opportunities

Hard gate: if the selected service has no linked ICP, or the ICP has no persona,
stop and run `marketing-icp` first. Do not invent ICP/persona context
inside the ideas prompt.

Run the central readiness check before generation:

```bash
scripts/validate-content-readiness.sh [service-slug] [icp-slug] [persona-slug]
```

## Content types and stage rules

| content_type | Allowed buying_stage |
|--------------|---------------------|
| linkedin_post, x_post, blog_post | all 5 stages |
| case_study | decision, vendor only |
| landing_page | vendor only |
| prospecting_sequence | any (usually separate skill) |

**Buying stages:** problem → concept → education → decision → vendor

Details: `references/buying-stages-and-types.md`

## Workflow

### 1. Build context

Assemble from workspace:

- **Company:** name, tagline, description, industry, brand_voice, specializations
- **Service:** name, type, challenges, features, outcomes, process, differentiators, fit_criteria
- **ICP:** target client company segment; pain_points, goals, trigger_events, buying_mode, messaging_angle, job_to_be_done, anti_fit_criteria
- **Persona:** decision maker or user; job_titles, seniority, pain_points, goals, content_formats, channels, objections
- **Persona distribution:** if user selects multiple personas, either generate a
  separate batch per persona or assign explicit counts per persona; every idea
  must carry one `persona` slug.
- **Exclusion list:** firm profile section `existing_content`, existing idea
  titles, existing `unique_angle`, existing `buyer_question`, and user-provided
  URLs/titles to avoid
- **Content landscape:** Exa search — top 10 articles on topic in last 12 months
  (if API set). If no research API is used, mark ideas as `research_mode: dry_run`.

### 2. Service page opportunity research (optional)

When `landing_page` count > 0 and user requests research:

Run service-page research — 5 queries:

competitors, landing_structure, objections, social_proof, cta_strategies

Optional DataForSEO keyword data.

Save research JSON to include in idea files for landing_page type only.

### 3. AI generation

**System prompt:** `references/system-prompt.md`. A buying-mode-aware appendix is always added on top; it tailors ideas to the ICP's `buying_mode` — `reactive` (problem/pain → urgent, problem-solving) vs `proactive` (challenge/opportunity → aspirational, growth-oriented), with `mixed` as the default. The ICP's `buying_mode`, `messaging_angle`, and `market_research` are passed in context for the AI to adapt.

**User prompt includes:**

- Count per type OR total count distributed across stages
- Language from firm context
- Existing ideas from `workspace/marketing/content/ideas/` as JSON (dedup)
- Dedupe against titles, buyer questions, unique angles, and problem framing,
  not only exact title matches
- Big5 topic guidance where relevant (cost, problems, comparisons, alternatives, reviews)
- hook_type per idea: data | question | contrarian | specificity | problem | story
- Quality rubric per idea: buyer question, stage fit, service fit, proof source,
  non-generic angle, next action
- Persona-aware distribution if more than one persona is selected
- Research mode: `market_informed` only if Exa/DataForSEO/SERP/market context was
  used; otherwise `dry_run`
- SEO discipline: `target_keyword` only for `blog_post` and `landing_page`; set
  it empty/null for LinkedIn, X, case study, and prospecting
- Proof discipline:
  - do not invent client names, metrics, page counts, revenue numbers, or research claims;
  - use specific numbers only when they exist in firm/service/proof context;
  - if `case_study` is requested and no real proof exists, create the idea with
    a `[Client]` placeholder and `proof_source: needs real client proof before draft`;
  - never generate a case study draft from a placeholder proof idea.

**Output schema:** `references/output-schema.md`

Generate batch ID: `batch-{YYYY-MM-DD}-{uuid-short}` — same ID in all idea files from this run.

### 4. Write workspace outputs

One file per idea:

`workspace/marketing/content/ideas/{content_type}--{buying_stage}--{slug}.md`

Keep all ideas in one folder. Do not create type subfolders. The filename is a
human scanning index for large backlogs; frontmatter remains the source of truth.

```yaml
---
title:
content_type: blog_post
buying_stage: problem
status: new
language: en
service: {slug}
icp: {slug}
persona: {slug}
buyer_question:
big5_topic: problems          # optional: cost|problems|comparisons|alternatives|reviews
target_keyword:                 # optional, from SEO research
generation_batch: batch-2026-06-01-abc123
competitive_research: false     # landing_page only — path to research file if saved
hook_type: data                 # metadata for quality (optional in frontmatter)
unique_angle:
proof_source:
next_action:
recommended_next_skill: marketing-content-blog-post
research_mode: dry_run
---
```

Description body: 2–3 sentences on content angle.

If landing_page with research, also write:
`workspace/marketing/content/ideas/{content_type}--{buying_stage}--{slug}-research.json`

### 5. Default distribution (if user doesn't specify)

Only content types that are **enabled** are generated. By default just three are
enabled: **LinkedIn×5, X×5, blog×3** (≈13 ideas). `case_study` has a default
count of 2 and `landing_page`/`prospecting_sequence` default to 0, but those are
**off by default** — they are only generated if the user enables them.
The legacy "total count" mode (no per-type counts) defaults to 20 ideas spread
across all 5 stages.

## Quality rules

- Titles must use hook patterns (data, question, contrarian, specificity, problem, story)
- Avoid generic titles ("Complete Guide to X", "10 Best Tips")
- Each idea needs unique_angle vs existing ideas and content landscape
- Match content type to buying stage restrictions
- Early stages → educational; late stages → comparison/proof
- No fabricated proof: specific metrics, client names, research claims, and case
  study facts must come from workspace context or be marked as needing real proof.
- Every idea must include `buyer_question`, `next_action`, `recommended_next_skill`,
  and `research_mode`.
- Run `scripts/validate-content-ideas.sh` after writing ideas; fix any failures
  before generating drafts.

## Related Skills

| Skill | When |
|-------|------|
| `marketing-icp` | Missing ICP |
| `marketing-content-blog-post` etc. | Generate draft from approved idea |
| `marketing-service-page` | Create service page from a `landing_page` opportunity |
