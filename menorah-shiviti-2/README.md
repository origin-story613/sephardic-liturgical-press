# Shiviti 2

A second menorah shiviti, begun as an exact copy of Shiviti 1
(`menorah-shiviti/`) and changed from there. Shiviti 1 and the books that
carry it are not affected by changes here.

- `main.tex`: standalone output; choose `aceo`, `siddur`, `birkon` or
  `poster` with `\menorahformat`. Compile with LuaLaTeX (twice).
- `shiviti2-setup.tex`: preamble setup; provides `\shivitiII` and
  `\shivitiIIpage`. It can sit in the same document as Shiviti 1.
- `menorah.lua`: the drawing (Lua table `shiviti2`). `psalm67.lua`: the text,
  copied from Shiviti 1.
- `sources.md`: how Shiviti 2 differs from Shiviti 1.

Everything in `menorah-shiviti/sources.md` and `HANDOFF.md` (text, spelling,
font, rules about the Name) applies here unless `sources.md` says otherwise.

**Final files** (no draft label; letters as shapes, for CorelDRAW or a laser
engraver): `export/`, rebuilt with `sh tools/export.sh [format]`. See
`sources.md`.
