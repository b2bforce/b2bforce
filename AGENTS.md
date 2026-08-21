# AGENTS.md — B2BForce Skills + Workspace

Guide for AI coding assistants working in this repository.

## Purpose

This is a **skills + workspace repo** for a **professional service firm** (Maister PSF):
a business that sells expertise via projects and retainers — agencies, consultancies,
dev shops, and similar B2B service providers. **Not** for product SaaS companies or
e-commerce.

Framework: David Maister's [*Managing the Professional Service Firm*](https://en.wikipedia.org/wiki/Managing_the_Professional_Service_Firm).

## Directory structure

```text
├── AGENTS.md                 # This file
├── .agents/
│   └── skills/               # Agent Skills — executable workflows (primary)
├── .claude/skills/           # Symlink → .agents/skills (Claude Code)
├── workspace/                # Operational artifacts (committed)
│   ├── firm/                 # Your company profile, brands, services, verified client proof
│   ├── marketing/            # ICP, content, landing pages
│   ├── sales/                # Prospecting, opportunities, proposals, outcomes
│   ├── clients/              # Won accounts — onboarding, account plans, QBRs, health
│   ├── intelligence/         # Competitors, snapshots, changes, reports, AI visibility
│   └── pdca/                 # Measurement loop — cycles, scoreboards, evals
├── examples/
│   ├── demo-firm/            # Fictional single-brand firm — example and validator fixture
│   └── demo-group/           # Fictional multi-brand group — the Brand Scope Gate demonstrated
├── data/                     # Optional machine metadata only when a tool needs it
├── docs/                     # SETUP-PROMPT, WORKSPACE conventions
└── scripts/bootstrap.sh      # Clone template for new firm instances
```

`examples/` is never firm context — see the Firm Context Gate below.

## Before any task

1. Read `workspace/firm/profile.md` first. This is the primary firm context.
2. Read the relevant `workspace/*/README.md` for the area you are working in.
3. Follow `docs/WORKSPACE.md` for file naming and output paths.

## Minimal Files Rule

Keep the repo as small as possible while still useful to an AI agent and a human
operator.

- Prefer **one source of truth** over mirrored files.
- Prefer **Markdown in `workspace/`** for business context because humans and LLMs
  can both read it.
- Create JSON only when a script, app, or integration actually consumes it.
- Do not create placeholder files, duplicate summaries, or long explanatory docs
  unless a workflow needs them.
- In every file, write the minimum useful text: concrete facts, decisions, paths,
  and next actions. Cut generic explanation.

## File Naming for Large Folders

When a workflow creates many files in one folder, filenames must be easy to scan
without opening each file.

- Encode the most useful sorting/filtering dimensions in the filename.
- Keep the folder flat when it is one backlog or one operational queue.
- Do not create type subfolders unless ownership, permissions, or workflow
  boundaries are actually different.
- Frontmatter remains the source of truth; filename metadata is a human-readable
  index for large directories.

Example: content ideas use
`workspace/marketing/content/ideas/{content_type}--{buying_stage}--{slug}.md`.

## DRY and SOLID Rule

Keep this repo DRY and SOLID.

- Put shared rules, gates, schemas, and conventions in one central place.
- Do not copy the same instruction block into many skills or docs.
- A skill should own one workflow and depend on shared conventions instead of
  redefining them.
- If a rule applies to many workflows, add it to `AGENTS.md`, `docs/WORKSPACE.md`,
  or a focused shared doc such as `docs/content-generation.md`.
- Keep skill files small: prerequisites specific to that skill, the workflow steps,
  outputs, quality checks, and links to shared rules.
- When changing a shared rule, update the central source first, then only adjust
  skills that need workflow-specific behavior.

## Firm Profile Decision

Use `workspace/firm/profile.md` as the primary firm profile.

Do not create a second firm profile in `.agents/`. If a user has sensitive context,
ask where it should live before writing it. Do not invent hidden mirrors.

`data/firm.json` is optional machine metadata. Do not create or update it during
setup unless a concrete tool or script needs structured fields.

## Firm Context Gate

This repo only works after the firm and its services are described.

Before running any marketing, sales, or intelligence workflow, verify:

