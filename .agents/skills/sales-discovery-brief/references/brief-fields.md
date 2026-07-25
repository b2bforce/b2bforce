# Discovery Brief Fields

Section rules for `workspace/sales/opportunities/{account}--{service}--{YYYY-MM}/!_discovery.md`.

## Signal vocabularies

Keep these values exact — `sales-bid-qualification` and
`scripts/validate-proposal.sh` read them.

| Field | Values |
|-------|--------|
| `source` | `inbound`, `referral`, `outbound`, `rfp`, `existing_client` |
| `budget_signal` | `stated`, `range_hinted`, `unknown`, `no_budget` |
| `timeline_signal` | `dated`, `quarter_hinted`, `unknown`, `no_timeline` |
| `decision_process` | `mapped`, `partial`, `unknown` |
| `bid_decision` | `pending`, `bid`, `conditional`, `no_bid` |
| `brief_quality` | `thin`, `workable`, `strong` |

`source` matters more than it looks. Referrals and existing clients convert at a
different rate than cold outbound, and a firm that treats every lead the same
over-invests in the weakest channel.

## `## Situation`

Two or three sentences of context: what the company does, why they are looking
now, how the conversation started. Enough that someone reading in three months
knows who this is.

## `## Problem in the buyer's words`

Quote the buyer. Direct quotes here are the single most reusable asset in the
folder — the proposal opens with the buyer's own language, and a proposal that
sounds like the buyer's internal conversation reads as understanding rather than
pitching.

```markdown
> "Every release takes a week of manual regression and we still ship bugs to
> production. My team is spending Fridays on it instead of the new platform."
```

If there is no quote — an RFP with no call, for example — say so plainly and use
the closest paraphrase, marked as a paraphrase.

## `## Impact`

What the problem costs today. Money, hours, risk, blocked revenue, staff
attrition. Record only what the buyer stated or confirmed.

If the buyer has not quantified it, that is itself a finding: write "not
quantified by the buyer" and add the quantifying question to `## Open questions`.
Do not estimate on their behalf — a number you invented will end up in a proposal
and then in a negotiation.

## `## Desired outcome`

What they want to be true when the work is done, in their terms. Not your
deliverables. "Releases go out on Tuesday without a war room" is an outcome;
"CI/CD pipeline implementation" is a deliverable.

## `## Decision process`

Who decides, who influences, who can veto, and what must happen for a yes:
procurement, security review, board approval, a pilot.

```markdown
| Role | Name | Part in the decision |
|------|------|----------------------|
| Economic buyer | unknown | Signs; not yet met |
| Champion | Anna (CTO) | Ran the first call, wants this solved |
| Blocker | unknown | Security review mentioned, process unclear |
```

`unknown` in this table is useful information. An opportunity where the economic
buyer has never been met is a different risk than one where they ran the call.

## `## Constraints`

Timing, budget, incumbent vendor, internal capacity, compliance, technology,
geography. Include the incumbent by name if stated — losing to an incumbent is the
most common loss reason and the cheapest to see coming.

## `## Firm assessment`

Your reading, clearly separated from the buyer's words:

- which service this maps to, and confidence;
- which fit criteria are met;
- **which anti-fit criteria are triggered** — always state these, and do not
  soften them;
- what would make this a good engagement, and what would make it painful.

## `## Open questions`

Real questions, ordered by how much they would change the decision. Each with why
it matters.

```markdown
1. Who else approves this besides you? — Determines whether a pilot is needed.
2. What happens if this slips past Q4? — Tests whether the timeline is real.
3. Have you budgeted for this, or is this exploratory? — Decides bid or no-bid.
```

On a `thin` brief this is the longest section, and that is correct.

## `## Next action`

One step, with an owner and a date. Not a list of options.

## Worked example — thin brief

A three-line inbound email produces something like this, and that is a legitimate
output:

```yaml
---
account: northwind-logistics
account_public: false
service: platform-migration
icp: mid-market-logistics
persona: cto-mid-market
source: inbound
opened: 2026-07-25
updated: 2026-07-25
budget_signal: unknown
timeline_signal: unknown
decision_process: unknown
competitors_known: []
bid_decision: pending
brief_quality: thin
---
```

With `## Situation` holding two sentences, `## Problem in the buyer's words`
holding the one line they wrote, most other sections holding "not stated", and
`## Open questions` holding the four questions that would make this workable.

The brief is honest, took two minutes, and is enough for `sales-bid-qualification`
to say "not yet — ask these first".
