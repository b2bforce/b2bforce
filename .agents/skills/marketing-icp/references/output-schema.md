# ICP + Personas — Output Schema

Structured JSON for generation. Strip `reasoning` before persisting to workspace.

## Top level

```json
{
  "reasoning": "string (200+ words, analysis before generation — do not save to workspace)",
  "icp": { "...": "..." },
  "personas": [ { "...": "..." } ]
}
```

`personas`: min 1, max 3 items.

## ICP object

| Field | Notes |
|-------|-------|
| name | ICP segment name |
| industry | Segment industry/category |
| company_size | startup \| small \| medium \| large \| enterprise |
| buying_mode | reactive \| proactive \| mixed |
| buying_situation | Moment of truth that triggers active search |
| job_to_be_done | JTBD statement |
| pain_points | 3-7 specific pains |
| current_alternatives | Competitors, DIY, status quo |
| trigger_events | Specific, observable purchase triggers |
| goals | Business goals with measurable targets where known |
| success_metrics | KPIs they track |
| anti_fit_criteria | Disqualification signals |
| messaging_angle | Recommended messaging |
| geography | Regions |
| business_model | saas, agency, consulting, ecommerce, marketplace, subscription, product, service, hybrid, other, or null |
| ownership_type | public, private, pe_backed, vc_backed, startup, family, cooperative, nonprofit, government, or null |
| growth_stage | early, growth, mature, declining, turnaround, or null |
| tech_stack | Concrete tools/platforms when known |
| digital_maturity | low \| medium \| high \| advanced \| null |
| buying_motion | high_touch \| self_serve \| partner \| rfp \| procurement \| mixed \| null |
| budget_readiness | first_time \| switching \| upgrading \| consolidating \| null |
| sales_cycle_length | 1_week \| 1_month \| 1_3_months \| 3_6_months \| 6_12_months \| 12_plus \| null |
| average_deal_size | Nullable string, e.g. "$50k-$100k" |
| content_preferences | Formats they consume |
| preferred_channels | Where they discover/evaluate vendors |

## Persona object

| Field | Notes |
|-------|-------|
| name | Persona label |
| job_titles | 3-5 typical titles |
| seniority_level | c_level, vp, director, manager, senior_ic, ic |
| department | it, marketing, sales, finance, hr, operations, product, engineering, customer_success, legal, executive, other |
| pain_points | Role-specific frustrations |
| goals | 12-24 month goals |
| kpis | Metrics they own |
| decision_role | economic_buyer, technical_buyer, user_buyer, influencer, champion, gatekeeper, decision_maker, or null |
| fears_risks | What they fear if project fails |
| motivators | What drives them |
| success_definition | How they define success |
| change_readiness | innovator, early_adopter, early_majority, late_majority, laggard, or null |
| ai_attitude | enthusiast, optimist, neutral, cautious, skeptic, or null |
| content_formats | Preferred formats |
| channels | Where they spend time |
| research_habits | How they evaluate vendors |
| tone_preferences | Communication style |
| objections | Sales objections |
| value_proposition | What the firm offers them |
| proof_types | Evidence they trust |
