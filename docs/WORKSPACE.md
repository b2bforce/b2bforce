# Workspace Conventions

File naming and output paths for B2BForce skills + workspace.

## General rules

1. Use **kebab-case** for slugs: `acme-digital`, not `Acme Digital`.
2. One primary markdown file per entity; use subfolders for history or attachments.
3. Prefix draft/template files with `!_` when they need attention: `!_profile.md`.
4. Date-prefix reports: `YYYY-MM-DD-weekly-report.md`.

## Path map

| Entity | Path pattern | Example |
|--------|--------------|---------|
| Company | `workspace/firm/profile.md` | — |
| Service | `workspace/firm/services/{slug}.md` | `services/seo-retainer.md` |
| ICP | `workspace/marketing/icp/{slug}.md` | `icp/mid-market-saas.md` |
| Buyer persona | `workspace/marketing/icp/personas/{slug}.md` | `personas/cmo-mid-market.md` |
| Content idea | `workspace/marketing/content/ideas/{content_type}--{buying_stage}--{slug}.md` | One backlog folder; filename indexes type + stage |
| Blog draft | `workspace/marketing/content/drafts/blog/{slug}.md` | 800–1500 words, Markdown |
| LinkedIn draft | `workspace/marketing/content/drafts/linkedin/{slug}.md` | Plain text, ~150–250 words |
| X draft | `workspace/marketing/content/drafts/x/{slug}.md` | Plain text, ≤280 chars or thread |
| Case study draft | `workspace/marketing/content/drafts/case-studies/{slug}.md` | PASTOR, Markdown |
| Service page | `workspace/marketing/landing-pages/{slug}/page.md` | Brief/service/URL + optional SERP — see `competitor-research.md` |
| Competitor | `workspace/intelligence/competitors/{slug}/` | `competitors/acme-agency/!_profile.md` |
| Weekly report | `workspace/intelligence/reports/{date}-{slug}.md` | `reports/2026-05-26-acme-agency.md` |
| Prospecting sequence | `workspace/sales/prospecting/{service}--{icp}--{persona}--{campaign-slug}.md` | Email sequence — separate from social drafts |
| Proof record | `workspace/firm/proof/{slug}.md` | `proof/northwind-release-automation.md` |
| Opportunity | `workspace/sales/opportunities/{account}--{service}--{YYYY-MM}/` | `opportunities/acme-industrial--platform-migration--2026-07/` |
| PDCA area | `workspace/pdca/{area}/` | `pdca/content-to-pipeline/README.md` |
| PDCA cycle | `workspace/pdca/{area}/cycles/{YYYY}-W{ww}--{slug}.md` | `cycles/2026-W31--buyer-question-coverage.md` |

Per-type length, format, and research rules: [content-generation.md](content-generation.md).

## Content idea frontmatter (example)

Path:

`workspace/marketing/content/ideas/blog_post--problem--why-mid-market-saas-teams-fail-at-content-marketing.md`

```yaml
---
title: Why mid-market SaaS teams fail at content marketing
content_type: blog_post   # blog_post | linkedin_post | x_post | case_study | landing_page | prospecting_sequence
buying_stage: problem     # problem | concept | education | decision | vendor
status: new               # new | approved | in_progress | generated | declined | later
language: en
service: seo-retainer
icp: mid-market-saas
persona: cmo-mid-market
buyer_question: Why is our content volume not producing qualified pipeline?
hook_type: problem
unique_angle: Why teams overproduce posts instead of fixing distribution.
proof_source: Internal audit of SaaS content programs.
next_action: Compare current content operations against the service audit checklist.
recommended_next_skill: marketing-content-blog-post
research_mode: dry_run
---
```

`service`, `icp`, and `persona` are required for content ideas and all idea-based
drafts. If an ICP/persona does not exist yet, create it first with
`marketing-icp`.

Keep all ideas in one folder. Do not create type subfolders. For human scanning
at high volume, encode type and buying stage in the filename:
`{content_type}--{buying_stage}--{slug}.md`. The frontmatter remains the source
of truth if filename and metadata ever disagree.

