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
- The firm sells under more than one brand, or adds a brand — `add-brand` mode

## Before You Start

1. Read [docs/SETUP-PROMPT.md](../../docs/SETUP-PROMPT.md) for full bootstrap flow.
2. Use `workspace/firm/profile.md` as the primary context file.

## Workflow

### Create (first time)

1. **Interview** — ask (do not guess):
   - Firm name, website URL, industry
   - Does the firm sell under more than one brand (separate names/domains)?
     If yes, list them — each becomes `workspace/firm/brands/{slug}.md` and the
     Brand Scope Gate in `AGENTS.md` applies. One brand: create nothing extra.
   - Primary services (1–5) — in multi-brand, ask which brand each belongs to
   - Target clients (ICP summary)
   - Competitors to monitor (name + URL) — in multi-brand, which brand(s) each
     competes with
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

### Add a brand (`add-brand` mode)

Use when the firm starts selling under an additional name. Rules live in the
Brand Scope Gate in `AGENTS.md`; this skill only executes them.

1. **Interview** — brand name, website, positioning sentence, content language,
   which existing services (if any) move to it.
2. **Write** `workspace/firm/brands/{slug}.md` (schema: `docs/WORKSPACE.md`).
   Keep firm-level facts in `profile.md`; the brand file carries only what
   differs.
3. **If this is the second brand file, migrate in the same change** — this is
   the moment the workspace switches to multi-brand:
   - `git mv` every existing market-side artifact into the first brand's
     segment: `firm/services/{slug}.md` → `firm/services/{brand}/{slug}.md`,
     same move for `marketing/icp/` (with `personas/`), `marketing/content/`
     (`ideas/`, `drafts/`), `marketing/landing-pages/`,
     `marketing/placements/`, `sales/prospecting/`, `sales/opportunities/`,
     and `intelligence/ai-visibility/`.
   - Frontmatter stays untouched: bare slugs now resolve within the segment's
     brand. Do **not** add `brand:` fields to path-scoped artifacts.
   - Shared entities (clients, proof, competitors) gain their brand fields —
     `brands: [...]` / `brand:` — pointing at the first brand unless the user
     says otherwise, and any `services:` lists in client accounts switch to the
     qualified `{brand}/{slug}` form.
4. **Verify** — `scripts/validate-brands.sh` must pass before anything new is
   generated. It rejects flat stragglers, so a partial migration cannot go
   unnoticed.
5. Tell the user that brand-scoped workflows now need a brand: an explicit
   choice per run, or `B2BFORCE_BRAND` in the environment.

## Output paths

| Artifact | Path |
|----------|------|
| Firm profile | `workspace/firm/profile.md` |
| Brand (multi-brand only) | `workspace/firm/brands/{slug}.md` |
| Services | `workspace/firm/services/{slug}.md` — multi-brand: `services/{brand}/{slug}.md` |
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
