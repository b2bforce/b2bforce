# Source tiers

Used by `marketing-content-sources` (choosing) and `marketing-content-factcheck`
(verifying). The tiering idea and the T4/T5 rejection follow claude-blog
`blog-factcheck` (MIT).

| Tier | Examples | Decision |
|------|----------|----------|
| T1 | Product documentation, a regulator's page, a statute, a company's own post about its own product, a report with methodology from the people who ran it, public data | Preferred |
| T2 | Industry study with a stated methodology, peer-reviewed paper, an expert's book (cited with chapter) | Accept; record the methodology or chapter |
| T3 | Reputable newsroom that links to the primary source | Only when the primary is unreachable |
| T4 | Generic SEO blogs, affiliate rankings, vendor posts about the market with no source | Reject |
| T5 | Content farms, pages with no author and no sources, generated text | Reject |

Notes:

- A vendor's post about **its own** product is T1 for that product's features and
  T4 for market numbers ("70% of agencies…") it does not source.
- A social post (X, LinkedIn) proves someone said something, not that it is true.
  Cite it as that person's opinion, with their name, never as a fact.
- `workspace`, `proof`, and `author` rows carry no tier. They are accepted for
  claims about the firm, its services, and its clients — within the Proof Gate.
