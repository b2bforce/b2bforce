---
fixture: true
name: Mid-market EU distribution companies
industry: Wholesale and distribution
company_size: 100-500 employees, in-house team of 4-15
buying_mode: reactive
service: erp-integration
---

# ICP — Mid-market EU distributors (Bramblegate)

## Segment

EU distributors running an ERP in production next to a warehouse system and a
webshop that each keep their own stock number. The operations side reports to a
COO who is personally in the reconciliation loop.

## Why they buy

`buying_mode: reactive`. They move after the mismatch has cost something
visible: a stockout on a top product that the ERP said was available, or a month
close that slipped past the board meeting.

## Pain points

| Pain | Consequence | Current workaround |
|------|-------------|--------------------|
| Three systems, three stock numbers | Ordering by phone call, not by system | Weekly spreadsheet reconciliation |
| Invoicing waits on reconciliation | Order-to-invoice lag measured in days | Overtime at month end |
| Mappings changed by one person | Every integration change is a risk | "Do not touch it in Q4" rule |

## Trigger events

- A stockout or double-sell reaches a key customer.
- The month close misses the board pack deadline.
- The person who owns the mappings resigns.

## Objections

- "Our ERP partner says they can do this." They can — at their pace, on their
  backlog, in their contract.
- "We are replacing the ERP anyway." Then this is anti-fit, and we say so.

## Anti-fit signals

ERP migration planned within the year; no in-house owner for the mappings.

## Notes

Written from the firm profile and delivered engagements; no external research
was run for this demo file.