- `workspace/firm/profile.md` exists and is filled with real firm context.
- At least one `workspace/firm/services/{slug}.md` exists and describes an actual
  service the firm sells.

If either is missing, stop the requested workflow and insist on completing setup
first. Ask for the missing firm/service details until there is enough context to
write the files. Without a firm profile and service definitions, the skills have no
useful grounding and should not generate downstream artifacts.

**`examples/` is fiction and never satisfies this gate.** `examples/demo-firm/`
(single-brand) and `examples/demo-group/` (multi-brand) hold fictional firms used as
readable examples and as the regression fixtures for the validators. Every file in
them carries `fixture: true` in its frontmatter.

- Never read it as the user's firm context, and never fill a missing profile from it.
- Never cite its proof records, metrics, quotes, or client names. A file with
  `fixture: true` is not evidence, whatever its permission flags say.
- Copy its **structure** freely — that is what it is for. Never copy its facts.
- Write deliverables to `workspace/`. Only `scripts/demo-check.sh` and a deliberate
  change to the demo itself write under `examples/`.

## Brand Scope Gate

Some firms run more than one brand: separate names, domains, and service lines,
sold by one legal firm with one shared team and one shared client base. The
workspace supports that without taxing the single-brand majority.

**The mode is detected, never configured.** `workspace/firm/brands/{slug}.md` is
the registry — one file per brand, schema in `docs/WORKSPACE.md`. Zero or one
file means **single-brand**: flat paths, no brand fields anywhere, every rule in
this document exactly as written. Two or more files mean **multi-brand**, and
three rules apply on top:

1. **Market-side paths carry a `{brand}/` segment** directly under the entity
   root: `firm/services/{brand}/`, `marketing/icp/{brand}/` (personas inside),
   `marketing/channels/{brand}/`, `marketing/content/{brand}/`,
   `marketing/landing-pages/{brand}/`, `marketing/placements/{brand}/`,
   `sales/prospecting/{brand}/`, `sales/opportunities/{brand}/`,
   `intelligence/ai-visibility/{brand}/`.
   The path is the **only** source of a path-scoped artifact's brand — never
   repeat it in frontmatter, because the copy is what drifts.
