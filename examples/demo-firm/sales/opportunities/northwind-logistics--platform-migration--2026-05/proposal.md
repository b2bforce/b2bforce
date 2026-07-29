---
fixture: true
title: Warehouse integration cutover
subtitle: Bringing the warehouse integration into the pipeline your team already runs
firm: Ferrymark Systems
client: Northwind Logistics
opportunity: northwind-logistics--platform-migration--2026-05
account: northwind-logistics
service: platform-migration
icp: mid-market-logistics
persona: cto-mid-market-logistics
price_model: project
currency: EUR
proof_refs:
  - northwind-release-automation
proof_needed: false
status: sent
generated_at: 2026-05-20
sent: 2026-05-20
---

## Situation

The new warehouse provider goes live in October, and the integration you have today
cannot go with it. Stock and order movements arrive as a nightly file drop, and a
single person reconciles them by hand every morning before dispatch trusts the
numbers.

Anna put the constraint this way on 18 May:

> "The new warehouse provider goes live in October whether we are ready or not. The
> integration we have is a nightly file drop with a manual reconciliation step, and
> the person who reconciles it is going on parental leave in September."

So there are two dates, not one. The provider switch is October, and the knowledge
transfer has to be finished before mid-September. The second date is the tighter of
the two and it is the one that shapes this plan.

## Outcomes

When this engagement ends, these should be true:

- Stock and order movements sync with the new provider through the same pipeline your
  team already runs, deployed on the same weekly slot as everything else.
- The morning reconciliation step no longer exists as a manual activity. Mismatches
  surface as alerts with a documented resolution path.
- Both integrations can run in parallel until the legacy contract ends, and switching
  between them is a configuration change rather than a deployment.
- Piotr's team can operate and change the integration without anyone who left the
  company or went on leave.

We are not promising a mismatch rate. That depends on the data the new provider
sends, which neither of us controls yet. What we commit to is that a mismatch becomes
visible automatically instead of being found by a person reading a file.

## Approach

Three phases across seven weeks, each ending with something you can inspect.

**Phase 1 — Provider contract and reconciliation rules (weeks 1–2).** We document
what the new provider's API actually returns against a test environment, and we write
down the reconciliation rules that currently live in one person's head. That document
is the deliverable, and it is also the knowledge transfer.

**Phase 2 — Integration in the pipeline (weeks 3–5).** The new integration is built
behind a configuration switch, with contract tests that run on every pull request in
your existing setup. Both integrations run in parallel against the same orders so
differences are observable before the cutover, not during it.

**Phase 3 — Rehearsal and cutover (weeks 6–7).** A full rehearsal against the test
environment, then the cutover with the legacy path still available. Two handover
sessions with Piotr's team, and the runbook committed to your repository.

Marta Nowak leads and is on the engagement four days a week throughout, as she was
on the release work. No junior staffing behind a senior name, and no handoff to a
different team after signature.

## Scope

1. Documented provider contract, written against their test environment.
2. Written reconciliation rules, reviewed by the person who performs them today.
3. New warehouse integration behind a configuration switch.
4. Contract tests running on every pull request in your existing CI.
5. Parallel-run mode with a comparison report between the two integrations.
6. Alerting for mismatches, with a documented resolution path per alert type.
7. One full cutover rehearsal and the cutover itself.
8. Two recorded handover sessions and a runbook in your repository.

## Out of scope

Each of these would be a separate conversation:

- Changes to the legacy provider integration beyond keeping it runnable in parallel.
- Warehouse process or physical operations design at the new provider.
- Master data cleanup in the product or location catalogues.
- Reporting and BI changes downstream of stock movements.
- The dispatch board rewrite discussed in the 2026-Q2 review.
- Provider contract negotiation or SLA definition.

## Assumptions

If any of these does not hold, the timeline and the price change, and we will say so
before continuing rather than absorbing it quietly:

- The new provider's API is available in a test environment by the end of week 1,
  with credentials issued to us.
- Northwind owns the provider relationship and can get a technical answer within two
  working days.
- The person who performs reconciliation today is available for two sessions before
  mid-September.
- Piotr's team can review our pull requests within two working days.
- The legacy integration stays read-only after cutover. If it must keep writing, that
  is a scope change and we would re-estimate.

## Change control

Anything outside Scope is a change. We estimate it in writing, you approve it in
writing, and then we schedule it. No work starts on an unapproved change, and nothing
outside Scope appears on an invoice you have not seen first.

Changes are priced at the day rate below unless we agree a fixed amount. If a change
would move the cutover date, we say that when we estimate it, not afterwards.

## Proof

**Release automation for the Northwind freight platform** — your own engagement, for
the record rather than as a reference.

Deployment lead time went from 6 weeks to 4 days, and all 9 services in the release
now run regression on every pull request. The weekend release window has not been
used since February. Anna confirmed those figures in the 2026-Q2 review.

> "We stopped planning releases around public holidays."
> — Anna Kowalska, CTO, Northwind Logistics

The reason this matters here is mechanical, not sentimental: the integration in this
proposal deploys on the pipeline that work produced, and Piotr's team has been
operating it for two quarters. That is why this is a seven-week engagement rather
than a twelve-week one.

## Commercials

| Option | What it covers | Investment | Timeline |
|--------|----------------|-----------:|----------|
| Cutover only | Scope items 1–4, 7, 8 | 26,000 EUR | 5 weeks |
| **Full engagement (recommended)** | Scope items 1–8 | 34,000 EUR | 7 weeks |

We recommend the full engagement. The cutover-only option drops the parallel-run
comparison and the mismatch alerting, which are the two things that make an October
date recoverable if the provider's data differs from their documentation. Without
them the cutover becomes a single event you cannot rehearse honestly.

- **Payment:** 40% on start, 40% at the end of week 4, 20% on handover.
- **Day rate for approved changes:** 950 EUR.
- **Valid until:** 20 June 2026, after which we would need to re-check capacity.

Marta is available from 8 June. Holding that start date past the validity above is
not something we can promise, and the September constraint does not leave much room
behind it.

## Next step

A 30-minute call before 27 May with Anna and Piotr to confirm the parallel-running
question in Assumptions, which is the one open item that changes scope. If the full
engagement is right, reply to this document and we will send the schedule against the
existing master agreement.
