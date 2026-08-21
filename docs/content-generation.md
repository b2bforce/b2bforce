# Content Generation — Types and Skills

How B2BForce skills generate content. **Do not use one generic “write
content” skill** — each format has different prompts, context, length rules, and
workspace paths.

## Two pipelines (important)

| Pipeline | When | Skill | Output |
|----------|------|-------|--------|
| **Idea → draft** | User has a content idea with `content_type` | Type-specific `marketing-content-*` skills | `workspace/marketing/content/drafts/{type}/` |
| **Brief/service → service page** | New standalone service page from text, service file, URL, and optional SERP competitors | `marketing-service-page` | `workspace/marketing/landing-pages/{slug}/` |
| **Idea → prospecting** | Content idea type `prospecting_sequence` | `sales-prospecting-sequence` | `workspace/sales/prospecting/` |

Service pages are **not** the same workflow as blog posts. The standalone
service-page pipeline can use service context, a brief, a URL, SEO phrases, and
optional SERP/competitor research. `landing_page` ideas are service-page
opportunities; they route to `marketing-service-page`, not a content draft skill.

## Content types (from `ContentIdea`)

| Type | Label | Buying stages | Skill name |
|------|-------|---------------|-----------|
| `blog_post` | Blog Post | All stages | `marketing-content-blog-post` |
| `linkedin_post` | LinkedIn Post | All stages | `marketing-content-linkedin-post` |
| `x_post` | X (Twitter) Post | All stages | `marketing-content-x-post` |
| `case_study` | Case Study | `decision`, `vendor` only | `marketing-content-case-study` |
| `landing_page` | Service Page Opportunity | `vendor` only | `marketing-service-page` |
| `prospecting_sequence` | Prospecting emails | (sales) | `sales-prospecting-sequence` |

Stage restrictions must be enforced in `marketing-content-ideas` when generating
ideas — do not assign `landing_page` to problem-aware stage, etc.

## Prompt layering (all idea → draft types)

Every generation skill should stack prompts in this order:

1. **Base writer** — style, storytelling, data/evidence rules (no length).
2. **Quality layer** — universal anti-slop guidelines.
3. **Format layer (per type)** — **highest priority** — length, structure, output format.

Per-type format requirements live in each skill's `references/`.

Idea → draft skills are written for the **current agent/LLM session**. API keys
are only required by explicit external research/scraping steps such as
`tool-exa`, `tool-firecrawl`, or `tool-dataforseo`.

### Per-type format summary

| Type | Length | Output | Key rules |
|------|--------|--------|-----------|
| **LinkedIn** | 150–250 words optimal; max ~300 words / 3000 chars | Plain text, no markdown headers | One sentence per line; no bullet lists; 0–2 emojis; 2–3 hashtags; framework varies by buying stage (story hook, PAS, etc.) |
| **X / Twitter** | 150–250 chars optimal; max 280/tweet; threads 8–12 | Plain text; threads separated by `---` | No external links in body; 1–2 hashtags; reply hooks; algorithm-native |
| **Blog** | 800–1500 words | Markdown with H2/H3 | Framework by stage (expert opinion funnel, how-to, comparison, etc.) |
| **Case study** | 500–1500 words | Markdown | PASTOR structure; 2–3 metrics; client quote; before/after |
| **Prospecting** | Email sequence | Markdown / structured emails | Separate frameworks (OIS, PAS, Trigger, Value-First, Curiosity) — not social formats |

## Context inputs (shared)

All idea → draft skills read from workspace (not from JSON import):

- `workspace/firm/profile.md` — brand voice, words to avoid
- `workspace/firm/services/{slug}.md` — service context
- `workspace/marketing/icp/{slug}.md` — target client company segment
- `workspace/marketing/icp/personas/{slug}.md` — decision maker or user persona
- Content idea file — title, description, `content_type`, `buying_stage`, `status`,
  language, `service`, `icp`, `persona`, `buyer_question`, `hook_type`,
  `unique_angle`, `proof_source`, `next_action`, `recommended_next_skill`,
  `research_mode`

## ICP gate

Do not generate content ideas, drafts, landing pages, prospecting, or content
editing suggestions without `service + icp + persona` context. The service should
link to the ICP via `target_icps` when possible; each persona must point back to
the ICP with `icp:`.

If the selected service has no ICP or no persona, run `marketing-icp` first.
Do not create a throwaway ICP inside a prompt.

