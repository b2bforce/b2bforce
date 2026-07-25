---
name: intel-weekly-report
description: >-
  Generate a weekly competitive-intelligence report from monitored competitor
  page changes within a date range, with an AI business-impact summary and
  per-page change list. Use when the user wants a weekly digest, monitoring
  summary, or shareable intel report. Read firm profile and monitoring files first.
license: MIT
metadata:
  version: 1.0.0
  category: intelligence
---

# Weekly Intelligence Report

Aggregates detected website changes for monitored competitors over a period
(default: last 7 days) into a single report with an AI summary.

## Read First

1. `workspace/firm/profile.md` — firm scope.
2. Monitoring files from `intel-competitor-monitoring`:
   `workspace/intelligence/competitors/{slug}/changes/*.md`,
   `snapshots/{page-slug}/*.md`, and `pages.md`.

## When to Use

- User wants a **weekly digest** / **monitoring summary** across competitors
- Producing a **shareable** intelligence report
- Scheduled or manual summary of significant changes

## Workflow (per competitor)

### 1. Collect changed snapshots

For the period `[period_start, period_end]`, collect change artifacts from:

`workspace/intelligence/competitors/{slug}/changes/*.md`

Include files where frontmatter `changed_at` falls inside the range. Significance
is **not** filtered here; all detected changes count. Track:

- `pages_analyzed` - count of rows in `pages.md` with `Monitor=true`
- `pages_with_changes` - distinct `page_slug` values with change files in the
  period
- `raw_changes[]` - `{ url, page_slug, change_type, significance, changed_at,
  business_summary }`

If `pages_with_changes == 0`, the summary is exactly
`"No changes detected during this reporting period."` A report is still produced
for the company in this case.

### 2. Business-impact summary

Use the current agent/LLM session to summarize the collected change files.
Truncate the combined change text to **15000 chars** (`MAX_DIFF_LENGTH`). Use
this system prompt:

```text
You are a business intelligence analyst specializing in competitive monitoring.
Your task is to summarize website changes detected on a monitored company's website.

Guidelines:
- Provide a concise summary in 3-5 sentences
- Focus on business-relevant changes (pricing, products, messaging, team changes)
- Highlight any strategic implications
- Use clear, professional language
- If changes seem minor/technical, note that briefly
```

User prompt:
`Summarize the following website changes detected on {name} ({url}):\n\n{diffs}`

If no LLM summary is available, summarize the change files deterministically and mark
`<!-- dry-run: no LLM summary -->`.

### 3. Write the report

`workspace/intelligence/reports/{YYYY-MM-DD}-{slug}-weekly.md`

```yaml
---
competitor: {slug}
period_start: 2026-05-25
period_end: 2026-06-01
pages_analyzed: 12
pages_with_changes: 3
generated: 2026-06-01
---
```

Body sections:

1. **Summary** — the AI business-impact summary.
2. **Changed pages** — per URL: what changed (1–2 lines from the diff).
3. **No-change note** — if applicable.

### 4. Optional: answer-engine visibility drift

If `workspace/intelligence/ai-visibility/share-of-answer.md` exists, add an
**AI visibility** section comparing the two most recent batches:

- citation rate this batch vs last, as a rate over the same active prompts;
- prompts where the firm gained or lost a mention;
- competitors that gained mentions;
- new domains appearing in `cited_domains`.

Rules, inherited from `intel-ai-visibility` and not restated per report:

- Skip this section entirely if only one batch exists. A baseline is not a trend.
- Compare batches, never individual runs. Engines are non-deterministic, and a single
  run flipping is noise.
- Never explain **why** a mention changed. Engines do not disclose that, and an
  invented mechanism is worse than reporting the change alone.

Visibility batches are usually monthly while this report is weekly, so most weeks this
section is absent or unchanged. Say "no new batch since {date}" rather than repeating
last month's numbers as if they were fresh.

### 5. Optional: roll-up across all competitors

A combined `workspace/intelligence/reports/{YYYY-MM-DD}-weekly-rollup.md`
linking each per-competitor report.

## Scheduling

Can be run manually by an agent or by one responsible automation runner. The
generator is period-agnostic and accepts any `[period_start, period_end]`;
**previous 7 days** is the recommended default.

## Rules

1. Only include pages with change artifacts in the period; never pad the report.
2. Keep the AI summary to 3–5 sentences, business-focused.
3. Reports are committed artifacts — write to `workspace/intelligence/reports/`.

## Related Skills

| Skill | When |
|-------|------|
| `intel-competitor-monitoring` | Produces the snapshot/change files this report consumes |
| `intel-competitor-discovery` | Expand the monitored set before reporting |
| `intel-ai-visibility` | Produces the share-of-answer batches for the visibility section |
| `firm-context` | Competitor list and firm scope |
