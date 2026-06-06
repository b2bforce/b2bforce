---
name: intel-competitor-monitoring
description: >-
  Files-only competitor website monitoring for a shared B2BForce workspace.
  Use to maintain competitor profiles, monitored page lists, page snapshots,
  change notes, and weekly report inputs under workspace/intelligence/.
  Read firm profile first; for firm profile setup, see firm-context.
license: MIT
metadata:
  version: 1.0.0
  category: intelligence
---

# Competitor Monitoring

Files-only workflow for monitoring external companies/competitors in a shared
repo. The source of truth is committed Markdown under `workspace/`.

There is no hidden runtime state. This makes the workflow easier to review,
merge, and hand to another agent or teammate.

## Read Firm Context First

Before adding or crawling competitors:

1. Read `workspace/firm/profile.md` for firm scope, services, geography, and
   known competitors.
2. Read existing competitor folders under
   `workspace/intelligence/competitors/{slug}/`.
3. Write findings and weekly exports to `workspace/intelligence/reports/`.

## When to Use

- User asks for competitor monitoring, account tracking, or website change
  detection.
- A competitor profile exists and pages should be crawled or refreshed.
- Discovery produced candidate competitors and the user confirmed which ones to
  monitor.
- Weekly report needs change artifacts to summarize.

## Core Rules

1. One competitor = one folder:
   `workspace/intelligence/competitors/{slug}/`.
2. Homepage is monitored by default when a competitor is added.
3. Discovered subpages default to `monitor: false`; the user must approve them
   before recurring crawls.
4. First crawl stores a baseline snapshot only. It must not create a business
   change alert.
5. Every later crawl compares against the latest previous snapshot for the same
   page slug.
6. Significant changes are written as Markdown change artifacts; minor/noisy
   changes may be omitted or marked `significance: minor`.
7. Never invent changes. If scraping fails or content is incomplete, write a
   crawl note with `status: error` instead of summarizing guessed differences.

## File Layout

Use the structure documented in `references/file-layout.md`:

```text
workspace/intelligence/competitors/{slug}/
├── !_profile.md
├── pages.md
├── notes.md
├── snapshots/
│   └── {page-slug}/
│       └── {YYYY-MM-DDTHHMMSSZ}.md
└── changes/
    └── {YYYY-MM-DDTHHMMSSZ}--{page-slug}.md
```

Weekly reports stay outside competitor folders:

`workspace/intelligence/reports/{YYYY-MM-DD}-{slug}-weekly.md`

## Workflow

### 1. Ensure competitor profile

Create or update:

`workspace/intelligence/competitors/{slug}/!_profile.md`

Required frontmatter:

```yaml
---
name: Example Competitor
website_url: https://www.example.com/
root_domain: example.com
company_type: competitor
monitoring_enabled: true
monitoring_frequency: weekly
source: manual
created: 2026-06-06
updated: 2026-06-06
---
```

If the competitor came from discovery, include the discovery phrase and reason in
the body. Do not mirror this into hidden JSON.

### 2. Ensure page index

Create or update:

`workspace/intelligence/competitors/{slug}/pages.md`

Use a table:

```markdown
# Monitored Pages

| Page slug | URL | Monitor | Priority | Source | Last crawled | Notes |
|-----------|-----|---------|----------|--------|--------------|-------|
| homepage | https://www.example.com/ | true | high | manual |  | Baseline page |
```

Rules:

- `Page slug` must be stable kebab-case.
- Homepage row is required and starts with `Monitor=true`.
- Discovered pages are appended with `Monitor=false`.
- Do not delete old page rows automatically; mark in notes if removed or broken.

### 3. Discover pages

Use sitemap, current agent/browser, or `tool-firecrawl` if configured.

Write discovered candidates by appending rows to `pages.md` with
`Monitor=false`. Keep the list short and useful:

- service pages,
- pricing/offer pages,
- case studies,
- resources/blog pages that reveal positioning,
- team/about pages if hiring or leadership changes matter.

Avoid adding every blog post. For most firms, 5-20 monitored candidates is
enough.

### 4. Crawl enabled pages

For each row with `Monitor=true`:

1. Fetch clean page content.
2. Normalize obvious noise: whitespace, tracking parameters, cookie banners,
   repeated nav/footer text when possible.
3. Compute a content hash if the agent/tool can do so. If not, use the snapshot
   timestamp and content body as evidence.
4. Write a snapshot:
   `snapshots/{page-slug}/{YYYY-MM-DDTHHMMSSZ}.md`

Snapshot frontmatter:

```yaml
---
page_slug: homepage
url: https://www.example.com/
crawled_at: 2026-06-06T12:00:00Z
status: success
content_hash: optional-hash
word_count: 1234
source_tool: current-agent
---
```

Body: cleaned Markdown page content, truncated only if the page is too large. If
truncated, say exactly where.

### 5. Compare with previous snapshot

Find the latest older snapshot for the same page slug.

- If none exists: baseline only, no change artifact.
- If the new content is equivalent after normalization: no change artifact.
- If changed: write a change artifact:
  `changes/{YYYY-MM-DDTHHMMSSZ}--{page-slug}.md`

Change artifact frontmatter:

```yaml
---
page_slug: homepage
url: https://www.example.com/
previous_snapshot: snapshots/homepage/2026-06-01T120000Z.md
current_snapshot: snapshots/homepage/2026-06-06T120000Z.md
changed_at: 2026-06-06T12:00:00Z
change_type: messaging
significance: significant
---
```

Body sections:

1. `## Business Summary` - 2-3 sentences.
2. `## What Changed` - concrete observed changes.
3. `## Why It Matters` - implications for the firm.
4. `## Evidence` - short excerpts or bullet references to the snapshots.

## Significance Rules

Mark `significance: minor` for:

- typo/formatting/copyright-year changes,
- cookie/banner/nav/footer noise,
- minor date updates,
- tracking or script changes,
- tiny wording changes with no commercial implication.

Mark `significance: significant` for:

- new service, offer, package, or pricing signal,
- changed positioning or ICP language,
- new case study/client proof,
- hiring/leadership/partnership change,
- page removal or major information removal,
- new campaign, event, resource, or productized service relevant to the firm.

If uncertain, mark `significance: review` and explain what a human should check.

## Scheduling

This skill does not require a built-in scheduler. For a shared repo, prefer one
responsible person or automation runner to perform recurring crawls and commit
the resulting files.

Recommended cadence:

| Page priority | Cadence |
|---------------|---------|
| high | weekly |
| normal | monthly |
| low | quarterly or manual |

Avoid multiple people crawling the same competitor at the same time. Timestamped
snapshot files reduce merge conflicts, but duplicate snapshots create noisy
history.

## Testing Requirements

1. Create one competitor folder with `!_profile.md` and `pages.md`.
2. Crawl homepage once and write a baseline snapshot.
3. Crawl the same page again and confirm either no change artifact or one
   `changes/{timestamp}--homepage.md`.
4. Run `intel-weekly-report` against the change artifacts.

## Reference Files

| File | Content |
|------|---------|
| `references/file-layout.md` | Folder structure and artifact rules |

## Related Skills

| Skill | When |
|-------|------|
| `firm-context` | Before setup - competitor list and firm scope |
| `intel-competitor-discovery` | SERP-based competitor finding |
| `intel-weekly-report` | Weekly report generation from change files |
