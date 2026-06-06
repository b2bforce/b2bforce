---
name: marketing-icp
description: >-
  Create or enrich an Ideal Customer Profile and 1-3 buyer personas for a B2B
  service. If the service is missing, first create it from a URL, text description, or both via
  marketing-service. Use when ICP/personas are missing before content,
  landing pages, or prospecting. Output to workspace/marketing/icp/.
license: MIT
metadata:
  version: 1.0.0
  category: marketing
---

# ICP

Task-oriented workflow for creating or enriching ICP + buyer personas. The source of truth is
always a service file, never a free-floating URL-only ICP.

## When to Use

- User says "add ICP", "create ICP", "generate buyer personas", or "who should
  this service target?"
- Content ideas, drafts, landing pages, or prospecting are blocked by missing ICP
- Existing service has no linked `target_icps`

## Inputs

Ask only for missing essentials:

- Existing service slug, or service URL, description, or both
- Optional target market constraints from the user
- Desired persona count if not default 1-3

If no service file exists, run `marketing-service` first. Do not generate ICP
directly from a URL or brief while skipping the service file.

## Prerequisites

1. `workspace/firm/profile.md`
2. `workspace/firm/services/{service-slug}.md`
3. Current agent/LLM session
4. Optional market research via `tool-exa` if the user wants enrichment

Never ask the user to paste API keys in chat. If a tool key is needed, tell the
user to fill `.env` locally.

## Workflow

### 1. Ensure service context

If the user gave a URL/description instead of a service slug, create or enrich the
service with `marketing-service`, then continue from the resulting service
file.

### 2. Gather context

Load:

- `workspace/firm/profile.md`
- `workspace/firm/services/{service-slug}.md`
- existing ICP files in `workspace/marketing/icp/`
- existing persona files in `workspace/marketing/icp/personas/`

Do not duplicate an existing ICP segment. If a close match exists, ask whether to
enrich it or create a distinct segment.

### 3. Optional market research

Use `tool-exa` only when configured and useful. Research is optional enrichment,
not a gate.

Suggested research questions:

1. Operational pain in the target industry for this service
2. Buying committee and decision roles
3. Trigger events and market changes
4. Common vendor selection criteria
5. Objections and current alternatives

Mark research-backed notes separately in the generated files. Do not cite market
claims as verified if no research was run.

### 4. Generate ICP + personas

Use `references/system-prompt.md` and `references/output-schema.md`.

Prompt context:

```text
Analyze this firm and service. Generate ONE ICP and 1-3 buyer personas.

=== FIRM PROFILE ===
{workspace/firm/profile.md}

=== SERVICE ===
{workspace/firm/services/{service-slug}.md}

=== EXISTING ICPs / PERSONAS (DO NOT DUPLICATE) ===
{list}

=== USER TARGETING CONSTRAINTS ===
{if any}

=== MARKET RESEARCH ===
{if any}

Return structured output matching references/output-schema.md.
Write reasoning first for internal use, then strip reasoning before saving files.
Language: {content_language from firm profile}
```

Buying mode:

- `reactive` when the buyer has an urgent problem or risk
- `proactive` when the buyer seeks growth, optimization, or strategic upside
- `mixed` when both are credible

### 5. Write workspace outputs

| Output | Path |
|--------|------|
| ICP | `workspace/marketing/icp/{slug}.md` |
| Personas | `workspace/marketing/icp/personas/{slug}.md` |
| Service link | Append ICP slug to service frontmatter `target_icps` |

ICP frontmatter:

```yaml
---
name:
industry:
company_size:
buying_mode:
service: {service-slug}
---
```

Persona frontmatter:

```yaml
---
name:
icp: {icp-slug}
seniority_level:
department:
decision_role:
---
```

### 6. Validate

Run:

```bash
scripts/validate-content-readiness.sh {service-slug} {icp-slug}
```

Treat failures as hard stops before content ideas, drafts, landing pages, or
prospecting.

## Quality Rules

- ICP is a company segment; persona is a role/person inside that segment.
- Pain points must include consequences and current workarounds.
- Trigger events must be observable.
- Personas should cover distinct roles: economic buyer, technical buyer,
  champion, user, influencer, or gatekeeper.
- `buying_mode` must drive messaging angle, JTBD, objections, and proof needs.
- Do not invent market facts, budgets, tech stacks, or proof.

## Related Skills

| Skill | When |
|-------|------|
| `marketing-service` | Service file is missing or incomplete |
| `marketing-content-ideas` | Next step after ICP + personas |
| `sales-prospecting-sequence` | Outbound after service + ICP + persona exist |
