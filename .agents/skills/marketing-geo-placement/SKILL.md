---
name: marketing-geo-placement
description: >-
  Turn the domains answer engines actually cite into a ranked backlog of surfaces to get
  onto — listicles, directories, communities, review sites — each with an owner, a next
  action, and a status. Use after intel-ai-visibility, or when asked how to get
  recommended by AI, mentioned in LLM answers, or onto third-party rankings.
license: MIT
metadata:
  version: 1.0.0
  category: marketing
---

# GEO Placement

Converts visibility findings into work. Without this, `intel-ai-visibility` is a
dashboard in Markdown, and the repo already has an opinion about dashboards that
nobody acts on.

The reason this is the higher-value half: for service-firm queries, third-party
listicles and rankings collect a **larger share of citations than the firms' own
websites**, and community sources like Reddit are frequently the single most-cited
domain in a vertical. Meanwhile most cited domains appear in only one vertical — which
means there is usually **no entrenched incumbent** on the surfaces that matter for a
given niche. That is the opening, and it is the part on-site optimization cannot reach.

It also means the classic reflex — write more of our own content — is aimed at the
minority of citations. The firm's own site matters, but it is not where most of the
answer comes from.

## Read First

1. `workspace/intelligence/ai-visibility/runs/*/*.md` — the `cited_domains` from every
   run. This is the input; without runs there is nothing to rank.
2. `workspace/intelligence/ai-visibility/share-of-answer.md` — which prompts the firm
   loses, and to whom.
3. `workspace/marketing/placements/` — existing targets and their status.
4. `workspace/firm/profile.md` and `workspace/firm/services/*.md` — what the firm can
   credibly claim on a third-party surface.

If no runs exist, stop and run `intel-ai-visibility` first. Do not assemble a placement
list from general knowledge of directories — the point is the domains the engines cite
**for this firm's prompts**, which is rarely the obvious list.

## Ranking Targets

Count how often each domain is cited across runs, then weight by how reachable it is.
A domain cited twice that accepts submissions beats a domain cited five times that does
not take outside listings at all.

| `source_type` | What the firm can actually do |
|---------------|-------------------------------|
| `listicle` | Pitch inclusion in a "best {category}" roundup. Highest leverage, usually reachable. |
| `directory` | Complete and verify a profile. Slow, mechanical, and often effective — verified profiles attract materially more citations than bare ones. |
| `community` | Participate honestly where the firm has standing. Never astroturf. |
| `review_site` | Ask real clients for reviews — which is a `client-qbr` referral-adjacent ask, not a purchase |
| `publication` | Contribute or get quoted |
| `own_site` | Already the content pipeline's job; note it and move on |

Prioritize by `citation_count`, then by whether a competitor is already listed there.
A surface that cites a tracked competitor and not the firm is the clearest gap
available.

## Output

`workspace/marketing/placements/{domain}.md` — one file per domain, flat folder.

```yaml
---
domain: clutch.co
source_type: directory
citation_count: 14
prompts_cited_in: [best-drupal-migration-agency-mid-market, drupal-consultancy-poland]
competitors_present: [northwind-studio]
firm_present: false
status: new              # new | pitched | listed | declined | not_viable
action: Claim and verify the profile; add three client reviews.
owner: Marta
next_check: 2026-09-01
first_seen: 2026-07-25
updated: 2026-07-25
---
```

Body: what this surface is, why an engine cites it, what inclusion actually requires
(submission, pitch, payment, client reviews), and what was tried with the result.

`not_viable` is a real and useful status — a domain that does not accept outside
listings should be recorded once as closed rather than reappearing in every review.

### When the gap is content, not placement

Some prompts fail because the firm has nothing to cite, not because it is missing from
a directory. In that case do **not** invent a placement target. Append an idea to
`workspace/marketing/content/ideas/{content_type}--{buying_stage}--{slug}.md` with the
failing prompt as the `buyer_question`, and let the existing pipeline handle it.

That reuse is the point: the repo already has ideas → draft → validate. This skill adds
a source of demand for it, not a parallel content path.

## Rules

1. Only rank domains that appear in actual run files. Never add a directory because it
   is well known.
2. Never invent a citation count, and never claim the firm is listed somewhere without
   checking.
3. **No astroturfing.** Community placement means participating where the firm has
   genuine standing. Fake reviews, sockpuppet posts, and paid-for-organic-looking
   mentions are out — they are the fastest way to lose both the surface and the
   reputation the firm sells on.
4. Reviews come from real clients who agreed. Cross-check `referenceable` in
   `workspace/clients/{slug}/!_account.md` before asking.
5. This skill stops at the backlog. It does not write outreach emails —
   `sales-prospecting-sequence` owns outreach copy, and a pitch for inclusion is a
   different message from a sales sequence anyway.
6. One file per domain. Do not create a folder per domain; the flat folder plus
   frontmatter is the index.
7. Re-rank when a new batch lands, and move statuses rather than rewriting history.

## Measuring It

The only honest success metric here is placements moved `new` → `listed`, and then
whether the next `intel-ai-visibility` batch names the firm more often. Those are
different things and the second one lags by months.

Being listed is an **output**. Being named in answers is the outcome. If the firm wants
this tracked properly over time, that is `firm-pdca-setup` with `share-of-answer.md` as
the source of truth — not a number asserted in a report.

## Testing Requirements

1. Run with no `ai-visibility/runs/` present; confirm it stops and points at
   `intel-ai-visibility` instead of producing a generic directory list.
2. Run against runs citing one directory and one community domain; confirm both get a
   file with the correct `source_type` and a concrete `action`.
3. Confirm a domain cited for a competitor but not the firm is prioritized.
4. Confirm a prompt failing for lack of firm content produces a content idea rather
   than a placement file.
5. Confirm no `citation_count` appears that cannot be counted from run files.

## Related Skills

| Skill | When |
|-------|------|
| `intel-ai-visibility` | Produces the runs and cited domains this consumes |
| `marketing-content-ideas` | Receives gaps that are content problems, not placement problems |
| `client-qbr` | Where a real client review or reference is actually asked for |
| `intel-competitor-monitoring` | Which competitors to check each surface for |
| `firm-pdca-setup` | Tracks whether placements changed the visibility rate |
