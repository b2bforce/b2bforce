---
name: marketing-content-linkedin-post
description: >-
  Write a LinkedIn post (150-250 words, plain text) from a content idea. Use when
  content_type is linkedin_post. No Exa research. Stage-specific frameworks apply.
  Output to workspace/marketing/content/drafts/linkedin/. Not for blog or X formats.
license: MIT
metadata:
  version: 1.0.0
  category: marketing
---

# LinkedIn Post Generation

Draft pipeline for a content idea of type `linkedin_post`.

## When to Use

- Idea with `content_type: linkedin_post`
- User wants LinkedIn-native copy (not cross-posted blog summary)

## Prerequisites

- Content idea file + firm/service/ICP/persona context
- Current agent/LLM session
- **Do NOT** run Exa reference search (skipped for this type)

## Prompt layering

1. Base writer (style only)
2. Quality layer
3. **LinkedIn format layer** → `references/format-requirements.md`

Optional: `workspace/firm/content-guidelines/linkedin-post.md`

Follow the shared draft gate and writing quality rules in `docs/content-generation.md`.
Use `buyer_question`, `unique_angle`, `proof_source`, `next_action`, and
`research_mode` from the idea; do not write from title + description only.

## Output format (critical)

- **Plain text** — NOT Markdown headers
- One sentence per line
- 150–250 words optimal; max ~300 words / 3000 chars
- 0–2 emojis if brand-appropriate
- 2–3 hashtags at end
- Engagement question at end
- **No bullet lists** (hurts engagement)
- First-person voice (I, we, you)

## Stage → framework (from format prompt)

| Stage | Framework |
|-------|-----------|
| Problem | Story Hook, Poll |
| Concept | Category, This-vs-That |
| Education | Framework, How-To |
| Decision | Comparison, Data |
| Vendor | CSR, Behind-the-Scenes |

## Output path

`workspace/marketing/content/drafts/linkedin/{slug}.md`

Frontmatter: `idea`, `content_type`, `buying_stage`, `service`, `icp`, `persona`,
`generated_at`. Body = plain text only. Title in frontmatter for filing.

Run `scripts/validate-content-draft.sh {output}`. Update idea frontmatter to
`status: generated` after the draft validates.

## Related Skills

`marketing-content-x-post` — different length/platform rules
