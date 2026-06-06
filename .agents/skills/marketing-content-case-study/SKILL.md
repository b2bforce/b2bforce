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
- Real client proof before drafting if the idea uses placeholder proof

## Prompt layering

1. Base writer
2. Quality layer
3. **Case study format layer** → `references/format-requirements.md`

Follow the shared draft gate and writing quality rules in `docs/content-generation.md`.

## Proof gate

If `proof_source` says `needs real client proof before draft`, or the title contains
`[Client]`, stop. Ask for real client facts before writing:

- client name or approved anonymized label
- starting situation and business problem
- service delivered and timeline
- 2–3 real metrics, before/after facts, or qualitative outcomes
- approved quote or explicit note that no quote is available

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
