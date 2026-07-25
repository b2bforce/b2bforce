---
name: marketing-service
description: >-
  Create, enrich, or refresh a B2B service definition in workspace/firm/services/
  from a URL, a text description, or both. Use when a service is missing,
  incomplete, or outdated before ICP generation.
license: MIT
metadata:
  version: 1.0.0
  category: marketing
---

# Service

Task-oriented workflow for creating, enriching, or refreshing a service. The user
should not need to choose between "from URL" and "from description" skills.

## When to Use

- User says "add service", "create service", "refresh service", or provides a
  service URL/brief
- A service file is missing before `marketing-icp`
- Existing `workspace/firm/services/{slug}.md` is incomplete or stale

## Inputs

Ask only for missing essentials:

- Service name or working slug
- URL, description, or both
- Whether this is `create`, `enrich`, or `refresh` if not obvious

Input rules:

- URL only: fetch page content if web/tool access is available.
- Description only: use the user description as the source of truth.
- URL + description: user description wins when it conflicts with page content.
- If neither URL nor description is available, stop and ask for one.

## Prerequisites

- `workspace/firm/profile.md`
- Current agent/LLM session
- Optional website access through current agent/browser, or `tool-firecrawl` if
  configured

Never ask the user to paste API keys in chat. If a tool key is needed, tell the
user to fill `.env` locally.

## Workflow

### 1. Choose mode

- `create` — no matching service exists.
- `enrich` — a minimal service file exists and should be improved.
- `refresh` — re-check an existing service URL/description for meaningful changes.

### 2. Check duplicates

Read `workspace/firm/services/*.md`.

Hard stop if an existing service has the same normalized `source_url` or a clearly
equivalent label. Point the user to that service file and switch to `enrich` or
`refresh`.

### 3. Gather evidence

Read firm profile first.

If a URL is present, fetch the service page. If unavailable, proceed only from the
description and mark `source_url` for later enrichment. Do not invent page facts.

If a description is present, keep it as explicit user-provided context.

### 4. Build service definition

Use this extraction order:

1. Job to be done
2. Outcomes
3. Challenges
4. Process
5. Deliverables/features
6. Differentiators
7. Fit and anti-fit criteria
8. Proof points
9. Pricing model/positioning if stated

Do not invent proof, metrics, pricing, clients, certifications, or guarantees.
Use `!_verify` notes for useful but low-confidence facts.

For proof points, read `workspace/firm/proof/` and reference the matching records by
slug instead of restating their numbers here. One source of truth per client result
— see the Proof Gate in `AGENTS.md`.

### 5. Write output

Write one file:

`workspace/firm/services/{slug}.md`

Frontmatter:

```yaml
---
label:
service_type: retainer|project|subscription|package|consulting|training|support|other
source_url:
target_icps: []
---
```

Body sections should stay concise:

- Main problem
- Job to be done
- Expected outcomes
- Process
- Deliverables
- Differentiators
- Fit criteria
- Anti-fit criteria
- Proof points
- Notes / `!_verify` if needed

## Quality Rules

- Outcomes should be concrete business outcomes, not generic benefits.
- Challenges should include consequences and current workarounds.
- Proof points must resolve to a record in `workspace/firm/proof/`, or come from the
  user, firm profile, or page content — otherwise omit them.
- Keep the service file readable for humans and LLMs; do not mirror it into JSON.
- Do not create `data/firm.json` or hidden service context files.

## Related Skills

| Skill | When |
|-------|------|
| `firm-context` | Firm profile is missing |
| `marketing-company-profile` | Firm profile needs website enrichment |
| `marketing-icp` | Generate ICP + personas from this service |
