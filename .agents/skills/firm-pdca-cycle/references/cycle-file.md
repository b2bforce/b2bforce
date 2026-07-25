# Cycle File Rules

Section-by-section rules for `workspace/pdca/{area}/cycles/{YYYY}-{Www}--{slug}.md`.

Keep every heading even when the content is one line. A missing heading almost
always means a skipped step, which is why `scripts/validate-pdca-cycle.sh` checks
for all eleven.

## `## Goal`

One sentence. What this cycle is trying to move, in business language. Not a task
list.

## `## Baseline`

One row per metric this cycle targets.

```markdown
| Metric | Value | Date range | Source | Quality |
|--------|-------|------------|--------|---------|
| Drafts passing validator first try | 62% | 2026-07-01..2026-07-26 | Validator exit codes | high |
| Qualified interest attributed to content | — | — | Deal notes | waiting |
```

Quality is `high`, `medium`, `low`, or `waiting`. A `waiting` baseline means the
metric cannot be the subject of this cycle's hypothesis.

## `## Hypothesis`

Exactly one, in this shape:

> If we do X, metric Y should change by Z, because W.

The number matters. "Should improve" is not a hypothesis, because no result can
contradict it.

## `## Acceptance Criteria`

Written **before** anything in `Do Log`. Each criterion needs a check that decides
it, and a mandatory flag.

```markdown
| # | Criterion | Check | Mandatory |
|---|-----------|-------|-----------|
| 1 | All new drafts pass the validator on first run | `scripts/validate-content-draft.sh` exit 0 | yes |
| 2 | Every published draft answers a `buyer_question` from an existing idea | Cross-read idea frontmatter | yes |
| 3 | Tone matches the firm profile | Independent LLM read against profile | no |
```

Prefer criteria a script can decide. A deterministic check that exists outside the
generating step is worth more than a careful opinion from the step that produced
the work.

## `## Plan`

One block per action, maximum three.

```markdown
### A1 — Publish three drafts answering uncovered buyer questions

- Expected output: 3 drafts in `workspace/marketing/content/drafts/blog/`
- Expected outcome: buyer-question coverage 3 → 6
- Measured on: 2026-07-31
- Depends on: three approved ideas with `status: approved`
- Risk: ideas may lack proof, blocking the draft
- Needs approval: no
```

## `## Do Log`

Append-only. One entry per action attempt.

```markdown
### 2026-07-29 — A1 — done

- What: published 3 blog drafts
- Result: 3 files created, all passed the validator on first run
- Evidence: `workspace/marketing/content/drafts/blog/{a,b,c}.md`, validator exit 0
- Verified in target system: yes — files present, `status: generated` on the ideas
```

An entry without evidence is not done. If an action failed, log the diagnosis and
the different method tried next — not the same attempt repeated.

## `## Eval Results`

Pasted from `firm-pdca-eval`. Never written by the executing step.

```markdown
| # | Criterion | Verdict | Evidence |
|---|-----------|---------|----------|
| 1 | Drafts pass validator | pass | 3/3 exit 0 |
| 2 | Answers an uncovered buyer question | pass | Ideas 14, 19, 22 |
| 3 | Tone matches profile | uncertain | Two drafts read more promotional than the profile allows |

Mandatory criteria: 2 pass, 0 fail, 0 uncertain.
Overall: pass with a non-mandatory concern.
```

A `fail` or `uncertain` on a mandatory criterion blocks a successful close.

## `## Check`

```markdown
| Metric | Baseline | Plan | Actual | Status | Role |
|--------|----------|-----:|-------:|--------|------|
| Drafts passing validator first try | 62% | 80% | 86% | 🟢 | leading |
| Buyer questions covered | 3 | 6 | 5 | 🟠 | leading |
| Qualified interest attributed to content | — | — | N/D | 🔴 | outcome |
```

Below the table, in prose:

- what moved and what did not,
- data completeness and quality,
- outcome movement separated from leading and output movement,
- deviations, errors, side effects,
- anything that changed at the same time and could explain the result instead.

If the outcome row is `N/D`, say plainly that this cycle cannot claim outcome
movement.

## `## Act`

The decision, its reason, and what happens next.

```markdown
Decision: `change`

Coverage improved but stalled at 5 of 6 because one idea had no usable proof.
The blocker is proof availability, not drafting capacity, so adding drafting
effort would not help. Next cycle targets the proof gap instead.
```

Allowed: `maintain`, `standardize`, `scale`, `change`, `stop`, `observe_longer`,
`ask_owner`. `scale` and `stop` require an `outcome` cadence Check.

## `## Blockers`

What stopped, what was attempted, what the owner has to decide. Empty is fine —
write `None.` rather than deleting the heading.

## `## Next Cycle Inputs`

The handoff. What the next Plan should start from: the carried-over baseline, the
unresolved blocker, the criterion that came back `uncertain`.

This is the section that makes the loop a loop. A cycle that closes without it
leaves the next cycle to start from scratch.

## Status transitions

```text
planning → doing → evaluating → closed
```

Plus `blocked` and `waiting_for_data` from any state. Both are legitimate resting
states and neither is a failure to hide — an area honestly parked on missing data
is more useful than one filled with estimates.