Optional per-firm content guidelines: add
`workspace/firm/content-guidelines/{type}.md` and feed it into the format layer.

## Draft gate

Before any idea → draft skill:

1. Run `scripts/validate-content-ideas.sh`.
2. Use only an idea with `status: new` or `status: approved`.
3. Verify `recommended_next_skill` matches the skill you are about to run.
4. Load the firm, service, ICP, persona, and all idea frontmatter fields listed
   above. Do not write from title + description only.
5. Treat `research_mode: dry_run` as an internal-context draft. Do not imply the
   angle has been externally benchmarked.
6. Treat `research_mode: market_informed` as externally enriched only if a research
   artifact or cited reference notes are present.
7. After writing the draft, run `scripts/validate-content-draft.sh {draft-path}`.
8. Update the source idea to `status: generated` only after the draft exists and
   validates.

Case studies have an additional proof gate: if `proof_source` says
`needs real client proof before draft`, or the title contains `[Client]`, read
`workspace/firm/proof/` for a matching record before asking the user anything. A
case study is public material and needs `usable_publicly: true`. If no usable record
exists, stop, collect the client facts, and have `sales-outcome-log` write the record
— then draft. Do not draft a fake case study with placeholder proof.

## Client proof in content

All content types share one source of truth for client results:
`workspace/firm/proof/{slug}.md`. The canonical rules are the Proof Gate in
`AGENTS.md`; the short version for content:

- Public material — blog, case study, service page, social — requires
  `usable_publicly: true`.
- Name a client only with `client_public: true`; otherwise use the record's approved
  anonymized label.
- Quote a client only with `quote_approved: true`.
- Use only metrics with `verified: true`.
- No usable record? Write what is true without the client claim, and say what proof
  is missing.

Proposals are **not** part of the idea → draft pipeline. They use
`sales-proposal`, a different gate, and `scripts/validate-proposal.sh`. They do
reuse the shared writing-quality rules below and the same proof rules, with one
difference: a proposal is private, so it may cite a record with
`usable_publicly: false` as long as naming and quote flags are respected.

## Answer-first opening (blog, case study, service page)

Long-form content is now read by two audiences: a buyer, and an answer engine deciding
what to quote. Both want the same thing in the same place.

**Open by answering the idea's `buyer_question` directly, in 40–60 words, before any
build-up.** Then develop it as normal.

This looks like it contradicts "open with a specific buyer problem, observation, or
tension" below. It does not, and the resolution matters: name the tension **and** resolve
it in the same opening. A direct answer that states what most firms get wrong is both.

```markdown
<!-- weak: tension with no answer, nothing extractable -->
Every mid-market team eventually faces the migration question. It is harder than
it looks, and the stakes are high. Let's explore what's involved.

<!-- strong: names the tension and answers it in one move -->
Most mid-market teams ask whether to migrate all at once or incrementally. Below
roughly 200k monthly users, incremental almost always wins: it keeps releases
shippable and spreads risk across quarters. Above that, the coordination cost of
running two systems flips the maths — and that threshold, not platform choice, is
the decision that matters.
```

Why 40–60 words: short enough to be quoted whole, long enough to carry a qualified
claim. A one-sentence teaser gives an engine nothing to lift; a 200-word wind-up buries
the answer below where it looks.

Also worth doing, not mechanically enforced:

- **A machine-readable FAQ** — an `## FAQ` section with each question as an `###`
  subhead and a self-contained answer under it. Self-contained matters: an answer that
  depends on the paragraph above it cannot be quoted alone.
- **Named, quantified evidence.** "Reduced deployment time by 80%" is quotable;
  "significantly faster" is not. Evidence still comes only from
  `workspace/firm/proof/` — see the Proof Gate.
- **Concrete entities.** Name the platforms, standards, regions, and roles. Engines match
  on specifics, and so do buyers.

`scripts/validate-content-draft.sh` checks the opening paragraph length on blog posts.
It cannot check whether the opening actually answers the question — that stays a
judgment call for the writing skill.

This is the on-site half of answer-engine visibility. The larger half is which
third-party surfaces get cited at all, which is `intel-ai-visibility` and
`marketing-geo-placement`.

## Shared writing quality

These rules come from the old app prompt stack and apply to every content draft:

- Open with a specific buyer problem, observation, or tension. No generic intros.
- Every section should move from problem/context → insight → action.
- Use concrete examples only from workspace context, reference notes, or a
  `workspace/firm/proof/` record.
