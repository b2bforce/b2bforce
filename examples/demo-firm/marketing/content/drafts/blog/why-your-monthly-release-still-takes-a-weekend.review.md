---
fixture: true
draft: why-your-monthly-release-still-takes-a-weekend
round: 2
factcheck: pass
consistency: pass
deslop: pass
reader_test: pass
deslop_score: 40
waived_by:
---

# Review: Why your monthly release still takes a weekend when you already have CI

## Factcheck

- Round: 2 · Date: 2026-07-17 · Claims: 6
- match: 5 · paraphrase ok: 1 · distorted: 0 · not found: 0 · rejected: 0 · no source: 0
- Verdict: pass

| # | Paragraph | Claim (quoted) | Support | Rating | Evidence (fetched 2026-07-17, ≤ 25 words) | Fix |
|---|-----------|----------------|---------|--------|-------------------------------------------|-----|
| 1 | P21 | "a mid-market freight operator with 9 services in the release" | S1 | match | Record: "manual regression pass across 9 services" | — |
| 2 | P21 | "Deployment lead time went from 6 weeks to 4 days" | S1 | match | Metric verified: true, before "6 weeks", after "4 days" | — |
| 3 | P21 | "all 9 services now run regression on every pull request" | S1 | match | Metric verified: true, "9 of 9" | — |
| 4 | P21 | "the weekend release window has not been used since" | S1 | paraphrase ok | Record: "has not been used since February" | — |
| 5 | P22 | "We stopped planning releases around public holidays." | S1 | match | Approved quote, quote_approved: true, client_public: true | — |
| 6 | P23 | "What we did not promise them … is a defect-rate figure" | S3 | match | Service file: "We do not promise a defect-rate percentage." | — |

### Earlier rounds

- Round 1: revise — 1 no source ("two real releases" paragraph had no marker; S2 added)

## Consistency

- Round: 2 · Date: 2026-07-17 · Angle: "The weekend is the human release decision, not the test run"
- Claims: 31 · Blocking: 0 · Repetitions: 1
- Verdict: pass

| # | Code | Place A | Place B | What is wrong | Proposal |
|---|------|---------|---------|---------------|----------|
| 1 | REP | P1: "a human still decides whether the release is safe to ship" | P9: "the last chance to catch a problem" | Close restatement; P9 adds the rollback point, so it stays | Keep both |

### Angle by section

| Section | supports / neutral / undercuts | Why |
|---------|--------------------------------|-----|
| The part CI did not take over | supports | Shows why the checks stayed manual |
| Three things the manual pass is actually protecting | supports | Names what must be replaced; counter "three" matches three items |
| Why "we'll do it in a quiet quarter" does not happen | supports | The constraint is the same two people |
| What replacing it looks like in practice | supports | Sequencing plus a proof-backed example |
| FAQ | neutral | Self-contained answers |
| Where to start this week | supports | Next step follows from the angle |

### Earlier rounds

- Round 1: pass

## Deslop

- Round: 2 · Language: en · Mode: detect · Date: 2026-07-17
- Verdict: pass

| Dimension | Before | After |
|-----------|--------|-------|
| Directness | 8 | |
| Rhythm | 8 | |
| Trust in the reader | 8 | |
| Authenticity | 8 | |
| Density | 8 | |
| **Total** | 40/50 | |

No findings.

### Observations

- P17: "That is the real cost, and it is not on the release calendar anywhere." — a single
  section closer (ST-03 needs two); left as voice.

### Earlier rounds

- Round 1: revise (34/50) — EN-C05 "That decision is the weekend. Not the test run."; EN-O02 "It is worth being precise about…"

## Reader test

- Round: 2 · Date: 2026-07-17 · Reader: CTO of a mid-market logistics operator · Fresh agent, no context
- Angle (idea): "The weekend is the human release decision, not the test run" · Angle (read): "CI automated the tests, not the decision to release; that decision is the weekend" · Match: match
- Score: 8/10
- Verdict: pass

### Reader's answers

0. Yes — paragraph 1: "CI running your tests and your release being automated are different things." About the question, not the firm; the firm appears in one example near the end.
1. CI automated the tests, not the decision to release, and that decision is the weekend.
2. Time the next release check by check and list who performs each one.
3. Clear for a CTO; "staged rollout" is not explained, which is fine for this reader.
4. Would read to the end; the FAQ is skimmable.
5. "Every CTO in this position has a version of this plan" — a generalization.
6. Nothing quoted.
7. No contradictions found.
8. Helpful: one result with numbers and a stated limit.
9. 8/10.

### Fixes

| # | Place (quote) | Problem per the reader | Proposal |
|---|---------------|------------------------|----------|
| 1 | "Every CTO in this position has a version of this plan" | Reads as a fact with no support | Author's call — kept as the firm's observation |

### Earlier rounds

- Round 1: pass (7/10)

## Changes

- Round 1 → 2: P1 merged the closing fragment into the previous sentence (deslop EN-C05);
  P6 opening rewritten without the announcement (deslop EN-O02); S2 marker added to the
  two-releases paragraph (factcheck).
