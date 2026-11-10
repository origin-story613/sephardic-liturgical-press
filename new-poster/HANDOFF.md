# Handoff: a new shiviti or poster

Yosef wants to start **another shiviti or poster**. What it is has not been
decided: ask him (§7). This brief gathers everything the earlier poster
projects learned, so the new one starts where they left off. Read it all,
then read the `HANDOFF.md` and `sources.md` of the existing poster closest
to the new idea (§1).

## 1. The posters so far (read their code; reuse it)

| Folder | What it is | Worth reusing |
|---|---|---|
| `menorah-shiviti/` | **Shiviti 1**: Psalm 67 as a menorah, Psalm 16:8 and the Name above, Stam Sefarad. Carried by the birkon, Seder HaShulchan and Shabbat siddur (`menorah-setup.tex`, `\menorahshivitipage`). | Text on curves; a piece shared into the books |
| `menorah-shiviti-2/` | **Shiviti 2**: Shiviti 1 plus דע לפני מי אתה עומד…, the Name with a stretched final he and Adonai inside, the combined names, Ana BeKoach in two square blocks of drawn-out letters. Engraved on wood by laser. | Drawn-out letters as outlines (`stretched()`, `glyph-outlines.lua`); export for print and laser (`tools/export.sh`) |
| `modim-derabanan/` | Modim deRabanan as a formal panel: Stam Sefarad title, pointed text in Taamey David, justified, frame. | Simple scaled page; justified block with a centred short last line (`modim.lua`) |
| `ani-ledodi/` | For Yosef's wife: all of Shir HaShirim as a tiny justified background, a large 2×2 אהבה in gold over it. | Text that fills an area exactly (`ahava.lua`); fonts not in TeX Live kept with their licences (`fonts/`); letters knocked out of a background |

Each poster's `sources.md` records its text, every decision Yosef made, and
the reasons. Follow its pattern from the first day.

## 2. Working with Yosef

- **Yosef**: observant Sephardic Jew (Edot HaMizrach, Seattle Turkish
  Sephardic custom), Hebrew-fluent, developer background. Some pieces are
  for sale (the shivitis), some are gifts (Ani LeDodi). Ask which.
- Locked-down Windows computer: **nothing installs**. He works in GitHub web
  and **Overleaf**, which is **connected to this repo and syncs from
  `main`** (Menu → GitHub → Pull GitHub changes to Overleaf; Menu → Main
  document; compiler **LuaLaTeX**). He cannot see a change until it is
  merged into `main`.
- **Pull requests:** develop on your branch, open a PR, and **merge it
  yourself**: he gave that standing permission for the shiviti PRs, and the
  poster projects have worked that way since. Then tell him in one line to
  pull in Overleaf and recompile, and which main document.
- He often cannot open chat attachments: give **GitHub links**. He sends
  **photos** of his siddur and of examples he likes; use them for text and
  structure, never copy a design.
- **One question per decision**, with lettered options; he answers "a",
  "b". Record each decision in `sources.md` straight away.
- **Never decide religious content**: text, spelling, which verses, how a
  divine name appears. Propose design; he decides.
- He notices small things (a word a few points off centre, a lost space).
  **Measure your renders before you report** (§5).

## 3. Hard rules

1. **The four-letter Name is never written out in any file**: not in
   `.tex`, `.lua`, `.md`, comments or commit messages. Build it from code
   points at compile time (`NAME_HEAD`, `HE` in `menorah-shiviti-2/menorah.lua`;
   `\Shem{}` in `shared/macros/hebrew-layout.sty` for pointed text). The
   shivitis also store אלהים, Adonai, the combined names (built by
   interleaving code points) and the 42-letter name only as code points;
   ask him how to treat any name the new piece contains. In prose write ה׳.
2. **Pre-commit hook:** install it from `seder-hashulchan/HANDOFF.md` §3 as
   `.git/hooks/pre-commit` in your clone, `chmod +x`, test it with a staged
   file containing the Name. It only catches the four letters adjacent: an
   interleaved form must never be typed at all.
3. **No leftovers:** when he reverses a decision, remove its code,
   parameters and notes. Rewrite garbled notes rather than patch them.
4. **Never rewrite git history** without asking.
5. **Other sessions** edit the books and other posters at the same time.
   Pull before you start, keep to your own folder, and say before you touch
   `shared/`, the root files or another project.
6. **Licences:** record the source and licence of every text and font in
   `sources.md`. Check a font's licence before he chooses it if the piece
   may be sold (§4).

## 4. Text and fonts

**Texts.** `sefaria.org` is blocked from the container; use the public
Sefaria export (`storage.googleapis.com/sefaria-export/json/...`; the index
is `books.json` in the `Sefaria/Sefaria-Export` GitHub repo).

- Tanakh: Westminster Leningrad Codex, "Tanach with Ta'amei Hamikra"
  (public domain). "Miqra according to the Masorah" is CC-BY-SA: not for a
  piece for sale.
- Prayers: *Siddur Edot HaMizrach*, "Torat Emet 357" (public domain), the
  books' base text.
- **His siddur wins** where it differs (Psalm 67 and Modim deRabanan both
  had spellings to change); ask for a photo. Torat Emet has slips (it had
  בָּשָׁר for בָּשָׂר in Modim).
- Sefaria orders vowel marks differently from typed text: compare with
  `unicodedata.normalize('NFC', …)` and check replacement counts. Count
  words and letters by code point, and check finished text the same way.
- Ketiv/qere and similar points are his to decide (see `ani-ledodi/sources.md`).

