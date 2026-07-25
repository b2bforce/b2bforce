---
name: intel-ai-visibility
description: >-
  Track whether answer engines name the firm — build a versioned panel of buyer-intent
  prompts, run them across ChatGPT/Claude/Gemini/Perplexity, and roll results into a
  share-of-answer table with citation rate and named competitors. Use for AI visibility,
  GEO/AEO monitoring, "do LLMs recommend us", or answer-engine share of voice.
license: MIT
metadata:
  version: 1.0.0
  category: intelligence
---

# AI Visibility

Answers one question on a schedule: **when a buyer asks an answer engine for a firm
like this one, does this firm get named?**

This is the same pattern as `intel-competitor-monitoring` — a versioned panel, dated
runs, a rollup — with prompts in place of URLs. Nothing new architecturally. The value
is in the panel design and in the measurement discipline below.

Buyers now shortlist inside chat sessions, and an answer engine returns four to seven
names where a search page returned ten links. A firm can run the entire content
pipeline in this repo, rank perfectly well, and be absent from that shortlist. Without
this skill the repo gives it no way to find out.

## Read First

1. `workspace/firm/profile.md` — firm name, aliases, domain, geography.
2. `workspace/firm/services/*.md` — what the firm actually sells.
3. `workspace/marketing/icp/*.md` and `icp/personas/*.md` — how buyers describe their
   problem, and their objections.
4. `workspace/marketing/content/ideas/*.md` — every idea carries a `buyer_question`.
   These are already real buyer phrasings; do not invent new ones while they exist.
5. `workspace/intelligence/competitors/*/!_profile.md` — the named set to measure
   against. Share of answer is only meaningful relative to somebody.

The Firm Context Gate and ICP Gate apply. A prompt panel built without ICP context is
a list of keywords with question marks.

## Measurement Discipline

The rules that keep this skill from producing a misleading artifact. Non-negotiable,
because an answer engine is **non-deterministic**: three runs of one prompt give three
answers.

1. **Never report a single run as truth.** A run is one sample.
2. **Minimum three runs per prompt per engine** before reporting presence or a trend.
3. **Report a rate, never a boolean.** "Named in 2 of 3 runs" is a finding. "We are in
   ChatGPT" is not a claim this data supports.
4. **The first batch is a baseline.** No drift claims, exactly as the first competitor
   crawl stores a snapshot and raises no alert.
5. **Every run records `engine`, `model`, `run_index`, and the date.** A result without
   these is unusable, because engines and model versions change underneath the panel.
6. **Never paraphrase an answer into a verdict.** Store the verbatim response. The
   wording is the evidence, and a summary of it is the agent's opinion.
7. **A missing mention is not proof of absence** — it is one sample where the firm was
   not named. Say it that way.

This matters more here than in most skills. Everything else in this repo refuses to
invent client results; an AI-visibility artifact that reports one lucky run as
"we rank in ChatGPT" would be the same failure wearing a dashboard.

## The Prompt Panel

`workspace/intelligence/ai-visibility/!_prompts.md` — versioned, committed, and stable.
Week-to-week runs are incomparable if the panel drifts, so changing a prompt means
adding a new one and retiring the old, never editing in place.

**15–30 prompts, maximum 30.** The same discipline as "5–20 monitored pages is enough".

Each prompt is what a **buyer** would type, not what the firm would like to rank for:

| Prompt type | Example shape |
|-------------|---------------|
| Category shortlist | "best {service} agency for {icp descriptor}" |
| Geographic | "{service} consultancy in {region}" |
| Problem-led | the `buyer_question` from a content idea, verbatim |
| Comparison | "{competitor} alternatives for {icp}" |
| Objection | the objection from a persona file, phrased as a question |
| Vendor-check | "is {firm} a good choice for {problem}" |

The last type is the weakest signal and easy to over-read: an engine asked directly
about a named firm will usually say something positive. Keep at most two.

The API caps a prompt at **500 characters**. Longer prompts are rejected rather than
truncated, so runs stay comparable.

```yaml
---
engines: [chat_gpt, perplexity]
runs_per_prompt: 3
country: PL
cadence: monthly
firm_aliases: ["Acme Digital", "Acme Digital sp. z o.o.", "acmedigital.com"]
competitors: [northwind-studio, meridian-labs]
panel_version: 2
updated: 2026-07-25
---
```

Body: a table of `prompt_slug | prompt | type | service | icp | status`, where `status`
is `active` or `retired`. Retired rows stay for history.

`firm_aliases` matters more than it looks. An engine may name the firm without its
legal suffix, or cite the domain without naming the company, and a panel that only
matches the exact registered name will under-count.

## Running A Batch

```bash
S=.agents/skills/tool-dataforseo/scripts

# Confirm which models the engine currently accepts — names drift
bash $S/llm-response.sh --models chat_gpt

# One run
bash $S/llm-response.sh chat_gpt "best drupal migration agency for mid-market retail" PL
```

