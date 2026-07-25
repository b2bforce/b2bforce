# Intelligence

Market awareness — competitors, website changes, answer-engine visibility, and reports.

| Subfolder | Purpose |
|-----------|---------|
| `competitors/{slug}/` | One folder per monitored competitor (`!_profile.md`, `pages.md`, snapshots, changes, notes) |
| `ai-visibility/` | Prompt panel, dated run batches, and the share-of-answer rollup |
| `reports/` | Discovery reports and weekly intelligence reports |

Skills: `intel-competitor-monitoring` for files-only website monitoring,
`intel-ai-visibility` for whether answer engines name the firm, `intel-weekly-report`
for the digest across both.

Both monitoring workflows share one pattern: a versioned panel of things to watch, dated
artifacts per check, and a rollup. Nothing is hidden in runtime state, so a teammate or
another agent can review the history in git.

## Sampling an answer engine is not like crawling a page

A page crawl is repeatable: fetch it twice, get the same bytes. An answer engine returns
something different each time, so a single run proves nothing on its own.

The rules are in the Answer Engine Sampling section of
[../../AGENTS.md](../../AGENTS.md) — minimum three runs before any claim, report a rate
rather than a yes/no, first batch is a baseline only. Read them before writing anything
into `ai-visibility/`.

Naming and folder structure: [../../docs/WORKSPACE.md](../../docs/WORKSPACE.md).