`target_keyword` is only for `blog_post` and `landing_page`. Leave it empty for
LinkedIn, X, case study, and prospecting ideas.

## Competitor folder structure

```text
workspace/intelligence/competitors/{slug}/
├── !_profile.md          # Name, URL, monitoring frequency, why it matters
├── pages.md              # Monitored page index
├── notes.md              # Manual analyst notes
├── snapshots/            # Timestamped page snapshots
└── changes/              # Timestamped change artifacts
```

## Landing page folder (standalone workflow)

```text
workspace/marketing/landing-pages/{slug}/
├── page.md
├── service-context.md
└── competitor-research.md
```

## Proof record

`workspace/firm/proof/{slug}.md` — one verified client result. This is the only
place a client outcome may be recorded, and the only source skills may cite from.
See the Proof Gate in `AGENTS.md` for the rules that read these fields.

Flat folder; the filename is the index. Slug on the result, not just the client:
`northwind-release-automation`, not `northwind`.

```yaml
---
client: northwind-logistics       # slug, or an approved anonymized label
client_public: false              # may the client be named?
quote_approved: false             # may a quote be reproduced?
usable_publicly: false            # may this appear in public material?
service: platform-migration
icp: mid-market-logistics
engagement_type: project          # project | retainer
period: 2025-03..2025-09
metrics:
  - { label: "Deployment lead time", before: "6 weeks", after: "4 days", verified: true }
reference_call_ok: false
source_opportunity:               # set when created from a won opportunity
created: 2025-10-01
updated: 2025-10-01
---
```

Body: what the situation was, what the firm did, what changed, and the approved
quote if `quote_approved: true`.

The three permission flags are independent and must not be treated as one:
`client_public` governs naming, `quote_approved` governs quoting, and
`usable_publicly` governs public material. A private proposal may cite a record
that is not publicly usable; a case study may not.

`verified: true` means a human confirmed the number. An agent must never set it.

A new record created on a win is a **stub** — flags `false`, `metrics` empty. That
is the honest state before delivery produces results.

## Opportunity folder

```text
workspace/sales/opportunities/{account}--{service}--{YYYY-MM}/
├── !_discovery.md    # situation, buyer's words, decision process, open questions,
│                     # bid_decision, brief_quality
├── proposal.md       # only after the Proposal Gate passes
└── outcome.md        # won | lost | no_decision | declined_by_us + reason + competitor
```

Scope lives **inside** `proposal.md` as `## Scope`, `## Out of scope`,
`## Assumptions`, and `## Change control`. Do not create a separate scope file — a
second document drifts from the first, and the client only reads one of them.

`bid_decision` is stored in `!_discovery.md` frontmatter rather than its own file,
for the same reason.

This folder is a record of decisions, not a CRM. One file per stage, each with a
decision and a reason. No pipeline stages, forecasts, probability weights, or
roll-ups — that is a different kind of tool and this repo should not drift into it.

## PDCA area folder

```text
workspace/pdca/{area}/
├── README.md        # outcome, metrics, sources of truth, cadence, owner, autonomy, baseline
├── cycles/
│   └── {YYYY}-W{ww}--{slug}.md
├── scoreboard.md    # appended when a cycle closes
├── evals.md         # acceptance-criteria patterns and regression tests
└── errors.md        # repeated failures and the guard added for each
```

One area = one business outcome. Do not create an area for "marketing" in general.

`scoreboard.md` grows by **appended rows**, one per metric checked, and past rows are
never rewritten. Do not pre-generate a row or column per future week: unfilled weeks
are placeholder content, and an append-only long table stays diffable as history.

Cycle files carry eleven required sections and are gated by
`scripts/validate-pdca-cycle.sh`. Details: `firm-pdca-cycle` and its
`references/cycle-file.md`.

## Private data

These stay **gitignored**:

- `.env` — API keys
- `data/firm.json` — optional machine metadata if a tool needs it

Workspace content is otherwise committed as operational history.
