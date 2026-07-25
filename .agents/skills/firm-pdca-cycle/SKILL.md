---
name: firm-pdca-cycle
description: >-
  Run one Plan-Do-Check-Act cycle for a PDCA area in workspace/pdca/, ending in a
  measured result and an explicit decision. Use when the user wants to plan a
  measurable experiment, record what was done, check the outcome against a
  baseline, close a cycle, or asks whether previous work actually worked. Requires
  an area created by firm-pdca-setup.
license: MIT
metadata:
  version: 1.0.0
  category: measurement
---

# PDCA Cycle

One cycle = one hypothesis, 1–3 actions, a measured result, an independent
evaluation, and a decision. The cycle file is the deliverable.

The repo's other skills generate artifacts. This one closes the loop on them.
Published posts, sent sequences, and shipped pages are not success. Movement on
the area's outcome metric is.

## Read First

1. `workspace/pdca/{area}/README.md` — outcome, metrics, sources, cadence,
   autonomy boundaries.
2. The previous cycle in `workspace/pdca/{area}/cycles/`.
3. `workspace/pdca/{area}/errors.md` and `evals.md` — known failures and the
   acceptance-criteria patterns to reuse.
4. `workspace/pdca/{area}/scoreboard.md` — what was already recorded.

If the area does not exist, stop and run `firm-pdca-setup` first.

## When to Use

- Starting a measurable experiment in an existing area.
- Recording what was actually done and what the evidence shows.
- Closing a cycle with a decision.
- The user asks whether the last batch of work moved anything.

## Overdue Detection — Run This First

This repo has no scheduler, so the cycle skill is its own watchdog. On every
invocation, before anything else, report:

1. Any open cycle whose `check_due` date has passed.
2. Any cycle with a filled `Do Log` and an empty `Eval Results`.
3. Any cycle closed without a decision in the allowed vocabulary.
4. Any metric still `waiting` since setup, with the age of the request.
5. Whether the area's `outcome_cadence` check is overdue.

State these plainly before proposing new work. An area with three open cycles and
no closed ones does not need a fourth plan.

## Core Rules

1. One hypothesis per cycle, stated as: "If we do X, metric Y should change by Z,
   because …".
2. Maximum three actions. More than three and the Check cannot attribute anything.
3. **Acceptance criteria are written before Do, not after.** This is the rule the
   whole skill exists to enforce; a criterion invented after seeing the result is
   a rationalization.
4. Never invent a number. Missing data is `waiting` and the status icon is
   `🔴 N/D`, not an estimate and not silence.
5. Missing data is not success. A cycle may close as failed; it may not close as
   successful with an unmet mandatory criterion.
6. Outputs delivered ≠ outcome moved. Report them in separate rows and never let
   an output metric justify `scale`.
7. Do not present correlation as cause. If the outcome moved and something else
   changed at the same time, say so.
8. Never edit a closed cycle or a past scoreboard row. Correct the record forward
   in a new cycle.

## Cycle File

Path: `workspace/pdca/{area}/cycles/{YYYY}-{Www}--{slug}.md`

Example: `workspace/pdca/content-to-pipeline/cycles/2026-W31--buyer-question-coverage.md`

Frontmatter:

```yaml
---
area: content-to-pipeline
cycle_id: 2026-W31
cadence: fast              # fast | outcome
status: planning           # planning | doing | evaluating | closed | blocked | waiting_for_data
baseline_quality: high     # high | medium | low | waiting
opened: 2026-07-27
check_due: 2026-07-31
closed:
decision:                  # set on close, from the Act vocabulary
---
```

Required sections, in this order. Keep every heading even when a section is short
— the validator checks for them and a missing section usually means a skipped step:

```markdown
## Goal
## Baseline
## Hypothesis
## Acceptance Criteria
## Plan
## Do Log
## Eval Results
## Check
## Act
## Blockers
## Next Cycle Inputs
```

Full field-by-field rules: `references/cycle-file.md`.

## Workflow

### 1. Plan

1. Read everything in **Read First** and run **Overdue Detection**.
2. Record the baseline for the metrics this cycle targets: value, date range,
   source, quality. If a source is missing, set `status: waiting_for_data`, write
   the concrete request, and stop. Do not plan against an imagined baseline.
3. Write one hypothesis with a numeric expected change.
4. Choose 1–3 actions. For each: expected output, expected outcome, measurement
   date, dependency, risk, and whether it needs approval.
5. Write acceptance criteria — measurable, and each with the check that will
   decide it. Reuse patterns from `evals.md`.
6. Set `check_due` from the area's cadence. Use `fast` for output and leading
   metrics; only an `outcome` cycle may target an outcome metric.

