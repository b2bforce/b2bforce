# Contributing

Thank you for contributing to B2BForce skills + workspace.

## Skill conventions

- Location: `.agents/skills/{kebab-case-name}/SKILL.md`
- Frontmatter: `name` must match folder name; include `description` with trigger phrases
- Keep `SKILL.md` under 500 lines — move details to `references/`
- Prefix by active area: `firm-`, `intel-`, `marketing-`, `sales-`. Use `firm-` for
  firm-wide, cross-cutting workflows (`firm-context`, `firm-pdca-*`); `tool-` is
  reserved for thin wrappers around external tools, whether an API (`tool-exa`) or a
  local renderer (`tool-weasyprint`)
- **Content generation:** one skill per content type (`marketing-content-blog-post`, `marketing-content-linkedin-post`, etc.) — see [docs/content-generation.md](docs/content-generation.md). Do not ship a single generic content skill.
- Service pages: use `marketing-service-page`. Do not add a separate content landing-page draft skill.
- Hub skill: `firm-context` — all skills should read `workspace/firm/profile.md` first
- Output paths: always document where artifacts go in `workspace/` (see `docs/WORKSPACE.md`)

## Validation

```bash
./validate-skills.sh
```

All skills must pass before merge. If you change a workspace artifact format, also
run the matching validator in `scripts/` (content readiness, content ideas, content
draft, proposal, PDCA cycle).

## Pull requests

1. Fork / branch from `main`
2. Add or update skill + workspace README if output paths change
3. Run validator
4. Open PR with description of workflow and test steps

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
