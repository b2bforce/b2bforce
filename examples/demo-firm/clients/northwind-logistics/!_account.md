---
fixture: true
client: northwind-logistics
services: [platform-migration]
engagement_type: mixed
start_date: 2025-10-06
renewal_date: 2026-11-26
mrr_band: 2-5k
health: green
health_reason: Release pipeline stable for two quarters and the cutover is on schedule at the day 30 checkpoint.
contacts:
  - { name: "Anna Kowalska", role: "CTO", type: economic_buyer }
  - { name: "Piotr Lis", role: "Head of Platform", type: user }
  - { name: "Marek Wolny", role: "CFO", type: gatekeeper }
referenceable: true
status: active
reviewed_at: 2026-07-15
last_contact: 2026-07-20
---

# Northwind Logistics

## What we do for them

Two things run in parallel. A support retainer keeps the release pipeline we built
between October 2025 and February 2026 maintained, and a fixed-scope project is
delivering the warehouse integration cutover before their new provider goes live in
October. `engagement_type: mixed` is what that combination is called here.

## What the relationship depends on

Piotr's team operating the pipeline without us. The retainer is small on purpose: if
it grew, it would mean the handover did not work. Anna judges us on whether her senior
engineers are on the roadmap, not on our activity level.

## Open risks

- The new warehouse provider's test environment is the one dependency we do not
  control, and the October date is contractual for Northwind.
- The person who performs the morning reconciliation is on parental leave from
  mid-September. Knowledge transfer has to complete before then, which is earlier
  than the cutover itself.
- Marek (CFO) has never been in a conversation with us. Anything above her signing
  limit would go through someone we have not met.

## Why there is no money here

Contract values, margin, and hours are deliberately absent. `mrr_band` is a band. The
engagement value lives in `sales/opportunities/.../outcome.md`, where a leak is
cheaper — see the Client Context Gate in `AGENTS.md`.
