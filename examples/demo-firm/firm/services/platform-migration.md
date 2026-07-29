---
fixture: true
label: Platform migration and release automation
service_type: project
source_url: https://example.com/ferrymark/platform-migration
target_icps: [mid-market-logistics]
---

# Platform migration and release automation

## Main problem

A logistics platform that ships once a month, over a weekend, with a manual
regression pass. The release process consumes senior capacity, blocks the roadmap,
and depends on two people personally.

## Job to be done

Move the client from a manual, weekend-bound release to an automated pipeline their
own engineers run on a weekday slot.

## Expected outcomes

- Releases on a fixed weekday slot with no scheduled overtime.
- Regression running automatically on every pull request.
- Rollback a single engineer can trigger without a runbook.
- The engineers who hold the process today stop being the constraint.

We do not promise a defect-rate percentage. It depends on how the client's team
writes code after we leave, and a number we cannot control is not an outcome to
sell.

## Process

1. Baseline and risk map — instrument the current process before changing it.
2. Automated regression on the commercially critical services first.
3. Pipeline and release mechanics, including staged rollout and rollback.
4. Handover: two working sessions, runbook in the client's repository, manual
   process formally retired.

## Deliverables

Written baseline with timings, automated regression suites for the critical path,
pipeline in the client's existing CI, two supervised production releases, runbook
committed to the client's repository, two recorded handover sessions.

## Differentiators

- Two releases are run *with* the client's team rather than handed over as a
  document. This is usually what decides whether the change holds.
- The runbook lives in the client's repository, not ours.
- A principal is on the engagement four days a week throughout.

## Fit criteria

- 8–40 in-house engineers, so there is a team to hand over to.
- An existing CI system, even a neglected one.
- A named technical contact with four hours a week available.
- Releases are a stated business problem, not an engineering preference.

## Anti-fit criteria

- No in-house engineering team — there is nobody to hand the pipeline to.
- The client wants seats filled rather than a process changed.
- A platform rewrite is planned in the same quarter.
- Release pain is a symptom of an unresolved architecture decision the client is
  not ready to make.

## Proof points

- `northwind-release-automation` — release automation for a mid-market freight
  platform, publicly usable.

Cite these by slug. The numbers live in the proof records, not here.