2. **Firm-side entities stay shared** — one client account, one proof record,
   one competitor profile, whichever brands are involved — and declare brands in
   frontmatter: `brands: [...]` on clients and competitors, `brand:` on proof.
   Only these shared entities use the qualified reference form `{brand}/{slug}`
   (e.g. in a client's `services:` list). Everywhere else references stay bare
   slugs and resolve within the artifact's own brand.
3. **A service and the ICP and personas it targets belong to the same brand.**
   Content, prospecting, and proposals inherit the brand of their path and may
   reference only that brand's service, ICP, and persona. Cross-brand content
   does not exist; what exists is the sibling brand's own pipeline.

Consequences stated once here rather than in each skill:

- **Never aggregate market metrics across brands.** Share-of-answer, citation
  counts, and SEO metrics are per brand, the same discipline as the per-engine
  rule in Answer Engine Sampling. A number for "the group" is a number for
  nothing.
- **The prompt panel limit (max 30 active) is per brand panel**, not per firm.
- A brand with `status: sunset` accepts no new artifacts; its history stays.
- When a workflow needs one brand and several exist, an explicit argument wins,
  then the `B2BFORCE_BRAND` environment variable; otherwise stop and ask.
  Auto-selection never guesses between brands.
- The cross-brand opportunity this structure exists for lives in
  `workspace/clients/`: an account buying from one brand while a sibling brand
  has a fitting service is an expansion signal, surfaced by
  `client-account-plan` and `client-health-review`.

The second brand is the migration moment: creating it moves every market-side
artifact of the first brand into its `{brand}/` segment in the same change
(`firm-context`, `add-brand` mode). Check the layout mechanically:

```bash
scripts/validate-brands.sh
```

Treat a non-zero exit as a hard stop. Keep these checks in the script; do not
restate them in skills.

**People.** `workspace/firm/people/{slug}.md` is the optional shared-team
registry, useful in both modes and near-mandatory in multi-brand, where one
marketing or sales team serves several brands. Each person declares `functions`
and `brands` (`all`, or a list). Once any person file exists, `owner:` fields in
placements, channels, and PDCA areas must resolve to a person slug — checked by
`scripts/validate-brands.sh`. The registry holds assignments only: rates, hours,
utilization, capacity, and salary are rejected, the same line this repo draws
against ledger data in `workspace/clients/`. Schema: `docs/WORKSPACE.md`.

## ICP Gate

ICP is required after firm setup and before content work.

Use the minimum useful model:

- `workspace/marketing/icp/{slug}.md` = target client company segment.
- `workspace/marketing/icp/personas/{slug}.md` = decision makers or users inside
  that target company.

Before running content ideas, content drafts, idea-based landing pages, prospecting,
or other audience-matched generation, verify the selected service has:

- one linked ICP file, preferably via service frontmatter `target_icps`;
- at least one persona file with `icp: {icp-slug}`;
- enough ICP/persona detail to adapt pain points, buying mode, objections, tone,
  and calls to action.

If ICP or personas are missing, stop the requested content/sales workflow and run
`marketing-icp` first. Do not invent an inline ICP inside a content prompt and
do not generate content that is only matched to the firm or service.

Before `marketing-content-ideas`, run:

```bash
scripts/validate-content-readiness.sh [service-slug] [icp-slug] [persona-slug]
```

Treat a non-zero exit as a hard stop. Fix the missing firm, service, ICP, or persona
files before generating ideas. Keep this validation centralized in the script; do
not copy its checks into every content skill.

## Proof Gate

Several skills are forbidden from inventing client results — correctly. This gate is
where the real ones live, so those skills have somewhere to look instead of asking
the user again every time.

**One record per client result:** `workspace/firm/proof/{slug}.md`. Schema in
`docs/WORKSPACE.md`, section "Proof record".

Before writing any client result, metric, name, quote, or case detail:

1. Read `workspace/firm/proof/` for a record matching the service and ICP.
2. Cite only what a record supports, and list the records you used.
3. If no record exists, emit `proof_needed` and say what is missing. Do not
   estimate, illustrate, or write a plausible number.

Three flags decide what may be written, and they are **not interchangeable**:

| Flag | Controls |
|------|----------|
| `client_public` | Whether the client may be **named**. False means describe anonymously. |
| `quote_approved` | Whether a client quote may be reproduced. |
| `usable_publicly` | Whether the result may be used in **public** material — case studies, website, social. |

A private proposal may cite a record with `usable_publicly: false`, as long as it
respects `client_public` and `quote_approved`. Public content requires
`usable_publicly: true`. Conflating these leaks a client's private result onto a
website.

`verified: true` on a metric means **a human confirmed that number**. An agent may
never set it from inference or from its own earlier output.

In multi-brand mode each record also carries `brand:` — the brand that delivered
the result — and `cross_brand:` (default `false`). A sibling brand may cite the
record only when `cross_brand: true`, and must attribute the result to the
delivering brand rather than present it as its own. `false` is the safe default:
some groups deliberately do not connect their brands in public, and an agent
cannot know which kind it is working for.

Records are created by `sales-outcome-log` — on a win, or in `backfill` mode for
past engagements. The record's `brand` comes from the opportunity's path segment.

## Proposal Gate

Before `sales-proposal` runs, verify in the opportunity folder
`workspace/sales/opportunities/{account}--{service}--{YYYY-MM}/`:

- `!_discovery.md` exists;
- `brief_quality` is `workable` or `strong` — never `thin`;
- `bid_decision` is `bid` or `conditional`, and any `bid_condition` is met;
- `workspace/firm/services/{service}.md` exists and declares `service_type`;
- the ICP and persona named in the brief exist.

If any fails, stop and run `sales-discovery-brief` or `sales-bid-qualification`
first. A proposal written from a thin brief is the single most expensive artifact
this repo can produce: it costs hours and loses.

Every proposal must carry non-empty `## Out of scope`, `## Assumptions`, and
`## Change control`, and exactly one pricing table whose `price_model` matches the
service's `service_type`.

After writing a proposal, run:

```bash
scripts/validate-proposal.sh {proposal-path}
```

Treat a non-zero exit as a hard stop. Keep these checks in the script; do not
restate them in each sales skill.

Validate before rendering a PDF with `tool-weasyprint`. The PDF is what leaves the
building, so a Proof Gate violation must be caught while it is still Markdown.
Rendered PDFs go to `tmp/pdf/` and are gitignored — `proposal.md` is the record.

## Client Context Gate

`workspace/clients/{slug}/` holds a won account. Before running any `client-*` skill,
verify `!_account.md` exists with:

- a real `engagement_type` (`retainer`, `project`, or `mixed`);
- at least one **named contact with a role** — a relationship the firm cannot name is
  not a relationship it can manage;
- `reviewed_at`, on an active account;
- in multi-brand mode: `brands: [...]` naming every brand that sells to this
  client, with `services:` in the qualified `{brand}/{slug}` form. The account
  stays **one record** however many brands are involved — splitting it per brand
  would hide exactly the cross-brand picture this folder exists to show.

If any is missing, run `client-onboarding` first. Check it mechanically:

```bash
scripts/validate-account.sh [workspace/clients/{slug}]
```

Errors exit non-zero. Warnings are reported without failing, because a bookkeeping
lapse should not block a QBR — with one exception, below.

**Stale data is the failure mode of this folder.** Nothing here refreshes itself, so a
file is only as true as the last person who touched it. A `health: green` that has not
been reviewed in over 90 days is therefore an **error**, not a warning: it is an
assertion the firm can no longer support and a human will act on it. Stale `amber` or
`red` is only a warning — the firm already knows that account needs attention.

`workspace/clients/` holds the **relationship**, never the ledger. No contract values,
margin, utilization, or hours; `mrr_band` is a band on purpose. The validator rejects
exact-money fields, both to stay out of PSA territory and because this is the most
sensitive folder in the repo.

## Renewal And Expansion Review

Before starting new prospecting, check the existing client base first:

```bash
scripts/validate-account.sh
```

Surface any account with a `renewal_date` inside 60 days, or with no QBR in two
quarters, and say so **before** generating new outbound. In multi-brand mode also
surface accounts buying from one brand while a sibling brand has a service fitting
their profile — the cheapest expansion this structure can see, and the reason
client accounts stay shared across brands. This is not politeness about
ordering. Acquiring a client costs several times more than expanding one and closes
about half as fast, so running acquisition while a renewal quietly lapses is the most
expensive sequencing mistake available here.

`client-health-review` produces the full sweep. Treat its findings as work, not as a
report — a portfolio review nobody acts on is the reason this folder can rot.

## Answer Engine Sampling

Applies to every workflow that reads an answer engine — `intel-ai-visibility`,
`marketing-geo-placement`, and the visibility section of `intel-weekly-report`. Stated
once here rather than in each skill.

Answer engines are **non-deterministic**: the same prompt returns different answers on
different runs, and model versions change underneath a panel.

- **One run is a sample, never a fact.** Minimum three runs per prompt per engine before
  claiming presence or a trend.
- **Report a rate, not a boolean.** "Named in 2 of 3 runs" is supportable; "we rank in
  ChatGPT" is not.
- **First batch is a baseline.** No drift claims, the same rule as the first competitor
  crawl.
- **Store verbatim answers.** The wording is the evidence; a paraphrase is the agent's
  opinion about the evidence.
- **A missing mention is one sample without the firm, not proof of absence.**
- **Never explain why a result changed.** Engines do not disclose ranking mechanics, and
  an invented mechanism is worse than reporting the change alone.
- **Never average rank across engines.** Report per engine.

Every run artifact carries `engine`, `model`, `run_index`, and a date. Without those the
file cannot be compared to anything and should not be written.

## Measurement Loop

Most skills in this repo generate artifacts. `workspace/pdca/` is where the firm
records whether those artifacts moved a business outcome.

Rules that apply to every skill, not just the PDCA ones:

- **Outputs are not outcomes.** A published post, a sent sequence, or a shipped
  page is an output. Never report it as a business result.
- **No source of truth, no number.** A metric whose source the user cannot name is
  `waiting`. Do not estimate a baseline, a target, or a benchmark.
- **Missing data is not success.** Past its due date, a missing value is `🔴 N/D`.
- **Acceptance criteria come before the work.** A criterion written after seeing
  the result is a rationalization, not a test.
- **Do not self-assess.** Judging work with the same reasoning that produced it
  adds no independent signal. Run `firm-pdca-eval` as a separate pass, and prefer
  deterministic checks over an opinion.

Cadence: a firm that sells expertise sees pipeline effects months after the work,
so outcome metrics are checked quarterly and only weekly or biweekly for outputs
and leading indicators. A weekly outcome target invites optimizing the wrong thing.

Before closing a cycle, run:

```bash
scripts/validate-pdca-cycle.sh {cycle-path}
```

Treat a non-zero exit as a hard stop. This is the structural gate; keep it in the
script rather than restating its checks in each PDCA skill.

## Skills

Location: `.agents/skills/{skill-name}/SKILL.md`

Cursor and Claude Code both discover skills from `.agents/skills/` ([Agent Skills spec](https://cursor.com/docs/skills)). Claude uses symlink `.claude/skills` → `.agents/skills`.

Run workflows exactly as documented in each skill.

> **MAINTENANCE RULE — keep this list complete.**
> The tables below must list **every** skill folder in `.agents/skills/`.
> Whenever you (or anyone) **add, rename, or remove** a skill, you **must** update
> the matching table here in the **same change**, then verify:
>
> ```bash
> # counts must match
> ls -d .agents/skills/*/ | wc -l                 # skill folders
> grep -cE '^\| `[a-z-]+`' AGENTS.md              # rows in the tables below
> ./validate-skills.sh                            # all skills valid
> ```
>
> Also update the skill count in `README.md` ("N Agent Skills"). New skill
> `name:` (frontmatter) must equal its folder name and be kebab-case.

### Hub and intelligence

| Skill | Purpose |
|-------|---------|
| `firm-context` | Create and maintain firm profile |
| `intel-competitor-monitoring` | Files-only competitor snapshots and change notes |
| `intel-competitor-discovery` | Find competitors via SERP, dedupe by domain |
| `intel-weekly-report` | Weekly intel digest with AI business-impact summary |
| `intel-ai-visibility` | Answer-engine share of voice — prompt panel, dated runs, share-of-answer rollup |

### Marketing — firm and positioning

| Skill | Purpose |
|-------|---------|
| `marketing-company-profile` | Company profile create/enrich/refresh from website |
| `marketing-service` | Service create/enrich/refresh from URL, description, or both |
| `marketing-icp` | ICP + personas for a service |

### Marketing — content pipeline

| Skill | Purpose |
|-------|---------|
| `marketing-content-ideas` | Ideas across stages and types |
| `marketing-content-blog-post` | Blog draft (800–1500 words) |
| `marketing-content-linkedin-post` | LinkedIn post (plain text) |
| `marketing-content-x-post` | X post or thread |
| `marketing-content-case-study` | Case study (PASTOR) |
| `marketing-service-page` | Standalone service page from brief/service/URL + optional SERP |
| `marketing-seo-research` | Keyword research + target keyword + SEO context |
| `marketing-geo-placement` | Cited domains → ranked backlog of third-party surfaces to get onto |

### Sales

| Skill | Purpose |
|-------|---------|
| `sales-prospecting-sequence` | B2B email sequence |
| `sales-discovery-brief` | Call notes, inbound mail, or RFP → structured brief with open questions |
| `sales-bid-qualification` | Bid / no-bid / conditional against service fit and ICP anti-fit criteria |
| `sales-proposal` | Assemble proposal or SOW with scope boundaries, verified proof, one pricing table |
| `sales-outcome-log` | Record won/lost/no-decision; create the verified proof record on a win |

### Clients — retention and expansion

| Skill | Purpose |
|-------|---------|
| `client-onboarding` | First 90 days: written success definition, stakeholders, day 14/30/90 checkpoints |
| `client-account-plan` | Buying committee map plus expansion hypotheses with triggers |
| `client-qbr` | Quarterly review: delivered vs promised, next quarter, expansion and referral asks |
| `client-health-review` | Portfolio sweep: renewals, stale reviews, missing success definitions, unfilled proof stubs |

### Measurement

| Skill | Purpose |
|-------|---------|
| `firm-pdca-setup` | Create a PDCA area: outcome, metrics, sources of truth, cadence, baseline |
| `firm-pdca-cycle` | Run one Plan/Do/Check/Act cycle and close it with an explicit decision |
| `firm-pdca-eval` | Independent evaluation against criteria written before the work |

### Tools (API wrappers)

Thin wrappers other skills call. The API wrappers have ready `.sh` scripts that read
keys from `.env` — never inline API keys. `tool-weasyprint` is a local renderer and
needs no credentials.

| Skill | Purpose |
|-------|---------|
| `tool-firecrawl` | Scrape URL → markdown; map site URLs |
| `tool-dataforseo` | Google SERP results; keyword volume; answer-engine responses + citations |
| `tool-exa` | Neural search, contents, similar, cited answer |
| `tool-weasyprint` | Markdown → print-ready PDF (proposals, reports); no API key |

See [docs/content-generation.md](docs/content-generation.md) for per-type rules.

## Output rules

- **Always** write deliverables to `workspace/` paths — never only to chat.
- In multi-brand mode, every market-side path below gains a `{brand}/` segment
  directly under the entity root — see the Brand Scope Gate. Single-brand paths
  are exactly as listed.
- Distribution channels → `workspace/marketing/channels/{slug}.md` (owned
  surfaces: URL, which draft types feed it, how publishing happens, schedule)
- Competitor profiles → `workspace/intelligence/competitors/{slug}/`
- Reports → `workspace/intelligence/reports/`
- AI visibility → `workspace/intelligence/ai-visibility/` (`!_prompts.md`,
  `runs/{YYYY-MM-DD}/{prompt-slug}.md`, `share-of-answer.md`)
- Placement target → `workspace/marketing/placements/{domain}.md`
- ICP → `workspace/marketing/icp/`
- Content ideas → `workspace/marketing/content/ideas/{content_type}--{buying_stage}--{slug}.md`
  (frontmatter: `content_type`, `buying_stage`, `status`, `service`, `icp`, `persona`)
- Content drafts → type-specific subfolder under `content/drafts/` (blog, linkedin, x, case-studies)
- Standalone landing pages → `workspace/marketing/landing-pages/{slug}/`
- Prospecting → `workspace/sales/prospecting/`
- Client proof → `workspace/firm/proof/{slug}.md`
- Opportunity → `workspace/sales/opportunities/{account}--{service}--{YYYY-MM}/`
  (`!_discovery.md`, `proposal.md`, `outcome.md`)
- Client account → `workspace/clients/{slug}/` (`!_account.md`, `onboarding.md`,
  `account-plan.md`, `qbr/{YYYY}-Q{N}.md`, `notes.md`)
- Client health report → `workspace/clients/reports/{YYYY-MM-DD}-health.md`
- PDCA area → `workspace/pdca/{area}/` (`README.md`, `scoreboard.md`, `evals.md`, `errors.md`)
- PDCA cycle → `workspace/pdca/{area}/cycles/{YYYY}-W{ww}--{slug}.md`

**Content generation:** each format (blog, LinkedIn, X, case study, landing page) uses a
different skill, prompt, and output path. See [docs/content-generation.md](docs/content-generation.md).
After generating content ideas, run `scripts/validate-content-ideas.sh` before
creating drafts. After writing a draft, run
`scripts/validate-content-draft.sh {draft-path}` before marking the idea generated.

See `docs/WORKSPACE.md` for full conventions.

## Secrets

- Load API keys from `.env` (copy from `.env.example`).
- **Never** ask the user to paste API keys in chat.
- Tell the user to fill `.env` locally in their editor.

## Maister framing

| Folder | Maister dimension |
|--------|-------------------|
| `workspace/marketing/` | Visible expertise |
| `workspace/sales/` | Client development — winning the work |
| `workspace/clients/` | Client relationships and service quality — keeping and growing it |
| `workspace/intelligence/` | Market awareness |
| `workspace/pdca/` | Cross-cutting — whether the above moved an outcome |

Maister's argument is that delivered quality **is** the marketing engine: the existing
client base is the cheapest source of new work, and referrals from it outperform every
outbound channel. `workspace/clients/` is where that half of the framework lives.