Set `status: doing` when the plan is agreed.

### 2. Do

Log every action in `Do Log` with date, what was done, result, and evidence — a
file path, URL, ID, or command output. An action with no evidence is not done.

After each action, verify in the target system that the intended effect happened.
Do not assume success from the absence of an error.

Actions listed as requiring approval are prepared and left for the owner. Do not
execute them.

Stop and set `status: blocked` when:

- three different, diagnosis-driven repair attempts have failed,
- the next step needs data, access, tooling, or approval you do not have,
- the result of an external action is unknown and cannot be checked safely,
- the action would be irreversible, public, financial, or reputational.

When blocked, write what was attempted, the evidence, and the specific decision
the owner has to make. Do not attempt a fourth repair.

### 3. Evaluate

Set `status: evaluating` and run `firm-pdca-eval`. Paste its verdict into
`Eval Results`.

Do not skip this and do not self-assess. Evaluating your own work with the same
reasoning that produced it adds no independent signal — the point of the separate
pass is that it applies checks the executing step did not.

### 4. Check

After the measurement date:

1. Compare baseline to result, and plan to execution.
2. Include the eval verdict.
3. Assess data completeness and quality.
4. Separate outcome movement from leading and output indicators.
5. Record deviations, errors, blockers, and side effects.

If data is incomplete, mark the Check conditional, use `🔴 N/D`, and do not scale
anything on the strength of leading indicators alone.

### 5. Act

Close with one decision, stated with its reason:

| Decision | Meaning |
|----------|---------|
| `maintain` | Keep doing this at the same level |
| `standardize` | Make it the default way this work is done |
| `scale` | Increase investment — outcome cycles only |
| `change` | Same goal, different approach |
| `stop` | Stop doing this |
| `observe_longer` | Signal is real but too early to decide |
| `ask_owner` | Needs a human decision, stated explicitly |

`scale` and `stop` require an `outcome` cadence Check. A fast cycle can reach
`maintain`, `change`, `standardize`, `observe_longer`, or `ask_owner`.

Then:

1. Append scoreboard rows (below).
2. Write `Next Cycle Inputs`.
3. Add any repeated failure to `errors.md` and a matching check to `evals.md`.
4. Set `status: closed`, `closed`, and `decision`.
5. Run `scripts/validate-pdca-cycle.sh {cycle-path}`. Treat a non-zero exit as a
   hard stop.

If several consecutive cycles all close `maintain` or `scale` and none ever
closes `stop` or `change`, say so. A loop that never produces a negative decision
is not measuring anything.

## Scoreboard

Append one row per metric checked. Never rewrite a past row.

```markdown
| Check date | Cadence | Metric | Plan | Actual | Status | Cycle |
|------------|---------|--------|-----:|-------:|--------|-------|
| 2026-07-31 | fast | Drafts passing validator first try | 80% | 🟢 86% | on_track | [2026-W31](cycles/2026-W31--buyer-question-coverage.md) |
| 2026-07-31 | fast | Buyer questions covered | 6 | 🟠 5 | behind | [2026-W31](cycles/2026-W31--buyer-question-coverage.md) |
```

Status icons, for `higher_is_better`:

- `🟢` result ≥ 100% of plan
- `🟠` result ≥ 80% and < 100% of plan
- `🔴` result < 80% of plan

For `lower_is_better`:

- `🟢` result ≤ plan
- `🟠` result > plan and ≤ 125% of plan
- `🔴` result > 125% of plan

For a zero, binary, or non-linear target, define the rule in `evals.md` before
the cycle starts. Missing data past its due date is `🔴 N/D`.

Rows are appended, not columns. A wide table with one column per future week is
placeholder content and grows unreadable; an appended long table stays diffable
and keeps history intact.

## Testing Requirements

1. Open a `fast` cycle in an existing area and confirm acceptance criteria are
   written before any `Do Log` entry.
2. Log one action with evidence.
3. Run `firm-pdca-eval` and paste the verdict.
4. Close with a decision and confirm two scoreboard rows were appended.
5. Run `scripts/validate-pdca-cycle.sh` on the file and confirm it exits 0.
6. Re-run this skill and confirm Overdue Detection reports the closed cycle
   correctly and does not flag it as open.

## Reference Files

| File | Content |
|------|---------|
| `references/cycle-file.md` | Section-by-section cycle file rules and a worked example |

## Related Skills

| Skill | When |
|-------|------|
| `firm-pdca-setup` | Creates the area this cycle runs in |
| `firm-pdca-eval` | Independent evaluation, required before Check |
| `firm-context` | Firm profile and services |
| `intel-weekly-report` | Competitor digest — reports changes, does not measure outcomes |
