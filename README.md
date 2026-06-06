<div align="center">

# B2BForce

**Skills + workspace for AI agents in B2B service firms**

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![Support](https://img.shields.io/badge/support-b2bforce.ai-blueviolet.svg)](https://www.b2bforce.ai)

_MIT · the repo is the product_

[b2bforce.ai](https://www.b2bforce.ai) | [Author: Grzegorz Bartman](https://www.bartman.pl) | [Workspace docs](docs/WORKSPACE.md)

</div>

# What is B2BForce?

A ready-to-run set of **Agent Skills** and a **`workspace/`** built for **B2B service
firms** — agencies, dev shops, consultancies, and similar businesses that sell
expertise, not a product. Clone the repo, run the agent on your data, keep the code.
**No subscription, no vendor lock-in.**

It is **not a hosted SaaS app**. There's nothing to sign up for. You clone this
repo into your own git repository, personalize it for your firm, and run AI workflows
in your agent with full code and data ownership.

## The problem it solves

- **Generic AI skills break your workflow.** Most agent skills are built for B2C
  products, solo creators, or enterprise IT. They don't know what a client retainer
  looks like, how you write a brief, or what "deliverable" means in your context.
- **You spend more time fixing the output than doing the work.** The skill generates
  something that isn't wrong — it just doesn't fit. The automation creates more work,
  not less.
- **The fix: skills written for B2B service firms.** Not adapted — purpose-built.
  Every skill is modeled on how agencies, dev shops, and consultancies actually work:
  client briefs, project scopes, billing cycles, handoff docs.

## Who it's for

B2B service firms, **1–50 people**. You sell expertise, win on reputation, deliver
through people, and grow on client relationships. Good fits:

- Agencies — marketing, creative, growth
- Software and dev shops
- Consultancies and advisory firms
- Law, accounting, and tax firms
- Design and product studios
- Solo operators and fractional execs

For larger organizations, multi-team setups, stricter governance, or production
agent operations across many users and systems, this repo can still be useful as
a skills/workspace foundation — but it is worth considering a more structured
agent platform and implementation approach, such as
[Droptica Open Agent Hub](https://www.droptica.ai/services/open-agent-hub/).

## What's inside

**`workspace/`** maps to active workflows plus shared
context every skill reads before it runs:

| Folder | Job | What it does |
|--------|-----|--------------|
| `marketing/` | **Get known** | Define your ideal client; generate blog posts, case studies, LinkedIn/X posts, and SEO landing pages — output to your repo, not someone else's cloud |
| `sales/` | **Win clients** | Prospecting sequences — built for founder-led B2B sales |
| `intelligence/` | **Watch the market** | Track competitors, snapshots, changes, and weekly digests as repo files |
| `firm/` | **Shared context** | Your services, positioning, and guardrails — every skill reads the same firm facts |

These active workspace areas follow David Maister's
[*Managing the Professional Service Firm*](https://en.wikipedia.org/wiki/Managing_the_Professional_Service_Firm)
framework: market your expertise, develop clients, and watch the market.

Plus **18 Agent Skills** — firm context, competitor monitoring & discovery, weekly intel
reports, company/service/ICP setup, content ideas, 4 content draft types, SEO
research, landing page pipelines, prospecting, and 3 tool wrappers (Firecrawl,
DataForSEO, Exa).

Content type rules: [docs/content-generation.md](docs/content-generation.md)

## Quickstart

**Step 1** — Clone:

```bash
curl -fsSL https://raw.githubusercontent.com/b2bforce/b2bforce/main/scripts/bootstrap.sh | bash
# or manually:
git clone git@github.com:b2bforce/b2bforce.git ../my-firm-workspace && cd ../my-firm-workspace
```

**Step 2** — Paste the setup prompt into [Cursor](https://cursor.com), Claude Code, or Codex:

```
Set up B2BForce skills + workspace for my professional service firm in this repo.
Follow docs/SETUP-PROMPT.md — start the firm interview now.
```

**Step 3** — The agent runs the firm interview and personalizes your `workspace/`;
`workspace/firm/profile.md` starts as a template and is filled during setup.
You fill `.env` locally (never paste API keys in chat).

**Step 4** — Generate ICP + buyer personas for a service first, then run content
ideas, drafts, prospecting, or monitoring.

For the full bootstrap checklist, see [docs/SETUP-PROMPT.md](docs/SETUP-PROMPT.md).

## Prerequisites

- Git
- [Cursor](https://cursor.com) / Claude Code / Codex / Windsurf (or compatible [Agent Skills](https://cursor.com/docs/skills) client)
- Optional API keys in `.env` (Firecrawl, DataForSEO, Exa) — see [.env.example](.env.example)
- Optional API wrapper scripts require `curl` and `jq`.

Skills live in `.agents/skills/`. Claude Code reads `.claude/skills/`, a symlink to the
same directory.

**Agent resources:**

| Resource | Purpose |
|----------|---------|
| [docs/SETUP-PROMPT.md](docs/SETUP-PROMPT.md) | Full bootstrap interview + workspace setup |
| [AGENTS.md](AGENTS.md) | Project map for agents (directory, rules, Maister) |
| [.agents/skills/](.agents/skills/) | Agent Skills — workflows (monitoring, ICP, content…) |
| [frameworks/maister/README.md](frameworks/maister/README.md) | PSF framework cheat sheet |

## FAQ

**Is this a hosted SaaS?** No. You clone the repo and run the workflows in your own
agent, on your own machine. Code and data stay with you.

**Do I need paid API keys?** No. You can read the skills and run the basics without
them. Some skills call paid research/scraping tools (Firecrawl, DataForSEO, Exa)
and need a key in your local `.env`. Add only what you need.

**How is it different from a generic AI skills repo?** Generic repos are a pile of
prompts. This is a structure with an opinion — folders and skills mapped to how a B2B
service firm actually operates.

**Which agents does it work with?** Any agent that supports the
[Agent Skills spec](https://cursor.com/docs/skills): Cursor, Claude Code, Codex,
Windsurf.

**Can I contribute?** Yes — MIT-licensed and public. See [CONTRIBUTING.md](CONTRIBUTING.md)
and run `./validate-skills.sh` before submitting skill changes.

## Commercial

The repo is free — clone it and run it yourself. If you want it installed, tuned, or
extended into something custom, that's optional paid work:

- **Set up for you** — cloned into your git, firm interview run, API keys wired, handed back working
- **Skills tuned to your firm** — adapted to your services and process; new skills for your CRM, industry, or in-house tools
- **Split across repos** — per team, practice, or client, so history and access stay clean
- **Served over MCP** — skills and workspace exposed to any LLM chat (ChatGPT, claude.ai, Cursor) with per-person access control

Tell us what you need and we'll scope it: [contact@b2bforce.ai](mailto:contact@b2bforce.ai)

## Resources

- [B2BForce](https://www.b2bforce.ai) — implementation services
- [Grzegorz Bartman](https://www.bartman.pl) — author of B2BForce
- [Maister PSF (Wikipedia)](https://en.wikipedia.org/wiki/Managing_the_Professional_Service_Firm)
- [docs/WORKSPACE.md](docs/WORKSPACE.md) — file naming conventions
- [docs/content-generation.md](docs/content-generation.md) — content types, prompts, skill split
- [SECURITY.md](SECURITY.md) — secrets and sensitive workspace data
- [docs/services.md](docs/services.md) — paid implementation offerings
