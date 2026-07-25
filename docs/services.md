# Implementation Services

B2BForce is MIT-licensed and can be used without paid services.

If a firm wants help installing, adapting, or extending the skills, implementation
support is available at [b2bforce.ai](https://www.b2bforce.ai).

Typical paid work:

- setup and firm onboarding,
- custom skills for internal workflows,
- integrations with existing tools,
- team enablement for Cursor, Claude Code, Codex, or similar agents,
- running the PDCA loop unattended — scheduled cycle/eval/check runs, machine-readable
  run state, and a watchdog that reports skipped runs and missing evidence. The repo
  ships the loop for an agent session with a human present; automating it needs a
  scheduler this repo deliberately does not include,
- splitting `workspace/` into a private repo — the usual reason is
  `workspace/clients/`, which holds client names, renewal dates, and health
  assessments that a firm wants versioned but not in a public fork.

This is optional. The repo remains self-hosted and owned by the user.