**Fonts.**

- **Stam Sefarad CLM** (TeX Live, GPL with font exception): the shivitis'
  scribal hand, with tagin. **No vowel points** (they vanish silently), **no
  gershayim** (a plain `"` reads well), **no bold**.
- **Taamey David CLM** (`shared/fonts/`, loaded by `hebrew-layout.sty`):
  nikud and te'amim.
- **Keter Aram Tsova** (Aleppo Codex letterforms, GPL with font exception)
  is in `ani-ledodi/fonts/`. **Meir Sadan's** fonts there (Hofesh, Busta,
  Latet Bold) are **non-commercial, no derivatives**: a piece for sale needs
  his permission.
- A font not in TeX Live goes in the project's own `fonts/` with a
  `README.md` naming source, version and licence, unmodified. **Never add a
  second copy of a TeX Live font**: it scrambles the LuaTeX font cache.
- Before using a font, check it has every character the text needs (LuaTeX
  logs "Missing character").

## 5. Technical toolkit (lessons that cost time)

- **Formats:** each piece comes in `aceo` 2.5×3.5 in, `siddur` 3.5×4.75,
  `birkon` 4.25×5.5 and `poster` 12×18 (a placeholder size), chosen by one
  macro at the top of `main.tex`. Scale everything from one unit, 1% of the
  largest **2:3 box that fits the page**, so each size is the same design.
- **Only scaled spacing.** The house style's `\parskip`, the `center`
  environment, a TikZ picture alone in a paragraph, and `\topskip=0pt` with
  `\vspace*` each broke the ACEO page. Draw frames and overlays from inside
  a text line (`remember picture, overlay`; compile twice). Use `\vfill`
  at the bottom, not `\vspace*{\fill}`.
- **Hebrew in TikZ:** draw in an English (LTR) context, set each node in
  Hebrew. Never `decorations.text` (it reverses Hebrew). Words along curves:
  one rotated node per word, **centred on the path**.
- **Lua in its own `.lua` file**, never long code inside `\directlua`
  (escaping `%` and `\\` breaks). Keys passed through TeX must be ASCII.
  Watch for shadowed variable names.
- **Drawn-out letters** (a scribe's way to fill a line or square):
  `stretched()` in `menorah-shiviti-2/menorah.lua` draws the letter as one
  filled shape from the font's outline, widening only its plain horizontal
  stroke. Outlines come from `tools/make_glyph_outlines.py` (fontTools: make
  a venv with `python3 -m venv` and `pip install fonttools`) into
  `glyph-outlines.lua`, for Stam Sefarad only; for another font, regenerate
  and remeasure each letter's plain stroke. Prefer the traditional dilatable
  letters (of אהלתם), then ד ר ח. **Do not clip** to build shapes: clipping
  is lost in SVG and laser software. Not for pointed text.
- **Splitting a line into pieces:** use control spaces inside pieces; TeX
  drops a space at the start of a box.
- **Justified text:** `modim-derabanan/modim.lua` (last line stretched if
  nearly full, else centred); `ani-ledodi/ahava.lua` (size searched so the
  text fills an area exactly). Searching sizes to force a full last line
  failed on narrow columns: prefer centring the last line.
- **Check, don't eyeball:** render with `pdftoppm`, measure ink with Python
  (PIL), check left/right from the PDF (an earlier session swapped שויתי and
  לנגדי by misreading a preview), check letter order by code point,
  pixel-diff before and after a refactor. Small Hebrew renders mislead.
- **Draft label:** a small grey corner label naming format and sizes helps
  him see which size he compiled (Overleaf scales pages to fit). Turn it
  off for final output.
- Local setup: `apt-get install texlive-luatex texlive-latex-extra
  texlive-lang-other texlive-pictures poppler-utils` (not the Debian
  `culmus` package). `mutool` is available; Ghostscript and Inkscape are not.

## 6. Final files: print, CorelDRAW, laser

Copy `menorah-shiviti-2/tools/` (`export.sh`, `inline_svg_uses.py`): it
builds the final PDF with no draft label, then an SVG with every letter a
plain filled shape (`mutool draw -F svg -O text=path`, references expanded),
which CorelDRAW imports cleanly and saves as .cdr for the laser shop.
Check the SVG renders the same as the PDF, and has no `<text>`, `<use>`,
`clipPath` or Hebrew characters. Keep the files in the project's `export/`
(add a `.gitignore` exception for its PDFs, as for the birkon's print
files) and give him GitHub links. For laser engraving, suggest a test burn:
tagin and small inner letters are fine detail.

## 7. Questions for Yosef (one at a time)

1. **What is the piece?** The text or texts, and where they come from (a
   photo of his siddur, or the source).
2. **What is it for?** For sale, a gift, a page in one of the books, or
   engraving; that decides the licences and the output.
3. **Concept:** a shape (as the menorah), a formal panel (as Modim), a text
   field with large letters (as Ani LeDodi), or an example photo he likes.
4. **Letters:** pointed or not, and so which font; how any divine name
   appears.
5. **Sizes and output:** which formats, how it will be printed, engraved or
   framed.

## 8. First steps

1. Pull `main`, install the pre-commit hook, confirm LuaLaTeX works.
2. Ask question 1. Name the new folder after the piece, with `README.md`,
   `sources.md` and, once you build, `main.tex`, copying the closest
   poster's setup. Add it to the project table in the root `README.md`.
3. Build a first draft as soon as the text is settled, so he can react in
   Overleaf; then one decision at a time, each merged so Overleaf sees it.
