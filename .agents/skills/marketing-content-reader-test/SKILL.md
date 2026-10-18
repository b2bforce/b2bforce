---
name: marketing-content-reader-test
description: >-
  Review pass 4 for long-form content: hand the draft to a separate agent with no
  conversation context, reading as the target persona, and ask whether it answers
  the title's question, what is unclear, where they would stop reading, which claim
  is weakest, what sounds generated, and whether it reads as an ad for the firm.
  Compares the angle they read with the idea's. Use for a reader test, to check
  whether a post is clear, or to get a fresh read before publishing.
license: MIT
metadata:
  version: 1.0.0
  category: marketing
---

# Content Reader Test

Checks whether the text works on someone who has never seen the idea, the sources,
or this conversation. The writer sees what they meant to write; a fresh reader sees
only what is written. Of the four passes, this one tends to find the most.

Round, revision, and waiver rules: `docs/content-generation.md`, section "Review
passes".

## Inputs and output

| Reads | Writes |
|-------|--------|
| The draft; the persona file (who reads); the idea's `buyer_question` and `unique_angle` (for comparison only — the reader never sees them) | `## Reader test` section and `reader_test:` key in `{slug}.review.md` |

## Procedure

1. **Make the reader's copy** at `tmp/reader-test/{slug}.md`: strip HTML comments
   and all frontmatter except `title`. Keep `[ASK: …]` markers — the reader should
   notice them. Write the file rather than pasting text into the prompt: retyped text
   loses links and table cells, and the reader then reports problems that are not in
   the draft.
2. **Run a separate agent** (Agent tool / subagent) with no conversation context.
   The prompt holds only: the persona as a reader (role, company type, situation —
   from the persona file, without the angle or buyer question), the path to the
   reader's copy (and no other paths), and the questions below.
3. **Questions** — answer point by point, quoting the text:
   0. The title is "{title}". If you had typed this into a search engine, does the
      text answer it? Quote the sentence with the answer and give its paragraph. Is
      the text more about the question, or about the author's firm and its offer?
   1. What is the main point, in one sentence?
   2. What would you do differently in your company after reading it?
   3. What is unclear, or assumes knowledge you do not have?
   4. Where would you stop reading, and why?
   5. Which claim is the least supported?
   6. Does anything sound machine-generated? Quote it.
   7. Does the text contradict itself anywhere?
   8. Is the mention of the firm helpful or pushy?
   9. Score it 1–10 as something you would forward to a colleague.
4. **Compare the angle.** Set answer 1 against the idea's `unique_angle` and
   `buyer_question`: `match` (same meaning), `partial` (narrower, broader, or shifted
   emphasis), `mismatch`.
5. **No subagent available** (a chat in a browser, for example): give the user a
   ready prompt to paste into a new conversation, and wait for the answers.
6. Write the report. Do not edit the draft.

## Report

```markdown
## Reader test

- Round: N · Date: YYYY-MM-DD · Reader: {persona as described} · Fresh agent, no context
- Angle (idea): "…" · Angle (read): "…" · Match: match | partial | mismatch
- Score: n/10
- Verdict: pass | revise

### Reader's answers
### Fixes
| # | Place (quote) | Problem per the reader | Proposal |
|---|---------------|------------------------|----------|

### Earlier rounds
```

Set `reader_test: pass` or `reader_test: revise` in the frontmatter.

## Gate

Passes when, in question 0, the reader found a concrete answer to the title's question
in the first two paragraphs and did not read the text as being about the firm's
offer; the angle is `match`; the reader found no contradiction; and no `[ASK:]` is
left. A missing answer to the title, or "I would stop here because there is no
number", always blocks — it may not be moved to "for the author". Points from
questions 3–6 go to the drafting skill as fixes; the human decides which to apply.

A score that stalls around 7/10 over several rounds usually means the draft lacks a
real case, not better wording. Say so in the report, and ask for an `author` or
`proof` source rather than spending another round on phrasing.
