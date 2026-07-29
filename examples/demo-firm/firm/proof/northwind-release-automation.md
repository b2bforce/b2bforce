---
fixture: true
client: northwind-logistics
client_public: true
quote_approved: true
usable_publicly: true
service: platform-migration
icp: mid-market-logistics
engagement_type: project
period: 2025-10..2026-02
metrics:
  - { label: "Deployment lead time", before: "6 weeks", after: "4 days", verified: true }
  - { label: "Services with automated regression", before: "0 of 9", after: "9 of 9", verified: true }
  - { label: "Weekend release windows per quarter", before: "3", after: "0", verified: true }
reference_call_ok: true
source_opportunity:
created: 2026-03-02
updated: 2026-07-08
---

# Release automation for the Northwind freight platform

This record was created in `backfill` mode: the engagement predates this repo, so
there is no opportunity folder behind it.

## Situation

Northwind shipped its freight platform once a month over a weekend. Two engineers
ran a manual regression pass across 9 services on Friday, the team fixed what the
pass found on Saturday, and the deploy happened Sunday evening to keep Monday's
dispatch load clear.

## What we did

Baseline of the current process with timings, automated regression for the rating,
invoicing, and dispatch services first, then the remaining six. Deploy pipeline with
staged rollout and one-command rollback. Two supervised releases run with their
team, then the manual weekend pass was formally retired.

## What changed

Deployment lead time went from 6 weeks to 4 days. All 9 services run regression on
every pull request. The weekend release window has not been used since February.

All three metrics above were confirmed by Anna Kowalska in the 2026-Q2 review, from
Northwind's own CI and deployment records.

## Approved quote

> "We stopped planning releases around public holidays."
> — Anna Kowalska, CTO, Northwind Logistics

## Permissions

Northwind agreed to be named and quoted in public material, and to take reference
calls. That is three separate permissions and all three are recorded above.
