# Marketing

*Visible expertise* — positioning, ICP, content, and landing pages (Maister).

| Subfolder | Purpose |
|-----------|---------|
| `icp/` | Ideal Customer Profiles and buyer personas |
| `content/ideas/` | Content ideas — filenames use `{content_type}--{buying_stage}--{slug}.md` |
| `content/drafts/blog/` | Blog posts (800–1500 words, Markdown) |
| `content/drafts/linkedin/` | LinkedIn posts (plain text, ~150–250 words) |
| `content/drafts/x/` | X/Twitter posts or threads (≤280 chars/tweet) |
| `content/drafts/case-studies/` | Case studies (PASTOR, vendor/decision stages) |
| `landing-pages/` | Standalone service pages from brief/service/URL + optional SERP |
| `placements/` | Third-party surfaces answer engines cite — one file per domain, with a status and an owner |
| `seo/` | Keyword research per topic |

## ICP first

ICP means the target client company segment. Personas mean the decision makers or
users inside that company.

Before content ideas, drafts, landing pages, or prospecting, create:

- `workspace/marketing/icp/{slug}.md`
- `workspace/marketing/icp/personas/{slug}.md`

Use `marketing-icp` after `workspace/firm/profile.md` and at least one
`workspace/firm/services/{slug}.md` exist. Do not generate content without a selected
service, ICP, and persona.

After generating ideas, run `scripts/validate-content-ideas.sh` before creating
drafts.

## Content types — different skills, different rules

Do not treat all drafts the same. See [docs/content-generation.md](../../docs/content-generation.md).

| Type | Skill | Key difference |
|------|-----------------|----------------|
| Blog | `marketing-content-blog-post` | Long Markdown; Exa reference articles |
| LinkedIn | `marketing-content-linkedin-post` | Plain text; stage-based frameworks; no Exa |
| X | `marketing-content-x-post` | Short/thread; no links in body |
| Case study | `marketing-content-case-study` | PASTOR; decision/vendor stages only |
| Service page | `marketing-service-page` | Brief/service/URL → optional SEO/SERP → differentiated copy |

Skills: `marketing-icp`, `marketing-content-ideas`, plus per-type content skills above.

## Two channels, not one

`seo/` optimizes for search results. `placements/` works on being cited by answer
engines, which is a different channel with surprisingly little overlap — only around a
tenth of what answer engines cite sits in the top 10 organic results.

For service-firm queries, third-party listicles and rankings collect more citations than
firms' own websites do, so `placements/` is about getting onto surfaces the firm does not
own. `intel-ai-visibility` measures where the firm stands; `marketing-geo-placement`
turns that into this folder.

The on-site half is the answer-first opening rule in
[docs/content-generation.md](../../docs/content-generation.md), which every long-form
draft follows.
