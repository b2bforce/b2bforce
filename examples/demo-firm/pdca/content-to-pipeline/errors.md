---
fixture: true
---

# Errors — content-to-pipeline

Repeated failures and the guard added for each. One entry per pattern, not per
occurrence.

## 2026-07-14 — a client figure appeared in a draft with no proof record behind it

**What happened.** A first pass at the release-weekend post said the manual
reconciliation step cost "around 15 hours a week". Nobody at the client had said that.
It was inferred from a discovery note that said "about three hours every morning".

**Why it got through.** The number was plausible and arithmetically defensible, which
is exactly the failure mode the Proof Gate exists for. Plausible is not verified.

**Guard.** Acceptance criterion 3 in `evals.md` is now mandatory on every draft: any
client figure has to appear verbatim in a `firm/proof/` record listed in
`proof_refs`. The published draft cites only the three verified metrics in
`northwind-release-automation`.

## Open pattern to watch

Two of three planned drafts shipped in the last two cycles. If it happens a third
time the plan is too large rather than the execution too slow, and the fix belongs in
Plan, not in effort.
