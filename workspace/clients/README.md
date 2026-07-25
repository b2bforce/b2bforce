# Clients

*Client relationships and service quality* — the Maister dimension where the money
already is (Maister).

The rest of `workspace/` is about winning work. This folder is about keeping it and
growing it, which is the cheaper half: expanding an existing client costs a fraction
of acquiring a new one, closes roughly twice as fast, and 84% of B2B sales start with
a referral from someone who already trusts you.

| File | Purpose |
|------|---------|
| `{slug}/!_account.md` | The account record: services bought, engagement model, renewal date, health, named contacts. Required. |
| `{slug}/onboarding.md` | First 90 days: the **written success definition**, stakeholders and what each judges success by, checkpoints at day 14 / 30 / 90 |
| `{slug}/account-plan.md` | Relationship map, expansion hypotheses with triggers, risks, next 90 days |
| `{slug}/qbr/{YYYY-QN}.md` | Quarterly review: delivered vs promised, next quarter, expansion ask, referral ask |
| `{slug}/notes.md` | Relationship signals with a risk level |
| `reports/{YYYY-MM-DD}-health.md` | Portfolio sweep across all accounts |

Only `!_account.md` is required. Create the rest when a workflow needs them — an
empty `qbr/` folder is the placeholder clutter the Minimal Files Rule exists to
prevent.

## Where the first 90 days go

Nearly half of B2B client departures happen in the first 90 days, and the decision is
often made around day 14 — before any work has produced a result. What the client is
judging in that window is whether they understand what is happening and whether it
matches what they were sold.

That is why `onboarding.md` exists and why its most important line is not the plan but
the **written success definition**: the sentence the client would use, in their words,
to say this engagement worked. If nobody wrote it down, the firm and the client are
each measuring something different and neither knows it.

The single most useful leading indicator in this folder is mechanical: does every
active account have one? `scripts/validate-account.sh` answers it.

## What this folder is not

A CRM, and not a PSA. It holds the **relationship** — who the people are, what they
were promised, what they got, what they might buy next. It never holds timesheets,
invoices, utilization, or margin.

`mrr_band` is a band rather than an exact figure on purpose. This folder is the most
sensitive one in the repo, and a band answers every question a workflow here actually
asks while making an accidental leak far less costly. The moment this folder tries to
hold exact contract values and profitability, it is competing with real PSA tools on
their ground and losing.

## Staleness is the failure mode

Unlike competitor snapshots, nothing here refreshes itself. A `health: green` from
seven months ago on an account that is quietly leaving is **worse than no file**,
because it is an active lie that a human will act on.

So `reviewed_at` is not decoration. A stale `reviewed_at` combined with
`health: green` is a hard validation failure, not a warning — the combination is
precisely the lie. Stale with `amber` or `red` is only a warning, because the firm
already knows that account needs attention.

## Confidentiality

This is the highest-sensitivity folder in the repo: client names, renewal dates, and
`health: red` assessments. Read the client-data section of
[../../SECURITY.md](../../SECURITY.md) **before** the first account file, and decide
once whether this repo is private or shared.

## Related

Naming and schema: [../../docs/WORKSPACE.md](../../docs/WORKSPACE.md).
Client Context Gate and the renewal review rule: [../../AGENTS.md](../../AGENTS.md).
Won opportunities arrive from [../sales/](../sales/); verified results leave to
[../firm/proof/](../firm/).
