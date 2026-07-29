---
fixture: true
name: Mid-market EU logistics and freight operators
industry: Logistics, freight forwarding, third-party warehousing
company_size: 200-800 employees, 8-40 in-house engineers
buying_mode: reactive
service: platform-migration
---

# ICP — Mid-market EU logistics operators

## Segment

EU freight and logistics operators running a platform they built themselves, usually
over eight to fifteen years. Dispatch, rating, and invoicing are in the same system.
Engineering reports to a CTO or Head of Platform who is also responsible for uptime.

## Why they buy

`buying_mode: reactive`. They move when the release process has already cost them
something visible: a defect that reached invoicing, a roadmap commitment missed two
quarters running, or the resignation of one of the two people who can run a release.
Messaging that leads with strategic upside does not land here. Messaging that names
the weekend and the two-person dependency does.

## Pain points

| Pain | Consequence | Current workaround |
|------|-------------|--------------------|
| Monthly release needs a manual regression pass | Two senior engineers lose a weekend a month; roadmap slips | Release calendar planned around public holidays |
| Rating and invoicing defects reach production | Manual invoice corrections, credibility damage with shippers | A second manual review pass, which adds more hours |
| Release knowledge held by two people | Cannot take leave during a release week; recruitment risk | Informal "do not both be away" rule |
| No rollback path | Incidents are resolved by fixing forward under pressure | A senior engineer stays online after every deploy |

## Trigger events

- A defect reaches invoicing or dispatch and is discussed above the CTO.
- One of the two release engineers resigns or is visibly being recruited.
- A large shipper makes an uptime or delivery commitment part of a renewal.
- A peak season is approaching and the release freeze is being planned early.

## Buying committee

CTO or Head of Platform decides and usually holds the budget. The finance director
signs above a threshold. The engineers who run releases today are the users and can
quietly block a change they were not consulted on.

## Objections

- "We could do this ourselves in a quieter quarter." They have said this for two
  quarters, and the quiet quarter does not arrive.
- "Our platform is unusual." The dispatch domain is; the release process is not.
- "We tried a consultancy and got a document." Reasonable, and the reason two
  releases are run together rather than handed over.

## Anti-fit signals

No in-house engineering team, a platform rewrite planned in the same quarter, or a
buyer who wants seats filled rather than a process changed.

## Notes

Segment written from the firm profile and delivered engagements. No external market
research was run for this demo file.
