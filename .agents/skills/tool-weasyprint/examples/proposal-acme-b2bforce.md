---
title: Release automation for the Meridian platform
subtitle: Moving from monthly release weekends to a weekly, unattended pipeline
firm: ACME B2BFORCE
client: Meridian Freight Systems
date: 25 July 2026
valid_until: 31 August 2026
reference: ACME-2026-0142
footer: Commercial proposal — confidential
opportunity: meridian-freight--platform-migration--2026-07
account: meridian-freight
service: platform-migration
icp: mid-market-logistics
persona: cto-mid-market
price_model: project
currency: EUR
proof_refs:
  - northwind-release-automation
  - anonymized-manufacturer-migration
proof_needed: false
status: draft
generated_at: 2026-07-25
sent:
---

## Situation

Meridian ships the freight platform once a month, and every release costs a
weekend. Two engineers run a manual regression pass across 14 services on Friday,
the team fixes what the pass finds on Saturday, and the deploy happens Sunday
evening so that Monday's dispatch load is unaffected.

In our two conversations in July, Tomasz described the cost this way:

> "We plan releases around public holidays. My best two engineers spend one
> weekend a month on regression instead of the customer portal, and we still
> shipped a rating bug to production in May."

Three consequences you named, in your order of priority:

- The customer portal rebuild has slipped two quarters, and it is the commitment
  your largest shipper renewed on.
- The May rating defect reached production and took nine engineering days to
  unwind, including manual invoice corrections.
- Both engineers who know the release process have been approached by
  competitors this year. The process depends on them personally.

You are not looking for a testing tool. You are looking to stop the release
process from consuming your senior capacity and to remove the single point of
failure it has become.

## Outcomes

When this engagement ends, these should be true:

- Releases ship on a fixed weekly slot, on a weekday, with no scheduled overtime.
- The regression suite runs automatically on every pull request and completes in
  under 30 minutes.
- A rating or invoicing defect cannot reach production without failing a check
  first.
- Any engineer on your team can run, read, and change the pipeline. The two who
  hold the process today stop being the constraint.

We are deliberately not promising a defect-rate percentage. Defect rates depend on
how your team writes code after we leave, and a number we cannot control is not an
outcome we should sell you. What we can commit to is the mechanism: the checks that
must pass, running automatically, on every change.

## Approach

Four phases across eight weeks. Each ends with something you can inspect.

### Phase 1 — Baseline and risk map (week 1)

We instrument the current process before changing it: how long each regression
step actually takes, which of the 14 services fail most often, and which manual
steps carry the real risk. You get a written baseline, which is also how we both
judge the result later.

We expect to find that a minority of services account for most of the regression
time. That shapes the order of everything after this.

### Phase 2 — Automated regression on the critical path (weeks 2–4)

We automate the regression pass for the services that carry rating, invoicing, and
dispatch logic first — the three areas where a defect has commercial consequences.
Each service gets its suite wired into your existing GitHub Actions setup, running
on every pull request.

By the end of week 4, the Friday manual pass covers materially less ground, and
the highest-risk paths are covered by checks that cannot be skipped.

### Phase 3 — Pipeline and release mechanics (weeks 5–6)

We build the deploy pipeline: staged rollout, health checks, and an automated
rollback path that a single engineer can trigger without a runbook. We then run
two releases *with* your team, on the weekly slot, while the manual process is
still available as a fallback.

Running two releases together rather than handing over a document is the part that
usually decides whether this holds after we leave.

### Phase 4 — Handover and retirement of the manual process (weeks 7–8)

Two working sessions with your engineers, the runbook written in your repository
rather than ours, and a documented decision to retire the manual weekend pass.

**Who does the work.** Marta Nowak (principal, 11 years in platform delivery)
leads and is on the engagement four days a week throughout. Piotr Lis (senior
engineer) works alongside your team on the suites. There is no junior staffing
behind a senior name on this engagement, and no handoff to a different team after
signature.

## Scope

1. Written baseline of the current release process, with timings and a risk map.
2. Automated regression suites for the rating, invoicing, and dispatch services.
3. Regression running on every pull request in your existing GitHub Actions setup.
4. Deploy pipeline with staged rollout, health checks, and one-command rollback.
5. Two supervised production releases on the weekly slot.
6. Runbook committed to your repository.
7. Two handover sessions, recorded, with your engineers.

## Out of scope

The following are not included, and would each be a separate conversation:

- Application code changes beyond what is needed to make a service testable.
- Automated test coverage for the 11 services outside the critical path.
- Cloud infrastructure cost optimization or migration between providers.
- The two legacy services you plan to decommission in Q4.
- On-call rotation design, alerting policy, or production incident response.
- Performance or load testing.
- Training beyond the two handover sessions in Scope.

## Assumptions

If any of these does not hold, timeline and price change, and we will say so before
continuing rather than absorbing it quietly:

- A named technical contact is available up to four hours per week.
- We receive repository, CI, and staging access in week 1.
- Staging mirrors production configuration for the three critical services.
- Your team can merge our pull requests within two working days.
- The eight-week window does not overlap your December freight peak.

## Change control

Anything outside Scope is a change. We estimate it in writing, you approve it in
writing, and we schedule it — no work starts on an unapproved change, and nothing
outside Scope appears on an invoice you have not seen first.

Changes are priced at the day rate below unless we agree a fixed amount. If a
change would push the end date, we tell you that when we estimate it, not
afterwards.

## Proof

**Release automation for a logistics platform** — Northwind Logistics

Deployment lead time went from six weeks to four days across nine services.
Regression moved from a manual pass to automated checks on every pull request, and
the weekend release window was retired in the first quarter after handover.

> "We stopped planning releases around holidays."
> — Anna Kowalska, CTO, Northwind Logistics

**A mid-market manufacturer** — named on request, anonymized here

The same pattern in a regulated environment where a manual QA sign-off was a
compliance requirement rather than a habit. Fourteen services, manual gate
replaced by an auditable automated one, weekly cadence reached within one quarter.
This is the closer comparison to your rating and invoicing constraints.

Both engagements were run by Marta, and Anna has agreed to take a reference call
if that would help.

## Commercials

| Option | What it covers | Investment | Timeline |
|--------|----------------|-----------:|----------|
| Critical path only | Scope items 1–3 | 26,000 EUR | 5 weeks |
| **Full engagement (recommended)** | Scope items 1–7 | 38,000 EUR | 8 weeks |
| Full engagement + 3-month support | All Scope items, plus support retainer | 38,000 EUR + 4,200 EUR/month | 8 weeks + 3 months |

We recommend the full engagement. The critical-path option removes most of the
regression time but leaves the deploy and rollback mechanics manual, which means
the weekend process cannot actually be retired and the dependency on your two
engineers stays where it is.

- **Payment:** 40% on start, 40% at the end of week 4, 20% on handover.
- **Day rate for approved changes:** 950 EUR.
- **Valid until:** 31 August 2026. After that we would need to re-check capacity.

Marta is available from 17 August. Holding that start date past the validity above
is not something we can promise.

## Next step

A 30-minute call before 5 August with Tomasz and whoever signs, to confirm scope
and the start date. If the full engagement is right, reply to this document and we
will send the agreement this week.

If a reference call with Anna at Northwind would be more useful first, say so and
we will arrange it before the call.
