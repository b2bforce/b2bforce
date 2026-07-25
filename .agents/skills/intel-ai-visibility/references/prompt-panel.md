# Prompt Panel Design And Mention Counting

Two things this file exists for: building a panel that measures something, and counting
a mention consistently enough that month-to-month numbers mean anything.

## Building The Panel From Files The Repo Already Has

Do not brainstorm prompts. Derive them, so the panel stays tied to the firm's actual
market rather than to whatever the agent found plausible.

| Source | What to take | Becomes |
|--------|--------------|---------|
| `workspace/firm/services/{slug}.md` | the service noun a buyer would use | category and geographic prompts |
| `workspace/marketing/icp/{slug}.md` | industry, size, geography | the qualifier in "for {icp descriptor}" |
| `icp/personas/{slug}.md` | objections, verbatim | objection prompts |
| `workspace/marketing/content/ideas/*.md` | `buyer_question`, verbatim | problem-led prompts |
| `workspace/intelligence/competitors/*/` | competitor names | comparison prompts |

Use the buyer's noun, not the firm's. A firm selling a "platform modernization
engagement" is searched for as "drupal migration agency". If the service file uses
internal language, the prompt uses the buyer's.

### Coverage worth having

A 30-prompt panel spread across every service is thinner than a 15-prompt panel covering
the two services that actually pay the bills. Start with one service and one ICP, and
add breadth only once a batch has told you something.

Rough shape for a single service:

- 4–6 category shortlist prompts at different qualifiers (size, industry, geography)
- 3–5 problem-led prompts taken from real `buyer_question` values
- 2–3 comparison prompts against named competitors
- 2–3 objection prompts
- at most 2 vendor-check prompts

### Prompts that waste money

- **Head terms with no buyer intent** — "digital transformation". Nobody shortlists from
  that answer.
- **Anything the firm would like to be asked** rather than what buyers ask. The panel is
  a measurement instrument, not a wish list.
- **Prompts naming the firm** beyond the two vendor-checks. An engine asked about a
  named firm will usually find something nice to say, which measures nothing.
- **Prompts over 500 characters.** The API rejects them, and a shortened prompt breaks
  comparability with earlier batches.

## Counting A Mention

The part that quietly decides whether the numbers are trustworthy. Decide once, write it
in `!_prompts.md`, and apply it the same way every batch.

### Firm mentioned

Count a mention when the answer names the firm via any entry in `firm_aliases`, or cites
the firm's own domain. Three cases to handle explicitly:

| Case | Count as |
|------|----------|
| Named in the recommendation list | `mentioned: true` |
| Domain cited as a source but firm not named in prose | `mentioned: cited_only` |
| Named only in a caveat ("smaller shops like X may not scale") | `mentioned: true`, and note the framing |

`cited_only` is worth tracking separately. Being a source the engine reads is a
different position from being a name it recommends, and the two move independently.

A negative or hedged mention still counts as a mention. Record the framing in the run
note rather than silently dropping it — being named unfavorably is a finding, and
scoring it as absence hides it.

### Rank

Rank is the firm's position in the answer's list of recommended providers.

- Numbered or bulleted list → the position, counting only provider names.
- Prose with providers in sentence order → position in that order, and mark it
  `rank_basis: prose`.
- Mentioned but not as a recommendation → no rank. Leave it empty; do not write `99`
  or invent a floor value, because it will be averaged later.

Averaging ranks across engines is misleading and should not appear in the rollup.
Report per engine.

### Competitors

Count only competitors that have a folder in `workspace/intelligence/competitors/`. An
unknown name appearing repeatedly is a finding of its own: it means the firm's competitor
set is out of date, and `intel-competitor-discovery` should run.

## Reading A Batch Honestly

Three questions, in order:

1. **Is the firm named anywhere?** If not, the problem is presence, and the answer is
   almost always third-party surfaces — `marketing-geo-placement`.
2. **If named, is it named consistently?** 1 of 3 runs is fragile presence, not
   presence. It usually means the firm is a marginal candidate rather than an
   established one.
3. **Where is the engine looking?** The cited domains are the most actionable output in
   the whole batch and the part no on-site work can substitute for.

What a batch cannot tell you: why. Engines do not explain themselves, and an inferred
causal story about a ranking change is speculation. Record what changed and what the
firm did; do not narrate a mechanism.

## Cadence

Monthly is right for most firms. Weekly costs more, adds noise from
non-determinism rather than signal, and nothing a firm does in this area moves in a
week — placements take weeks to land and longer to affect answers.

Re-run the full panel in one batch on one date. A panel spread across a fortnight is not
a batch, because the engines changed underneath it.
