# Sales

*Client development* — prospecting and deal tracking (Maister).

| Subfolder | Purpose |
|-----------|---------|
| `prospecting/` | B2B one-to-one outbound email sequences and optional variant/import packs |
| `opportunities/{account}--{service}--{YYYY-MM}/` | One folder per opportunity: discovery brief, proposal, outcome |

## The funnel

```text
sales-prospecting-sequence → sales-discovery-brief → sales-bid-qualification
                                                   → sales-proposal → sales-outcome-log
```

A prospect who replies enters an opportunity folder. Nothing is proposed until the
brief is `workable` and the bid decision is `bid` or `conditional` — see the
Proposal Gate in [../../AGENTS.md](../../AGENTS.md).

`outcome.md` closes the loop three ways: it makes win rate computable, it feeds
repeated loss patterns back into the ICP's `anti_fit_criteria`, and on a win it
creates the record in `workspace/firm/proof/` that unblocks case studies.

An opportunity folder is a record of decisions, not a CRM. No pipeline stages,
forecasts, or roll-ups.

Naming and file formats: [../../docs/WORKSPACE.md](../../docs/WORKSPACE.md).
Proposal gate: `scripts/validate-proposal.sh {proposal-path}`.
