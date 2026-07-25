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
│   ├── firm/                 # Your company profile + services
│   ├── marketing/            # ICP, content, landing pages
│   ├── sales/                # Prospecting sequences
│   ├── intelligence/         # Competitors, snapshots, changes, reports
│   └── pdca/                 # Measurement loop — cycles, scoreboards, evals
├── data/                     # Optional machine metadata only when a tool needs it
├── docs/                     # SETUP-PROMPT, WORKSPACE conventions
└── scripts/bootstrap.sh      # Clone template for new firm instances
```

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

### Sales

| Skill | Purpose |
|-------|---------|
| `sales-prospecting-sequence` | B2B email sequence |

### Measurement

| Skill | Purpose |
|-------|---------|
| `firm-pdca-setup` | Create a PDCA area: outcome, metrics, sources of truth, cadence, baseline |
| `firm-pdca-cycle` | Run one Plan/Do/Check/Act cycle and close it with an explicit decision |
| `firm-pdca-eval` | Independent evaluation against criteria written before the work |

### Tools (API wrappers)

Thin wrappers other skills call. Each has ready `.sh` scripts that read keys from
`.env`. Never inline API keys.

| Skill | Purpose |
|-------|---------|
| `tool-firecrawl` | Scrape URL → markdown; map site URLs |
| `tool-dataforseo` | Google SERP results; keyword volume |
| `tool-exa` | Neural search, contents, similar, cited answer |

See [docs/content-generation.md](docs/content-generation.md) for per-type rules.

## Output rules

- **Always** write deliverables to `workspace/` paths — never only to chat.
- Competitor profiles → `workspace/intelligence/competitors/{slug}/`
- Reports → `workspace/intelligence/reports/`
- ICP → `workspace/marketing/icp/`
- Content ideas → `workspace/marketing/content/ideas/{content_type}--{buying_stage}--{slug}.md`
  (frontmatter: `content_type`, `buying_stage`, `status`, `service`, `icp`, `persona`)
- Content drafts → type-specific subfolder under `content/drafts/` (blog, linkedin, x, case-studies)
- Standalone landing pages → `workspace/marketing/landing-pages/{slug}/`
- Prospecting → `workspace/sales/prospecting/`
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
| `workspace/sales/` | Client development |
| `workspace/intelligence/` | Market awareness |
| `workspace/pdca/` | Cross-cutting — whether the above moved an outcome |
