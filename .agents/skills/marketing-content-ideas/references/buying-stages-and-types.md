# Buying Stages and Content Types

Canonical content-idea enums.

## Buying stages

| Key | Label | Content focus |
|-----|-------|---------------|
| problem | Stage 1: Problem Aware | Recognize and name the pain |
| concept | Stage 2: Solution Concept | Solution categories and approaches |
| education | Stage 3: Education | Deep dive, costs, risks |
| decision | Stage 4: Decision | Internal buy-in, business case |
| vendor | Stage 5: Vendor Selection | Differentiation, proof, comparison |

## Content types

| Key | Label |
|-----|-------|
| linkedin_post | LinkedIn Post |
| x_post | X (Twitter) Post |
| blog_post | Blog Post |
| case_study | Case Study |
| prospecting_sequence | Prospecting Email Sequence |
| landing_page | Service Page Opportunity |

## Stage restrictions

```yaml
landing_page: [vendor]
case_study: [decision, vendor]
# all other types: all stages
```

## Default idea batch (app form)

Only **enabled** types are generated. The default-enabled set is LinkedIn + X +
Blog (≈13 ideas). The other rows carry default counts but ship **disabled**.

| Type | Default count | Enabled by default? |
|------|---------------|---------------------|
| linkedin_post | 5 | yes |
| x_post | 5 | yes |
| blog_post | 3 | yes |
| case_study | 2 | no |
| landing_page | 0 | no |
| prospecting_sequence | 0 | no |

## Big 5 topics

cost, problems, comparisons, alternatives, reviews
