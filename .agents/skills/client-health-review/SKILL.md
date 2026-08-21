---
name: client-health-review
description: >-
  Sweep every client folder and report what needs attention — renewals inside 90 days,
  accounts in their first 90 days, missing success definitions, accounts with no QBR in
  two quarters, unfilled proof stubs, stale reviews, and referral-ready accounts. Use
  for portfolio review, retention review, or before starting new prospecting.
license: MIT
metadata:
  version: 1.0.0
  category: client
---

# Client Health Review

The portfolio sweep. `intel-weekly-report` does this for competitors; this does it for
the client base, which is where the revenue already is.

It exists for a specific reason: everything else in `workspace/clients/` is per-client
and therefore only runs when someone remembers an account. The account nobody
remembers is the one that churns. Small firms carry roughly twice the annual churn of
large ones, and the difference is not talent — it is that somebody's job is to look
at the whole list on a schedule.

## Read First

1. Every `workspace/clients/*/!_account.md`.
2. Each account's `onboarding.md`, `account-plan.md`, `qbr/`, and `notes.md`.
3. `workspace/firm/proof/` — which records are still empty stubs.
4. `workspace/sales/opportunities/*/outcome.md` — wins with no client folder.

Start with the mechanical pass; it produces the structural facts without judgment:

```bash
scripts/validate-account.sh
```

## When to Use

- Monthly or quarterly portfolio review.
- **Before starting new prospecting.** This is the renewal review rule in `AGENTS.md`:
  a renewal inside 60 days or an account with no QBR in two quarters gets surfaced
  before the firm spends effort on new logos. Acquisition is the expensive channel;
  running it while an existing account quietly lapses is the mistake this ordering
  prevents.
- Anything about retention, churn risk, renewals, or where growth could come from.

## Signals

Each row is a fact plus the skill that resolves it. Nothing here is a judgment call.

| Signal | Condition | Resolve with |
|--------|-----------|--------------|
| Renewal approaching | `renewal_date` within 90 days | `client-qbr`, then `client-account-plan` |
| In the danger window | `start_date` within 90 days | `client-onboarding` checkpoints |
| **No success definition** | active account, no `success_definition` | `client-onboarding` |
| Review overdue | no `qbr/` file in two quarters | `client-qbr` |
| Stale review | `reviewed_at` older than 90 days | human review, then bump |
| **Stale green** | stale `reviewed_at` **and** `health: green` | hard failure — verify or downgrade |
| Gone quiet | `last_contact` older than 6 weeks on an active account | contact, then `notes.md` |
| Health declared without cause | `health` is `amber`/`red`, `health_reason` empty | fill the reason |
| Unfilled proof stub | proof record exists with empty `metrics` | `sales-outcome-log` |
| Referral-ready | `referenceable: true`, no referral asked in the last two QBRs | `client-qbr` |
| Referral undecided | `referenceable: pending` past day 90 | ask the client |
| Won, not onboarded | `outcome.md` with `result: won`, no client folder | `client-onboarding` |
| Single-threaded | one named contact on an active account | `client-account-plan` |
| Single-brand account (multi-brand only) | `brands` lists one brand while a sibling brand has a service matching the client's profile | `client-account-plan` — cross-brand hypothesis |

**Stale green is the one to take seriously.** A `health: green` last reviewed seven
months ago is worse than no file at all, because a human will act on it. Unlike a
competitor snapshot, nothing here refreshes itself — the file is only as true as the
last person who touched it. Report stale green as a failure, not an item.

## Workflow

1. Run `scripts/validate-account.sh` for the structural pass.
2. Walk every account folder and collect the signals above with dates.
3. Group by **what to do**, not by client. A list organized by account produces
   reading; a list organized by action produces action.
4. Compute the portfolio numbers from frontmatter only (below).
5. Write the report.
6. State the top three actions, with an account and an owner. Not ten.

## Portfolio Numbers

Computable from `!_account.md` frontmatter. Report only what the files support, and
mark the rest `unknown` — an estimated retention rate is worse than an absent one.

| Number | Healthy |
|--------|---------|
| Active accounts, and how many are retainer vs project | Project engagements churn far harder |
| Accounts with a written success definition | 100%. The strongest leading indicator here. |
| Accounts with a QBR in the last two quarters | 100% |
| `referenceable: true` share | Higher performers sit near 80% |
| Accounts inside their first 90 days | Watch closely — this is where most churn happens |
| Renewals in the next 90 days | Each one needs a QBR first |
| Stale reviews, and stale greens | Stale greens should be zero |

Do not compute NRR, churn rate, or logo retention here unless the firm records the
inputs. If the firm wants those tracked over time, that is `firm-pdca-setup` with this
report as the source of truth — not a number guessed once inside a report.

## Output

`workspace/clients/reports/{YYYY-MM-DD}-health.md`

```yaml
---
generated: 2026-12-01
accounts_active: 11
accounts_with_success_definition: 8
accounts_missing_qbr: 3
renewals_90d: 2
in_first_90_days: 1
stale_reviews: 4
stale_greens: 1
unfilled_proof_stubs: 3
referenceable: 5
---
```

Body: **Do this first** (three actions), **Renewals and reviews**, **At risk**,
**Referral and proof opportunities**, **Portfolio numbers**, **Data quality** — the
accounts whose files are too stale to trust, which is a finding about the firm's
habits rather than about a client.

## Rules

1. Report only what the files say. Never infer that an account is healthy because
   nothing is recorded — that is the absence of data, not a green light.
2. Never guess a renewal date, an MRR band, or a health colour.
3. If most accounts are stale, lead with that. A report built on stale files is
   itself unreliable, and saying so is more useful than ranking fictional risk.
4. Group by action. Cap "Do this first" at three.
5. Do not write into client folders from here. This report reads and recommends;
   the per-client skills write.

## Testing Requirements

1. Run with no client folders; confirm it says the folder is empty and points to
   `client-onboarding` rather than producing an empty report.
2. Create an account with `health: green` and `reviewed_at` six months old; confirm
   stale green is reported as a failure, and that `validate-account.sh` exits non-zero.
3. Create a won `outcome.md` with no client folder; confirm it appears as
   "won, not onboarded".
4. Create a proof record with empty `metrics`; confirm it appears as an unfilled stub.
5. Confirm no portfolio number is reported that the frontmatter does not support.

## Related Skills

| Skill | When |
|-------|------|
| `client-onboarding` | Resolves missing accounts and missing success definitions |
| `client-qbr` | Resolves overdue reviews and upcoming renewals |
| `client-account-plan` | Resolves single-threaded accounts before renewal |
| `sales-outcome-log` | Fills the proof stubs this report surfaces |
| `firm-pdca-setup` | Turns these numbers into a tracked outcome over time |
| `intel-weekly-report` | The same sweep pattern, for competitors |
