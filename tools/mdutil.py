"""Markdown helpers shared by the generators (escaping for Hugo with raw HTML on)."""

import html
import json
import re


def md(text):
    """Escape prose for Markdown. Raw HTML is enabled on the site, so < and > must
    become entities; '{{<' and '{{%' would start a Hugo shortcode."""
    text = text.replace("\\", "\\\\")
    text = html.escape(text, quote=False)
    for ch in "`*_[]":
        text = text.replace(ch, "\\" + ch)
    text = text.replace("{{", "{&#123;")
    # A paragraph must not turn into a heading, list or quote.
    text = re.sub(r"^(\s*)([#+\-=>]|\d+[.)])", lambda m: m.group(1) + "\\" + m.group(2), text)
    return text


def md_cell(text):
    """Prose inside a table cell."""
    return md(text).replace("|", "\\|").replace("\n", " ")


def code(text, in_table=False):
    """An inline code span. Backslash escapes do not work in code spans, but a GFM
    table needs \\| even there. A span containing '{{<' would start a shortcode,
    so it falls back to <code> with entities."""
    if "{{<" in text or "{{%" in text:
        out = "<code>%s</code>" % html.escape(text).replace("{", "&#123;")
    else:
        fence = "``" if "`" in text else "`"
        pad = " " if text.startswith("`") or text.endswith("`") else ""
        out = fence + pad + text + pad + fence
    if in_table:
        out = out.replace("|", "\\|")
    return out


def code_block(lines):
    """A code block. Fenced unless the text contains shortcode delimiters, which
    Hugo would expand even inside a fence."""
    body = "\n".join(lines)
    if "{{<" in body or "{{%" in body:
        esc = html.escape(body).replace("{", "&#123;")
        return '<pre class="synopsis"><code>%s</code></pre>' % esc
    return "```text\n%s\n```" % body


def yaml_str(text):
    # JSON strings are valid YAML double-quoted scalars.
    return json.dumps(text, ensure_ascii=False)


def sentence(text):
    text = text.strip()
    if not text:
        return text
    text = text[0].upper() + text[1:]
    if text[-1] not in ".!?:":
        text += "."
    return text




def first_sentence(text):
    """The first sentence; '...' and abbreviations like 'e.g.' do not end it."""
    m = re.match(r"(.+?[^.\s][.!?])(\s+[A-Z(\"]|$)", text, re.S)
    return m.group(1) if m else text
