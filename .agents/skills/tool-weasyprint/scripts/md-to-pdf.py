#!/usr/bin/env python3
"""Render a Markdown document to a print-ready PDF with WeasyPrint.

Usage:
  uv run --with markdown --with weasyprint python3 \\
    .agents/skills/tool-weasyprint/scripts/md-to-pdf.py INPUT.md [-o OUT]

YAML frontmatter is stripped from the body and never rendered into the PDF.
Selected scalar keys can feed the cover page; everything else is ignored, so
internal fields such as proof_refs stay out of a client-facing document.
"""

from __future__ import annotations

import argparse
import html
import re
import sys
from pathlib import Path

SKILL_DIR = Path(__file__).resolve().parent.parent
DEFAULT_CSS = SKILL_DIR / "assets" / "proposal.css"

# Only these frontmatter keys may reach the rendered page.
COVER_KEYS = (
    "title",
    "subtitle",
    "firm",
    "client",
    "date",
    "valid_until",
    "reference",
    "footer",
)

FRONTMATTER_RE = re.compile(r"\A---[ \t]*\r?\n(.*?)\r?\n---[ \t]*\r?\n?", re.DOTALL)
SCALAR_RE = re.compile(r"^([A-Za-z_][A-Za-z0-9_]*):[ \t]*(.*)$")


def split_frontmatter(text: str) -> tuple[dict[str, str], str]:
    """Return (scalar frontmatter, body). Non-scalar values are skipped."""
    match = FRONTMATTER_RE.match(text)
    if not match:
        return {}, text

    meta: dict[str, str] = {}
    for line in match.group(1).splitlines():
        if not line.strip() or line.lstrip().startswith("#"):
            continue
        if line[:1] in " \t-":  # nested mapping or list item
            continue
        found = SCALAR_RE.match(line)
        if not found:
            continue
        value = found.group(2).strip().strip("\"'")
        if value and not value.startswith(("[", "{")):
            meta[found.group(1)] = value

    return meta, text[match.end():]


def build_cover(meta: dict[str, str]) -> str:
    def esc(key: str) -> str:
        return html.escape(meta.get(key, ""))

    if not (meta.get("title") or meta.get("client")):
        return ""

    rows = []
    if meta.get("client"):
        rows.append(("Prepared for", esc("client")))
    if meta.get("date"):
        rows.append(("Date", esc("date")))
    if meta.get("valid_until"):
        rows.append(("Valid until", esc("valid_until")))
    if meta.get("reference"):
        rows.append(("Reference", esc("reference")))

    meta_html = "".join(
        f'<div class="cover-row"><span class="cover-key">{label}</span>'
        f'<span class="cover-value">{value}</span></div>'
        for label, value in rows
    )

    firm = f'<p class="cover-firm">{esc("firm")}</p>' if meta.get("firm") else ""
    subtitle = (
        f'<p class="cover-subtitle">{esc("subtitle")}</p>' if meta.get("subtitle") else ""
    )
    title = esc("title") or esc("client")

    return (
        '<section class="cover">'
        f"{firm}"
        f'<h1 class="cover-title">{title}</h1>'
        f"{subtitle}"
        f'<div class="cover-meta">{meta_html}</div>'
        "</section>"
    )


def render(md_text: str, extensions: list[str]) -> str:
    import markdown

    return markdown.markdown(md_text, extensions=extensions, output_format="html5")


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Render Markdown to a print-ready PDF via WeasyPrint."
    )
    parser.add_argument("input", type=Path, help="Markdown file to render")
    parser.add_argument(
        "-o",
        "--output",
        type=Path,
        help="Output .pdf path, or a directory. Default: tmp/pdf/{input stem}.pdf",
    )
    parser.add_argument(
        "--css",
        action="append",
        type=Path,
        default=None,
        help="Stylesheet to apply. Repeatable. Replaces the bundled default.",
    )
    parser.add_argument(
        "--add-css",
        action="append",
        type=Path,
        default=None,
        help="Stylesheet applied on top of the bundled default. Repeatable.",
    )
    parser.add_argument("--title", help="Override the cover title")
    parser.add_argument("--client", help="Override the cover client")
    parser.add_argument("--firm", help="Override the cover firm name")
    parser.add_argument("--footer", help="Override the page footer text")
    parser.add_argument("--no-cover", action="store_true", help="Skip the cover page")
    parser.add_argument("--toc", action="store_true", help="Insert a table of contents")
    args = parser.parse_args()

    if not args.input.is_file():
        print(f"error: no such file: {args.input}", file=sys.stderr)
        return 1

    raw = args.input.read_text(encoding="utf-8")
    meta, body = split_frontmatter(raw)
    meta = {key: value for key, value in meta.items() if key in COVER_KEYS}

    for key in ("title", "client", "firm", "footer"):
        override = getattr(args, key)
        if override:
            meta[key] = override

    extensions = ["tables", "fenced_code", "attr_list", "def_list", "sane_lists"]
    if args.toc:
        extensions.append("toc")
        body = "[TOC]\n\n" + body

    cover = "" if args.no_cover else build_cover(meta)
    footer = html.escape(meta.get("footer", ""))

    document = (
        "<!DOCTYPE html><html lang='en'><head><meta charset='utf-8'>"
        f"<title>{html.escape(meta.get('title', args.input.stem))}</title>"
        f"<style>@page {{ @bottom-left {{ content: '{footer}'; }} }}</style>"
        "</head><body>"
        f"{cover}"
        f"<main class='doc'>{render(body, extensions)}</main>"
        "</body></html>"
    )

    if args.css:
        stylesheets = list(args.css)
    else:
        stylesheets = [DEFAULT_CSS] + list(args.add_css or [])

    for sheet in stylesheets:
        if not sheet.is_file():
            print(f"error: no such stylesheet: {sheet}", file=sys.stderr)
            return 1

    output = args.output or Path("tmp/pdf")
    if output.suffix.lower() != ".pdf":
        output = output / f"{args.input.stem}.pdf"
    output.parent.mkdir(parents=True, exist_ok=True)

    from weasyprint import CSS, HTML

    HTML(string=document, base_url=str(args.input.parent)).write_pdf(
        output, stylesheets=[CSS(filename=str(sheet)) for sheet in stylesheets]
    )

    print(output)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
