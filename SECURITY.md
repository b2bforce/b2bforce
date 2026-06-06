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
