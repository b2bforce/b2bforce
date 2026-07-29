---
fixture: true
client: northwind-logistics
service: platform-migration
source_opportunity: northwind-logistics--platform-migration--2026-05
started: 2026-06-08
success_definition: "Stock and orders sync with the new provider and nobody reconciles anything by hand in the morning."
success_definition_source: client
day_14: 2026-06-22
day_30: 2026-07-08
day_90: 2026-09-06
status: active
---

# Onboarding — warehouse cutover

The account itself started in October 2025 with the release automation project. This
plan covers the cutover engagement won on 15 June.

## Success definition

> "Stock and orders sync with the new provider and nobody reconciles anything by hand
> in the morning."

Anna Kowalska, kickoff call, 8 June. Her words, confirmed out loud against the
proposal's `## Outcomes` section, which is why `success_definition_source` is
`client` rather than `firm_hypothesis`.

Note what it does not contain: a mismatch rate. The proposal deliberately did not
promise one, and the success definition was not quietly written to be easier than the
thing we sold.

## Stakeholders

| Name | Role | Type | What they judge success by | Met |
|------|------|------|----------------------------|-----|
| Anna Kowalska | CTO | economic_buyer | No manual reconciliation, October date held | yes |
| Piotr Lis | Head of Platform | user | His team can change the integration without us | yes |
| Ewa Zielińska | Operations lead | user | Dispatch trusts the stock numbers on day one | yes |
| Marek Wolny | CFO | gatekeeper | Not involved at this size | **no** |

Ewa was not named in the proposal and was added at kickoff. She performs the
reconciliation today, so the knowledge transfer is with her, and she is the one going
on leave in September.

## What we promised

From the proposal's `## Outcomes` and `## Scope`: provider contract documented,
reconciliation rules written down, integration behind a configuration switch,
contract tests on every pull request, parallel-run comparison, mismatch alerting,
one rehearsal plus the cutover, two handover sessions and a runbook.

Restated from `## Out of scope`, because Ewa's team has not read the proposal: no
warehouse process design at the new provider, no master data cleanup, no reporting or
BI changes, and the dispatch board rewrite is not in this engagement.

## Kickoff agenda

Confirm the success definition in Anna's words. Confirm provider test credentials and
who owns that relationship. Agree that Ewa's two sessions happen before 10 September.
Name the escalation path: Piotr first, Anna if a date is at risk. Agree the checkpoint
dates below.

## Checkpoints

| Checkpoint | Date | What must be true |
|------------|------|-------------------|
| Day 14 | 2026-06-22 | Provider contract documented against a real test environment; Anna knows what we found and it matches what she bought |
| Day 30 | 2026-07-08 | Reconciliation rules written and reviewed by Ewa; integration running in parallel on at least one order type |
| Day 90 | 2026-09-06 | Rehearsal complete, handover sessions done before Ewa's leave, runbook in their repository |

Day 14 is not about output. It is whether Anna can describe what is happening in her
own words and recognise it as the engagement she signed.

## Risks

- Provider test environment is an assumption from the proposal, not a fact we control.
- Ewa's leave date moves the real handover deadline a month before the cutover.
- Marek has never met us, and he signs above Anna's limit.

## Not yet known

Whether the provider's data matches their documentation. Everything after Phase 2
depends on the answer, and the parallel-run comparison exists to find it early.
