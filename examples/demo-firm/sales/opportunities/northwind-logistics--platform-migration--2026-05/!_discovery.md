---
fixture: true
account: northwind-logistics
account_public: true
service: platform-migration
icp: mid-market-logistics
persona: cto-mid-market-logistics
source: existing_client
opened: 2026-05-11
updated: 2026-05-18
budget_signal: stated
timeline_signal: dated
decision_process: mapped
competitors_known: []
bid_decision: bid
brief_quality: strong
---

# Discovery — Northwind warehouse cutover

## Situation

Northwind Logistics is an existing client. We automated their release process
between October 2025 and February 2026, and they now run weekly releases on the
pipeline their team owns. Anna Kowalska (CTO) raised the next problem in the 2026-Q2
review: the warehouse management integration is still the one part of the platform
that cannot be deployed with everything else, and it blocks the cutover to their new
warehouse provider in October.

Two calls, 11 and 18 May, with Anna and Piotr Lis (Head of Platform).

## Problem in the buyer's words

> "The new warehouse provider goes live in October whether we are ready or not. The
> integration we have is a nightly file drop with a manual reconciliation step, and
> the person who reconciles it is going on parental leave in September."

## Impact

Stated by the buyer, not estimated by us:

- The October provider switch is contractual. Missing it means running two warehouse
  contracts in parallel, which Anna described as "the expensive outcome".
- Reconciliation takes one person around three hours every morning. They have not
  quantified the error rate, only that "we find something most weeks".
- The reconciliation knowledge sits with one person who is away from September.

## Desired outcome

Order and stock movements sync with the new provider through the same pipeline as
everything else, with no morning reconciliation step and nobody who has to personally
remember how it works.

## Decision process

| Role | Name | Part in the decision |
|------|------|----------------------|
| Economic buyer | Anna Kowalska (CTO) | Holds the budget line for platform work, signs to 50k EUR |
| Champion | Anna Kowalska | Raised it, wants it closed before September |
| User | Piotr Lis (Head of Platform) | His team runs it afterwards; blocked a similar change in 2025 |
| Finance | Marek Wolny (CFO) | Signs above 50k EUR, not needed at the expected size |

No procurement process for repeat work under the existing master agreement, which
Anna confirmed on the second call.

## Constraints

- Hard date: new provider live in October, cutover rehearsal needed in September.
- The reconciliation owner is on leave from mid-September, so knowledge transfer has
  to happen before that, not during the cutover.
- The legacy provider contract runs to the end of the year, so both integrations must
  work in parallel for a period.
- No incumbent vendor competing. This is a repeat engagement.

## Firm assessment

Maps to `platform-migration`, high confidence. Fit criteria met: in-house team of 22
engineers, existing CI they now own, named technical contact available, and the
business problem is stated with a date attached.

Anti-fit criteria triggered: **none**, with one qualification worth stating plainly.
The scope depends on the new provider's API being documented and available in a test
environment. If it is not, this becomes an integration discovery engagement rather
than a cutover, and the October date is not ours to save. Anna understands this; it
is written into the assumptions of the proposal rather than absorbed quietly.

What would make this a good engagement: we already know their pipeline, and Piotr's
team has run releases on it for two quarters. What would make it painful: a provider
whose test environment is not ready, combined with a fixed external date.

## Open questions

1. Is the new provider's API available in a test environment today, and who at
   Northwind owns that relationship? — Decides whether the October date is realistic.
2. Does the parallel-running period need both integrations writing, or is the legacy
   one read-only after cutover? — Changes scope materially.
3. Who takes over reconciliation knowledge before mid-September? — Determines whether
   handover has to complete a month earlier than the cutover.

## Next action

Ferrymark sends the proposal by 20 May, covering the cutover with the provider test
environment as a stated assumption. Owner: Marta Nowak.
