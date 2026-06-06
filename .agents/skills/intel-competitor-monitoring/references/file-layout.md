# Files-Only Monitoring Layout

Competitor monitoring stores all shared state in committed workspace files.

## Competitor Folder

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

## `!_profile.md`

The competitor profile is the human-readable source of truth for who the
competitor is and why they matter.

Required frontmatter:

```yaml
---
name:
website_url:
root_domain:
company_type: competitor
monitoring_enabled: true
monitoring_frequency: weekly
source: manual
created:
updated:
---
```

Body should include:

- why this competitor matters,
- relevant services/offers,
- geography/market,
- known strengths,
- what to watch.

## `pages.md`

Page index and monitoring configuration.

```markdown
# Monitored Pages

| Page slug | URL | Monitor | Priority | Source | Last crawled | Notes |
|-----------|-----|---------|----------|--------|--------------|-------|
| homepage | https://example.com/ | true | high | manual |  | Baseline page |
```

Rules:

- Keep `Page slug` stable. It is used in snapshot/change paths.
- Homepage should be present for every monitored competitor.
- Discovered pages start with `Monitor=false` until the user approves them.
- Use `Priority=high|normal|low`.

## Snapshots

Path:

`snapshots/{page-slug}/{YYYY-MM-DDTHHMMSSZ}.md`

Frontmatter:

```yaml
---
page_slug:
url:
crawled_at:
status: success
content_hash:
word_count:
source_tool:
---
```

Body is cleaned Markdown page content. Keep raw snapshots factual. Do not put
business interpretation here.

## Changes

Path:

`changes/{YYYY-MM-DDTHHMMSSZ}--{page-slug}.md`

Frontmatter:

```yaml
---
page_slug:
url:
previous_snapshot:
current_snapshot:
changed_at:
change_type: messaging
significance: significant
---
```

Allowed `change_type` values:

- `messaging`
- `offer`
- `pricing`
- `proof`
- `team`
- `partnership`
- `content`
- `page_removed`
- `technical`
- `unknown`

Allowed `significance` values:

- `significant`
- `minor`
- `review`

Body:

```markdown
# Change: {page title or page slug}

## Business Summary

2-3 sentences.

## What Changed

- Concrete observed change.

## Why It Matters

- Competitive implication for the firm.

## Evidence

- Previous: `{previous_snapshot}`
- Current: `{current_snapshot}`
```

## Merge Rules

- Timestamped snapshot/change files are append-only.
- If two people crawl the same page, keep both snapshots unless clearly
  duplicate.
- Resolve `pages.md` conflicts manually; it is the only likely shared-edit file.
- Do not store secrets or API responses with credentials in snapshots.
