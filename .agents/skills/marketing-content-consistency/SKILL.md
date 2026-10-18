---
name: marketing-content-consistency
description: >-
  Review pass 2 for long-form content: inventory every claim with its paragraph,
  then find pairs that contradict each other, mismatched numbers, counters that do
  not match ("five steps" with four), broken cross-references, examples that break
  the text's own rules, sections that undercut the idea's angle, and repetition.
  Report only. Use to check whether a draft contradicts itself, find repetition, or
  check that a post holds its angle.
license: MIT
metadata:
  version: 1.0.0
  category: marketing
---

# Content Consistency

Finds places where the text contradicts itself or says the same thing twice. Truth
belongs to `marketing-content-factcheck`, style to `marketing-content-deslop`.

Round, revision, and waiver rules: `docs/content-generation.md`, section "Review
passes".

## Inputs and output

| | In the review loop | Standalone |
|-|--------------------|------------|
| Reads | The draft, and the idea's `buyer_question` and `unique_angle` (the angle) | A file the user names; the angle from the user, or from title and opening |
| Writes | `## Consistency` section and `consistency:` key in `{slug}.review.md` | Report in chat |

Never edit the draft. Propose; the drafting skill or the human decides.

## Procedure

### 1. Claim inventory

Number paragraphs from P1 (headings H1, H2…; a list is one paragraph, its items
P5.1, P5.2; a table is one paragraph, its rows P6.r1…). List every claim:

| ID | Paragraph | Quote (verbatim) | Type | Subject | Value |
|----|-----------|------------------|------|---------|-------|
| C1 | P2 | "The migration takes a week." | fact-number | migration: duration | 7 days |

Types: `fact`, `fact-number`, `judgment`, `recommendation`, `definition`, `counter`
(announces a number of items, including "one", "each", "every"), `cause`,
`attribution` ("X recommends…"), `reference` ("as shown above").

Normalize units only where the text does; when unsure, record both forms. Mark
quoted third-party claims `third-party` — they pair with the author's claims only
when the author endorses them.

### 2. Checks

Details and examples: [references/check-types.md](references/check-types.md).

| Code | Check | Blocks |
|------|-------|--------|
| `CON` | Contradiction: two claims about the same subject cannot both hold (negation, conflicting judgment or recommendation, "always" vs an exception, two attributions to the same person or source that disagree) | yes |
| `NUM` | Number mismatch: same quantity with different values, units, or dates; sums and shares that do not add up | yes |
| `CNT` | Counter: an announced number of items ("three steps", "each with one question") differs from the actual items, list entries, or table cells | yes |
| `ANG` | Angle: a section or claim undercuts the idea's angle, or the text never answers the `buyer_question` | yes |
| `REF` | Cross-reference to a place that does not exist or does not say that | yes |
| `EXM` | Example, template, or method that breaks a rule stated in the same text | yes |
| `REP` | Repetition: the same idea 2+ times with no new information | no — the human decides |

For `CON`, compare every pair of claims about the same subject, not only neighbors.
Above 40 claims, group by subject first, then compare within groups. Group all
attributions to one person or source as one subject.

### 3. Filter false alarms

Before reporting `CON`, check whether the difference comes from different
conditions, different time, different scope, a third-party opinion presented as
such, or a contrast the text names itself. If so, do not report. A named contrast is
still reported when it sets the firm's own example against the method's rule. When
unsure, report as `to verify` with the condition that might explain it.

### 4. Report

```markdown
## Consistency

- Round: N · Date: YYYY-MM-DD · Angle: "{unique_angle}"
- Claims: n · Blocking: n · Repetitions: n
- Verdict: pass | revise

| # | Code | Place A | Place B | What is wrong | Proposal |
|---|------|---------|---------|---------------|----------|

### Angle by section
| Section | supports / neutral / undercuts | Why |

### Earlier rounds
```

The claim inventory is working material; do not paste it into the review file.
Set `consistency: pass` or `consistency: revise` in the frontmatter.

## Gate

Passes with no `CON`, `NUM`, `CNT`, `ANG`, `REF`, or `EXM`. `REP` never blocks.
Standalone without an angle, `ANG` is reported as `not checked`.
