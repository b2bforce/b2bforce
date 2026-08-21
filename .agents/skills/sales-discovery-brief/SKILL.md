---
name: sales-discovery-brief
description: >-
  Turn call notes, an inbound email, or RFP text into a structured discovery brief
  for one opportunity, with a qualification verdict and the list of unanswered
  questions. Use when a prospect replies, a fit call happens, an RFP arrives, or
  before writing a proposal. Output to workspace/sales/opportunities/.
license: MIT
metadata:
  version: 1.0.0
  category: sales
---

# Discovery Brief

Captures what is actually known about one opportunity before anyone writes a
proposal. The brief is the input every later sales skill reads.

Most proposal time is lost to hunting for context, not to writing. A brief that
records the buyer's own words, the decision process, and — critically — what is
still unknown, is what makes a later proposal fast and specific.

## Read First

1. `workspace/firm/profile.md` — what the firm sells.
2. `workspace/firm/services/{slug}.md` — the candidate service, its fit and
   anti-fit criteria.
3. `workspace/marketing/icp/{slug}.md` and its personas — how this buyer type
   usually buys.
4. Existing folders in `workspace/sales/opportunities/` — do not open a duplicate.

## When to Use

- A prospect replied and there is something real to record.
- A fit or discovery call happened and notes exist.
- An RFP or inbound brief arrived.
- Someone wants a proposal and no brief exists yet.

## Core Rules

**Brand scope.** In a multi-brand workspace (2+ brand homes in `workspace/firm/brands/`), every path this skill reads or writes is brand-scoped: definitional entities (services, ICP, personas, proof, channels) live in `firm/brands/{brand}/…`, working pipelines carry a `{brand}/` segment under their entity root, and the working brand comes from the user's choice or `B2BFORCE_BRAND` — never guessed. Rules: Brand Scope Gate in `AGENTS.md`; paths: `docs/WORKSPACE.md`.

1. One opportunity = one folder. Do not create a folder per conversation.
2. **Record only what was said.** Everything else goes in `## Open questions`.
   A brief that reads as complete when it is not is how a firm ends up proposing
   into a decision process it never understood.
3. Never invent budget, timeline, decision makers, or competitors. Absent is
   `unknown`, not a guess.
4. Distinguish the buyer's words from your interpretation. Quote the buyer for the
   problem statement; put your reading under `## Firm assessment`.
5. Do not write a proposal in this skill and do not decide bid/no-bid here. Those
   are `sales-proposal` and `sales-bid-qualification`.

## Output

Folder: `workspace/sales/opportunities/{account}--{service}--{YYYY-MM}/`

File: `!_discovery.md`

The `!_` prefix marks it as needing attention until qualification runs, per the
repo's naming convention.

Frontmatter:

```yaml
---
account: acme-industrial
account_public: false
service: platform-migration
icp: mid-market-manufacturing
persona: cto-mid-market
source: inbound | referral | outbound | rfp | existing_client
opened: 2026-07-25
updated: 2026-07-25
budget_signal: unknown          # stated | range_hinted | unknown | no_budget
timeline_signal: unknown        # dated | quarter_hinted | unknown | no_timeline
decision_process: unknown       # mapped | partial | unknown
competitors_known: []
bid_decision: pending           # set by sales-bid-qualification
brief_quality: thin             # thin | workable | strong
---
```

Body sections:

```markdown
## Situation
## Problem in the buyer's words
## Impact
## Desired outcome
## Decision process
## Constraints
## Firm assessment
## Open questions
## Next action
```

Field-by-field rules and a worked example: `references/brief-fields.md`.

## Brief Quality

Set `brief_quality` honestly, because the Proposal Gate reads it.

| Value | Means |
|-------|-------|
| `thin` | Problem is vague, or no impact, decision process, and timeline |
| `workable` | Problem and desired outcome are concrete; one or two gaps remain |
| `strong` | Problem, impact, outcome, decision process, and constraints all recorded |

A `thin` brief is a normal first state after a short inbound email. Say what is
missing and what question would close the gap.

## Refuse To Proceed

If the user asks for a proposal from a `thin` brief, do not write one. Return the
three questions that would move the brief to `workable` and offer to draft the
follow-up message that asks them.

This refusal is the point of the skill. A proposal built on a thin brief is where
the average firm spends eight hours and loses.

## Workflow

### 1. Identify the opportunity

Slug the account in kebab-case. Pick the service the request most likely maps to;
if two services could fit, record both under `## Firm assessment` and let
qualification decide.

Check for an existing folder for the same account and service. If found, update it
instead of creating a second one.

### 2. Extract from the source

Work through the source material once, and write down only what is present:

- the problem, quoted where possible;
- what it costs them today — money, time, risk, or blocked work;
- what they say they want instead;
- who decides, who influences, and what has to happen for a yes;
- constraints: timing, budget, incumbent vendor, internal capacity, compliance.

For an RFP, also record the submission deadline, required format, and evaluation
criteria if stated.

### 3. Mark the gaps

Everything not stated goes under `## Open questions` as a question you would
actually ask, not a field name. "Who else has to approve this besides you?" beats
"decision process: unknown".

### 4. Assess fit

Compare against the service's fit and anti-fit criteria and the ICP. Write your
reading under `## Firm assessment` — including reasons this might not be a good
fit. Do not soften anti-fit signals; they are what makes the next step cheap.

### 5. Set the next action

One concrete next step with an owner. Then hand off to
`sales-bid-qualification`.

## Testing Requirements

1. Build a brief from a three-line inbound email; confirm `brief_quality: thin`
   and that `## Open questions` is the longest section.
2. Ask for a proposal from that brief; confirm the skill refuses and returns
   questions instead.
3. Build a brief from full call notes; confirm `workable` or `strong`.
4. Re-run for the same account and service; confirm it updates rather than
   creating a second folder.

## Reference Files

| File | Content |
|------|---------|
| `references/brief-fields.md` | Section rules, signal vocabularies, worked example |

## Related Skills

| Skill | When |
|-------|------|
| `sales-bid-qualification` | Next — decides bid or no-bid on this brief |
| `sales-proposal` | After a `bid` or `conditional` decision |
| `marketing-icp` | The ICP or persona for this buyer does not exist yet |
| `firm-context` | Firm profile or service definition missing |
