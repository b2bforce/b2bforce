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

## Proof Library And Opportunities

`workspace/firm/proof/` holds real client results and `workspace/sales/opportunities/`
holds discovery notes and pricing. Both are committed to git by default, which is
correct for a firm's private repo and wrong for a public one.

Before the first proposal or proof record, decide which this repo is:

- **Private firm repo** — commit them. That is the point: versioned, reviewable
  history of what was proposed and what it produced.
- **Public or shared repo** — add these to `.gitignore` first:

```gitignore
workspace/firm/proof/
workspace/sales/opportunities/
```

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
a private client cannot be named by accident. It cannot decide whether the repo
should be public — that is your call, made once, up front.

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
