---
fixture: true
area: content-to-pipeline
outcome: More qualified cutover and release-automation enquiries from published content
owner: founder
service: platform-migration
icp: mid-market-logistics
fast_cadence: weekly
outcome_cadence: quarterly
timezone: Europe/Warsaw
metric_pack: content
created: 2026-06-29
updated: 2026-07-20
---

# PDCA — content to pipeline

## Outcome

Buyers in mid-market logistics arrive at the first call already knowing what we do
about release processes, instead of us explaining it from scratch.

## Metrics

| Metric | Unit | Direction | Role | Source | Quality |
|--------|------|-----------|------|--------|---------|
| Qualified enquiries attributed to content | count | higher_is_better | outcome | waiting | waiting |
| Drafts passing the validator on first run | % | higher_is_better | leading | `scripts/validate-content-draft.sh` exit codes | high |
| Buyer questions covered by a published draft | count | higher_is_better | leading | `marketing/content/ideas/` frontmatter | high |
| Drafts published vs planned | count | higher_is_better | output | Content backlog | high |

Four metrics, one of them `waiting`. That is the honest state of this area: three can
be counted from files in this repo, and the one that actually matters commercially
cannot be counted yet.

## Baseline

| Metric | Value | Date range | Source | Quality |
|--------|-------|------------|--------|---------|
| Qualified enquiries attributed to content | — | — | waiting | waiting |
| Drafts passing the validator on first run | 50% | 2026-06-01..2026-06-28 | Validator exit codes | high |
| Buyer questions covered by a published draft | 1 | as of 2026-06-28 | Idea frontmatter | high |
| Drafts published vs planned | 1 of 3 | 2026-06 | Content backlog | high |

The outcome baseline is empty on purpose. Nobody records where an enquiry came from
today, so any number here would be invented, and the cycle below cannot claim outcome
movement because of it.

## Autonomy boundaries

**Allowed without asking:** read the workspace, create and update files under
`pdca/content-to-pipeline/`, draft content ideas, write drafts, run the validators,
propose the next cycle.

**Requires approval:** publishing anything to the website or LinkedIn, contacting a
client or prospect, spending money on tools or ads, changing analytics or tracking.

## Open data requests

| What is missing | Who must provide it | By when |
|-----------------|--------------------|---------|
| A first-touch field on enquiries, filled at the first call, so content attribution stops being guesswork | founder | 2026-08-31 |

Until that exists, the outcome metric stays `waiting` and every cycle in this area is
limited to leading and output claims.