- Never invent case results, metrics, quotes, client names, or external research.
- Acknowledge boundaries where useful: when an approach fits, and when it does not.
- Match buying mode: reactive buyers need urgency, empathy, and quick wins;
  proactive buyers need strategic upside, tradeoffs, and ROI logic.
- Avoid AI-slop phrases: "testament to", "plays a crucial role", "underscores",
  "groundbreaking", "delve", "showcase", "comprehensive", "multifaceted",
  "it's worth noting", and vague attributions such as "experts say".
- Do not add a generic conclusion section. End with a stage-matched next action.

## Content idea validation

After writing ideas, run:

```bash
scripts/validate-content-ideas.sh
```

This validates required frontmatter, filename convention, stage restrictions,
proof placeholders for case studies, and SEO keyword rules.

## Research enrichment (differs by type)

| Type | Exa reference articles | Competitive research | SERP / scrape |
|------|------------------------|----------------------|---------------|
| Blog post | Yes | No | No |
| Case study | Yes | No | No |
| Service page opportunity | No | Yes (optional, via `marketing-service-page`) | Yes (optional) |
| LinkedIn | **No** | No | No |
| X post | **No** | No | No |
| Prospecting | **No** | No | No |

Implementing skills: call Exa only for types in the first column; never attach
long-form reference blocks to LinkedIn/X prompts.

Exa is optional enrichment, not a prerequisite for writing. Use the existing
`tool-exa` skill when the user wants a market-informed draft or when a long-form
skill needs reference articles. Do not create a separate Exa/content-research skill
unless it owns a new persisted artifact and workflow.

## Distribution channels

`workspace/marketing/channels/` (multi-brand: `channels/{brand}/`) is the registry
of **owned** surfaces content ships to — blog, X, LinkedIn, newsletter, Medium.
Schema: `docs/WORKSPACE.md`, section "Distribution channel".

- **When the registry has active channels, it decides distribution.**
  `marketing-content-ideas` proposes only content types some active channel lists
  in `content_types`, and sizes counts to the channels' `schedule` lines — a
  channel posting weekly does not need five ideas a week. With no channel files,
  the hardcoded defaults apply as before.
- **Draft skills read the target channel's body** — its "what to publish here"
  and format notes — as one more context input, after the persona.
- **Publishing mechanics live in the channel file**, not in skills: `publish_via`
  (Buffer, native, CMS, mailing tool) plus the body's how-to. Skills produce
  drafts; the channel file says how a draft leaves the repo and who approves it.
- A `paused` or `retired` channel receives nothing. Retiring the only channel for
  a type effectively disables that type in idea generation.

## Workspace output paths

```text
workspace/marketing/content/
├── ideas/
│   └── {content_type}--{buying_stage}--{slug}.md
│                              # frontmatter: content_type, buying_stage, status, service, icp, persona
└── drafts/
    ├── blog/{slug}.md
    ├── linkedin/{slug}.md
    ├── x/{slug}.md
    ├── case-studies/{slug}.md

workspace/marketing/landing-pages/
└── {slug}/                      # standalone service-page workflow only
    ├── page.md
    ├── service-context.md       # generated service definition
    └── competitor-research.md   # SERP URLs + scrape summaries

workspace/sales/prospecting/
├── {service}--{icp}--{persona}--{campaign-slug}.md
│                                  # default prospecting_sequence
└── {service}--{icp}--{persona}--{campaign-slug}/
    ├── sequence.md                # optional pack when variants/import are requested
    ├── variants.md
    └── crm-import.csv
```

## Skill design rules

1. **One skill per content type** (or one router skill that delegates) — never
   one prompt for all formats.
2. Each skill's `SKILL.md` carries format requirements in `references/`.
3. Each skill documents: allowed buying stages, length, output path, research steps.
4. `marketing-content-ideas` generates ideas with explicit `content_type`.
   `landing_page` ideas are service-page opportunities and should use
   `recommended_next_skill: marketing-service-page`.
5. Content idea filenames must use `{content_type}--{buying_stage}--{slug}.md`
   for scanning large backlogs. Do not create type subfolders.
6. `marketing-service-page` is a **separate skill** for standalone service pages.
   Do not recreate a separate content landing-page draft skill.

## Related docs

- [WORKSPACE.md](WORKSPACE.md) — naming conventions
