#!/usr/bin/env python3
"""Make an SVG from `mutool draw -F svg -O text=path` self-contained for
CorelDRAW and laser software: every <use> of a glyph outline becomes its own
<path>, and the glyph definitions and data-text attributes are dropped.

Usage: python3 inline_svg_uses.py in.svg out.svg
"""
import re
import sys

src = open(sys.argv[1], encoding='utf-8').read()
defs = dict(re.findall(r'<path id="([^"]+)" d="([^"]+)"/>', src))


def inline(m):
    attrs = m.group(1)
    ref = re.search(r'xlink:href="#([^"]+)"', attrs).group(1)
    attrs = re.sub(r'\s*(xlink:href|data-text)="[^"]*"', '', attrs)
    return '<path d="%s"%s/>' % (defs[ref], attrs)


out, n = re.subn(r'<use([^>]*)/>', inline, src)
out = re.sub(r'<defs>.*?</defs>\s*', '', out, flags=re.S)
assert '<use' not in out and 'data-text' not in out
open(sys.argv[2], 'w', encoding='utf-8').write(out)
print('inlined', n, 'glyphs')