Cost is the argument for doing this in the repo at all: DataForSEO's LLM Responses API
is fractions of a cent per request plus model tokens, so 30 prompts × 2 engines × 3
runs is a few dollars a month. The SaaS category for the same job averages a few
hundred dollars a month. This is the sharpest available illustration of the repo's
"no subscription, no vendor lock-in" claim — a whole product category replaced by an
API call and a folder of Markdown the firm owns.

### Without an API key

This is the one workflow in this repo that is materially worse without a paid key. Be
honest about it rather than papering over it:

- Ask the current agent session the prompts directly, record `engines: [current-session]`,
  and state in the rollup that coverage is one engine and grounding is unverified.
- A session-only panel measures a single model, often without live web search. It is a
  starting point, not a visibility measurement, and the rollup must say so.

Do not present a degraded run as equivalent. The repo's FAQ says paid keys are
optional, which stays true — this workflow just gets a weaker answer without one.

## Output

### Run file — one per prompt per batch

`workspace/intelligence/ai-visibility/runs/{YYYY-MM-DD}/{prompt-slug}.md`

**All engines and all runs for that prompt go in one file.** Splitting per engine per
run would produce roughly 180 files a month, which collides with the Minimal Files
Rule for no benefit. One file per prompt per batch keeps it at panel size.

```yaml
---
prompt_slug: best-drupal-migration-agency-mid-market
prompt: "best drupal migration agency for mid-market retail"
batch: 2026-07-25
country: PL
firm_mentioned_runs: 1
total_runs: 6
engines: [chat_gpt, perplexity]
competitors_mentioned: [northwind-studio]
cited_domains: [clutch.co, reddit.com, g2.com]
---
```

Body: one `## {engine} · run {n} · {model}` section per run, each with the **verbatim**
answer, its cited sources, and a one-line note on whether the firm or a tracked
competitor appears. No summarizing across runs here — that is the rollup's job.

### Rollup

`workspace/intelligence/ai-visibility/share-of-answer.md`

Append-only, one row per prompt per batch. Past rows are never rewritten — the history
is the point, and rewriting it destroys the only trend data the firm has.

```markdown
| Batch | Prompt | Engine | Firm named | Rate | Rank | Competitors named | Top cited |
|-------|--------|--------|-----------:|-----:|-----:|-------------------|-----------|
| 2026-07-25 | best-drupal-migration-agency-mid-market | chat_gpt | 1/3 | 33% | 4 | northwind-studio (3/3) | clutch.co |
```

Then a short **Findings** section, and only claims the runs support:

- citation rate — share of active prompts where the firm was named in at least one run;
- share of answer against each named competitor;
- which domains the engines cite, which is the input to `marketing-geo-placement`;
- prompts where the firm never appears — the actual work list.

Do not compute a trend from fewer than two batches, or from fewer than three runs.

## Retention

Rollup rows are kept permanently. Raw run folders older than **six months** may be
deleted — they are bulky, the rollup carries the finding, and a verbatim answer from an
engine version that no longer exists has little value. Say so before deleting.

## Rules

1. The panel is capped at 30 active prompts and changes by adding and retiring, never
   by editing a prompt in place.
2. Minimum three runs per prompt per engine before any presence or trend claim.
3. Store verbatim answers. Never store a paraphrase as the result.
4. Match against `firm_aliases`, not just the registered name.
5. Never fabricate a run, a citation, or a competitor mention. A failed request is a
   run note with `status: error`, exactly as a failed crawl is.
6. This skill observes. It does not write content, pitch anyone, or edit the website —
   `marketing-geo-placement` and the content skills act on the findings.
7. Tactics in this area change fast. Note the date of any benchmark used, and re-check
   the approach yearly rather than trusting a number in this file forever.

## What This Does Not Do

**No `llms.txt` generation.** It is widely recommended and there is still no confirmed
evidence that major answer engines consume it; Google has said publicly that it does
not. Shipping it as a feature would be cargo cult in a repo whose whole argument is
that outputs are not outcomes. If a firm wants one, it is a five-minute manual file.

**No ranking guarantee.** Nothing here makes an engine name the firm. It tells the firm
whether it is named, and where the engines are looking instead. Acting on that is
`marketing-geo-placement` and the content pipeline.

## Related Skills

| Skill | When |
|-------|------|
| `marketing-geo-placement` | Turns `cited_domains` into a backlog of surfaces to get onto |
| `tool-dataforseo` | `llm-response.sh` — the engine calls |
| `intel-competitor-monitoring` | Supplies the named competitor set, and the pattern this copies |
| `intel-weekly-report` | Reports visibility drift alongside competitor changes |
| `marketing-content-ideas` | Supplies `buyer_question` values, and receives gaps back |
| `marketing-seo-research` | The classic-search counterpart; different channel, same buyer |
