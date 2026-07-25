---
name: firm-pdca-setup
description: >-
  Set up a files-only PDCA measurement area for one process or outcome in a
  professional service firm — outcome, metrics, direction, source of truth,
  cadence, and baseline. Use when the user wants to measure whether marketing,
  sales, delivery, or content work actually moves a business outcome, or asks
  for KPIs, a scoreboard, or a measurement loop. Read firm profile first.
license: MIT
metadata:
  version: 1.0.0
  category: measurement
---

# PDCA Setup

Creates one measurement area under `workspace/pdca/{area}/`. An area owns exactly
one business outcome and the metrics that evidence it.

Everything is committed Markdown. There is no hidden runtime state, no database,
and no subscription. The scoreboard is a table in the repo.

## Read First

1. `workspace/firm/profile.md` — what the firm sells and to whom.
2. `workspace/firm/services/{slug}.md` — the service this area serves.
3. `workspace/pdca/README.md` — existing areas, so you do not create a duplicate.

## When to Use

- User wants to know whether content, prospecting, or delivery work is producing
  results.
- User asks for KPIs, a scoreboard, targets, or "how do we measure this".
- A skill produced artifacts for weeks and nobody has checked the outcome.
- Before `firm-pdca-cycle` — an area must exist first.

## Core Rules

1. One area = one outcome = one folder. Do not create an area that measures
   "marketing" in general.
2. **Every metric must name a source of truth.** If the user cannot say where the
   number comes from, set the metric `source: waiting` and do not invent a
   baseline.
3. **Start with exactly one area.** Refuse to create a second area in the same
   session. A firm that cannot sustain one cadence will not sustain three.
4. Outputs are not outcomes. Every area needs at least one outcome metric;
   output metrics are marked `role: output` and can never be the reason a cycle
   is called a success.
5. Never invent a baseline, a target, or a benchmark. An empty baseline with
   `quality: waiting` is a valid, honest state.

## Cadence — Two Speeds, Not One

Professional service firms have long sales cycles. Marketing and business
development work influences pipeline months later, so a weekly outcome number is
noise and a weekly *target* invites the firm to optimize the wrong thing.

Set two cadences per area:

| Cadence | What it measures | Default |
|---------|------------------|---------|
| `fast_cadence` | Outputs and leading indicators | weekly or biweekly |
| `outcome_cadence` | The business outcome | quarterly |

Rules:

- Only `outcome_cadence` checks may justify `scale` or `stop` decisions.
- A fast check may never be reported as outcome movement.
- If the user insists on a weekly outcome number, record the source of truth and
  the expected lag in the area README so the lag is visible later.

## Metric Packs

Do not invent a metric set from scratch. Pick a pack, then cut it to the metrics
whose source of truth actually exists.

Full definitions, directions, and workspace bindings:
`references/metric-packs.md`.

| Pack | Measures | Needs |
|------|----------|-------|
| `content` | Publishing throughput, draft quality gate pass rate, buyer-question coverage | Nothing beyond this repo — **the only pack that works on a fresh clone** |
| `pipeline` | Fit calls, proposals sent, win rate, pipeline value | A sales pipeline the firm records somewhere |
| `visibility` | Answer-engine citation rate, share of answer, placements earned | An AI-visibility monitoring habit |
| `retention` | Net revenue retention, logo churn, expansion share, referenceable clients | A client record and renewal dates |
| `delivery` | On-time delivery, out-of-scope hours, written success definitions | Engagement records |

Start with `content` unless the user already has a source of truth for another
pack. It is measurable from committed files today, which means the first cycle
can close with real numbers instead of `N/D`.

## Workflow

### 1. Define the area

Ask for, and do not guess:

- the one business outcome this area should move,
- which service and ICP it serves,
- who owns it,
- what the agent may do without asking (see Autonomy Boundaries).

Slug the area in kebab-case: `content-to-pipeline`, `retainer-retention`.

### 2. Choose metrics

Pick 3–6 metrics. For each, record name, unit, direction, role, and source.

