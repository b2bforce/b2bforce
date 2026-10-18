---
fixture: true
draft: why-your-monthly-release-still-takes-a-weekend
updated: 2026-07-16
---

# Sources: Why your monthly release still takes a weekend when you already have CI

External sources: none needed. The idea is `research_mode: dry_run`; every fact in the
draft is about the firm's own engagement and service.

## Questions

1. Why does a monthly release still take a weekend when the team already has CI?
2. What result did a comparable firm get, and is it usable in public?
3. What does the firm commit to, and what does it refuse to promise?

| ID | Claim (as it may appear) | Source | Excerpt (≤ 25 words) | Type | Tier | Accessed |
|----|--------------------------|--------|----------------------|------|------|----------|
| S1 | Northwind, 9 services: lead time 6 weeks → 4 days; regression on every PR; weekend window unused; CTO quote | northwind-release-automation | "Deployment lead time went from 6 weeks to 4 days. All 9 services run regression on every pull request." | proof | — | 2026-07-16 |
| S2 | Running two releases with the client's team decides whether the change holds | firm/services/platform-migration.md | "Two releases are run with the client's team rather than handed over as a document. This is usually what decides whether the change holds." | workspace | — | 2026-07-16 |
| S3 | The firm does not promise a defect-rate figure; it depends on the client's team | firm/services/platform-migration.md | "We do not promise a defect-rate percentage. It depends on how the client's team writes code after we leave" | workspace | — | 2026-07-16 |

## Unsupported

| Claim | Decision (opinion / cut) | Note |
|-------|--------------------------|------|
| The manual pass protects commercial correctness, cross-service order, and reversibility | opinion | Stated as the firm's diagnosis, not as a measured finding |
| Teams plan the release calendar around public holidays | opinion | Framed as a sign to look for, no frequency claimed |

## Rejected sources

| URL | Reason (T4/T5, echo, stale, no excerpt) |
|-----|------------------------------------------|
