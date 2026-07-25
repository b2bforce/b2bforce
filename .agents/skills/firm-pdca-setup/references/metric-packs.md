# Metric Packs

Ready metric sets for a professional service firm, bound to workspace entities
this repo already produces. Pick a pack, then delete every metric whose source of
truth does not exist yet.

A generic PDCA loop fits any business. These packs are what make the loop specific
to a firm that sells expertise through projects and retainers.

## Reading the tables

- **Direction** — `higher_is_better` or `lower_is_better`. Decides the status icon.
- **Role** — `outcome` (the business result), `leading` (predicts it), `output`
  (work produced). An output metric may never be the reason a cycle is a success.
- **Source** — where the number comes from. If it does not exist, set `waiting`.

## `content`

The only pack that works on a fresh clone, because every source is a file in this
repo. Use it for the first area.

| Metric | Unit | Direction | Role | Source |
|--------|------|-----------|------|--------|
| Qualified interest attributed to content | count | higher_is_better | outcome | Deal notes, reply/inbound log |
| Buyer questions covered by a published draft | count | higher_is_better | leading | `workspace/marketing/content/ideas/` `buyer_question` vs drafts |
| Drafts passing `validate-content-draft.sh` first try | % | higher_is_better | leading | Validator exit codes |
| Ideas moving from `new` to `generated` | count | higher_is_better | output | Idea frontmatter `status` |
| Drafts published vs planned | count | higher_is_better | output | Content queue |

Notes:

- The outcome metric almost always starts as `waiting`. That is correct and honest.
  Do not substitute traffic for it — traffic is not an outcome for a firm that
  sells expertise.
- Idea and draft counts are cheap to compute from frontmatter and make a good
  first real Check.

## `pipeline`

| Metric | Unit | Direction | Role | Source |
|--------|------|-----------|------|--------|
| Won engagement value | currency | higher_is_better | outcome | Deal records |
| Win rate | % | higher_is_better | outcome | Proposal outcomes |
| Fit calls held | count | higher_is_better | leading | Calendar, deal notes |
| Proposals sent | count | higher_is_better | output | Proposal files |
| Hours from brief to proposal sent | hours | lower_is_better | leading | Timestamps on the brief and the proposal |
| Proposals declined for poor fit | count | higher_is_better | leading | Qualification decisions |

Notes:

- Declining bad-fit work is a `higher_is_better` leading metric, not a failure.
  Firms that bid selectively win more of what they bid on.
- `sales-prospecting-sequence` produces the top of this pack today. The proposal
  and outcome side depends on the firm recording deals somewhere — often a
  spreadsheet, which is a perfectly valid source of truth.

## `visibility`

| Metric | Unit | Direction | Role | Source |
|--------|------|-----------|------|--------|
| Prompts where the firm is named | % | higher_is_better | outcome | Answer-engine spot checks |
| Average position when named | rank | lower_is_better | leading | Same |
| Share of answer vs named competitors | % | higher_is_better | leading | Same, plus `workspace/intelligence/competitors/` |
| Third-party domains cited for the category | count | higher_is_better | leading | Cited sources in answers |
| Placements earned on cited domains | count | higher_is_better | output | Outreach log |

Notes:

- Answer-engine output is non-deterministic. Require at least three runs of the
  same prompt before recording a value, and record the engine and run count with
  the number. A single run is not evidence.
- Keep the prompt set stable across cycles or the numbers are not comparable.

## `retention`

| Metric | Unit | Direction | Role | Source |
|--------|------|-----------|------|--------|
| Net revenue retention | % | higher_is_better | outcome | Invoicing |
| Logo churn | % | lower_is_better | outcome | Client records |
| Expansion share of bookings | % | higher_is_better | leading | Deal records |
| Clients with a written success definition | % | higher_is_better | leading | Engagement records |
| Referenceable clients | count | higher_is_better | leading | Client records |

Notes:

- "Clients with a written success definition" is the strongest leading indicator
  in this pack and the cheapest to move, because it depends only on the firm
  writing something down.
- Retention metrics move on a quarterly or annual clock. Do not put them on the
  fast cadence.

## `delivery`

| Metric | Unit | Direction | Role | Source |
|--------|------|-----------|------|--------|
| Engagements delivered on time | % | higher_is_better | outcome | Engagement records |
| Out-of-scope hours delivered unbilled | hours | lower_is_better | outcome | Time records |
| Engagements with an explicit scope boundary | % | higher_is_better | leading | Scope documents |
| Engagements closed with a recorded outcome | % | higher_is_better | leading | Engagement records |

Notes:

- This pack needs time records. If the firm does not track time, most of it stays
  `waiting` — say so rather than estimating. An unbilled-hours number the firm
  guessed is worse than no number, because it will be used to make a pricing
  decision.
- "Engagements closed with a recorded outcome" is worth measuring even alone: it
  is what makes case studies and proposals possible later.

## Custom metrics

If the firm needs a metric outside these packs, it still needs all five fields
(name, unit, direction, role, source) and a real source of truth. The rule that
does not bend: no source, no baseline, no target — record `waiting`.