- `direction: higher_is_better | lower_is_better`
- `role: outcome | leading | output`
- `source:` a named system, report, or file path — or `waiting`

Refuse to proceed past six metrics. A scoreboard nobody fills is worse than no
scoreboard, because it implies measurement that is not happening.

### 3. Record the baseline

For each metric, write the current value with its date range, source, and
quality: `high`, `medium`, `low`, or `waiting`.

If a source of truth is missing, write `waiting` and add a concrete request to
the area README stating who must provide what. Do not estimate.

### 4. Write the area files

```text
workspace/pdca/{area}/
├── README.md        # outcome, metrics, sources, cadence, owner, autonomy, baseline
├── cycles/          # created by firm-pdca-cycle
├── scoreboard.md    # header only; rows are appended as cycles close
├── evals.md         # acceptance-criteria patterns and regression tests
└── errors.md        # repeated failures and the guard added for each
```

`README.md` frontmatter:

```yaml
---
area: content-to-pipeline
outcome: More qualified implementation interest from published content
owner: founder
service: seo-retainer
icp: mid-market-saas
fast_cadence: weekly
outcome_cadence: quarterly
timezone: Europe/Warsaw
metric_pack: content
created: 2026-07-25
updated: 2026-07-25
---
```

Body sections, in this order:

1. `## Outcome` — one sentence, business language, no metric names.
2. `## Metrics` — the table below.
3. `## Baseline` — value, date range, source, quality per metric.
4. `## Autonomy boundaries` — what the agent may do, and what needs approval.
5. `## Open data requests` — every `waiting` source with an owner and a date.

Metrics table:

```markdown
| Metric | Unit | Direction | Role | Source | Quality |
|--------|------|-----------|------|--------|---------|
| Qualified implementation interest | count | higher_is_better | outcome | Deal notes | medium |
| Drafts passing validator first try | % | higher_is_better | leading | validate-content-draft.sh | high |
| Posts published vs planned | count | higher_is_better | output | Content queue | high |
```

`scoreboard.md` is created with the header row only. Do **not** pre-generate a
column or row per future week — that is placeholder content, and the repo's
Minimal Files Rule forbids it. Rows are appended by `firm-pdca-cycle` when a
cycle closes.

```markdown
# Scoreboard — {area}

Appended when a cycle closes. Never edit a past row.

| Check date | Cadence | Metric | Plan | Actual | Status | Cycle |
|------------|---------|--------|-----:|-------:|--------|-------|
```

### 5. Seed evals

`evals.md` starts with the acceptance-criteria patterns this area will reuse and
the deterministic checks available. At minimum, record that
`scripts/validate-pdca-cycle.sh` is the structural gate.

### 6. Hand off

Tell the user the area is ready and that the next step is `firm-pdca-cycle`. Do
not open the first cycle in the same run — setup and planning are different
decisions, and bundling them tends to produce a plan the user never agreed to.

## Autonomy Boundaries

Record these explicitly per area, because they differ by firm. Default split:

**Allowed without asking:** read data sources, create and update files under
`workspace/pdca/{area}/`, draft experiments, propose next-cycle plans.

**Requires approval:** publishing anything public, contacting a client or
prospect, spending money, changing tracking or permissions, anything
irreversible or reputational.

## Testing Requirements

1. Create one area with the `content` pack and at least one `waiting` metric.
2. Confirm `README.md`, `scoreboard.md`, `evals.md`, and `errors.md` exist and
   that `scoreboard.md` has a header and no data rows.
3. Confirm the `waiting` metric appears under `## Open data requests`.
4. Run `firm-pdca-cycle` and confirm it finds the area.

## Reference Files

| File | Content |
|------|---------|
| `references/metric-packs.md` | Metric definitions, directions, and workspace bindings per pack |

## Related Skills

| Skill | When |
|-------|------|
| `firm-context` | Before setup — firm profile and services must exist |
| `firm-pdca-cycle` | Runs the Plan → Do → Check → Act cycle in this area |
| `firm-pdca-eval` | Independent evaluation before a cycle's Check |
