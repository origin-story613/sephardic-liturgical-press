# Sephardic Liturgical Press

LuaLaTeX sources for Sephardic liturgical works. All projects share one set of
fonts, one house style, and one pocket page size (3.5in x 4.75in, matched to
the Bne Issakhar pocket siddur).

| Project | Status |
|---|---|
| `birkon/` | In progress: Sephardic bencher (Birkat HaMazon + Shabbat table) |
| `shabbat-siddur/` | Planned |
| `menorah-shiviti/` | Planned |

## Layout

```
shared/
  fonts/                    Gentium Plus (bundled); put TaameyDavidCLM here
  macros/hebrew-layout.sty  languages, fonts, liturgical macros
  geometry/pocket-dimensions.sty
birkon/
  main.tex                  entry point
  sections/                 one file per section
  sources/                  where each section's text came from, edits, checklist
  cover/
```

## Compiling in Overleaf

1. Upload the whole repository (keep the folder structure) as one project.
2. Menu -> Settings: **Compiler: LuaLaTeX**, **Main document: `birkon/main.tex`**.
3. Upload the Taamey David CLM font files (`TaameyDavidCLM-Medium` and
   `TaameyDavidCLM-Bold`, `.otf` or `.ttf`) into `shared/fonts/`. Until they are
   there, the build falls back to TeX Live's David CLM and logs a warning.

Do **not** add a copy of `DavidCLM-*.otf` to `shared/fonts/`: TeX Live already
ships files with those names, and a second copy confuses LuaTeX's font cache
(the Hebrew comes out as scrambled glyphs).

## Compiling locally

```
cd birkon
lualatex main.tex
```

## House style (`hebrew-layout.sty`)

| Markup | Use |
|---|---|
| `\rubric{...}` | English instruction line; sits tight against the text below it |
| `\sectiontitle{...}` | Centered bold section title |
| `\begin{seasonal}{rubric} ... \end{seasonal}` | Seasonal insertion: rubric above, body indented 0.2in from the right |
| `\whispered{...}` | Whispered passage, wrapped in parentheses |
| `\divider` | Centered rule between liturgical sections |
| `\begin{textbox}{title} ... \end{textbox}` | Boxed Latin-script passage (e.g. Ladino), double rule |
| `\Shem{prefix}` | The divine name, with an optional prefix |

Conventions: repeated lines are printed in full. The divine name is never
typed in a source file: write `\Shem{}`, or `\Shem{prefix}` for a prefixed form
(`\Shem{לַ}`, `\Shem{בַּ}`, `\Shem{מֵ}`). The macro assembles the Name at compile
time with the source text's pointing.

## Licensing

- Gentium Plus: SIL Open Font License (`shared/fonts/LICENSE-GentiumPlus.txt`).
- Taamey David CLM: Culmus Project, GPL with font exception.
- Check the license of every Sefaria text before selling copies; text from
  Siddur Zechut Yosef is under copyright and is a nusach reference only.
