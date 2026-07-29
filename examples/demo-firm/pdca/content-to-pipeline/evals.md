---
fixture: true
---

# Evals — content-to-pipeline

Acceptance-criteria patterns this area reuses, and the checks that decide them.

## Deterministic checks available

| Check | Decides |
|-------|---------|
| `scripts/validate-content-ideas.sh` | Every idea carries the required frontmatter and a valid type/stage pair |
| `scripts/validate-content-draft.sh {path}` | Length, structure, answer-first opening, and correct folder per type |
| `scripts/validate-pdca-cycle.sh {path}` | The structural gate for every cycle file in this area |

Prefer these over an opinion. A check that runs outside the step that produced the
work is worth more than a careful reread by the step itself.

## Reusable criteria patterns

1. Every new draft passes `validate-content-draft.sh` on the first run. Mandatory.
2. Every published draft answers a `buyer_question` that appears in an idea file and
   was not already covered. Mandatory, decided by cross-reading idea frontmatter.
3. No client claim appears that is not in a `firm/proof/` record with
   `usable_publicly: true`. Mandatory, decided by grep against `proof_refs`.
4. Tone matches the firm profile. Not mandatory, and judged by a separate read rather
   than by the writing step.

## Regression tests

- The blog draft in this demo is the reference for criterion 1. If a change to
  `validate-content-draft.sh` makes it fail, either the rule changed on purpose or the
  rule is wrong.
- Criterion 3 regressed once already: see `errors.md`.
