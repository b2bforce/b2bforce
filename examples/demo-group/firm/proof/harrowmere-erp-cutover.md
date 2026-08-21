---
fixture: true
client: harrowmere-distribution
client_public: true
quote_approved: true
usable_publicly: false
brand: bramblegate
cross_brand: true
service: erp-integration
icp: mid-market-distributors
engagement_type: project
period: 2026-01..2026-04
metrics:
  - { label: "Manual stock reconciliation", before: "34 hours a month", after: "4 hours a month", verified: true }
  - { label: "Order-to-invoice lag", before: "6 days", after: "2 days", verified: true }
reference_call_ok: true
source_opportunity:
created: 2026-05-04
updated: 2026-07-30
---

# Stock reconciliation for Harrowmere Distribution

Created in `backfill` mode; the engagement predates the group's workspace.

## Situation

Harrowmere's warehouse system, webshop, and ERP each held a different stock
number. Two people spent most of a week each month reconciling them, and
invoicing waited on the result.

## What we did

Baseline of the mismatches, integration of stock and invoicing flows under
Harrowmere's CI, exception alerting, runbook and two handover sessions with
their team.

## What changed

Manual stock reconciliation went from 34 hours a month to 4, and order-to-invoice
lag from 6 days to 2. Confirmed by Nils Fairweather in the April close review,
from Harrowmere's own time logs and invoicing records.

## Approved quote

> "Ordering stopped being an argument about whose number is right."
> — Nils Fairweather, COO, Harrowmere Distribution

## Permissions

Harrowmere agreed to be named and quoted, and to reference calls — but **not** to
public material: `usable_publicly` is `false`, so this record can support a
proposal and never a case study. `cross_brand: true` records their explicit
agreement that the group's other brand may cite this result with attribution —
the multi-brand rule this demo exists to show.
