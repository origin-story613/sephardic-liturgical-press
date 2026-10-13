# Handoff: Menorah Shiviti (Psalm 67)

An art piece in the `sephardic-liturgical-press` repo: Psalm 67 typeset in the
shape of a seven-branched menorah, in the tradition of the Shiviti plaque.
Read this whole file before doing anything.

## 1. The goal

- An **original, commercial-grade** design of Psalm 67 laid out as a menorah,
  intended **for sale**, produced in several formats from one parametric
  master (see `sources.md`, decisions): ACEO cards, a page for the birkon and
  siddur, a poster, and possibly a stencil for hand printing on fine paper.
  Each format is its own single-page output with its own page size; the book
  page matches the books' trim but is not set like a book page.
- Typeset in **LuaLaTeX + TikZ**: text placed at computed coordinates, not
  traced from an image. Vector PDF output for printing.
- The design must be **Yosef's own**. Shiviti menorahs are a centuries-old
  form, but every specific commercial or printed design is someone's work. Do
  not copy or closely imitate an existing design. (The birkon dropped a
  double-ruled box for exactly this reason: it looked too much like the
  siddur's.)

### The traditional structure (verify; don't assume)

- Psalm 67 has 8 verses. Verse 1 is the heading (לַמְנַצֵּחַ בִּנְגִינֹת
  מִזְמוֹר שִׁיר); verses 2–8 are seven verses for the **seven branches**, with
  verse 5 (יִשְׂמְחוּ וִירַנְּנוּ …) traditionally on the **center shaft**.
- **Checked in this repo's source:** verses 2–8 contain **49 words**
  (7 + 6 + 6 + 11 + 6 + 6 + 7), matching the tradition linking them to the 49
  days of the Omer.
- **Not settled: the letter count of verse 5.** Tradition often cites 49
  letters. The Torat Emet siddur text gives **48** because it spells מִישׁוֹר
  with a vav. The Masoretic spelling מִישֹׁר gives **47**. Before any layout
  depends on counts, establish the exact text with Yosef: a Masoretic Tanakh
  edition, or his own tradition. Then count programmatically and record the
  result in a sources file.
- Shiviti plaques often also carry שִׁוִּיתִי ה׳ לְנֶגְדִּי תָמִיד (Psalm 16:8)
  above the menorah, and sometimes other verses or the menorah's base.
  **Ask Yosef what goes on the piece** besides Psalm 67.

### Questions to ask Yosef early (one clear question each)

1. **Size and format.** Poster size, e.g. 11×17 in, 12×18 in, 18×24 in, A3 or
   A2. Portrait, presumably. Printed where: a print shop, or giclée on art
   paper?
2. **Content.** Psalm 67 only, or with Shiviti (Psalm 16:8) at the top, a
   title, the Name in large letters at the top as many shivitis have, a base
   inscription, or decorative border elements?
3. **Text source** for Psalm 67 (see §1 above): which edition, which spellings,
   with nikud, and with or without cantillation marks (te'amim).
4. **Script / font pipeline** (§4): square script with nikud (Pipeline A), or
   ancient epigraphic scripts (Pipeline B)?
5. **Visual style.** Line only or filled shapes, ink colour(s) or monochrome,
   whether the menorah outline is drawn or implied by the text alone.

## 2. Who you are working with

- **Yosef.** Observant Sephardic Jew, Hebrew-fluent, developer background.
- Works on a **locked-down Windows computer**: nothing can be installed. All
  work is browser-based: GitHub web and **Overleaf (free plan)**.
- **He often cannot open files attached in chat.** Always give him **GitHub
  links** instead (`https://github.com/origin-story613/sephardic-liturgical-press/blob/main/<path>`).
- Overleaf is not synced to GitHub. He updates Overleaf by opening a file on
  GitHub, clicking **Copy raw file**, and pasting over the file in Overleaf
  (Ctrl+A, Ctrl+V). New files: **New File** in the right Overleaf folder, then
  paste. After every change, tell him exactly which files to update, with links.
  **The Overleaf free plan has a compile time limit.** Heavy TikZ can exceed
  it, so keep the drawing efficient and test compile times locally.
- **He wants decisions asked clearly:** one specific question per decision,
  with concrete options. For visual choices, render small comparison images
  and describe them, or give previews; he can't open attachments reliably.
  Never decide religious content yourself.

## 3. Hard rules (non-negotiable)

1. **The divine name is never written out in any file in the repo**: not in
   `.tex`, not in `.md` notes, not in comments or commit messages. Use the
   `\Shem{}` macro from `shared/macros/hebrew-layout.sty`, which assembles the
   Name from Unicode code points at compile time. In prose, describe it or use
   ה׳. If the design needs the Name **unpointed** (many shivitis show it large
   without vowels), add a separate macro that also builds it from code points.
   Never type it.
   - Psalm 67 itself uses אֱלֹהִים. The repo rule so far covers only the
     four-letter Name; **ask Yosef** whether he wants the same treatment for
     אֱלֹהִים in this piece's source files.
2. **Local safeguard:** in every fresh clone, install the pre-commit hook given
   in `seder-hashulchan/HANDOFF.md` §3 as `.git/hooks/pre-commit` (deliberately
   *not* part of the repo). `chmod +x` it and test it with a staged file
   containing the Name.
3. **Genizah.** The finished poster contains holy names. Ask Yosef whether to
   add a small genizah notice (the books carry one on the copyright page).
4. **No leftover artifacts.** When Yosef reverses a decision, remove the code,
   notes and docs that supported it, not just the output.
5. **Never rewrite git history without asking.**
6. **Licensing.** The biblical text is public domain, but a specific digital
   edition may carry a license: check the `license` field of any Sefaria
   version used. Pipeline B fonts need a commercial license (§4). Record every
   source and license in `menorah-shiviti/sources.md`.
7. **Other sessions edit this repo** (Seder HaShulchan, Shabbat Siddur).
   `git pull` before every edit, push with `git pull --rebase` on conflict, and
   tell Yosef before changing anything in `shared/`. Prefer keeping this
   project's code inside `menorah-shiviti/` (its own preamble and geometry),
   using only `\Shem{}` and the font setup from the shared style, if they fit.

## 4. Fonts

- **Pipeline A (square script, with nikud): Culmus Project fonts.** Free and
  commercially usable (GPL with font exception).
  - **Taamey David CLM** supports cantillation marks. It's the books' intended
    font, and Yosef uploads it to `shared/fonts/` himself.
  - **Keter YG** and **David CLM** are already in TeX Live (`kpsewhich
    KeterYG-Medium.ttf`).
  - **Never add a second copy** of a font TeX Live already ships (David CLM,
    Keter YG, etc.) to the repo or system. Two files with the same name confuse
    the LuaTeX font cache, and the Hebrew prints as scrambled glyphs. If it
    happens: remove the extra copy and delete
    `/var/lib/texmf/luatex-cache/generic/fonts/otl/` entries for that font.
- **Pipeline B (ancient scripts): Kris J. Udd's fonts** (Paleo-Hebrew,
  Proto-Sinaitic, Dead Sea Scroll scripts).
  - They map glyphs to **Latin keyboard keys** (typing `a` gives alef), not
    Unicode Hebrew, and have **no vowel points**. The text needs a
    letter-by-letter Hebrew-to-key mapping table, kept in the repo and
    documented.
  - **A desktop commercial license is required before distribution.** Don't
    commit the font files unless Yosef confirms the license allows it.

## 5. Technical approach

- `shapepar` can't handle the split, discontinuous lines of menorah branches.
  The plan is **TikZ nodes at computed coordinates**, or a **TikZ `\clip`**
  mask.
- **Likely pitfall, so test it first:** TikZ's `decorations.text` (text along
  a path) places glyphs one by one. That probably breaks Hebrew right-to-left
  order and the positioning of nikud and te'amim. A safer approach for curved
  branches: place **whole words as individual nodes**, each rotated to the
  tangent of the branch arc, with positions computed so the words are evenly
  spaced along the arc. Build a small test with one branch and nikud before
  committing to a method.
