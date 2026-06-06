---
name: marketing-content-x-post
description: >-
  Write an X (Twitter) post or thread from a content idea. Use when content_type is
  x_post. Max 280 chars per tweet, no external links in body. Output to
  workspace/marketing/content/drafts/x/. For LinkedIn use marketing-content-linkedin-post.
license: MIT
metadata:
  version: 1.0.0
  category: marketing
---

# X (Twitter) Post Generation

Draft pipeline for a content idea of type `x_post`.

## When to Use

- Idea with `content_type: x_post`
- Single tweet or educational thread (8–12 tweets)

## Prerequisites

- Content idea + context files
- Current agent/LLM session
- **No Exa reference articles**

## Prompt layering

1. Base writer
2. Quality layer
3. **X format layer** → `references/format-requirements.md`

Follow the shared draft gate and writing quality rules in `docs/content-generation.md`.
Use `buyer_question`, `unique_angle`, `proof_source`, `next_action`, and
`research_mode` from the idea; do not write from title + description only.

## Platform rules (2026 algorithm)

- **No external links in tweet body** (kills reach — put link in first reply if needed)
- 1–2 hashtags max, at end
- 150–250 characters optimal per tweet
- Max **280 characters** per single tweet
- Threads: separate tweets with `---` divider in output file
- Reply/engagement hooks critical
- One idea per tweet — punchy lines

## Stage → hook pattern

| Stage | Hook type |
|-------|-----------|
| Problem | Data hook, Question hook |
| Concept | Contrarian hook |
| Education | Specificity hook, List thread (8–12 tweets) |
| Decision | Story hook |
| Vendor | Proof hook (soft CTA, no link in body) |

## Output

`workspace/marketing/content/drafts/x/{slug}.md` — plain text body

For threads, document tweet count in frontmatter.

Frontmatter: `idea`, `content_type`, `buying_stage`, `service`, `icp`, `persona`,
`generated_at`. Run `scripts/validate-content-draft.sh {output}` and update the
idea to `status: generated` after the draft validates.
