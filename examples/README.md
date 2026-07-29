# Examples

**Everything in `demo-firm/` is fiction.** Ferrymark Systems does not exist, Northwind
Logistics is not a client, and every number, quote, and name in these files was
invented for the example. Each file carries `fixture: true` in its frontmatter, and a
file with that flag is never evidence — not in a proposal, not in a case study, not as
firm context. Copy the structure; never copy the facts. The rule is in
[AGENTS.md](../AGENTS.md), section "Firm Context Gate".

Two jobs, one directory:

1. **See what the workflows produce** before spending an hour on the firm interview.
2. **Catch schema drift.** `scripts/demo-check.sh` runs every workspace gate against
   this firm, so a change that breaks a file shape fails in CI instead of failing on a
   user's first real proposal.

```bash
scripts/demo-check.sh
```

## Read it in this order

The files follow one engagement from positioning to measurement. Reading them in order
is the fastest way to understand how the folders connect.

| # | File | Skill that writes it | What to notice |
|---|------|---------------------|----------------|
| 1 | `firm/profile.md` | `firm-context` | Every other skill reads this first |
| 2 | `firm/services/platform-migration.md` | `marketing-service` | `service_type: project` decides which pricing model a proposal may use |
| 3 | `marketing/icp/mid-market-logistics.md` | `marketing-icp` | `buying_mode: reactive` drives tone everywhere downstream |
| 4 | `marketing/icp/personas/cto-mid-market-logistics.md` | `marketing-icp` | The ICP is a company; the persona is a person inside it |
| 5 | `firm/proof/northwind-release-automation.md` | `sales-outcome-log` (`backfill`) | Three independent permission flags, and `verified: true` per metric |
| 6 | `marketing/content/ideas/blog_post--problem--*.md` | `marketing-content-ideas` | Filename encodes type and buying stage for scanning at volume |
| 7 | `marketing/content/drafts/blog/*.md` | `marketing-content-blog-post` | Answers the idea's `buyer_question` in the first paragraph |
| 8 | `sales/opportunities/northwind-logistics--platform-migration--2026-05/!_discovery.md` | `sales-discovery-brief` | `brief_quality: strong` is what unlocks a proposal |
| 9 | `.../proposal.md` | `sales-proposal` | Out of scope, Assumptions, and Change control are mandatory and non-empty |
| 10 | `.../outcome.md` | `sales-outcome-log` (`close`) | The win creates a proof **stub**, not a result |
| 11 | `firm/proof/northwind-warehouse-cutover.md` | `sales-outcome-log` | The honest post-win state: flags `false`, `metrics` empty |
| 12 | `clients/northwind-logistics/!_account.md` | `client-onboarding` | Named contacts with roles, `mrr_band` instead of money |
| 13 | `clients/northwind-logistics/onboarding.md` | `client-onboarding` | The success definition is in the client's words |
| 14 | `clients/northwind-logistics/qbr/2026-Q2.md` | `client-qbr` | One commitment marked *not delivered*, with the cause attributed to the firm |
| 15 | `pdca/content-to-pipeline/README.md` | `firm-pdca-setup` | One metric is `waiting`, because its source of truth does not exist |
| 16 | `pdca/content-to-pipeline/cycles/2026-W29--*.md` | `firm-pdca-cycle` | Acceptance criteria dated before the Do Log; outcome row is `N/D` |
| 17 | `pdca/content-to-pipeline/scoreboard.md` | `firm-pdca-cycle` | Append-only rows, one per metric checked |

`evals.md` and `errors.md` in the PDCA area complete that folder's required shape.

## What the demo is deliberately showing

- **A stub next to a filled record.** Item 11 is empty on purpose. A win produces a
  stub, and a stub nobody returns to is the documented failure mode of the proof
  library. Item 5 is what one looks like after a human confirmed the numbers.
- **Three permission flags that are not interchangeable.** `client_public` governs
  naming, `quote_approved` governs quoting, `usable_publicly` governs public material.
  The demo's public record sets all three; the stub sets none.
- **A missed commitment.** The QBR marks one item not delivered and says it was the
  firm's fault. A review where everything went well is not a review.
- **A metric that cannot be measured.** The PDCA area leaves the outcome metric
  `waiting` and the cycle's outcome row `N/D`, because no source of truth exists yet.
  Missing data is not success.
- **A planning error, named as one.** Two of three planned drafts never started
  because the ideas behind them did not exist. The cycle closes `change`, not "try
  harder".

## Dates

Committed dates are fixed ISO dates so the story reads consistently. Three fields are
compared against *today* by `scripts/validate-account.sh` — `reviewed_at`,
`last_contact`, and `renewal_date` — so a committed date would eventually make this
account look stale and fail the account gate on its own. `scripts/demo-check.sh`
validates a copy in `tmp/` with those three fields shifted to be relative to today.
The offsets live in that script and nowhere else.

## Changing the demo

If a validator or a file schema changes, update the demo in the same pull request.
`scripts/demo-check.sh` runs on every PR, so a stale demo fails CI rather than rotting
quietly — see [CONTRIBUTING.md](../CONTRIBUTING.md).
