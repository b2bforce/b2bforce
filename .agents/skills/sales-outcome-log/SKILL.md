---
name: sales-outcome-log
description: >-
  Record how an opportunity ended — won, lost, or no-decision — with the reason and
  the competitor, then create the verified proof record on a win. Also backfills
  proof records for past engagements. Use after a proposal is decided, for win-loss
  review, or when the firm has client results nothing in the repo has captured.
license: MIT
metadata:
  version: 1.0.0
  category: sales
---

# Outcome Log

Closes the loop on one opportunity and feeds the proof library.

Two things depend on this skill. Win rate is not computable unless outcomes are
recorded — and a large share of proposal leaders cannot state their own win rate.
And `marketing-content-case-study` is unrunnable until a verified proof record
exists, because it correctly refuses to invent client results.

## Read First

1. The opportunity folder: `!_discovery.md` and `proposal.md` if present.
2. `workspace/firm/proof/` — an existing record for this client may just need
   updating.
3. `workspace/marketing/icp/{icp}.md` — where a repeated loss pattern belongs.

## When to Use

- A proposal was accepted, declined, or went quiet.
- Win-loss review across recent opportunities.
- `bid_decision: no_bid` — a declined bid is an outcome worth recording.
- **Backfill:** the firm has past client results and the repo has no proof records,
  so case studies and proposals have nothing to cite.

## Modes

| Mode | Use |
|------|-----|
| `close` | An opportunity in `workspace/sales/opportunities/` ended |
| `fill` | Delivery produced results — turn an existing stub into a usable record |
| `backfill` | A past engagement with no opportunity folder — record the proof only |

`backfill` is how a firm that just cloned this repo makes its existing track record
usable. Run it once per notable past engagement; three good records beat a folder
of thin ones.

`fill` is the mode that keeps this pipeline from stalling. A win creates a stub with
empty `metrics`, and a stub nobody returns to is the failure mode of the whole proof
library. Two things trigger `fill`: a `client-qbr` where the client just confirmed
numbers out loud, and `client-health-review`, which reports every stub still empty.

## Core Rules

1. Record the reason the **buyer** gave, separately from the firm's interpretation.
   The stated reason is usually not the real one, and conflating them destroys the
   only useful signal in the data.
2. Never invent a loss reason, a competitor, or a decision date. `unknown` is a
   real value, and a pattern of `unknown` is itself the finding: the firm is not
   asking.
3. `verified: true` on a proof metric requires a **human** to have confirmed the
   number. An agent may never set it from inference.
4. Do not mark a client public. `client_public` and `quote_approved` are the
   client's decision, recorded by a human. Default both to `false`.
5. A quiet prospect is `no_decision`, not `lost`. They are different problems: one
   is a competitive loss, the other is a stalled decision process, and they need
   different fixes.

## Output — `outcome.md`

`workspace/sales/opportunities/{opportunity}/outcome.md`

```yaml
---
opportunity: acme-industrial--platform-migration--2026-07
result: won                     # won | lost | no_decision | declined_by_us
decided: 2026-09-12
value: 32000
currency: EUR
price_model: project
reason_stated: unknown          # what the buyer said
reason_assessed: incumbent_renewal
competitor: unknown
proof_record:                   # set on a win
---
```

Allowed `reason_assessed` values: `price`, `scope_mismatch`, `timing`,
`no_budget`, `incumbent_renewal`, `internal_build`, `no_decision_process`,
`lost_champion`, `capability_gap`, `we_declined`, `unknown`.

Body:

```markdown
## What happened

Short factual sequence, with dates.

## Reason the buyer gave

> "We decided to extend our current vendor for another year."

## Our assessment

The champion never introduced us to the economic buyer, and qualification flagged
that gap as a condition we then proposed past anyway.

## What we would do differently

Hold the `conditional` bid condition instead of waiving it.
```

The last section is what makes this a loop rather than a filing cabinet.

## Output — Proof Record

On `result: won`, and in `backfill` mode, create or update:

`workspace/firm/proof/{slug}.md`

Schema and field rules: `docs/WORKSPACE.md`, section "Proof record".

```yaml
---
client: northwind-logistics
client_public: false
quote_approved: false
usable_publicly: false
service: platform-migration
icp: mid-market-logistics
engagement_type: project
period: 2026-09..2026-11
metrics: []
reference_call_ok: false
source_opportunity: acme-industrial--platform-migration--2026-07
created: 2026-09-12
updated: 2026-09-12
---
```

