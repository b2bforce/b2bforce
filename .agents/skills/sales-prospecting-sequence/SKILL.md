---
name: sales-prospecting-sequence
description: >-
  Generate a one-to-one B2B outbound email sequence for a service, ICP, and
  persona, with framework selection, cadence, proof/compliance guardrails, and
  ready-to-send email copy. Use when content_type is prospecting_sequence or the
  user needs outbound sales emails. Output to workspace/sales/prospecting/.
  Not for blog, social content, or newsletter campaigns.
license: MIT
metadata:
  version: 1.0.0
  category: sales
---

# Prospecting Sequence Generation

Standalone sales workflow for **one-to-one B2B outbound email**. It is separate
from marketing content drafts and should not use blog/social prompt layers.

## When to Use

- Outbound email sequence for a service + ICP + persona
- Idea with `content_type: prospecting_sequence` OR direct user request
- Founder-led or sales-led outreach where the goal is a reply, diagnosis, or
  low-friction next step

Do **not** use for newsletters, nurture campaigns, product onboarding, blog/social
drafts, or mass promotional sends.

## Prerequisites

**Brand scope.** In a multi-brand workspace (2+ brand homes in `workspace/firm/brands/`), every path this skill reads or writes is brand-scoped: definitional entities (services, ICP, personas, proof, channels) live in `firm/brands/{brand}/…`, working pipelines carry a `{brand}/` segment under their entity root, and the working brand comes from the user's choice or `B2BFORCE_BRAND` — never guessed. Rules: Brand Scope Gate in `AGENTS.md`; paths: `docs/WORKSPACE.md`.

- `workspace/firm/profile.md`
- `workspace/firm/services/{service}.md`
- `workspace/marketing/icp/{icp}.md`
- `workspace/marketing/icp/personas/{persona}.md`
- Current agent/LLM session
- Optional content idea with `content_type: prospecting_sequence`
- Optional account/prospect facts supplied by the user

If firm, service, ICP, or persona context is missing, stop and create it first.
Do not invent an inline ICP/persona inside this skill.

No Exa research by default. Use only workspace facts and user-provided account
facts. If account-specific personalization is requested but facts are missing,
write placeholders and list the missing facts instead of fabricating triggers.

## Workflow

### 1. Load context and choose mode

Read the firm, service, ICP, and persona files. If an idea file exists, read all
frontmatter, especially `language`, `buyer_question`, `unique_angle`,
`proof_source`, and `next_action`.

Choose one mode:

- `segment_sequence` - reusable sequence for a service + ICP + persona.
- `account_sequence` - sequence for one named account/prospect with supplied
  facts.
- `variant_pack` - base sequence plus 2-3 light variants for different personas
  or trigger situations.

### 2. Build the strategy

Define before writing emails:

- audience: target company type + buyer persona;
- offer: the useful thing the prospect can get before a sales call;
- proof: a record in `workspace/firm/proof/` (respect `client_public` before naming
  anyone), other workspace facts, user input — or mark `proof_needed`;
- likely objection: time, risk, internal capacity, incumbent vendor, budget;
- CTA type: diagnostic question, useful resource, teardown/audit offer, or soft
  permission ask;
- personalization mode: `segment`, `account`, or `placeholder`.

Do not open with "we help companies like yours" unless the segment and problem
are concrete. Prefer a specific observation, tension, trigger, or buyer problem.

### 3. Select one framework

The model picks ONE framework from ICP/persona signals:

| Framework | Select when |
|-----------|-------------|
| `ois` (Observation-Insight-Solution) | ICP has concrete industry, company_size, tech_stack — specific data to observe |
| `pas` (Problem-Agitation-Solution) | ICP/persona have strong, clearly defined pain_points + fears_risks |
| `trigger` (Trigger-Based) | Persona has trigger_events (funding, hiring, expansion) |
| `value_first` | Persona seniority director+, change_readiness cautious, or ai_attitude neutral/cautious/skeptic |
| `curiosity` (Curiosity-Gap) | Persona seniority_level is c_level or vp |

### 4. Choose email count and cadence

Start from ICP `sales_cycle_length`, then adjust for relationship warmth:

