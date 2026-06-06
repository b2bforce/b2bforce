# Content Ideas — Output Schema

Strict JSON for structured AI output.

```json
{
  "ideas": [
    {
      "title": "string",
      "description": "string (2-3 sentences)",
      "buying_stage": "problem|concept|education|decision|vendor",
      "content_type": "linkedin_post|x_post|blog_post|case_study|landing_page|prospecting_sequence",
      "hook_type": "data|question|contrarian|specificity|problem|story",
      "buyer_question": "string",
      "unique_angle": "string",
      "proof_source": "string|null",
      "next_action": "string",
      "recommended_next_skill": "marketing-content-blog-post|marketing-content-linkedin-post|marketing-content-x-post|marketing-content-case-study|marketing-service-page|sales-prospecting-sequence",
      "research_mode": "dry_run|market_informed",
      "big5_topic": "cost|problems|comparisons|alternatives|reviews|null",
      "target_keyword": "string|null"
    }
  ]
}
```

All fields required in strict mode (nullable types use `"type": ["string", "null"]` in OpenAI schema).

When user specifies type counts, restrict `content_type` enum to requested types only.

## Stage validation (enforce after generation)

| content_type | Valid buying_stage |
|--------------|-------------------|
| landing_page | vendor |
| case_study | decision, vendor |
| others | any |

Reject or regenerate ideas that violate this table.

## SEO validation

`target_keyword` is only allowed for `blog_post` and `landing_page`. It must be
`null` for LinkedIn, X, case study, and prospecting ideas.

## Recommended next skill

| content_type | recommended_next_skill |
|--------------|------------------------|
| blog_post | marketing-content-blog-post |
| linkedin_post | marketing-content-linkedin-post |
| x_post | marketing-content-x-post |
| case_study | marketing-content-case-study |
| landing_page | marketing-service-page |
| prospecting_sequence | sales-prospecting-sequence |
