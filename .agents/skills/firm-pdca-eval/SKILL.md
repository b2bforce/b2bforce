---
name: firm-pdca-eval
description: >-
  Independently evaluate a PDCA cycle against the acceptance criteria written
  before the work started, using deterministic checks first and an LLM judge
  second. Use before a cycle's Check, when verifying whether work actually met its
  criteria, or when a result needs a second opinion that is not the executor's.
license: MIT
metadata:
  version: 1.0.0
  category: measurement
---

# PDCA Eval

Scores one cycle against the acceptance criteria that were written before `Do`.
Produces a verdict per criterion with evidence, and nothing else.

This is a separate step for a reason. When the same reasoning that produced the
work also judges it, the judgement adds no independent signal — it shares the
executor's blind spots and tends to confirm the work rather than test it. An
evaluation is only worth running if it applies a check the executing step did not.

## Read First

1. The cycle file: `workspace/pdca/{area}/cycles/{cycle-id}--{slug}.md`.
2. `workspace/pdca/{area}/evals.md` — regression tests and reusable checks.
3. `workspace/pdca/{area}/README.md` — metric directions and roles.

Read the acceptance criteria **before** reading the Do Log, so the criteria frame
the evidence rather than the evidence reframing the criteria.

## When to Use

- Before `Check` in `firm-pdca-cycle`. Required, not optional.
- The user wants to know whether work actually met its criteria.
- A result looks good and nobody has tested it against what was promised.
- A previously fixed failure needs a regression check.

## What You Receive

- the goal and baseline,
- the acceptance criteria **as written before `Do`**,
- the raw evidence and the state of the target system,
- the tool trace, if available,
- the regression tests from `evals.md`.

You do not receive, and must not accept as evidence, the executing step's own
narrative that the work went well.

## Grader Order

Always in this order. Stop escalating once a criterion is decided.

### 1. Deterministic checks

Scripts, exit codes, file existence, frontmatter values, counts, string matches.
These live outside the generating process, so they are the strongest evidence
available.

Available in this repo:

| Check | Use |
|-------|-----|
| `scripts/validate-content-draft.sh` | Draft structure and length |
| `scripts/validate-content-ideas.sh` | Idea backlog integrity |
| `scripts/validate-content-readiness.sh` | Firm, service, ICP, persona gates |
| `scripts/validate-pdca-cycle.sh` | Cycle file structure |
| `./validate-skills.sh` | Skill definitions |

Plus anything the criterion names: file present, count ≥ N, frontmatter field set,
command exits 0.

### 2. Independent LLM judge

Only for criteria a script cannot decide — tone, positioning fit, whether a draft
genuinely answers a buyer question.

Rules:

- Run in a fresh session or a separate context when the platform allows it.
- Judge against the criterion and the firm profile, not against the executor's
  explanation.
- Cite the specific passage that decided the verdict.
- Return `uncertain` rather than guessing. `uncertain` is a useful signal;
  a confident wrong `pass` is not.

### 3. Human

Escalate to the owner when:

- a grader returned `uncertain` on a mandatory criterion,
- deterministic and LLM graders disagree,
- the criterion covers a high-risk, irreversible, public, financial, or
  reputational action.

## Verdicts

Every criterion gets `pass`, `fail`, or `uncertain`, each with evidence.

Closing rules:

1. A cycle **may** close as failed. Failure is a legitimate, useful outcome.
2. A cycle **may not** close as successful, and its actions may not be scaled or
   standardized, while any mandatory criterion is `fail` or `uncertain`.
3. Absence of evidence is `uncertain`, never `pass`.
4. Do not soften a `fail` because the effort was substantial or the intent good.

## Output

Write the verdict table into the cycle's `## Eval Results`:

```markdown
| # | Criterion | Grader | Verdict | Evidence |
|---|-----------|--------|---------|----------|
| 1 | Drafts pass validator first run | deterministic | pass | 3/3 exit 0 |
| 2 | Answers an uncovered buyer question | deterministic | pass | Ideas 14, 19, 22 |
| 3 | Tone matches firm profile | llm | uncertain | Drafts B and C read more promotional than profile allows |

Mandatory: 2 pass, 0 fail, 0 uncertain.
Overall: pass with a non-mandatory concern.
Escalated to owner: no.
```

Do not write anything else into the cycle file. Check and Act belong to
`firm-pdca-cycle`.

## Turning Failures Into Tests

Every confirmed, repeated failure becomes a regression test.

1. Add the symptom, cause, fix, prevention, and automated check to
   `workspace/pdca/{area}/errors.md`.
2. Add the corresponding check to `workspace/pdca/{area}/evals.md` so future
   cycles are graded against it automatically.

An `errors.md` entry with no matching check in `evals.md` is incomplete — nothing
stops the failure from recurring.

`errors.md` entry:

```markdown
## Draft published without a linked idea

- Symptom: draft frontmatter `idea:` empty, validator failed on close
- Cause: draft written directly, skipping the idea backlog
- Fix: created the idea retroactively, relinked the draft
- Prevention: check `idea:` before publishing
- Automated check: `scripts/validate-content-draft.sh`
- Regression test: evals.md #4
- Verified: 2026-07-31
```

## Rules

1. Evaluate against criteria written before `Do`. If criteria were written after,
   record that as a process failure and grade what exists.
2. Deterministic before LLM, always.
3. Cite evidence for every verdict. A verdict without evidence is an opinion.
4. Never edit the criteria to fit the result.
5. Never write Check or Act. Those are decisions; this skill only produces
   findings.

## Testing Requirements

1. Evaluate a cycle where one mandatory criterion clearly fails; confirm the
   verdict blocks a successful close.
2. Evaluate a cycle with a missing piece of evidence; confirm `uncertain`, not
   `pass`.
3. Add one failure to `errors.md` and confirm a matching check lands in
   `evals.md`.

## Related Skills

| Skill | When |
|-------|------|
| `firm-pdca-cycle` | Owns the cycle; calls this skill before Check |
| `firm-pdca-setup` | Defines the metrics and seeds `evals.md` |
