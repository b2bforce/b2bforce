---
fixture: true
services: all
icp: mid-market-distribution-finance
owner: rhea-alcott
status: active
reviewed_at: 2026-08-10
---

# Positioning — Ledgerline

Brand-wide record. It replaces the one-line `positioning:` that `!_brand.md`
carried before: two sources of the same statement drift.

## Statement

> For CFOs at mid-market distributors whose management pack arrives on working
> day twelve and who today would hire a financial analyst to build it by hand, we
> are a monthly finance-reporting retainer that starts from operational data
> already integrated and checked, as shown by the stock reconciliation our
> sibling brand Bramblegate delivered for Harrowmere Distribution.

## Parts

| Part | Value | Source |
|------|-------|--------|
| For whom | CFOs at mid-market distributors | — |
| Situation | The pack lands on working day twelve and disagrees with operations' numbers | discovery: harrowmere-distribution--reporting-retainer--2026-06 |
| Alternative | Hiring a financial analyst | outcome: harrowmere-distribution--reporting-retainer--2026-06 |
| Difference 1 | Starts from stock and invoicing data that is already integrated and reconciled, instead of a new hire learning the exports | — |
| Proof 1 | Bramblegate's Harrowmere integration: manual reconciliation from 34 to 4 hours a month, attributed to Bramblegate | proof: bramblegate/harrowmere-erp-cutover |

## Alternatives

- Internal hire (a financial analyst) — 1 opportunity:
  harrowmere-distribution--reporting-retainer--2026-06 (`competitor: internal-hire`)
- The finance team keeps building the pack by hand — discovery:
  harrowmere-distribution--reporting-retainer--2026-06

## Dropped differences

- Monthly exit — "stop paying whenever the pack stops earning it" — proof_needed:
  a contract term, not a delivered result; it belongs in the proposal, not here

Proof 1 is a cross-brand citation: `cross_brand: true` on the record, and the
statement names Bramblegate as the brand that delivered it. The record has
`usable_publicly: false`, so this statement is internal — a public headline
cannot lean on the Harrowmere numbers.
