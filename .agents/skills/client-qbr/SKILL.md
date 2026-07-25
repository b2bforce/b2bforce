---
name: client-qbr
description: >-
  Prepare a quarterly business review for one client — delivered versus what was
  promised, scored against the success definition agreed at onboarding, then the next
  quarter, an expansion ask, and a referral ask. Use for QBRs, quarterly or renewal
  reviews, or account check-ins.
license: MIT
metadata:
  version: 1.0.0
  category: client
---

# Client QBR

One quarter, one client, four questions: what did we promise, what did they get, what
happens next, and what are we asking for.

The QBR is the only recurring moment where the firm has demonstrated value on the
table and the client's attention at the same time. That is why the expansion ask and
the referral ask belong here and not in a standalone workflow — asking before you have
shown the quarter's results is the version that damages the relationship. Firms that
run structured quarterly reviews grow account value materially faster than firms that
only talk to clients when something is wrong.

## Read First

1. `workspace/clients/{slug}/!_account.md` — Client Context Gate applies.
2. **`workspace/clients/{slug}/onboarding.md`** — the success definition and each
   stakeholder's criteria. This is the scorecard. A QBR that invents its own criteria
   this quarter is a status update.
3. The previous `workspace/clients/{slug}/qbr/` file — what was promised last quarter.
4. `workspace/clients/{slug}/account-plan.md` — the expansion hypotheses and triggers.
5. `workspace/firm/proof/` — records for this client, and comparable results.
6. `workspace/clients/{slug}/notes.md` — relationship signals from the quarter.

## When to Use

- Quarterly review with an active client.
- Renewal approaching — run this **before** the renewal conversation, not during it.
- The firm has not reviewed an account in two quarters, which the renewal review rule
  in `AGENTS.md` treats as a trigger.

## Delivered Versus Promised

The core section, and the one with the strongest temptation to drift.

Take last quarter's commitments — from the previous QBR, or from `onboarding.md` on the
first one — and mark each: **delivered**, **partial**, **not delivered**, or
**descoped by agreement**. Then score the success definition itself: `on_track`,
`at_risk`, or `not_measurable_yet`.

Rules that make this credible:

1. **A bad quarter is written as a bad quarter.** A client who lived through a missed
   commitment and reads that it was delivered stops trusting every other line. Firms
   lose accounts they were serving well by reporting them optimistically.
2. **Never invent a result.** Every number comes from a proof record, the client's own
   system, or a source the client can check. No source, no number — the Proof Gate is
   not relaxed because the audience is the client who lived it.
3. **Outputs are not outcomes.** "Shipped 14 deliverables" is activity. The success
   definition is the outcome. If the outcome is not measurable yet, say
   `not_measurable_yet` rather than substituting activity for it.
4. **Firm-caused misses get named as firm-caused.** Attributing everything to client
   dependencies is transparent and expensive.
5. `not_measurable_yet` is honest early and evasive late. If it is still that at the
   third QBR, the engagement has a measurement problem worth raising.

## The Two Asks

Both go at the end, both are optional, and both are earned by the section above.

**Expansion ask.** At most one, taken from `account-plan.md`, and only if its trigger
has actually fired. Frame it as the client's problem, not the firm's service. If the
quarter was scored `at_risk`, there is no expansion ask this quarter — fix delivery
first. Naming that skip explicitly is the point; an agent that asks anyway is the
failure mode.

**Referral ask.** The highest-return thing in this file. Most B2B purchases begin with
a referral, referred deals close in a fraction of the time of cold-sourced ones, and
firms rate referrals as their most effective channel by a wide margin over outbound —
yet most never systematically ask. The repo automates the channel that works worst
and, without this, ignores the one that works best.

Preconditions, all required:

- the quarter scored `on_track`;
- `referenceable` is not `false` in `!_account.md`;
- a specific, easy ask — a named person or a described situation, not "know anyone?"

Ask for one introduction, not a list. Make it forwardable: two or three sentences the
client can pass on without rewriting, plus a plain description of who the firm helps.
The client's effort is the constraint, not their goodwill.

If a precondition fails, record `referral_ask: skipped` and the reason. Asking a
client whose quarter went badly is how a recoverable account becomes a lost one.

## Workflow

1. Check the gate. Missing `!_account.md` or `onboarding.md` → run `client-onboarding`.
2. Assemble last quarter's commitments and mark each honestly.
3. Score the success definition. Note per-stakeholder criteria that diverge — the
   champion and the user often disagree, and renewal follows whoever holds budget.
4. Pull real results only. Anything unsourced becomes an open question for the client.
5. Decide the next quarter: at most three commitments, each with a date and an owner.
6. Decide the two asks against their preconditions, and record skips with reasons.
7. Write the file, then update `!_account.md`: `health`, `health_reason`,
   `reviewed_at`, `last_contact`, and `referenceable` if the client agreed.
8. **If this client's proof record is still an empty stub and the quarter produced
   confirmable numbers, say so and offer `sales-outcome-log` to fill it.** A stub
   nobody returns to is the documented failure mode of the proof library, and the QBR
   is the natural moment it gets fixed — the numbers are already on the table.

## Output

`workspace/clients/{slug}/qbr/{YYYY}-Q{N}.md`

```yaml
---
client: northwind-logistics
period: 2026-Q4
success_definition_status: on_track   # on_track | at_risk | not_measurable_yet
commitments_delivered: 3
commitments_missed: 1
health: green                          # green | amber | red
expansion_ask: release-automation      # service slug, or: skipped
expansion_ask_skipped_reason:
referral_ask: made                     # made | skipped
referral_ask_skipped_reason:
proof_refs: [northwind-release-automation]
next_review: 2027-01-15
generated: 2026-12-18
---
```

Body: **What we promised**, **What was delivered** (with the honest marks),
**Success definition status**, **Next quarter**, **Where we need you** (client-side
dependencies), **Expansion** if any, **Referral** if any.

This document is client-facing. Render it with `tool-weasyprint` if it is being sent:

```bash
uv run --with markdown --with weasyprint python3 \
  .agents/skills/tool-weasyprint/scripts/md-to-pdf.py \
  workspace/clients/{slug}/qbr/{YYYY}-Q{N}.md
```

Internal risk assessment stays in `account-plan.md` and `notes.md`, not here. Keep the
blunt language where the client will not read it.

## Testing Requirements

1. Run with one missed commitment; confirm it is marked missed, not softened, and that
   firm-caused attribution is stated.
2. Score a quarter `at_risk`; confirm no expansion ask and no referral ask are made,
   and both skips carry reasons.
3. Run with `referenceable: false`; confirm no referral ask regardless of the score.
4. Confirm every number in the file traces to a proof record or a client-side source.
5. Confirm an empty proof stub for this client triggers the offer to fill it.
6. Render the PDF; confirm no internal risk language appears in it.

## Related Skills

| Skill | When |
|-------|------|
| `client-onboarding` | Wrote the success definition this scores against |
| `client-account-plan` | Supplies the expansion hypothesis and its trigger |
| `sales-outcome-log` | Fills the proof record from results confirmed in this review |
| `client-health-review` | Flags accounts with no QBR in two quarters |
| `tool-weasyprint` | Renders the sendable PDF |
