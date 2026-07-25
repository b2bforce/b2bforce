---
name: sales-proposal
description: >-
  Assemble a B2B service proposal or SOW from the discovery brief, firm profile,
  service definition, ICP, and the verified proof library — with mandatory scope
  boundaries, assumptions, change control, and one pricing table. Use after a bid
  decision when the user needs a proposal, SOW, or RFP response.
license: MIT
metadata:
  version: 1.0.0
  category: sales
---

# Proposal

Assembles `proposal.md` for one qualified opportunity from context that already
exists in the workspace.

This skill is deliberately an assembly step, not a writing step. The bottleneck in
proposal work is not prose — it is finding the approved scope language, the current
pricing model, and a client result you are actually allowed to cite. A repo with
versioned, approved firm facts is the fix for that, so this skill reads and
composes rather than inventing.

## Proposal Gate

Do not start until all of the following hold. See `AGENTS.md` for the canonical
gate.

1. `!_discovery.md` exists in the opportunity folder.
2. `brief_quality` is `workable` or `strong`.
3. `bid_decision` is `bid` or `conditional`. For `conditional`, the
   `bid_condition` must be met — say so explicitly, or stop.
4. `workspace/firm/services/{service}.md` exists and has a `service_type`.
5. The ICP and persona files referenced by the brief exist.

If any fails, stop and name the missing piece. Run `sales-discovery-brief` or
`sales-bid-qualification` first.

## Proof Gate

Every client result, metric, name, or quote in the proposal must resolve to a
record in `workspace/firm/proof/{slug}.md`. See the Proof Gate in `AGENTS.md`.

- List every record you rely on in frontmatter `proof_refs`.
- A record with `client_public: false` may be cited as an anonymized description.
  **Never write that client's name.**
- Quote a client only from a record with `quote_approved: true`.
- If no relevant record exists, write the proof section with what is true — process,
  method, team experience, comparable public work — and add `proof_needed: true`
  to frontmatter. Do not describe a result the firm cannot evidence.

A proposal with an unsupported number is worse than one with fewer numbers. The
number will be quoted back during negotiation, and the firm will have to defend it.

## Length

Target **6–8 pages, roughly 2,000–2,500 words**. Proposals in that range close at
roughly twice the rate of 20-page documents. The validator fails above 3,000 words.

Length discipline is not cosmetic. A long proposal signals that the firm did not
know which parts mattered, and it moves the decision to whoever has time to read
it — usually not the economic buyer.

## Required Structure

In this order. The validator checks that each heading exists and is non-empty.

```markdown
## Situation
## Outcomes
## Approach
## Scope
## Out of scope
## Assumptions
## Change control
## Proof
## Commercials
## Next step
```

Section-by-section rules, worded examples, and the pricing table format:
`references/proposal-structure.md`.

Three of these are mandatory for a commercial reason, not a formatting one:

- **`## Out of scope`** — most firms deliver unbilled out-of-scope work every
  month, and a written exclusion list is the cheapest defense that exists.
- **`## Assumptions`** — every dependency on the client that, if unmet, changes
  the timeline or the price.
- **`## Change control`** — how a change gets priced and approved, agreed before
  it is needed rather than during the argument.

Scope lives inside the proposal. Do not create a separate scope file; a second
document drifts from the first and the client only ever reads one of them.

## Commercials

One pricing table. Not three scattered mentions, not a price in prose.

`price_model` in frontmatter must match `service_type` in the service file. A
retainer service priced as a fixed project, or the reverse, means either the
service definition or the proposal is wrong — stop and resolve which.

Options are allowed, and usually help: two or three tiers let the buyer choose
scope instead of choosing whether to proceed. Keep them in the same table, and
mark the recommended one.

State what the price includes, the payment schedule, and how long it holds.

## Workflow

### 1. Load context

Read, in order: brief, firm profile, service file, ICP, persona, then
`workspace/firm/proof/` for records matching this service and ICP.

### 2. Select proof

Choose at most three proof records — the closest by service, then by ICP. Note
each record's `client_public` and `quote_approved` flags before writing anything.

Three relevant results beat eight loosely related ones. The buyer is checking
whether the firm has solved this specific problem, not counting logos.

### 3. Open in the buyer's language

`## Situation` reuses the quote from `## Problem in the buyer's words` in the
brief. Do not paraphrase it into vendor language. The buyer should recognize their
own words in the first paragraph.

### 4. Write outcomes before approach

State what will be true when the work is done, then how the firm gets there.
Approach before outcome reads as a methodology pitch.

### 5. Draw the boundary

Fill `## Scope`, `## Out of scope`, `## Assumptions`, `## Change control`. Be
specific in the exclusions: name the adjacent work a client would reasonably
assume is included, and say it is not.

### 6. Price it

One table, `price_model` matching the service, payment schedule, validity.

### 7. Close with one next step

One action, dated, low friction. Not "let us know your thoughts".

### 8. Validate

```bash
scripts/validate-proposal.sh workspace/sales/opportunities/{opportunity}/proposal.md
```

Treat a non-zero exit as a hard stop.

### 9. Record the send

Set `status: sent` and `sent: {date}` when it goes out. Then `sales-outcome-log`
records what happened, which is what makes win rate computable later.

## Output

`workspace/sales/opportunities/{account}--{service}--{YYYY-MM}/proposal.md`

Frontmatter:

```yaml
---
opportunity: acme-industrial--platform-migration--2026-07
account: acme-industrial
service: platform-migration
icp: mid-market-manufacturing
persona: cto-mid-market
price_model: project            # must match service_type
currency: EUR
proof_refs:
  - northwind-release-automation
  - anonymized-manufacturer-migration
proof_needed: false
status: draft                   # draft | sent | withdrawn
generated_at: 2026-07-25
sent:
---
```

## Not A Contract

The output is a commercial proposal, not a legal agreement. It does not constitute
legal advice. Tell the user to have counsel review terms, liability, IP, and data
processing before signing — the same guardrail `sales-prospecting-sequence` applies
to email compliance.

## Confidentiality

Proposals contain pricing and the proof library contains unpublished client
results. Both are committed to git by default. Before the first proposal, confirm
the user understands this and wants it — see `SECURITY.md` for the gitignore
option if the repo is or will become public.

## Testing Requirements

1. Run against an opportunity with `bid_decision: pending`; confirm refusal.
2. Generate a proposal citing a record with `client_public: false`; confirm the
   client name appears nowhere and the validator passes.
3. Add a metric to `## Proof` that no referenced record supports; confirm the
   validator fails.
4. Set `price_model` to something other than the service's `service_type`; confirm
   the validator fails.
5. Delete `## Out of scope`; confirm the validator fails.
6. Confirm word count lands in 2,000–2,500 and the validator passes.

## Reference Files

| File | Content |
|------|---------|
| `references/proposal-structure.md` | Section rules, pricing table format, worked examples |

## Related Skills

| Skill | When |
|-------|------|
| `sales-discovery-brief` | Produces the brief; run first |
| `sales-bid-qualification` | Must record `bid` or `conditional` before this runs |
| `sales-outcome-log` | Records won/lost and creates the proof record on a win |
| `marketing-content-case-study` | Turns a proof record into a public case study |
