---
name: marketing-content-case-study
description: >-
  Write a B2B case study (500-1500 words, PASTOR framework) from a content idea.
  Use when content_type is case_study and buying_stage is decision or vendor.
  Uses Exa reference articles. Output to workspace/marketing/content/drafts/case-studies/.
license: MIT
metadata:
  version: 1.0.0
  category: marketing
---

# Case Study Generation

Draft pipeline for a content idea of type `case_study`.

## When to Use

- Idea with `content_type: case_study`
- Buying stage must be **decision** or **vendor** only

## Prerequisites

- Valid content idea (stage check)
- Firm/service/ICP/persona context
- Current agent/LLM session
- Optional: Exa reference notes via `tool-exa` for quality benchmarks
- A record in `workspace/firm/proof/` with `usable_publicly: true` when the idea
  uses placeholder proof

## Prompt layering

1. Base writer
2. Quality layer
3. **Case study format layer** → `references/format-requirements.md`

Follow the shared draft gate and writing quality rules in `docs/content-generation.md`.

## Proof gate

If `proof_source` says `needs real client proof before draft`, or the title contains
`[Client]`, do not ask the user to retype the facts yet — **read
`workspace/firm/proof/` first**. See the Proof Gate in `AGENTS.md`.

1. Look for a record matching this service and ICP.
2. A case study is public material, so it requires `usable_publicly: true`. A
   record with `usable_publicly: false` may not be drafted into a case study even
   though a private proposal could cite it.
3. Name the client only with `client_public: true`; otherwise use the record's
   approved anonymized label.
4. Quote the client only with `quote_approved: true`.
5. Use only metrics with `verified: true`.

If no usable record exists, stop and ask for the client facts, then have
`sales-outcome-log` write them to `workspace/firm/proof/` before drafting. Recording
them once is what stops this gate from blocking every future case study.

Facts needed for a record: client name or approved label, starting situation,
service delivered, timeline, 2–3 real metrics, and an approved quote or a note that
none is available.

Do not invent metrics, quote, client name, industry, timeline, or result.

## PASTOR structure (required)

- **P** Problem — client challenge with context
- **A** Amplify — consequences (revenue, team, risk)
- **S** Solution — your process/approach
- **T** Transformation — results with **metrics** (%, $, time)
- **O** Offer — how reader gets similar results
- **R** Response — clear CTA

## Must include

- 2–3 quantifiable metrics when real metrics are available; otherwise use verified
  qualitative outcomes and state proof limits plainly
- At least 1 client quote only when supplied or approved
- Before vs after comparison
- Timeline of engagement

## Research

Optional Exa: 5 reference case studies/articles on topic for quality benchmark
(do not copy).

## Output

`workspace/marketing/content/drafts/case-studies/{slug}.md` — Markdown

Headline pattern: "[Client Result] in [Timeframe]" or "How [Client] Achieved [Result]"

Frontmatter: `idea`, `content_type`, `buying_stage`, `service`, `icp`, `persona`,
`generated_at`. Run `scripts/validate-content-draft.sh {output}` and update the
idea to `status: generated` after the draft validates.
