---
name: client-account-plan
description: >-
  Map an account's buying committee and build expansion hypotheses from the firm's
  services this client has not bought, each with a trigger that says when to raise it.
  Use for account planning, expansion or cross-sell planning, or when asked where
  growth in the existing client base could come from.
license: MIT
metadata:
  version: 1.0.0
  category: client
---

# Client Account Plan

Answers two questions for one client: **who actually decides**, and **what else could
they buy and when**.

The economics are the reason this is a skill rather than a note. Selling to an
existing client is several times cheaper than acquiring a new one, closes roughly
twice as fast, and wins far more often, because the hard part — trust that the firm
delivers — is already paid for. Healthy firms take a meaningful share of quarterly
bookings from existing accounts. Firms that do not are usually not choosing that;
they simply have no place where the question is asked.

## Read First

1. `workspace/clients/{slug}/!_account.md` — Client Context Gate applies.
2. `workspace/clients/{slug}/onboarding.md` — the success definition and stakeholders.
3. **`workspace/firm/services/`** — all of them. The gap between what this firm sells
   and what this client bought *is* the expansion pipeline, and it is already written
   down. Read each service's `fit_criteria` rather than guessing at fit.
4. `workspace/clients/{slug}/qbr/` — what was already raised, and how it landed.
5. `workspace/firm/proof/` — a comparable result makes an expansion case concrete.

## When to Use

- Planning the next 90 days on an account.
- Expansion, cross-sell, or upsell planning.
- A renewal is approaching and the firm wants more than a flat renewal.
- The firm asks where growth could come from without new logos.
- A single-threaded relationship needs widening.

## Expansion Hypotheses

Each is a hypothesis, not a plan, and each needs four things:

| Part | Requirement |
|------|-------------|
| Service | An actual `workspace/firm/services/{slug}.md` the client has not bought |
| Client-side reason | A problem **this client has stated**, or an observed fact — not a generic benefit |
| Trigger | The event that makes it relevant. Without one this is a wish. |
| Evidence | A proof record for a comparable result, or an explicit note that there is none |

Match against the service's own `fit_criteria`. If the client fails them, say so and
drop the hypothesis — a service sold outside its fit criteria becomes the next
`scope_mismatch` loss and a damaged relationship at the same time.

Triggers are what turn this file from a document into a mechanism. Good ones are
observable: a renewal date, a hiring signal, a system being retired, a stated
quarterly goal, a stakeholder change, the day-90 checkpoint landing green.

Two to four hypotheses. A list of eight is a sign the firm is enumerating its service
catalogue rather than thinking about this client.

**Multi-brand workspaces:** draw candidate services from **every** brand home's
`firm/brands/{brand}/services/` — a sibling brand's service the client has not bought is
the cheapest expansion the structure can see, and the reason client accounts are
shared across brands. The hypothesis names the qualified `{brand}/{slug}`, holds
to that service's own fit criteria, and cites cross-brand proof only where the
record allows it (`cross_brand: true` — Proof Gate). Skip brands with
`status: sunset`.

## Workflow

### 1. Check the gate

`!_account.md` must exist with a real engagement model and one named contact. If not,
run `client-onboarding` first.

### 2. Map the committee

Table: name, role, type (economic buyer / champion / user / blocker / unknown),
relationship strength (`strong` / `working` / `none`), and who at the firm owns it.

Then state the concentration risk plainly. If exactly one person holds the
relationship, that is the account's largest single risk regardless of how well
delivery is going — and single-threaded accounts are how firms lose clients they
were serving well. Name who should be met next and what would make that natural.

Mark `unknown` where it is unknown. A committee map with invented roles is worse than
an incomplete one, because it will be used for planning.

### 3. Build the hypotheses

Walk every service file. For each one not bought: does this client have a stated
problem it addresses, and do they pass its `fit_criteria`? Keep the ones that survive
both questions.

### 4. Name the risks

Renewal risk, concentration risk, unaddressed criteria from `onboarding.md`, stale
`last_contact`, budget cycle timing. Each with what would reduce it.

### 5. Write `account-plan.md`

`workspace/clients/{slug}/account-plan.md`

```yaml
---
client: northwind-logistics
services_current: [platform-migration]
services_candidate: [release-automation, observability-retainer]
committee_mapped: 3
single_threaded: false
renewal_date: 2027-08-16
next_review: 2026-12-01
updated: 2026-09-20
---
```

Body: **Buying committee**, **Expansion hypotheses** (one subsection each, with the
four required parts), **Risks**, **Next 90 days** — at most three concrete actions
with an owner and a date.

## Rules

1. Only propose services that exist as files. Never invent a service the firm does not
   sell, and never soften a service's `fit_criteria` to make a hypothesis work.
2. Never invent a stakeholder, a title, or a budget. `unknown` is a real value.
3. Every hypothesis needs a trigger. No trigger, no hypothesis.
4. Cite results only from `workspace/firm/proof/` — the Proof Gate applies here as
   everywhere. "Similar clients see 30%" with no record behind it is exactly the claim
   this repo refuses to make.
5. This plan is internal. It is not sent to the client, and its language should be
   blunt about risk in a way a client-facing document would not be.
6. Three actions in "Next 90 days", maximum. A plan with twelve actions produces none.

## Testing Requirements

1. Run against an account with one bought service and three defined services; confirm
   candidates come only from the two remaining, and only if `fit_criteria` pass.
2. Run with a single named contact; confirm `single_threaded: true` and that
   concentration risk is called the largest risk.
3. Confirm a hypothesis without a trigger does not survive into the file.
4. Confirm no expansion claim cites a metric absent from `workspace/firm/proof/`.
5. Run with a missing `!_account.md`; confirm the gate stops it.

## Related Skills

| Skill | When |
|-------|------|
| `client-onboarding` | Creates the account record and stakeholder map this reads |
| `client-qbr` | Where an expansion hypothesis is actually raised with the client |
| `marketing-service` | Defines the services and `fit_criteria` this matches against |
| `sales-discovery-brief` | A hypothesis the client engages with becomes an opportunity |
