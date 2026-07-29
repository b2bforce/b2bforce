---
fixture: true
idea: blog_post--problem--why-your-monthly-release-still-takes-a-weekend
content_type: blog_post
buying_stage: problem
service: platform-migration
icp: mid-market-logistics
persona: cto-mid-market-logistics
target_keyword: release process automation logistics platform
language: en
proof_refs: [northwind-release-automation]
generated_at: 2026-07-16
---

# Why your monthly release still takes a weekend when you already have CI

CI running your tests and your release being automated are different things. Most
mid-market logistics teams have the first and assume it delivers the second. The
weekend survives because CI never replaced the manual regression pass — it runs
beside it, and a human still decides whether the release is safe to ship.

That decision is the weekend. Not the test run.

## The part CI did not take over

When a platform grows one service at a time, the regression pass grows with it as a
human activity. Someone opens the dispatch board and checks that yesterday's orders
still route. Someone prices a shipment by hand and compares it to last month's
invoice. Someone confirms that the warehouse integration still acknowledges a pick.

None of these were written down as tests, because each one started as a sensible
thing to check once. CI arrives later and covers the code that was easiest to test:
unit tests on rating logic, maybe a smoke test on the API. It does not cover the
three checks above, so the checks stay manual, and the release stays tied to whoever
performs them.

You can tell this is the situation when the release calendar is planned around
public holidays rather than around business need. A team whose release genuinely runs
itself does not care which weekend it is.

## Three things the manual pass is actually protecting

It is worth being precise about what the weekend buys you, because that is what has
to be replaced. In this segment it is almost always the same three.

**Commercial correctness.** Rating and invoicing errors do not fail loudly. They
produce plausible numbers that reach a customer. A unit test on the rating function
does not catch a misconfigured tariff table, and the person doing the manual pass
knows what last month's invoice should look like.

**Cross-service order.** Dispatch, warehouse, and billing are separate services that
agree on the shape of an order. The manual pass is the only place where all three are
exercised together, which is why it takes a weekend rather than an afternoon.

**Reversibility.** There is no rollback path, so the manual pass is functioning as
the last chance to catch a problem before it becomes an incident someone fixes
forward at 22:00 on a Sunday.

Any plan that automates the tests but leaves the third one manual will not retire the
weekend. The team will keep the manual pass as insurance, correctly, and now they
maintain two processes instead of one.

## Why "we'll do it in a quiet quarter" does not happen

Every CTO in this position has a version of this plan, and it has usually been in
place for two or three quarters. The reason it does not land is not discipline. It is
that the work has to be done by the two people who already run every release, and
those two are the constraint on the roadmap as well.

So the automation work competes with the roadmap for the same two calendars, and the
roadmap wins, because the roadmap has a customer attached to it. Meanwhile the
dependency on those two engineers grows, and at some point one of them takes a call
from a recruiter.

That is the real cost, and it is not on the release calendar anywhere.

## What replacing it looks like in practice

The sequencing matters more than the tooling. Automate the commercially dangerous
paths first — rating, invoicing, dispatch — because they are the reason the pass
exists. Build the rollback path before you retire anything, because rollback is what
lets the team stop treating the manual pass as insurance. Then run two real releases
on the new pipeline while the old process is still available.

Running those two releases together, rather than delivering a document, is usually
what decides whether the change survives contact with the team's next busy month.

We did exactly this at Northwind Logistics, a mid-market freight operator with 9
services in the release. Deployment lead time went from 6 weeks to 4 days, all 9
services now run regression on every pull request, and the weekend release window has
not been used since. Their CTO put the outcome more plainly than we would:

> "We stopped planning releases around public holidays."
> — Anna Kowalska, CTO, Northwind Logistics

What we did not promise them, and would not promise you, is a defect-rate figure.
That depends on how your team writes code after we leave. The mechanism is what can
be committed to: which checks must pass, running automatically, on every change.

## FAQ

### Does this mean our CI setup was wrong?

No. It means CI covered the code and not the release decision. The existing pipeline
is usually the right foundation, and most of this work extends it rather than
replacing it.

### Can we do this one service at a time?

Yes, and you should. Start with the services where a defect has commercial
consequences. The manual pass shrinks in proportion, so the weekend gets shorter
before it disappears.

### How long does the manual process stay as a fallback?

Until two releases have shipped on the new pipeline and the rollback path has been
used at least once deliberately. Retiring it before that is how teams end up
reinstating it.

### What if our platform is genuinely unusual?

The dispatch and rating domain often is. The release process rarely is. If the
constraint turns out to be an architecture decision you have not made yet,
automating around it is the wrong order of work, and that is worth finding out in a
conversation rather than in an engagement.

## Where to start this week

Time your next release honestly: how long each manual check takes, who performs it,
and which ones would have caught a real defect in the last six months. That list is
the scope of the problem, and you can produce it without hiring anyone.

If the list has more than five items on it and both names next to them are the same
two engineers, that is the point at which teams in this segment usually stop planning
to do it in a quiet quarter.
