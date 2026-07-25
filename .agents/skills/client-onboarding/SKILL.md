---
name: client-onboarding
description: >-
  Turn a won deal into a first-90-days plan with a written success definition, named
  stakeholders and what each judges success by, and checkpoints at day 14, 30, and 90.
  Use right after a win, when a new client starts, or when an existing account has no
  agreed definition of what success means.
license: MIT
metadata:
  version: 1.0.0
  category: client
---

# Client Onboarding

Creates the account record and the first-90-days plan for a client the firm just won.

This skill exists because of one number: nearly half of B2B client departures happen
in the first 90 days, and the decision is frequently made around **day 14** — before
any work could have produced a result. What the client evaluates in that window is
not output. It is whether they understand what is happening and whether it matches
what they bought.

## Read First

1. `workspace/firm/profile.md` — firm context.
2. The won opportunity, if there is one:
   `workspace/sales/opportunities/{opportunity}/` — `proposal.md` and `outcome.md`.
   **The proposal is the promise.** Onboarding either honors it or the client
   experiences a bait-and-switch in week one.
3. `workspace/firm/services/{service}.md` — what was actually sold.
4. `workspace/clients/{slug}/` — an account may already exist.

## When to Use

- `sales-outcome-log` recorded `result: won`.
- A new client starts without a formal proposal (referral, existing relationship).
- An **existing** account has no written success definition. This is the common case
  on a repo that was just set up, and it is worth backfilling for active clients
  before anything else in this folder.

## The Success Definition

The one output that matters most. Everything else here is scheduling.

Write the sentence the **client** would use to say this engagement worked, in their
words, with a number or an observable state in it.

| Not a success definition | A success definition |
|--------------------------|----------------------|
| "Improve the release process" | "We ship on a weekday without anyone working a weekend" |
| "Better reporting" | "I can answer the board's cost-per-lead question without asking the agency" |
| "Migrate the platform" | "Dispatch stays up through the migration weekend and no invoice is wrong" |

Rules:

1. It comes from the client, not from the firm. If the words are the firm's, that is
   a hypothesis to confirm on the kickoff call, and it must be marked as one.
2. If the proposal has an `## Outcomes` section, start there — those were the terms
   of the sale. Do not quietly write a different, easier definition.
3. Different stakeholders judge success differently. Record each one's criteria
   separately rather than averaging them into a sentence nobody said.
4. If the client cannot state one, that is the finding, and it goes in the risk list.
   An engagement with no agreed definition of success cannot be renewed on evidence.

Never invent it. An assumed success definition is worse than a missing one, because
the firm will confidently deliver against it.

## Workflow

### 1. Resolve the source

From a won opportunity, carry over: account slug, service, engagement type, the
buyer's stated situation, the promised outcomes, and scope boundaries. Without one,
ask for the same fields — do not proceed on a service the repo cannot name.

### 2. Write `!_account.md`

Schema: `docs/WORKSPACE.md`, section "Account record". At minimum a real engagement
model and **one named contact with a role**. That is the Client Context Gate in
`AGENTS.md`; the other skills in this folder will refuse to run without it.

`mrr_band` is a band, never an exact figure. Do not record contract value, margin,
utilization, or hours — that is a PSA tool, not this repo.

### 3. Map the stakeholders

For each person: name, role, whether they are economic buyer / champion / user /
blocker, and **what they personally judge success by**. The champion who bought the
work and the user who lives with it usually do not agree, and the firm finds out at
renewal if it did not ask now.

Flag anyone named in the proposal that the firm has not actually met.

### 4. Write `onboarding.md`

```yaml
---
client: northwind-logistics
service: platform-migration
source_opportunity: northwind--platform-migration--2026-07
started: 2026-08-17
success_definition: "We ship on a weekday without anyone working a weekend."
success_definition_source: client   # client | firm_hypothesis
day_14: 2026-08-31
day_30: 2026-09-16
day_90: 2026-11-15
status: active                      # active | complete
---
```

Body sections, in this order:

1. **Success definition** — the sentence, plus who said it and when.
2. **Stakeholders** — table: name, role, type, what they judge success by, met yet.
3. **What we promised** — pulled from the proposal's `## Outcomes` and `## Scope`,
   with the out-of-scope boundaries restated. The client's team has usually not read
   the proposal, so this is where scope creep is prevented cheaply.
4. **Kickoff agenda** — confirm the success definition out loud, confirm access and
   dependencies, name the escalation path, agree the checkpoint dates.
5. **Checkpoints** — day 14, 30, 90, each with what must be true by then. Day 14 is
   the important one and it is almost never about output; it is "does the client know
   what is happening and does it match what they bought".
6. **Risks** — including any assumption from the proposal that has not held.

### 5. Say what is not yet known

List the open questions the kickoff must answer. A confident onboarding plan built on
guesses is the failure this skill is supposed to prevent.

## Rules

1. Never invent the success definition, a stakeholder, or a criterion. Mark firm
   guesses as `firm_hypothesis` and confirm them on the call.
2. Do not restate the proposal's promises more favorably than the proposal did.
3. Day 14 gets a checkpoint even on a long engagement. On a 12-month retainer it is
   still where churn is decided.
4. Do not create `qbr/` or `account-plan.md` here. They come later, from their own
   skills, when there is something real to put in them.
5. Contract values, hours, and margin do not belong in this folder.

## Testing Requirements

1. Run from a won opportunity; confirm `success_definition` traces to the proposal's
   `## Outcomes` and that scope boundaries carry over.
2. Run with no proposal; confirm the skill asks rather than assuming a service.
3. Give a vague goal ("improve marketing"); confirm the skill pushes for an
   observable definition instead of accepting it.
4. Confirm `scripts/validate-account.sh workspace/clients/{slug}` passes.
5. Confirm no exact contract value appears anywhere in the output.

## Related Skills

| Skill | When |
|-------|------|
| `sales-outcome-log` | Recorded the win this skill starts from |
| `client-account-plan` | After onboarding lands, to plan expansion |
| `client-qbr` | First quarterly review, scored against the success definition here |
| `client-health-review` | Flags active accounts with no success definition |