| sales_cycle_length | Emails |
|--------------------|--------|
| `1_week`, `1_month` | 3 (short cycle) |
| `1_3_months` | 5 (standard B2B) |
| `3_6_months`, `6_12_months`, `over_1_year` | 7 (enterprise) |

Typical email-only spacing: Day 0 -> 3 -> 7 -> 12 -> 18 -> 25 -> 35.

Rules:

- 3-5 emails is the default for cold outbound.
- Use 7 emails only for high-value enterprise sequences with a real reason to
  keep adding new angles.
- Each follow-up must add a new angle: different pain, proof, useful asset,
  objection, trigger, or breakup. Never write "just following up".
- Stop the sequence on reply, opt-out, bounce, or clear disinterest.

### 5. Write the emails

Each email:

- 50-125 words by default; 150 words max when context is complex.
- Plain text only. No markdown bullets inside email bodies.
- One idea, one CTA, one expected reply.
- CTA should be a low-friction offer or question before asking for a meeting.
- Subject line must be honest and specific, never clickbait.
- Mention proof only if it exists in workspace/user input.
- Include personalization placeholders only when needed:
  `{prospect_company}`, `{prospect_role}`, `{observed_trigger}`,
  `{relevant_system}`, `{sender_name}`, `{sender_company}`,
  `{postal_address}`, `{opt_out_line}`.

All output must be written in the idea's or user's requested **language**, and
must use the firm's brand voice + respect `words_to_avoid`.

### 6. Run the quality gate

Before writing the final file, check:

- Is the prospect problem specific to the ICP/persona?
- Does every email add a new reason to reply?
- Is every claim/proof sourced from workspace or marked `proof_needed`?
- Is the CTA smaller than "book 30 minutes" unless the prospect is warm?
- Are fake triggers, fake case studies, fake metrics, and fake client names absent?
- Are opt-out/sender identity placeholders present for commercial outreach?
- Is the sequence suitable for one-to-one sales outreach, not mass marketing?

This skill does not provide legal advice. The output should include a compliance
checklist and remind the sender to verify local law, consent/legitimate-interest
rules, unsubscribe handling, and sender authentication before sending.

## Output Rules

Use the templates in `references/output-templates.md`.

Default output is a **single Markdown file**:

`workspace/sales/prospecting/{service}--{icp}--{persona}--{campaign-slug}.md`

Use an output folder only when the user asks for variants, CRM import, or account
customization pack:

```text
workspace/sales/prospecting/{service}--{icp}--{persona}--{campaign-slug}/
├── sequence.md              # canonical ready-to-send sequence
├── variants.md              # optional persona/trigger variants
└── crm-import.csv           # optional flat export, generated only if requested
```

Keep the filename/folder self-describing because prospecting can produce many
similar artifacts over time.

## Internal Structured Draft

```json
{
  "selected_framework": "ois|pas|trigger|value_first|curiosity",
  "framework_reasoning": "string",
  "mode": "segment_sequence|account_sequence|variant_pack",
  "personalization_mode": "segment|account|placeholder",
  "email_count": 3,
  "cadence_days": [0, 3, 7],
  "offer": "string",
  "proof_status": "workspace_proof|user_supplied|proof_needed",
  "sequence": [
    {
      "email_number": 1,
      "subject_line": "string",
      "body": "string (50-125 words)",
      "purpose": "initial_contact|follow_up|value_add|social_proof|urgency|breakup",
      "cta_type": "diagnostic_question|resource_offer|audit_offer|permission_ask|meeting_ask|breakup",
      "days_after_previous": 0
    }
  ],
  "quality_gate": {
    "claims_sourced": true,
    "fake_triggers_absent": true,
    "one_cta_per_email": true,
    "opt_out_placeholder_present": true
  }
}
```

This is an internal planning shape, not a separate JSON deliverable unless the
user explicitly asks for JSON.

## References

- `references/output-templates.md` - required Markdown structure, optional
  variants and CSV export templates

## Related Skills

| Skill | When |
|-------|------|
| `sales-discovery-brief` | A prospect replied — capture the opportunity before proposing |
| `sales-outcome-log` | Record what came of the campaign, including nothing |
