---
fixture: true
label: ERP integration for distribution platforms
service_type: project
source_url: https://example.com/bramblegate/erp-integration
target_icps: [mid-market-distributors]
---

# ERP integration for distribution platforms

## Main problem

A distributor whose warehouse system, webshop, and ERP disagree about stock. The
month closes late, the COO reconciles by spreadsheet, and nobody orders against
the numbers without calling the warehouse first.

## Job to be done

Make the ERP the single trusted source for stock and order state, with the
integrations owned by the client's own team afterwards.

## Expected outcomes

- Stock and order state consistent across systems, checked automatically.
- Manual reconciliation reduced to reviewing flagged exceptions.
- The client's team can change a mapping without calling us.

We do not promise a data-quality percentage: it depends on the client's master
data, which we do not control.

## Process

1. Baseline the current mismatches before changing anything.
2. Integrate the commercially critical flows first — stock, then invoicing.
3. Exception alerting with a documented resolution path per type.
4. Handover: runbook in the client's repository, two working sessions.

## Deliverables

Documented integration contract, mapping layer under the client's CI, exception
alerting, runbook, two recorded handover sessions.

## Fit criteria

- 100–500 employees, an in-house team of at least 4 who will own the mappings.
- An ERP already in production — we integrate, we do not select or install.
- A named operations contact with two hours a week available.

## Anti-fit criteria

- An ERP migration planned in the same year.
- Nobody in-house to hand the mappings to.
- The buyer wants a data-entry service rather than an integration.

## Proof points

- `harrowmere-erp-cutover` — stock reconciliation for a mid-market distributor.

Cite by slug. The numbers live in the proof record, not here.