On a fresh win the record is a **stub**: flags `false`, `metrics` empty. That is
correct and honest — the engagement has not produced results yet. Set
`proof_record: {slug}` in `outcome.md` so the two link.

**Multi-brand workspaces:** the record is written into the **delivering brand's
home** — `firm/brands/{brand}/proof/{slug}.md`, the brand taken from the
opportunity's path segment (`sales/opportunities/{brand}/…`), never asked for.
No `brand:` field — the path carries it. Set `cross_brand: false` unless the
user explicitly allows sibling brands to cite the result. In `backfill` mode
ask which brand delivered each result.

The stub becomes useful later, when delivery ends and a human confirms numbers —
that is `fill` mode. Say this to the user and offer to schedule the follow-up. If the
firm uses `workspace/clients/`, the QBR is the natural moment: the numbers are already
on the table, and `client-health-review` reports every stub still empty.

### Filling a record

Each metric needs a label, before, after, and `verified`:

```yaml
metrics:
  - { label: "Deployment lead time", before: "6 weeks", after: "4 days", verified: true }
  - { label: "Services on automated regression", before: "0", after: "9", verified: true }
```

Rules:

- `verified: true` only for a number a human confirmed. Ask explicitly: "can you
  confirm this figure is right and that we may use it?"
- `client_public: true` only after the client agreed to be named.
- `quote_approved: true` only with an actual approved quote, stored in the body.
- `usable_publicly: true` only when the client agreed to public use. This governs
  case studies and the website; a private proposal may cite a record that is not
  publicly usable, as long as naming and quote flags are respected.

## Feeding The Loop

1. **Repeated loss reason** — the same `reason_assessed` three times: add the
   pattern to the ICP's `anti_fit_criteria`, so qualification, content, and
   prospecting all read it.
2. **Named competitor** — add or update
   `workspace/intelligence/competitors/{slug}/` so the firm monitors who it
   actually loses to, rather than who it assumes.
3. **Win with results** — the proof record unblocks
   `marketing-content-case-study`, the highest-converting content type the repo
   supports.
4. **Measurement** — with `workspace/pdca/`, `outcome.md` frontmatter is the source
   of truth for the `pipeline` metric pack. Win rate becomes a `grep`, not an
   estimate.

## Workflow

1. Pick the mode.
2. For `close`: read the folder, ask for the result, the date, the value, and what
   the buyer said. Ask what the buyer said **verbatim** — the paraphrase loses the
   signal.
3. Write `outcome.md`. Keep stated and assessed reasons separate.
4. On a win, create the proof stub and link it both ways.
5. For `backfill`: skip `outcome.md`, create the proof record directly, and ask
   which metrics a human can confirm right now. Leave the rest unverified rather
   than filling them in.
6. For `fill`: read the existing record, ask which numbers the client has now
   confirmed, and update `metrics`, the permission flags, and `updated`. Never
   promote a flag the client did not agree to.
7. Check the loop triggers above and act on any that fire.
8. If several outcomes in a row are `unknown` on `reason_stated`, say so. The firm
   is not asking losers why they lost, which is the cheapest research available.

## Testing Requirements

1. Close a lost opportunity with `reason_stated: unknown`; confirm the assessment
   stays separate and no reason is invented.
2. Close a win; confirm a stub proof record appears with all flags `false` and
   empty `metrics`, linked from `outcome.md`.
3. Run `backfill` for a past engagement; confirm a record is created with only
   human-confirmed metrics marked `verified: true`.
4. Run `marketing-content-case-study` against a filled, publicly usable record;
   confirm its proof gate is now satisfied.
5. Run `fill` against a stub; confirm only human-confirmed metrics get
   `verified: true` and that unconfirmed ones stay out rather than being estimated.

## Related Skills

| Skill | When |
|-------|------|
| `sales-proposal` | Produced the proposal being decided |
| `sales-bid-qualification` | Receives the repeated-loss patterns |
| `marketing-content-case-study` | Consumes a filled, publicly usable proof record |
| `intel-competitor-monitoring` | Start monitoring a competitor that beat the firm |
| `client-onboarding` | A win becomes an account — run it next |
| `client-qbr` | Where confirmed results arrive that `fill` mode needs |
| `client-health-review` | Reports every proof stub still empty |
| `firm-pdca-cycle` | Turns recorded outcomes into a measured win rate |
