---
fixture: true
area: retainer-attribution
outcome: Qualified retainer enquiries attributed to cross-brand QBR asks
owner: rhea-alcott
brand: ledgerline
service: reporting-retainer
icp: mid-market-distribution-finance
fast_cadence: weekly
outcome_cadence: quarterly
timezone: Europe/Warsaw
metric_pack: content
created: 2026-07-28
updated: 2026-08-04
---

# PDCA — retainer attribution (Ledgerline)

A brand-scoped area: `brand: ledgerline` in the frontmatter, one outcome
measured for one brand — never a clone of the same area per brand, and never a
number aggregated across brands (Brand Scope Gate in `AGENTS.md`). The `owner`
is a slug from `firm/people/`, which is what the people registry is for.

## Outcome

Ledgerline's pipeline should come from the group's existing client base — the
cross-brand ask in QBRs — before it comes from outbound. This area measures
whether that is actually happening.

## Metrics

| Metric | Unit | Direction | Role | Source | Quality |
|--------|------|-----------|------|--------|---------|
| Retainer enquiries from QBR asks | count | higher_is_better | outcome | waiting | waiting |
| Accounts with a cross-brand hypothesis in their account plan | count | higher_is_better | leading | `clients/*/account-plan.md` | high |
| QBRs held that included the sibling-brand ask | count | higher_is_better | output | `clients/*/qbr/` | high |

## Baseline

| Metric | Value | Date range | Source | Quality |
|--------|-------|------------|--------|---------|
| Retainer enquiries from QBR asks | — | — | waiting | waiting |
| Accounts with a cross-brand hypothesis | 0 | as of 2026-07-28 | account plans | high |
| QBRs with the sibling-brand ask | 0 | 2026-Q2 | QBR files | high |

The outcome baseline is empty on purpose: nobody records where a retainer
enquiry came from yet, so the first cycles are limited to leading and output
claims.

## Autonomy boundaries

**Allowed without asking:** read the workspace, update files under
`pdca/retainer-attribution/`, draft account-plan hypotheses for review.

**Requires approval:** contacting a client, changing a QBR agenda, anything
public.

## Open data requests

| What is missing | Who must provide it | By when |
|-----------------|--------------------|---------|
| A source field on retainer enquiries, filled at first contact | rhea-alcott | 2026-09-30 |
