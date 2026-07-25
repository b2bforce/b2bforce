---
name: sales-bid-qualification
description: >-
  Decide bid, no-bid, or conditional on one opportunity by scoring the discovery
  brief against the service fit criteria and the ICP anti-fit criteria. Use before
  writing a proposal, when deciding whether to answer an RFP, or when the pipeline
  holds more requests than the firm can serve well.
license: MIT
metadata:
  version: 1.0.0
  category: sales
---

# Bid Qualification

Decides whether this opportunity is worth a proposal, and records why.

Bid selectivity is one of the few levers with a measured effect on win rate:
firms that qualify before proposing win around 56% of what they bid, against
roughly 45% for firms that bid on everything. Saying no is a performance
improvement, not lost revenue.

## Read First

1. The brief: `workspace/sales/opportunities/{opportunity}/!_discovery.md`.
2. `workspace/firm/services/{service}.md` — fit and anti-fit criteria.
3. `workspace/marketing/icp/{icp}.md` — `anti_fit_criteria`.
4. Recent `outcome.md` files in `workspace/sales/opportunities/*/` — what the firm
   has actually been losing, and to whom.

## When to Use

- A discovery brief exists and someone wants a proposal.
- An RFP arrived and the firm must decide whether to answer.
- More requests are open than the firm can serve well.
- Before `sales-proposal` — the Proposal Gate requires a decision here.

## Core Rules

1. Decide against **written** criteria in the service and ICP files, not against
   how much the team wants the work.
2. **A thin brief is not a bid decision.** If `brief_quality: thin`, return
   `pending` with the questions that would resolve it. Do not qualify on
   guesswork.
3. Every decision carries a reason that names the criteria that drove it.
4. `no_bid` is a successful outcome of this skill. If the firm has never recorded
   a `no_bid`, the qualification step is decorative — say so.
5. Do not soften an anti-fit signal because the deal is large. Large bad-fit
   engagements are the expensive kind.

## Decision

Write into `!_discovery.md` frontmatter:

| `bid_decision` | Meaning |
|----------------|---------|
| `bid` | Propose. Fit is clear and the process is understood well enough. |
| `conditional` | Propose only after a named condition is met. State the condition. |
| `no_bid` | Decline, with a reason recorded. |
| `pending` | Not decidable yet — brief too thin. |

Also set `qualified: {date}` and, for `conditional`, `bid_condition: {one line}`.

Then append the reasoning to the brief body under `## Qualification`:

```markdown
## Qualification

Decision: `conditional`
Condition: Economic buyer joins the next call before we invest proposal time.

Fit met: mid-market manufacturer, platform migration is our core service,
champion has budget authority for pilots.
Anti-fit triggered: no economic buyer contact yet (ICP anti-fit: "buying process
runs entirely through a technical champion").
Reasoning: The work is a good fit and the champion is credible, but every deal we
lost this year had the same gap. The condition is cheap to test and cuts the risk.
```

## Scoring

Score five dimensions. Keep it qualitative — a numeric score implies precision
this data does not have.

| Dimension | Strong | Weak |
|-----------|--------|------|
| Problem fit | Maps to a service the firm sells and has done before | Adjacent, or would need new capability |
| Buyer access | Economic buyer reachable or already met | Champion only, no path upward |
| Budget reality | Stated, or a range hinted credibly | `unknown` with no way to test it |
| Timeline reality | Dated, with a consequence for slipping | No timeline, or "as soon as possible" |
| Capacity | Firm can staff it in the window | Would need to displace committed work |

Then apply the overrides below, which beat any amount of enthusiasm on the five
dimensions.

## Hard No-Bid Signals

Recommend `no_bid` when any of these holds, and state which one:

- An explicit anti-fit criterion in the service or ICP file is triggered and
  cannot be worked around.
- The firm cannot staff the work in the stated window without breaking a
  commitment to an existing client.
- Price is the only stated evaluation criterion and the firm does not compete on
  price.
- The buyer wants free scoping work — a detailed plan with no engagement.
- An incumbent vendor is in place, the buyer will not say why they are looking,
  and there is no access beyond the champion. This is often a compliance bid used
  to justify a renewal already decided.
- The RFP arrived late, the deadline does not allow real work, and the firm has no
  prior relationship.
- Compliance, legal, or reputational conflict.

The last three are cheap to miss and expensive to discover after the work is done.
A firm answering 10 to 20 percent fewer RFPs, chosen deliberately, usually wins
more of them.

## Workflow

1. Read the brief and the criteria files.
2. If `brief_quality: thin`, stop, set `pending`, return the questions.
3. Score the five dimensions from **recorded** facts. An `unknown` in the brief is
   a weak score, never a neutral one.
4. Check the hard no-bid signals.
5. Decide, and write `bid_decision`, `qualified`, and the `## Qualification`
   section. For `conditional`, state the condition as a testable event.
6. Set the next action: proposal, the condition to close, or the decline message.
7. On `no_bid`, offer to draft a short, respectful decline. A clean no protects the
   referral channel, which produces far more work than outbound does.

## Feeding The Loop

When a `no_bid` reason repeats — the same anti-fit pattern three times — add it to
the ICP's `anti_fit_criteria` so the next qualification is faster and the pattern
is captured where content and prospecting skills also read it.

If the firm is measuring with `workspace/pdca/`, proposals declined for poor fit is
a `higher_is_better` leading metric. It is not a failure count.

## Testing Requirements

1. Qualify a `thin` brief; confirm `pending` and returned questions.
2. Qualify a brief that triggers a documented anti-fit criterion; confirm `no_bid`
   with the criterion named.
3. Qualify a good-fit brief with no economic buyer contact; confirm `conditional`
   with a testable condition.
4. Confirm `sales-proposal` refuses to run while `bid_decision` is `pending` or
   `no_bid`.

## Related Skills

| Skill | When |
|-------|------|
| `sales-discovery-brief` | Produces the brief this skill scores |
| `sales-proposal` | After `bid` or `conditional` |
| `sales-outcome-log` | Records the result, including a declined bid |
| `marketing-icp` | Update `anti_fit_criteria` when a no-bid reason repeats |
