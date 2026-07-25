# PDCA

Measurement loop. Every other area of this workspace produces artifacts — content,
sequences, pages, reports. This one records whether they moved a business outcome.

One folder per area. One area = one outcome.

```text
workspace/pdca/{area}/
├── README.md        # outcome, metrics, sources of truth, cadence, owner, autonomy, baseline
├── cycles/          # {YYYY}-{Www}--{slug}.md — one Plan/Do/Check/Act cycle
├── scoreboard.md    # appended when a cycle closes; never rewrite a past row
├── evals.md         # acceptance-criteria patterns and regression tests
└── errors.md        # repeated failures and the guard added for each
```

| Skill | Purpose |
|-------|---------|
| `firm-pdca-setup` | Create an area: outcome, metrics, sources, cadence, baseline |
| `firm-pdca-cycle` | Run one cycle and close it with an explicit decision |
| `firm-pdca-eval` | Independent evaluation against criteria written before the work |

## Rules that matter

- **Outputs are not outcomes.** Published posts and sent sequences are output
  metrics. They can never be the reason a cycle is called a success.
- **No source of truth, no number.** A metric without a named source is `waiting`,
  never estimated.
- **Missing data is not success.** Past its due date, a missing value is `🔴 N/D`.
- **Two cadences.** Outputs and leading indicators weekly or biweekly; the business
  outcome quarterly, because a firm that sells expertise sees pipeline effects
  months after the work.
- **Start with one area.** A cadence nobody sustains produces a folder that implies
  measurement that is not happening — worse than no folder.

Naming and paths: [../../docs/WORKSPACE.md](../../docs/WORKSPACE.md).
Structural gate: `scripts/validate-pdca-cycle.sh {cycle-path}`.
