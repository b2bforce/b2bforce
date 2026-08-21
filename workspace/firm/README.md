# Firm

Your company's identity — equivalent to the "Company" entity in B2BForce workflows.

| Path | Purpose |
|------|---------|
| `profile.md` | Primary firm overview and context; starts as a setup template |
| `brands/{slug}/` | One directory per market-facing brand (`!_brand.md` + its services, icp, proof, channels) — only for firms running several; leave empty otherwise |
| `services/{slug}.md` | Individual service definitions (problem → outcomes → proof) |
| `people/{slug}.md` | Optional shared-team registry — assignments only, never rates or hours |
| `proof/{slug}.md` | Verified client results — the only source any skill may cite |

During setup, replace the template in `profile.md` with real firm context, then
create one short `services/{slug}.md` file for every primary service the firm
offers. Keep each service file minimal; add detail only when a workflow needs it.

`brands/` stays empty for a single-brand firm — which is the default everywhere in
this repo. A firm selling under two or more names creates one **brand home** per
brand — `brands/{slug}/` holding `!_brand.md` plus that brand's `services/`,
`icp/`, `proof/`, and `channels/` — while working pipelines (content,
opportunities…) gain a `{brand}/` segment in their own areas. Rules: Brand Scope
Gate in [AGENTS.md](../../AGENTS.md); paths and file schema:
[docs/WORKSPACE.md](../../docs/WORKSPACE.md).

`proof/` is what lets skills cite a real client result instead of asking you to
retype it every time. Three flags per record control what may be written:
`client_public` (naming), `quote_approved` (quoting), `usable_publicly` (public
material). `verified: true` on a metric means a human confirmed the number — an
agent may never set it. Schema: [../../docs/WORKSPACE.md](../../docs/WORKSPACE.md).

Skills: `marketing-company-profile`, `marketing-service`, `sales-outcome-log`
(creates proof records, including `backfill` for past engagements).
