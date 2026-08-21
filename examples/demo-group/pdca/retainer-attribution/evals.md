---
fixture: true
---

# Evals — retainer-attribution

## Deterministic checks available

| Check | Decides |
|-------|---------|
| `scripts/validate-account.sh` | Every shared account declares its brands and qualified services |
| `scripts/validate-brands.sh` | Brand registry, people registry, and owner resolution hold |

## Reusable criteria patterns

1. Every account counted as "has a cross-brand hypothesis" names a real sibling
   service in the qualified `{brand}/{slug}` form. Mandatory, decided by
   reading `account-plan.md` frontmatter and files under `firm/services/`.
2. No metric in this area is ever summed with another brand's. Mandatory —
   see the Brand Scope Gate.
