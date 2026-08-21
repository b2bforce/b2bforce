# Setup Prompt — B2BForce Skills + Workspace

Copy everything below the line into Cursor, Claude Code, or Codex **after cloning this repo**.

---

```
Set up B2BForce skills + workspace for my professional service firm in THIS repository.

Please:

1. Create ./tmp/b2bforce-setup-tasks.md with the checklist below. Mark [x] as done.

--- CHECKLIST START ---
# B2BForce Skills + Workspace Setup

## Step 1: Firm interview (ASK ME — do not guess)
- [ ] Firm name and website URL
- [ ] Does the firm sell under more than one brand (separate names/domains)?
      If yes: list each brand with its website — one brand means nothing extra,
      two or more switch the workspace to multi-brand (Brand Scope Gate in
      AGENTS.md)
- [ ] Industry / niche (e.g. digital agency, SaaS consulting, legal)
- [ ] Primary services (1–5, with short descriptions; multi-brand: say which
      brand each belongs to)
- [ ] Target clients (ICP summary: industry, size, geography)
- [ ] Main competitors or accounts to monitor (names + URLs)
- [ ] Distribution channels you actually publish on (blog, X, LinkedIn,
      newsletter, Medium…): for each — URL, how you publish (Buffer, native,
      CMS, mailing tool), and how often (e.g. every Friday, daily);
      multi-brand: per brand
- [ ] Content language(s): en / de / pl / other
- [ ] Which workflows matter most? (pick: monitoring, AI visibility, ICP, content
      ideas, content generation, prospecting, proposals, client retention, landing
      pages, measurement, JSON import)
- [ ] Will this repo ever be public or shared outside the firm? (decides whether
      client proof, proposals, and client accounts get committed or gitignored —
      see SECURITY.md)
- [ ] Your 2-3 best client results, and for each: may we name the client, may we
      quote them, may we use it publicly?
- [ ] Your current active clients: name, which service, retainer or project, and
      renewal date if there is one
- [ ] If measurement: which business outcome matters most, and where does the
      number for it already live? (system, report, or spreadsheet)
- [ ] Where will outputs live? (this repo workspace/ — confirm)

STOP after Step 1 — wait for my answers before continuing.

## Step 2: Personalize this repo
- [ ] Fill workspace/firm/profile.md from my answers (primary firm context)
- [ ] If I named 2+ brands: create workspace/firm/brands/{slug}/!_brand.md per
      brand, put each brand's services, ICP, proof, and channels inside its
      brand home, and use {brand}/ path segments for content and sales
      artifacts (docs/WORKSPACE.md, "Multi-brand layout"); then run
      scripts/validate-brands.sh
- [ ] If I provided a website URL, run `marketing-company-profile` in enrich mode
      to improve workspace/firm/profile.md. If web/API access is unavailable,
      keep the interview-based profile and note that enrichment can be run later.
- [ ] For each primary service: create workspace/firm/services/{slug}.md with a minimal service definition
- [ ] For each named channel: create workspace/marketing/channels/{slug}.md
      (multi-brand: workspace/firm/brands/{brand}/channels/{slug}.md) with URL,
      content_types, publish_via, schedule, and a short "what to publish here"
      body
- [ ] For each competitor URL: create workspace/intelligence/competitors/{slug}/!_profile.md
- [ ] Update README.md title to "{Firm Name} — B2BForce Workspace"

## Step 3: Environment (NO secrets in chat)
- [ ] cp .env.example .env — tell me to fill keys locally in my editor
- [ ] List which .env vars I need based on enabled_workflows from Step 1
- [ ] Ensure .gitignore covers .env, optional firm.json, and tmp/
- [ ] If monitoring selected: point me to .agents/skills/intel-competitor-monitoring/references/file-layout.md
- [ ] Explain that competitor monitoring stores shared state as committed workspace files

## Step 4: Verify
- [ ] List installed skills in .agents/skills/
- [ ] Confirm workspace/firm/profile.md is readable
- [ ] Confirm at least one workspace/firm/services/{slug}.md exists, unless I said the firm has no defined service yet
- [ ] Suggest first task: generate ICP + buyer personas for one service
- [ ] If I gave client results: write them to workspace/firm/proof/ with
      `sales-outcome-log` in backfill mode, flags false unless I approved otherwise
- [ ] If I said this repo may be public: add workspace/firm/proof/,
      workspace/sales/opportunities/, and workspace/clients/ to .gitignore before
      writing anything into them
- [ ] If I named active clients: create workspace/clients/{slug}/!_account.md for
      each with `client-onboarding`, then tell me which ones have no written success
      definition. Do not invent one — ask me, or mark it as needing the next call.
      This is the highest-value backfill in the repo: it is the leading indicator
      for retention and most firms have it written down nowhere.
- [ ] If I have active clients: run `scripts/validate-account.sh` and show me what
      it reports
- [ ] If AI visibility selected: build a first prompt panel with `intel-ai-visibility`
      for ONE service and ONE ICP only, 10-15 prompts, derived from my service and ICP
      files. Tell me the estimated cost before running a batch, and label the first
      batch a baseline — not a trend
- [ ] If measurement selected: suggest `firm-pdca-setup` for one area only, using
      the `content` metric pack unless I named a source of truth for another pack
- [ ] Delete ./tmp/b2bforce-setup-tasks.md
--- CHECKLIST END ---

2. Execute Step 1 NOW — ask me the interview questions in a numbered list.

3. After I answer, complete Steps 2–4 without asking again unless something is ambiguous.

4. Never commit data/firm.json or .env.

5. Never ask me to paste API keys in chat — only point me to .env.
```
