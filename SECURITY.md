# Security

This repo is designed to be copied into a firm's own workspace. Treat workspace
content as business data.

## Secrets

- Never commit `.env`, API keys, access tokens, passwords, cookies, or private
  credentials.
- Keep API keys in `.env` only. Do not paste them into chat, prompts, snapshots,
  reports, or generated drafts.
- Before publishing or sharing a repo, search for secrets and private paths.

## Firm And Client Data

- `workspace/firm/profile.md`, service files, ICPs, prospecting sequences, and
  intelligence reports may contain sensitive strategy.
- Do not commit client names, client proof, metrics, quotes, or case details
  unless they are approved for reuse.
- If a proof point is private or unverified, mark it as needing proof instead of
  inventing or exposing details.

## Proof, Opportunities, And Client Accounts

Three folders hold material a firm cannot put on the internet by accident:

| Folder | Contents |
|--------|----------|
| `workspace/firm/proof/` | Real client results, metrics, and quotes |
| `workspace/sales/opportunities/` | Discovery notes and pricing |
| `workspace/clients/` | **Highest sensitivity** — client names, renewal dates, health assessments, named contacts |

All three are committed by default, which is correct for a firm's private repo and
wrong for a public one. `workspace/clients/` is the sharpest case: a `health: red`
assessment or a renewal date leaking is not an embarrassment, it is a commercial
problem for the client relationship it describes.

Before the first proposal, proof record, or account file, decide which this repo is:

- **Private firm repo** — commit them. That is the point: versioned, reviewable
  history of what was promised and what it produced.
- **Public or shared repo** — add these to `.gitignore` first:

```gitignore
workspace/firm/proof/
workspace/sales/opportunities/
workspace/clients/
```

Decide this **once, up front**. Removing a client name from git history after the fact
is far harder than never committing it, and the bootstrap flow encourages cloning from
a public template — so the default path leads straight into this trap.

If the firm wants versioned client history and a public repo, split them: keep skills
and docs public, and point `workspace/` at a private repo.

### No ledger in `workspace/clients/`

`mrr_band` is a band rather than an exact figure, and contract value, margin,
utilization, and hours are rejected by `scripts/validate-account.sh`. This is partly to
keep the repo out of PSA territory, but mostly to limit blast radius: a band answers
every question the workflows here actually ask, while making an accidental leak far
less damaging than an exact contract value would be.

Health assessments are internal. `health: red` and the risk language in
`account-plan.md` and `notes.md` are written for the firm, never for the client. Only
`qbr/` files are client-facing — keep the two separate, and check a rendered QBR PDF
before sending it.

Either way:

- Set `client_public: false` and `quote_approved: false` until the client agrees
  otherwise. Both default to `false` for this reason.
- `usable_publicly: true` is a separate decision from `client_public: true`. A
  client may allow you to be named in a private proposal and still not want the
  result on your website.
- Never set `verified: true` on a metric an agent inferred. It means a human
  confirmed the number, and it will end up in a proposal that a buyer will
  challenge.
- Keep client-identifying detail out of proposal filenames if the repo may ever be
  shared — the folder slug uses the account name.

`scripts/validate-proposal.sh` enforces the naming and quote flags mechanically, so
a private client cannot be named by accident. `scripts/validate-account.sh` rejects
exact-money fields in `workspace/clients/`. Neither can decide whether the repo should
be public — that is your call, made once, up front.

## Monitoring Snapshots

- Competitor snapshots should contain public website content only.
- Do not store authenticated pages, private portals, paid reports, cookies, or
  scraped responses that include credentials.
- Remove sensitive snippets before committing snapshots or reports.

## Prospecting

- Review outbound copy before sending.
- Verify local email law, sender identity, opt-out handling, and consent or
  legitimate-interest requirements.
- Keep prospect lists and personal data out of this public template repo.