- Compute the geometry in **Lua** (`\directlua`, available in LuaLaTeX) or
  generate coordinates with a Python script committed to the repo. Keep the
  layout parametric (branch radii, spacing, font size), so resizing the
  poster is one change.
- If the branches carry verses 2–4 and 6–8, the pairs (2, 8), (3, 7) and
  (4, 6) are mirror images: 7/7, 6/6 and 6/6 words, so the layout can be
  symmetric by words. Letters differ (31/29, 25/29, 26/26 in the Torat Emet
  text), so balance visually by spacing, not just by count. Recompute once the
  text is settled.
- Hebrew setup: babel with `bidi=basic` under LuaLaTeX, as in
  `shared/macros/hebrew-layout.sty`. Each TikZ node holding Hebrew should be
  set in Hebrew (`\foreignlanguage{hebrew}{…}` or the document's main
  language).
- Local tools (cloud session): `apt-get install texlive-luatex
  texlive-latex-extra texlive-lang-other texlive-pictures poppler-utils`. Do not
  install the Debian `culmus` package. **Always render and look:**
  `pdftoppm -r 100 -png main.pdf out`, and zoom into crops at high resolution
  to check nikud.

## 6. Repository

- Repo: `github.com/origin-story613/sephardic-liturgical-press` (private),
  branch `main`, commit author `origin-story613`. GitHub pushes sometimes fail
  with "Internal Server Error"; retry with backoff.
