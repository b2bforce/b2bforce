# Data

Lightweight metadata for B2BForce skills + workspace. Not a replacement for `workspace/` artifacts.

| File | Purpose |
|------|---------|
| `firm.template.json` | Optional template for tools that need machine-readable firm metadata |
| `firm.json` | Optional firm metadata (gitignored — private) |

Do not create `firm.json` during setup unless a concrete script, app, or integration
needs structured fields. The primary firm profile is `workspace/firm/profile.md`.
