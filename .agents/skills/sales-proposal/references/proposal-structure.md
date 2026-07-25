# Proposal Structure

Section rules for `workspace/sales/opportunities/{opportunity}/proposal.md`.

Target 2,000–2,500 words across all sections. `scripts/validate-proposal.sh` fails
above 3,000.

## `## Situation`

150–250 words. The buyer's problem in the buyer's words, taken from the discovery
brief. Include the quote.

```markdown
Your team ships every release behind a week of manual regression testing, and bugs
still reach production.

> "My team is spending Fridays on it instead of the new platform."

Three consequences you named: the platform roadmap has slipped two quarters,
Friday overtime is driving attrition on a four-person team, and the last
production incident cost a week of engineering time to unwind.
```

No firm introduction here. The buyer knows who they are talking to and does not
need the founding story before their own problem.

## `## Outcomes`

100–200 words. What will be true when the work is done, in the buyer's terms.
Three to five, each observable.

```markdown
- Releases ship on a fixed weekly slot without a war room.
- Regression runs in under 30 minutes, automated, on every pull request.
- Your team can explain and change the pipeline without us.
```

The third one matters more than firms expect. Buyers of professional services are
choosing between vendors who leave capability behind and vendors who leave
dependency, and saying which one you are is a differentiator.

Never state an outcome as a number the firm cannot control. "Reduce defects by
40%" is a proof claim about the future and needs the same evidence as a past
result — which does not exist. State the mechanism instead.

## `## Approach`

300–500 words. How the firm gets there — phases, what happens in each, what the
client sees at the end of each.

Keep it concrete enough to be credible and short enough to stay a proposal rather
than a project plan. Name the method the firm actually uses; a generic
"discover → design → deliver → optimize" diagram signals nothing.

Include who does the work. In a professional service firm the buyer is buying
specific people's judgement, so seniority and involvement are commercial facts,
not staffing details.

## `## Scope`

Deliverables, as a list a client could check off. Each with a form: document,
running system, trained team, recurring report.

## `## Out of scope`

**Mandatory and non-empty.** The validator fails without it.

List the adjacent work a reasonable client would assume is included, and say it is
not. Vague exclusions do not protect anyone.

```markdown
- Application code changes outside the release pipeline.
- Cloud infrastructure cost optimization.
- Migration of the two legacy services scheduled for decommission.
- On-call coverage or production incident response.
- Training beyond the two handover sessions in Scope.
```

Most firms deliver unbilled out-of-scope work every month, and a large share never
bill for any of it. This list is the cheapest control available, and it is easier
to agree now than to argue later.

## `## Assumptions`

**Mandatory and non-empty.** Every dependency on the client that changes the
timeline or price if unmet.

```markdown
- A named technical contact is available for up to 4 hours per week.
- We get repository and CI access in week 1.
- The staging environment mirrors production configuration.
- Security review, if required, starts before week 3.
```

Each assumption is a fact you would otherwise discover mid-engagement, when it is
expensive.

## `## Change control`

**Mandatory and non-empty.** How a change gets priced and approved.

```markdown
Anything outside Scope is a change. We estimate it in writing, you approve in
writing, and we schedule it — no work starts on an unapproved change. Changes are
priced at the day rate in Commercials unless we agree a fixed amount.
```

Agree the mechanism before it is needed. Mid-engagement is the worst possible time
to negotiate how changes work, because the relationship is already under strain.

## `## Proof`

Only from `workspace/firm/proof/{slug}.md` records listed in `proof_refs`.

Respecting the record flags:

```markdown
**Release automation for a logistics platform** (named client, public)
Northwind Logistics cut deployment lead time from six weeks to four days across
nine services. Regression moved from manual to automated on every pull request.

> "We stopped planning releases around holidays."
> — Anna Kowalska, CTO, Northwind Logistics

**A mid-market manufacturer** (anonymized at the client's request)
Same pattern in a regulated environment: 14 services, manual QA gate removed,
release cadence weekly within one quarter.
```

Rules:

1. Every number here must appear in a referenced proof record. The validator
   checks this.
2. A record with `client_public: false` is described, never named.
3. A quote requires `quote_approved: true` on its record.
4. No relevant record? Write what is true — method, comparable public work, team
   background — and set `proof_needed: true`. Say plainly that a directly
   comparable engagement is not being claimed.

## `## Commercials`

One table. Mark the recommended option.

```markdown
| Option | Scope | Investment | Timeline |
|--------|-------|-----------:|----------|
| Pipeline only | Scope items 1–3 | 24,000 EUR | 6 weeks |
| **Pipeline + handover (recommended)** | Scope items 1–5 | 32,000 EUR | 8 weeks |
| Pipeline + handover + 3-month support | All Scope items, plus support retainer | 32,000 EUR + 3,500 EUR/month | 8 weeks + 3 months |

Payment: 40% on start, 40% at week 4, 20% on handover.
Valid until: 2026-08-31.
Day rate for approved changes: 900 EUR.
```

Two or three options let the buyer choose *how much*, not *whether*. A single price
turns the decision binary.

`price_model` in frontmatter must match `service_type` in the service file:

| `service_type` | Expected `price_model` |
|----------------|------------------------|
| `project`, `package` | `project` or `fixed` |
| `retainer`, `subscription`, `support` | `retainer` |
| `consulting`, `training` | `project`, `day_rate`, or `retainer` |

A mismatch means the service definition or the proposal is wrong. Resolve which
before sending.

## `## Next step`

One action, dated, small.

```markdown
A 30-minute call on or before 5 August to confirm scope and start date. If the
pipeline-only option is enough, reply and we send the agreement this week.
```

Not "let us know your thoughts" — that puts the work of deciding what happens next
on the buyer.

## Frontmatter checklist

Required: `opportunity`, `account`, `service`, `icp`, `persona`, `price_model`,
`currency`, `proof_refs`, `proof_needed`, `status`, `generated_at`.

`status`: `draft` → `sent` → handled by `sales-outcome-log`, or `withdrawn`.
