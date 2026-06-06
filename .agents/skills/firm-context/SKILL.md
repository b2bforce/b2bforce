---
name: firm-context
description: >-
  Create and maintain the firm profile for a professional service firm skills + workspace repo.
  Use when starting a new firm repo, onboarding, missing business context, or before
  any marketing/sales/intelligence skill. For competitor monitoring, see
  intel-competitor-monitoring.
license: MIT
metadata:
  version: 1.0.0
  category: hub
---

# Firm Context

Hub skill for B2BForce. Establishes who the firm is before any other workflow runs.

## When to Use

- New B2BForce workspace — first task after clone
- User says "set up my firm", "fill firm context", "onboard"
- Another skill fails because `workspace/firm/profile.md` is missing or incomplete
- User updates positioning, services, ICP, or competitor list

## Before You Start

1. Read [docs/SETUP-PROMPT.md](../../docs/SETUP-PROMPT.md) for full bootstrap flow.
2. Use `workspace/firm/profile.md` as the primary context file.

## Workflow

### Create (first time)

1. **Interview** — ask (do not guess):
   - Firm name, website URL, industry
   - Primary services (1–5)
   - Target clients (ICP summary)
   - Competitors to monitor (name + URL)
   - Content language
   - Priority workflows

2. **Write files:**
   - `workspace/firm/profile.md` — primary firm profile and context
   - `workspace/firm/services/{slug}.md` — one minimal file per primary service
   - `workspace/intelligence/competitors/{slug}/!_profile.md` — one per competitor

3. **Website enrichment** — if the user provided a website URL, run
   `marketing-company-profile` in `enrich` mode after the interview-based
   profile exists. If website/API access is unavailable, keep the manual profile
   and note that enrichment can be run later. Do not block setup.

4. **Service file minimum** — keep each service file short:
   - service name
   - one-sentence description
   - who it is for
   - main problem it solves
   - expected outcome
   - proof or notes if known

5. **Sync README** — update title to `{Firm Name} — B2BForce Workspace`.

### Update (existing)

1. Read current `workspace/firm/profile.md`.
2. Apply firm-level changes to `workspace/firm/profile.md`.
3. Add/update/remove service files under `workspace/firm/services/` as needed.
4. Add/remove competitor folders under `workspace/intelligence/competitors/` as needed.

## Output paths

| Artifact | Path |
|----------|------|
| Firm profile | `workspace/firm/profile.md` |
| Services | `workspace/firm/services/{slug}.md` |
| Competitors | `workspace/intelligence/competitors/{slug}/!_profile.md` |

## Related Skills

| Skill | When |
|-------|------|
| `intel-competitor-monitoring` | After competitors are listed — enable crawl pipeline |
| `marketing-company-profile` | Create, enrich, or refresh profile from website URL |
| `marketing-service` | Create/enrich/refresh service before ICP |
| `marketing-icp` | Generate ICP + personas from service context |
| `marketing-content-ideas` | Content calendar after ICP |

## Rules

- Never ask for API keys — point user to `.env`.
- Do not create `data/firm.json` unless a concrete tool needs machine-readable metadata.
- Never commit `data/firm.json` if it contains private strategy.
- English only for UI strings and file content unless user specifies another language in `content_language`.
