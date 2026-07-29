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
| AI visibility panel | `workspace/intelligence/ai-visibility/!_prompts.md` | Versioned prompt panel, max 30 active |
| AI visibility run | `workspace/intelligence/ai-visibility/runs/{YYYY-MM-DD}/{prompt-slug}.md` | One file per prompt per batch, all engines inside |
| Placement target | `workspace/marketing/placements/{domain}.md` | `placements/clutch.co.md` |
| Prospecting sequence | `workspace/sales/prospecting/{service}--{icp}--{persona}--{campaign-slug}.md` | Email sequence — separate from social drafts |
| Proof record | `workspace/firm/proof/{slug}.md` | `proof/northwind-release-automation.md` |
| Opportunity | `workspace/sales/opportunities/{account}--{service}--{YYYY-MM}/` | `opportunities/acme-industrial--platform-migration--2026-07/` |
| Client account | `workspace/clients/{slug}/` | `clients/northwind-logistics/!_account.md` |
| QBR | `workspace/clients/{slug}/qbr/{YYYY}-Q{N}.md` | `qbr/2026-Q4.md` |
| Client health report | `workspace/clients/reports/{YYYY-MM-DD}-health.md` | `reports/2026-12-01-health.md` |
| PDCA area | `workspace/pdca/{area}/` | `pdca/content-to-pipeline/README.md` |
| PDCA cycle | `workspace/pdca/{area}/cycles/{YYYY}-W{ww}--{slug}.md` | `cycles/2026-W31--buyer-question-coverage.md` |

Per-type length, format, and research rules: [content-generation.md](content-generation.md).

## Worked example

`examples/demo-firm/` is a filled version of this path map: one fictional firm carried
from profile through ICP, content, discovery, proposal, win, client account, QBR, and a
closed PDCA cycle. When a schema here is ambiguous, that directory is the canonical
shape, and `scripts/demo-check.sh` keeps it honest by running every gate against it.

It is fiction and marked `fixture: true` in every file — read
[examples/README.md](../examples/README.md) before using anything from it.

Paths in this document are relative to `workspace/`. The validators in `scripts/`
resolve that prefix from `B2BFORCE_ROOT`, which defaults to `workspace/` and is set to
the demo copy only by `scripts/demo-check.sh`.

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

## AI visibility folder

```text
workspace/intelligence/ai-visibility/
├── !_prompts.md                      # the panel — max 30 active prompts, versioned
├── runs/{YYYY-MM-DD}/{prompt-slug}.md  # one file per prompt per batch
└── share-of-answer.md                # append-only rollup, one row per prompt per batch
```

**One run file per prompt per batch, with every engine and run inside it.** A file per
engine per run would produce well over a hundred files a month for a normal panel, which
breaks the Minimal Files Rule for no gain.

The panel is versioned and stable: change it by adding a prompt and marking the old one
`retired`, never by editing a prompt in place. Runs from a drifting panel are not
comparable, and comparability is the only reason to keep this history.

`share-of-answer.md` grows by **appended rows** and past rows are never rewritten, the
same discipline as `pdca/scoreboard.md`.

Retention: rollup rows are permanent; `runs/` folders older than six months may be
pruned. Sampling rules for these artifacts: "Answer Engine Sampling" in `AGENTS.md`.

## Placement target

`workspace/marketing/placements/{domain}.md` — one file per domain, flat folder, filename
is the index. One per third-party surface an answer engine cites.

`status` moves `new` → `pitched` → `listed`, with `declined` and `not_viable` as
terminal. `not_viable` is deliberate: a surface that does not accept outside listings
should be closed once rather than resurfacing in every review.

`citation_count` must be countable from files in `ai-visibility/runs/`. A domain that
appears in no run does not get a file.

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

## Client folder

```text
workspace/clients/{slug}/
├── !_account.md       # the account record — required
├── onboarding.md      # written success definition, stakeholders, day 14/30/90
├── account-plan.md    # committee map, expansion hypotheses with triggers, risks
├── qbr/{YYYY}-Q{N}.md # delivered vs promised, next quarter, expansion + referral asks
└── notes.md           # relationship signals with a risk level
workspace/clients/reports/{YYYY-MM-DD}-health.md
```

Only `!_account.md` is required. Create the rest when a workflow needs them.

There is deliberately **no** `engagements/` folder. A delivered engagement is already
recorded twice — the deal in `workspace/sales/opportunities/{opportunity}/outcome.md`
and the result in `workspace/firm/proof/{slug}.md`. A third copy inside the client
folder is exactly the mirroring the DRY rule forbids, and it would be the copy that
goes stale. `!_account.md` carries `services` and links to the opportunities instead.

### Account record

`workspace/clients/{slug}/!_account.md`. `client` must equal the folder name.

```yaml
---
client: northwind-logistics
services: [platform-migration]     # slugs from workspace/firm/services/
engagement_type: retainer          # retainer | project | mixed
start_date: 2026-08-17
renewal_date: 2027-08-16           # empty for a one-off project
mrr_band: 5-10k                    # a band, never an exact figure
health: green                      # green | amber | red
health_reason: Both quarters delivered against the success definition.
contacts:
  - { name: "Anna Kowalska", role: "CTO", type: economic_buyer }
  - { name: "Piotr Lis", role: "Head of Platform", type: user }
referenceable: true                # true | false | pending
status: active                     # active | paused | ended
reviewed_at: 2026-12-01            # required while active
last_contact: 2026-11-28
---
```

Body: what the firm does for them, what the relationship depends on, and open risks.

Rules enforced by `scripts/validate-account.sh`:

- at least one named contact with a role — the Client Context Gate;
- `health: amber` or `red` requires a `health_reason`. A colour without a stated cause
  cannot be acted on;
- `reviewed_at` is required while active, and a stale `reviewed_at` with `health: green`
  is an **error** — see the Client Context Gate in `AGENTS.md`;
- exact-money fields (`contract_value`, `mrr`, `arr`, `margin`, `utilization`,
  `hours_logged`, `rate`) are rejected. This folder holds the relationship, not the
  ledger, and `mrr_band` keeps a leak cheap.

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
- `*.pdf` and `tmp/` — rendered documents are build output, not records. The
  Markdown source is versioned; a committed PDF is a binary that drifts from it.

Workspace content is otherwise committed as operational history.
