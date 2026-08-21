---
fixture: true
channel: blog
platform: blog
url: https://example.com/ferrymark/blog
status: active
content_types: [blog_post]
publish_via: cms
schedule: "One post every second Thursday, reviewed the Monday before"
---

# Channel — Ferrymark blog

## What to publish here

Long-form problem-stage pieces that answer one buyer question from a real
discovery call — release weekends, rollback, the two-person dependency. Nothing
promotional: the blog exists to save the first ten minutes of a discovery call,
not to advertise.

Never here: client figures outside `firm/proof/`, and no defect-rate promises.

## How publishing happens

Draft passes `scripts/validate-content-draft.sh`, a human review against the
firm profile's tone rules, then it is pasted into the CMS and the idea file
moves to `status: generated`. No scheduling tool — the blog cadence is slow
enough to publish by hand.

## Rhythm

One post every second Thursday. The draft is written the week before; skipping a
slot is fine, rushing one is not.