- This project's folder: `menorah-shiviti/` (`README.md`, an empty
  `artwork/`). Suggested layout: `main.tex`, `geometry/` or a Lua file for the
  coordinates, `sources.md` (text edition, counts, licenses, decisions).
- Other books and their handoffs, for conventions: `birkon/`,
  `seder-hashulchan/HANDOFF.md`, `shabbat-siddur/HANDOFF.md`.
- Network: `sefaria.org` and `wikipedia.org` are blocked from the container.
  Sefaria texts are available from the public GCS bucket
  `https://storage.googleapis.com/sefaria-export/…`; the index is `books.json`
  in the public `Sefaria/Sefaria-Export` GitHub repo. Psalms are under
  `json/Tanakh/Writings/Psalms/Hebrew/`. Check each version's `license`.
- **Unicode mark order:** Sefaria orders vowel marks differently from typed
  text. Compare with `unicodedata.normalize('NFC', …)` when matching words,
  and verify replacement counts.

## 7. Suggested first steps

1. Clone the repo, install the pre-commit hook, and check that LuaLaTeX + TikZ
   compile.
2. Ask Yosef the questions in §1 (size, content, text edition, font pipeline,
   style), one at a time.
3. Fetch Psalm 67 from a properly licensed edition, record it in
   `sources.md`, and compute word and letter counts per verse.
4. Build a **one-branch prototype** to settle the text-on-curve method (§5)
   with nikud, and show Yosef a rendered preview.
5. Then the full menorah, parametric. Iterate on the design with rendered
   previews, one decision at a time.

## 8. Progress

- Pre-commit hook installed and tested; LuaLaTeX + TikZ compile with Taamey
  David CLM (already in `shared/fonts/`).
- Psalm 67 fetched from three Sefaria editions; counts, differences and
  licenses in `sources.md` (script: `tools/count_psalm67.py`).
- Text-on-curve method tested and settled (`sources.md`, technical decisions).
- **Formats (Yosef):** ACEO, book page, poster, possibly a hand-printed stencil.
- **Draft sketch** (layout per Yosef; styling not decided): `main.tex` +
  `menorah.lua` + `psalm67.lua`. Three nested branches per side (upright stem
  over a quarter arc). Verse 1 across the top; verses 2, 3, 4 down the left
  branches (outer to inner), verse 5 vertically down the shaft with its last
  3 words as a horizontal base well below the branches, verses 6, 7, 8 down the right branches (inner
  to outer). Letters only, no nikud or te'amim; spellings per Yosef's siddur. Faint guide lines. Format chosen
  by `\menorahformat` (aceo, book, poster) at the top of `main.tex`;
  locally: `lualatex -jobname=aceo "\def\menorahformat{aceo}\input{main}"`.
  Compile twice (the picture is placed relative to the page).
- **Next:** how the stencil would be printed (it constrains the whole design).
