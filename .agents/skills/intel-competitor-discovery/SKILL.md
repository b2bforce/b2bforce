---
name: intel-competitor-discovery
description: >-
  Discover new competitors via SERP results for a search phrase and location,
  deduplicate by root domain against already-monitored accounts, and propose
  candidates to add to monitoring. Use when the user wants to find competitors,
  research the market, or seed the monitoring list. Read firm profile first.
license: MIT
metadata:
  version: 1.0.0
  category: intelligence
---

# Competitor Discovery

Finds competitor candidates from search-engine results, so the user does not
have to know every competitor by name.

## Read Firm Context First

1. Read `workspace/firm/profile.md` — firm services, industry, geography, and the
   existing competitor list (used for deduplication).
2. Existing monitored competitors live in
   `workspace/intelligence/competitors/{slug}/!_profile.md`.

## When to Use

- User asks to **find / discover competitors** or **research the market**
- Seeding the monitoring list for a new firm
- Expanding monitoring around a specific service or keyword

## Workflow

### 1. Build the search phrase

From firm context: a service + geography phrase, e.g. `"drupal migration agency"`
or `"accounting firm Wroclaw"`. Ask the user to confirm or refine the phrase and
target country.

### 2. Fetch SERP results

Query a SERP API for the **top 10 organic results** (depth = 10) for the phrase
in the target country. Country is the SERP provider's full location name
(e.g. `United States`, `Germany`, `Poland`), not a country code.

- Requires `DATAFORSEO_LOGIN` / `DATAFORSEO_PASSWORD`.
- **Dry-run (no key):** ask the user for candidate URLs or use a provided list,
  and still run the dedup + profile steps below.

### 3. Process results

1. Extract **root domain** from each result URL (lowercase, strip leading `www.`).
2. **Group by domain** — one candidate per root domain. When several results
   share a domain, keep the **highest-ranked** one (lowest `position`).
3. **Deduplicate** against already-monitored accounts: in the app this is the set
   of existing monitored companies in the workspace (matched by root domain). In
   B2BForce, match against the competitor list in `workspace/firm/profile.md`
   and existing `workspace/intelligence/competitors/` slugs. Flag matches as
   `already_exists` and count `duplicates_skipped`.
4. Derive a candidate `name` from the result title (split on ` | `, ` - `,
   ` :: `, ` // `; fall back to the domain).

**Note:** the source pipeline does **not** auto-filter directories,
marketplaces, Wikipedia, aggregators (clutch.co, g2.com), or the firm's own
domain — every domain-grouped result is returned (duplicates flagged, not
removed). Dropping obvious non-competitors happens in the user review step
(§4), not automatically.

Return: `results[]` (name, domain, url, snippet, position, already_exists),
`total`, `duplicates_skipped`.

### 4. Present candidates and confirm

List candidates as a table (mark `already_exists` rows). **Do not auto-add** —
let the user pick which to monitor. This mirrors the source flow: the search
step returns candidates, and only an explicit confirm step creates accounts
(candidates already flagged `already_exists` are skipped on create).

### 5. Hand off to files-only monitoring

For each confirmed candidate, create
`workspace/intelligence/competitors/{slug}/!_profile.md` and
`workspace/intelligence/competitors/{slug}/pages.md`, then use
**`intel-competitor-monitoring`** to crawl. New competitors created from
candidates default to `monitoring_enabled: true`, `monitoring_frequency: weekly`,
and `company_type: competitor`. The homepage starts as the first monitored page
with `Monitor=true` and `Priority=high`.

Do not write to `.agents/firm-context.md`. If the firm profile needs a competitor
list, update `workspace/firm/profile.md`.

## Workspace Output

| Artifact | Path |
|----------|------|
| Discovery run | `workspace/intelligence/reports/discovery-{YYYY-MM-DD}-{phrase-slug}.md` |
| New competitor profile | `workspace/intelligence/competitors/{slug}/!_profile.md` |
| New page index | `workspace/intelligence/competitors/{slug}/pages.md` |

Discovery report frontmatter:

```yaml
---
phrase:
country:
total_results:
duplicates_skipped:
candidates_added: []
date: 2026-06-01
---
```

## Rules

1. **One candidate per root domain** — always dedupe.
2. Never add the firm's own domain.
3. Confirm with the user before adding to monitoring (no silent writes to the
   monitored list).
4. Respect rate limits; SERP discovery is a paid API call.

## Environment Variables

```bash
DATAFORSEO_LOGIN=
DATAFORSEO_PASSWORD=
```

## Related Skills

| Skill | When |
|-------|------|
| `firm-context` | Before discovery — services, geography, existing competitors |
| `intel-competitor-monitoring` | After discovery — crawl confirmed competitors |
| `intel-weekly-report` | Summarize changes across monitored competitors |
