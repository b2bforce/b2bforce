---
name: marketing-positioning
description: >-
  Work out a positioning statement for the whole firm, one department (several
  services), or one service: list what buyers chose instead of the firm, the
  differences against those alternatives, a proof record for each difference, and
  only then the one-sentence statement. Use when positioning is missing, reads like
  every competitor's, a service or department needs its own "why us", or the user
  asks for a positioning statement, differentiation, or "how do we stand out".
license: MIT
metadata:
  version: 1.0.0
  category: marketing
---

# Positioning

One workflow: five steps from the buyer's alternatives to one sentence, written to a
positioning record. Method: April Dunford, *Obviously Awesome* — alternatives first,
the sentence last. A template filled in from memory produces filler; that is the
failure this skill exists to prevent.

Record schema, scope limits, body format, and the resolution order:
`docs/WORKSPACE.md`, "Positioning record". Rules: "Positioning" in `AGENTS.md`.

## When to Use

- No record in `workspace/firm/positioning/` yet, or only the prose in
  `firm/profile.md`
- A service or department needs its own statement — a firm that sells five things
  rarely has one sentence true for all five
- After several won or lost outcomes, when the alternatives buyers named have changed
- `firm-context` setup finished and the profile has no worked positioning

## Prerequisites

**Brand scope.** In a multi-brand workspace (2+ brand homes in `workspace/firm/brands/`), every path this skill reads or writes is brand-scoped: definitional entities (services, ICP, personas, proof, channels, positioning) live in `firm/brands/{brand}/…`, working pipelines carry a `{brand}/` segment under their entity root, and the working brand comes from the user's choice or `B2BFORCE_BRAND` — never guessed. Rules: Brand Scope Gate in `AGENTS.md`; paths: `docs/WORKSPACE.md`.

1. Firm Context Gate passes: `workspace/firm/profile.md` and at least one service.
2. The services in scope exist and declare `target_icps`. If the ICP is missing, run
   `marketing-icp` first — never write an ICP inline here.
3. Read, for the services in scope:
   - `sales/opportunities/*--{service}--*/outcome.md` — `competitor`,
     `reason_stated`, `reason_assessed`
   - `sales/opportunities/*--{service}--*/!_discovery.md` — the situation and the
     buyer's words about what they do today
   - `firm/proof/` — records whose `service` is in scope
   - `intelligence/competitors/*/!_profile.md`
   - existing records in `firm/positioning/`
4. Never read `examples/` as evidence (Firm Context Gate).

## Workflow

### 0. Choose the scope

Ask which level, unless the user said:

| Level | `services:` | File |
|-------|-------------|------|
| Firm (multi-brand: brand) | `all` | `all.md` |
| Department / service line | several slugs + `label` | `{label-slug}.md` |
| Service | one slug | `{service-slug}.md` |

With several services and no records yet, propose a grouping before writing
anything: services that share an ICP in `target_icps` **and** the same alternatives
in their outcomes are one department candidate; services that share neither get
their own records. Recommend `all.md` only when one buyer and one difference really
hold across the services. Otherwise say no firm-wide statement is honest yet.

If a broader record covers the scope (a department or `all.md` above a service),
show it. Ask whether the new statement narrows it or deliberately differs. The
alternative for one service is often not the firm's alternative, and that is fine.

### 1. List the alternatives

What did buyers do before buying, or instead of buying, from the firm? Typical
answers: their own team, one person "doing marketing", a freelancer, another agency,
the vendor's services arm, a hire, or **nothing**, meaning they kept the current way.
"Nothing" is always a candidate.

- Count each alternative across the outcomes and discovery notes in scope, and list
  the opportunity slugs.
- With no opportunities yet, interview: the last five won and lost deals, what each
  buyer did instead or before.
- **Phantom competitors:** a monitored competitor that never appears in any outcome
  in scope may be one the firm never actually loses to. Ask before listing it. Do
  not list it silently, and do not drop it silently.

### 2. List the differences

For each alternative: what does the firm have that this alternative lacks, and what
does that give the client? Take 2–3 candidates from the services' `Differentiators`
and the interview, not from website copy. Also name what the firm sells in words the
buyer would use; this becomes the category in the sentence.

For a department, keep only differences true for **every** service in it.

### 3. Attach proof to each difference

Search `firm/proof/` (Proof Gate in `AGENTS.md`). Each difference gets a record, or it
moves to `## Dropped differences` with `proof_needed` and what would prove it. Never
estimate, illustrate, or borrow a result.

- A record with `usable_publicly: false` may support the statement, which is
  internal. Say that a public headline cannot lean on it.
- Multi-brand: a sibling brand's record only via `{brand}/{slug}` with
  `cross_brand: true`, attributed to the delivering brand.

### 4. Name for whom and in what situation

From the differences that survived step 3, pick the client type who cares most, the
moment they look for help, and the alternative from step 1 that this client
considers most often. `icp` must be an existing ICP in `target_icps` of every
service in scope. If it is not, the scope is too wide: split it.

### 5. Write the sentence

> For [whom], who [situation] and today [alternative], we are [difference], as shown
> by [proof].

Use `content_language`, one client group, and one or two differences. If the
sentence needs more to make sense, go back to step 4 and narrow the group.

### 6. Write and verify

1. Write the record (schema: `docs/WORKSPACE.md`). Use `status: draft` until the
   user confirms the sentence, then set `active`.
2. Writing `all.md` replaces the old source in the same change. In single-brand,
   the profile's `## Positioning` becomes one line pointing at
   `firm/positioning/all.md`. In multi-brand, remove the brand's `positioning:`
   field.
3. Run:

   ```bash
   scripts/validate-positioning.sh
   ```

   A non-zero exit is a hard stop.

## Output

| Scope | Path |
|-------|------|
| Firm | `workspace/firm/positioning/all.md` |
| Department | `workspace/firm/positioning/{label-slug}.md` |
| Service | `workspace/firm/positioning/{service-slug}.md` |

Multi-brand: `workspace/firm/brands/{brand}/positioning/…`, same filenames.

Report in chat: the sentence, the dropped differences with what would prove them,
and which proof records are internal-only.

## Quality checks

- [ ] Every alternative has its source: opportunity slugs, or "interview" and a date
- [ ] Phantom competitors were asked about, not assumed
- [ ] Every difference in `## Parts` has a `Proof N` row with a real record
- [ ] The statement names one client group and at most two differences
- [ ] No second source left: profile prose or the brand's `positioning:` field, if
      `all.md` was written
- [ ] `scripts/validate-positioning.sh` passes

## Related Skills

| Skill | When |
|-------|------|
| `marketing-icp` | ICP missing, or the chosen client type has no ICP |
| `sales-outcome-log` | Too few outcomes to see alternatives; `backfill` past deals first |
| `marketing-service-page` | Turn the statement into a page headline |
| `sales-proposal` | Open a proposal against the alternative the buyer considers |
| `sales-prospecting-sequence` | A first email where proof replaces adjectives |
