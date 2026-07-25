---
name: tool-weasyprint
description: >-
  Render a Markdown document to a print-ready PDF with WeasyPrint — proposals,
  case studies, reports. Use when a workspace artifact has to leave the repo as a
  client-facing document, or when the user asks for a PDF, a sendable proposal, or
  branded output. Strips frontmatter; CSS-overridable for firm branding.
license: MIT
metadata:
  version: 1.0.0
  category: tool
---

# Tool: WeasyPrint

Thin wrapper around [WeasyPrint](https://weasyprint.org) — turns a Markdown file in
`workspace/` into a PDF a client can receive. Other skills call this instead of
describing PDF generation themselves.

Modeled on the pattern in
[netresearch/markdown-to-pdf-skill](https://github.com/netresearch/markdown-to-pdf-skill):
brand-neutral default stylesheet, overridable with `--css`.

## Requirements

WeasyPrint is **not** pure Python. It binds to native libraries, and the Python
package alone fails at import with `cannot load library 'libpango-1.0-0'`.

| Platform | Install |
|----------|---------|
| macOS | `brew install pango` |
| Debian/Ubuntu | `sudo apt install libpango-1.0-0 libpangoft2-1.0-0` |
| Fedora | `sudo dnf install pango` |

Then no Python install is needed — `uv` fetches the packages per run:

```bash
uv run --with markdown --with weasyprint python3 \
  .agents/skills/tool-weasyprint/scripts/md-to-pdf.py {input.md} -o tmp/pdf/
```

Without `uv`: `pip install markdown weasyprint` and run with plain `python3`.

No API key. Nothing leaves the machine.

## Usage

```bash
S=.agents/skills/tool-weasyprint

# Default stylesheet, output to tmp/pdf/{stem}.pdf
uv run --with markdown --with weasyprint python3 $S/scripts/md-to-pdf.py \
  workspace/sales/opportunities/{opportunity}/proposal.md

# Explicit output path
uv run --with markdown --with weasyprint python3 $S/scripts/md-to-pdf.py \
  workspace/sales/opportunities/{opportunity}/proposal.md \
  -o tmp/pdf/meridian-proposal.pdf

# Firm branding layered on top of the default
uv run --with markdown --with weasyprint python3 $S/scripts/md-to-pdf.py \
  {input.md} --add-css workspace/firm/brand/pdf.css

# Replace the stylesheet entirely
uv run --with markdown --with weasyprint python3 $S/scripts/md-to-pdf.py \
  {input.md} --css workspace/firm/brand/pdf.css
```

| Flag | Effect |
|------|--------|
| `-o, --output` | File path, or a directory. Default `tmp/pdf/{stem}.pdf` |
| `--css` | Replace the bundled stylesheet. Repeatable |
| `--add-css` | Layer on top of the bundled one. Repeatable |
| `--title`, `--client`, `--firm`, `--footer` | Override cover fields |
| `--no-cover` | Skip the cover page |
| `--toc` | Insert a table of contents |

## Frontmatter Is Stripped

YAML frontmatter never reaches the PDF. Only these scalar keys are read, and only
for the cover:

`title`, `subtitle`, `firm`, `client`, `date`, `valid_until`, `reference`, `footer`

Everything else — `proof_refs`, `icp`, `persona`, `status`, internal slugs — is
dropped. This matters: the client-facing document must not carry the firm's
internal qualification and proof bookkeeping. Lists and nested values are ignored
by design rather than rendered as raw YAML.

If neither `title` nor `client` is present, no cover page is generated.

## Output Location

Write PDFs to `tmp/pdf/`. `*.pdf` and `tmp/` are both gitignored.

**Do not commit rendered PDFs.** The Markdown file is the record and it is
versioned; a committed PDF is a binary that drifts from its source and bloats
history. If the firm needs to know exactly what a client received, the commit of
`proposal.md` at send time is that record — which is also why `sales-proposal`
sets `status: sent` and `sent:` rather than archiving a file.

## Styling

`assets/proposal.css` is the default: A4, 24mm top margin, page numbers, a running
document title, cover page with an accent rule, and a pricing table where the
`**bold**` row is highlighted as the recommended option.

It is deliberately brand-neutral. To rebrand, write a small `--add-css` file
redefining the custom properties rather than forking the stylesheet:

```css
:root {
  --accent: #0b5d3b;
  --accent-soft: #eef5f1;
  --ink: #14181c;
}
.cover-firm { letter-spacing: 0.1em; }
```

Print-specific behavior already handled: table headers repeat across pages, tables
and quotes avoid page breaks, headings do not strand at the bottom of a page, and
orphans/widows are set.

## Example

`examples/proposal-acme-b2bforce.md` is a complete professional proposal from a
fictional firm, ACME B2BFORCE. It doubles as the visual test for the stylesheet and
as a worked reference for what a 6–8 page proposal contains.

```bash
uv run --with markdown --with weasyprint python3 \
  .agents/skills/tool-weasyprint/scripts/md-to-pdf.py \
  .agents/skills/tool-weasyprint/examples/proposal-acme-b2bforce.md
```

It renders to five A4 pages — cover plus four content pages, about 1,900 words — and
exercises every section `sales-proposal` requires, a three-option pricing table with
the recommended row highlighted, an approved client quote, and an anonymized second
proof point.

Note it lives here as a template, so `scripts/validate-proposal.sh` will reject its
path and its unbacked proof numbers. To validate it, copy it into a real
opportunity folder and point `proof_refs` at real records.

## Rules

1. Render from a file in `workspace/` or from an example — never from a string
   pasted into chat, so the PDF always has a versioned source.
2. For proposals, run `scripts/validate-proposal.sh` **before** rendering. The PDF
   is what leaves the building; a Proof Gate violation must be caught while it is
   still a Markdown file.
3. Never commit the output.
4. If the native library is missing, report the install command for the user's
   platform. Do not silently fall back to a different renderer — the stylesheet is
   written for WeasyPrint's paged-media support.

## Used by

`sales-proposal`. Available to any skill whose artifact needs to be sent outside
the firm — case studies, weekly intelligence reports, service pages.
