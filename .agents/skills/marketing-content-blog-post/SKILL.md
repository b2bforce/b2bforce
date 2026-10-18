---
name: marketing-content-blog-post
description: >-
  Write an 800-1500 word B2B blog post in Markdown from a content idea. Use when
  content_type is blog_post. Applies stage-specific frameworks and Exa reference
  articles. Output to workspace/marketing/content/drafts/blog/. For LinkedIn or X
  use marketing-content-linkedin-post or marketing-content-x-post instead.
license: MIT
metadata:
  version: 1.0.0
  category: marketing
---

# Blog Post Generation

Long-form draft pipeline for a content idea of type `blog_post`.

## When to Use

- Idea file has `content_type: blog_post`
- User asks to write/expand a blog idea

## Prerequisites

- Content idea: `workspace/marketing/content/ideas/blog_post--{buying_stage}--{slug}.md`
- Firm, service, ICP, persona context in workspace
- Current agent/LLM session
- Optional: Exa reference notes via `tool-exa` for market-informed long-form drafts

## Prompt layering (order matters)

1. **Base writer** — style, storytelling, anti-AI-slop (no length)
2. **Quality layer** — universal quality + buying-mode tone
3. **Blog format layer** — **authoritative** length/structure → `references/format-requirements.md`

Optional: `workspace/firm/content-guidelines/blog-post.md` if exists (company overrides).

Follow the shared draft gate and writing quality rules in `docs/content-generation.md`.

## Sources

Run `marketing-content-sources` first. It writes `{slug}.sources.md` next to the
draft; the draft may state only what a row there supports (rules:
`docs/content-generation.md`, "Sources and support markers").

Optional **Exa reference articles:** search 5 results on idea title via `tool-exa`
for angle and structure benchmarking. They are not evidence. Do not plagiarize.

## User prompt template

```text
Write a Blog Post based on this content idea. Follow FORMAT REQUIREMENTS exactly.

=== CONTENT IDEA ===
Title: {title}
Description: {description}
Buying Stage: {stage label}
Buyer question: {buyer_question}
Unique angle: {unique_angle}
Proof source: {proof_source}
Next action: {next_action}
Research mode: {research_mode}
Target keyword: {if any}

=== CONTEXT ===
{company, service, ICP, persona from workspace}

=== SOURCES ===
{rows from {slug}.sources.md}

=== REFERENCE ARTICLES ===
{exa results or none}

Requirements:
- 800-1500 words, Markdown H2/H3
- Match buying stage framework (see format requirements)
- Brand voice from firm profile
- Hook opening — no generic intro
- Every factual claim rests on a row in SOURCES; end the paragraph with its
  marker, e.g. <!-- S2, S5 -->. Missing detail: [ASK: ...], never a plausible value
- Client proof only via proof rows (public use requires usable_publicly: true)
- CTA aligned to buying stage
- Language: {language}

Return JSON: { "title": "...", "body": "markdown..." }
```

## Output

**Brand scope.** In a multi-brand workspace the draft inherits the idea file's brand: write to `workspace/marketing/content/{brand}/drafts/…` — same brand segment as the idea. See the Brand Scope Gate in `AGENTS.md`.

`workspace/marketing/content/drafts/blog/{slug}.md`, with `{slug}.sources.md` and
`{slug}.review.md` beside it.

Frontmatter: `idea`, `content_type`, `buying_stage`, `service`, `icp`, `persona`,
`target_keyword`, `generated_at`.

Run `scripts/validate-content-draft.sh {output}`. Update idea frontmatter to
`status: generated` after the draft validates.

## Review

Run the four review passes and revise per `docs/content-generation.md`, "Review
passes": `marketing-content-factcheck`, `marketing-content-consistency`,
`marketing-content-deslop`, `marketing-content-reader-test`, all on the same draft
version each round, max 3 rounds. Revisions touch only what a report names. The draft
is publishable when `scripts/validate-content-draft.sh --reviewed {output}` passes.

## Related Skills

`marketing-content-ideas` (upstream) | `marketing-content-sources` (before) |
review passes (after) | other `marketing-content-*` for different types
