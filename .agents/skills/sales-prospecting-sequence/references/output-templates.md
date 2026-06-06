# Prospecting Output Templates

Use these templates for `sales-prospecting-sequence`.

## Default Markdown File

Path:

`workspace/sales/prospecting/{service}--{icp}--{persona}--{campaign-slug}.md`

```markdown
---
type: prospecting_sequence
status: draft
language: {language}
service: {service}
icp: {icp}
persona: {persona}
source_idea: {optional-idea-path-or-null}
mode: segment_sequence
personalization_mode: segment
selected_framework: {ois|pas|trigger|value_first|curiosity}
email_count: {3|5|7}
cadence_days: [{0}, {3}, {7}]
proof_status: {workspace_proof|user_supplied|proof_needed}
created: {YYYY-MM-DD}
---

# Prospecting Sequence: {campaign-title}

## Strategy

**Audience:** {ICP + persona in one sentence}
**Service:** {service summary}
**Primary problem:** {specific buyer pain}
**Offer:** {useful thing offered before a sales call}
**Proof:** {workspace/user proof or `proof_needed: ...`}
**Main objection:** {likely objection}
**CTA pattern:** {diagnostic_question|resource_offer|audit_offer|permission_ask|meeting_ask}

## Personalization Inputs

| Field | Required? | Source | Notes |
|-------|-----------|--------|-------|
| `{prospect_company}` | yes | CRM/list | Company name |
| `{prospect_role}` | yes | CRM/list | Buyer role |
| `{observed_trigger}` | no | user/account research | Do not invent |
| `{relevant_system}` | no | user/account research | Tech/platform/process |
| `{sender_name}` | yes | sender | Human sender |
| `{sender_company}` | yes | firm profile | Firm name |
| `{postal_address}` | review | sender/compliance | Required in some jurisdictions |
| `{opt_out_line}` | review | sender/compliance | Required in many commercial outreach contexts |

## Sequence

### Email 1: Initial Contact

**Send:** Day 0
**Purpose:** initial_contact
**Subject:** {subject_line}
**CTA type:** {cta_type}

{plain-text-email-body}

**Why this email exists:** {one sentence}
**Personalization notes:** {what to replace/check before sending}

---

### Email 2: Follow-Up

**Send:** Day {N} after previous
**Purpose:** follow_up
**Subject:** {subject_line}
**CTA type:** {cta_type}

{plain-text-email-body}

**Why this email exists:** {one sentence}
**Personalization notes:** {what to replace/check before sending}

---

## Quality Gate

- [ ] ICP/persona problem is specific, not generic.
- [ ] Each email adds a new angle; no "just following up".
- [ ] Every proof point is from workspace/user input or marked `proof_needed`.
- [ ] No fake trigger, fake metric, fake case study, fake client, or fake quote.
- [ ] One CTA per email.
- [ ] First CTA is low-friction unless the prospect is warm.
- [ ] Subject lines are accurate and non-deceptive.
- [ ] Emails are plain text and mobile-readable.
- [ ] Stop conditions are clear: reply, opt-out, bounce, disinterest.
- [ ] Sender reviewed unsubscribe, postal address, consent/legitimate-interest,
      and sender authentication requirements before sending.

## Send Notes

**Stop conditions:** Stop on reply, opt-out, bounce, or clear disinterest.
**Compliance note:** This is draft sales copy, not legal advice. Sender must
verify local email law, unsubscribe handling, sender identity/address, and
domain authentication before sending.
```

## Optional Variant Pack

Use a folder only when variants are requested:

```text
workspace/sales/prospecting/{service}--{icp}--{persona}--{campaign-slug}/
├── sequence.md
├── variants.md
└── crm-import.csv
```

`variants.md`:

```markdown
# Prospecting Variants: {campaign-title}

## Variant A: {persona-or-trigger}

Use when: {condition}
Change: {what changes from canonical sequence}

### Email 1 Subject

{subject_line}

### Email 1 Body

{body}
```

## Optional CRM Import CSV

Generate only when the user asks for a flat export.

```csv
email_number,send_day,purpose,subject_line,body,cta_type,personalization_fields,stop_conditions
1,0,initial_contact,"{subject}","{body}","{cta_type}","prospect_company;prospect_role","reply;opt_out;bounce;disinterest"
```
