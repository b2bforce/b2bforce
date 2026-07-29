---
fixture: true
area: content-to-pipeline
cycle_id: 2026-W29--buyer-question-coverage
cadence: fast
status: closed
baseline_quality: high
opened: 2026-07-13
check_due: 2026-07-20
closed: 2026-07-20
decision: change
---

# Cycle 2026-W29 — buyer-question coverage

## Goal

Cover the three questions every discovery call in this segment opens with, so the
first ten minutes of a call stop being an explanation we have already written down.

## Baseline

| Metric | Value | Date range | Source | Quality |
|--------|-------|------------|--------|---------|
| Buyer questions covered by a published draft | 1 | as of 2026-07-12 | Idea frontmatter | high |
| Drafts passing the validator on first run | 50% | 2026-06-01..2026-06-28 | Validator exit codes | high |
| Qualified enquiries attributed to content | — | — | waiting | waiting |

## Hypothesis

If we publish three drafts answering the three uncovered questions from recent
discovery calls, buyer-question coverage goes from 1 to 4 within the week, because the
questions are already recorded in the idea backlog and each maps to one draft.

## Acceptance Criteria

| # | Criterion | Check | Mandatory |
|---|-----------|-------|-----------|
| 1 | Every new draft passes the validator on the first run | `scripts/validate-content-draft.sh` exit 0 | yes |
| 2 | Each draft answers a `buyer_question` from an existing idea that was not covered | Cross-read idea frontmatter | yes |
| 3 | No client figure appears that is not verbatim in a cited proof record | grep claims against `proof_refs` | yes |
| 4 | Tone matches the firm profile | Independent read against `firm/profile.md` | no |

Written 13 July, before anything in the Do Log.

## Plan

### A1 — Publish the "we already have CI" post

- Expected output: 1 blog draft in `marketing/content/drafts/blog/`
- Expected outcome: coverage 1 → 2
- Measured on: 2026-07-20
- Depends on: idea `blog_post--problem--why-your-monthly-release-still-takes-a-weekend`
- Risk: the only usable client figures are in one proof record
- Needs approval: publishing to the website — yes

### A2 — Publish the "what does handover actually mean" post

- Expected output: 1 blog draft
- Expected outcome: coverage 2 → 3
- Measured on: 2026-07-20
- Depends on: an approved idea, which did not exist at plan time
- Risk: no idea file yet, so this may not start
- Needs approval: publishing to the website — yes

### A3 — Publish the "can we do it one service at a time" post

- Expected output: 1 blog draft
- Expected outcome: coverage 3 → 4
- Measured on: 2026-07-20
- Depends on: A2 shipping first, same reviewer
- Needs approval: publishing to the website — yes

## Do Log

### 2026-07-16 — A1 — done

- What: wrote and published the CI / weekend release post
- Result: draft created, passed the validator on the first run
- Evidence: `marketing/content/drafts/blog/why-your-monthly-release-still-takes-a-weekend.md`, validator exit 0, idea moved to `status: generated`
- Verified in target system: yes — file present and live on the site

### 2026-07-17 — A1 — correction

- What: removed an unsourced client figure found in review
- Result: the "15 hours a week" reconciliation claim was inferred, not stated by the
  client. Replaced with the three verified metrics from
  `northwind-release-automation`
- Evidence: `errors.md`, entry 2026-07-14
- Verified in target system: yes — published version contains no unsourced figure

### 2026-07-20 — A2 — not started

- What: the second post never had an idea file
- Result: not started. The plan assumed an idea existed; it did not
- Evidence: no file in `marketing/content/ideas/` for the handover question
- Verified in target system: yes — backlog checked

### 2026-07-20 — A3 — not started

- What: blocked behind A2 by design
- Result: not started
- Evidence: dependency stated in Plan
- Verified in target system: yes

## Eval Results

| # | Criterion | Verdict | Evidence |
|---|-----------|---------|----------|
| 1 | Drafts pass the validator first run | pass | 1/1 exit 0 |
| 2 | Answers an uncovered buyer question | pass | Idea `...why-your-monthly-release...`, question not previously covered |
| 3 | No unsourced client figure | pass | Only after the 17 July correction; the first version failed this |
| 4 | Tone matches the profile | uncertain | The FAQ section reads more promotional than the profile allows |

Mandatory criteria: 3 pass, 0 fail, 0 uncertain.
Overall: pass, with one non-mandatory concern and one correction that should not have
been needed.

Run by `firm-pdca-eval` on 2026-07-20, against the criteria written on 13 July.

## Check

| Metric | Baseline | Plan | Actual | Status | Role |
|--------|----------|-----:|-------:|--------|------|
| Buyer questions covered by a published draft | 1 | 4 | 2 | 🟠 | leading |
| Drafts passing the validator on first run | 50% | 100% | 100% | 🟢 | leading |
| Drafts published vs planned | 1 of 3 | 3 | 2 | 🟠 | output |
| Qualified enquiries attributed to content | — | — | N/D | 🔴 | outcome |

One of three planned drafts shipped, so coverage moved by one instead of three. The
draft that did ship passed the validator first time, which is the one thing that
improved against baseline.

Data completeness: the three leading and output rows are countable from files. The
outcome row is `N/D` because no first-touch field exists yet, so **this cycle cannot
claim any outcome movement**. An enquiry did arrive on 18 July mentioning release
weekends, and it is not evidence: nobody asked where it came from, and one enquiry in
one week would not be a trend even if they had.

Deviation worth naming: the plan contained two actions whose inputs did not exist at
plan time. That is a planning error, not an execution shortfall, and the Do Log makes
it visible rather than reading as a capacity problem.

## Act

Decision: `change`

Two of the three actions were never startable because the ideas behind them did not
exist. Adding writing capacity would not have helped. The next cycle runs
`marketing-content-ideas` first and only plans drafts against ideas that already
exist and validate.

The unsourced-figure correction is handled by making criterion 3 permanent in
`evals.md` rather than by asking the writing step to be more careful, since the
writing step is what produced the number.

## Blockers

None that stopped work. The outcome metric remains unmeasurable until the first-touch
field exists, which is the open data request in the area README and is due 31 August.

## Next Cycle Inputs

- Carry the baseline forward: coverage 2, validator pass rate 100%.
- Run `marketing-content-ideas` before planning any draft. Plan at most two drafts,
  each against an existing idea file.
- Criterion 4 came back `uncertain` on the FAQ section. Either the profile's tone rule
  needs to be written more precisely or the FAQ needs rewriting — decide which before
  publishing the next post.
- Do not attempt an outcome claim in the next fast cycle. The earliest honest outcome
  Check is the quarterly one, after the first-touch field exists.
