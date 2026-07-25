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
- [ ] Industry / niche (e.g. digital agency, SaaS consulting, legal)
- [ ] Primary services (1–5, with short descriptions)
- [ ] Target clients (ICP summary: industry, size, geography)
- [ ] Main competitors or accounts to monitor (names + URLs)
- [ ] Content language(s): en / de / pl / other
- [ ] Which workflows matter most? (pick: monitoring, ICP, content ideas,
      content generation, prospecting, landing pages, measurement, JSON import)
- [ ] If measurement: which business outcome matters most, and where does the
      number for it already live? (system, report, or spreadsheet)
- [ ] Where will outputs live? (this repo workspace/ — confirm)

STOP after Step 1 — wait for my answers before continuing.

## Step 2: Personalize this repo
- [ ] Fill workspace/firm/profile.md from my answers (primary firm context)
- [ ] If I provided a website URL, run `marketing-company-profile` in enrich mode
      to improve workspace/firm/profile.md. If web/API access is unavailable,
      keep the interview-based profile and note that enrichment can be run later.
- [ ] For each primary service: create workspace/firm/services/{slug}.md with a minimal service definition
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
- [ ] If measurement selected: suggest `firm-pdca-setup` for one area only, using
      the `content` metric pack unless I named a source of truth for another pack
- [ ] Delete ./tmp/b2bforce-setup-tasks.md
--- CHECKLIST END ---

2. Execute Step 1 NOW — ask me the interview questions in a numbered list.

3. After I answer, complete Steps 2–4 without asking again unless something is ambiguous.

4. Never commit data/firm.json or .env.

5. Never ask me to paste API keys in chat — only point me to .env.
```
