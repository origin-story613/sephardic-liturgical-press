# Handoff: Ani LeDodi poster

A poster Yosef wants to make **for his wife**, with **אֲנִי לְדוֹדִי וְדוֹדִי לִי**
(Shir HaShirim 6:3). Nothing is designed yet. Read this whole file before
doing anything, then ask Yosef the questions in §6, **one at a time**.

## 1. The text

Westminster Leningrad Codex, "Tanach with Ta'amei Hamikra" in the Sefaria
export (**public domain**,
`storage.googleapis.com/sefaria-export/json/Tanakh/Writings/Song of Songs/Hebrew/Tanach with Ta'amei Hamikra.json`;
`sefaria.org` itself is blocked from the container):

- **6:3** (the verse he named): אֲנִ֤י לְדוֹדִי֙ וְדוֹדִ֣י לִ֔י הָרֹעֶ֖ה בַּשׁוֹשַׁנִּֽים׃
- Related, in case he wants them: **2:16** דּוֹדִ֥י לִי֙ וַאֲנִ֣י ל֔וֹ הָרֹעֶ֖ה
  בַּשּׁוֹשַׁנִּֽים׃ and **7:11** אֲנִ֣י לְדוֹדִ֔י וְעָלַ֖י תְּשׁוּקָתֽוֹ׃

Notes:

- Leningrad spells **הָרֹעֶה** (defective); many printings have **הָרוֹעֶה**.
  Ask which he wants (or his own source), as was done for Psalm 67.
- The initials of אני לדודי ודודי לי spell **אלול**, a well-known
  association. It is a possible design idea; mention it, don't decide it.
- 6:3 contains **no divine name**. Anything added (another verse, a
  blessing) may: see §3.
- **His wife's Hebrew name** is already in the repo, in the birkon's
  dedication page (`birkon/sections/front-matter.tex`, "Dedication: to
  Yosef's wife"), with Shir HaShirim 2:2. If a name or dedication goes on
  the poster, take it from there and confirm with him. Don't ask him to
  retype it, and don't guess.

## 2. Who you are working with

- **Yosef.** Observant Sephardic Jew (Edot HaMizrach, Seattle Turkish
  Sephardic custom), Hebrew-fluent, developer background.
- Locked-down Windows computer: **nothing can be installed**. He works in
  GitHub web and **Overleaf (free plan)**. Overleaf is **connected to this
  GitHub repo and syncs from `main`** (Menu → GitHub → Pull GitHub changes
  to Overleaf), so changes only reach him once they are merged into `main`.
- He often cannot open files attached in chat: give **GitHub links**.
- **Workflow that works:** develop on your session's branch, open a pull
  request, and **merge it yourself** (for the poster projects he told the
  earlier session to merge its own PRs; confirm that still applies here).
  Then tell him in one line to pull in Overleaf and recompile, naming the
  main document (Menu → Main document). Compile with **LuaLaTeX**.
- He wants **one clear question per decision**, with concrete lettered
  options. He answers tersely ("a", "b"). Record every decision in
  `ani-ledodi/sources.md` as it is made.
- **Never decide religious content** (text, spelling, which verses, how a
  divine name is treated). Design you may propose; he decides.
- He notices details (alignment to the pixel, spacing). **Check renders
  yourself before reporting**, and measure, don't eyeball (§5).

## 3. Hard rules (from the rest of the repo)

1. **The four-letter Name is never written out in any file** (not in
   `.tex`, `.lua`, `.md`, comments or commit messages). Build it from Unicode
   code points at compile time (see `the_name()`/`NAME_HEAD` in
   `menorah-shiviti*/menorah.lua`, or `\Shem{}` in
   `shared/macros/hebrew-layout.sty`). In earlier pieces אלהים, Adonai, the
   combined names and the 42-letter name were also stored as code points
   only. Ask before adding any of these.
2. **Pre-commit safeguard:** install the hook from
   `seder-hashulchan/HANDOFF.md` §3 as `.git/hooks/pre-commit` in your clone
   (it is not in the repo), `chmod +x`, and test it with a staged file
   containing the Name. It only catches the four letters adjacent, so
   interleaved forms must never be typed at all.
3. **No leftover artifacts:** when he reverses a decision, remove the code,
   parameters and notes that supported it.
4. **Never rewrite git history** without asking.
5. **Other sessions edit this repo** (books, birkon cover). Pull before
   editing, keep your changes inside `ani-ledodi/`, and tell him before
   touching `shared/` or another project.
6. **Licensing:** record every text and font source and license in
   `sources.md`. This poster is for his wife; ask whether it might also be
   sold, as the shivitis are.

## 4. Fonts

- **Stam Sefarad CLM** (Culmus, GPL with font exception, in TeX Live and
  Overleaf as `StamSefaradCLM.ttf`): the shivitis' scribal hand, with tagin.
  It has **no vowel points** (they vanish silently), **no gershayim** (use a
  plain `"`), and **no bold**.
- **Taamey David CLM** (in `shared/fonts/`, loaded by
  `shared/macros/hebrew-layout.sty`): the books' face, with nikud and
  te'amim. Used for Modim deRabanan's pointed text.
- **Never add a second copy** of a font TeX Live already ships: it scrambles
  the LuaTeX font cache.

## 5. What the earlier poster projects learned (reuse it)

Look at `menorah-shiviti/`, `menorah-shiviti-2/` and `modim-derabanan/`
for working code.

- **Formats:** every poster so far comes in four sizes, chosen by one macro
  in `main.tex`: `aceo` 2.5×3.5 in, `siddur` 3.5×4.75, `birkon` 4.25×5.5,
  `poster` 12×18 (placeholder). Scale everything from one unit, 1% of the
  largest **2:3 box that fits the page**, so each size is the same design
  (`modim-derabanan/main.tex` shows the simple version).
- **Only scaled spacing.** Fixed sizes in the house style (`\parskip`, the
  `center` environment's space, a TikZ picture in its own paragraph) push
  ACEO pages over; `\topskip=0pt` with `\vspace*` produced a blank page.
  Draw frames from inside a text line with
  `remember picture, overlay` (compile twice).
- **Hebrew and TikZ:** draw in an English (LTR) context and set each node in
  Hebrew, or the canvas comes out mirrored. Never use `decorations.text`
  (it reverses Hebrew). Words on curves: one rotated node per word, centred
  on the path (not standing on it).
- **Drawn-out letters** (a scribe's way to fill a line): `stretched()` in
  `menorah-shiviti-2/menorah.lua` cuts a glyph into three slices and widens
  only a plain horizontal stroke, with measured stretch zones per letter
  (`STRETCHABLE`). Don't use it on pointed text: points under the stroke
  distort.
- **Justified block with a centred short last line:**
  `modim-derabanan/modim.lua`.
- **Keep Lua in its own `.lua` file**; `\directlua` escaping (`%`, `\\`)
  breaks easily. When Lua passes keys through TeX, use ASCII keys; inside
  pieces of a split line use control spaces (TeX drops a leading space).
- **Check, don't eyeball:** render with `pdftoppm`, measure ink positions in
  Python, and check right/left placement from the PDF (an earlier session
  swapped שויתי and לנגדי by misreading a low-resolution preview). Check
  spellings by code point. Report what you measured.
- Local setup: `apt-get install texlive-luatex texlive-latex-extra
  texlive-lang-other texlive-pictures poppler-utils` (no Debian `culmus`).

## 6. Questions for Yosef (one at a time, lettered options)

1. **Text:** just אני לדודי ודודי לי, or the whole verse (with הרועה
   בשושנים)? Anything else on it: her name, a dedication, a date or
   occasion, the verse reference?
2. **Nikud:** pointed (Taamey David or another pointed face) or letters only
   (Stam Sefarad, matching the shivitis)? If the whole verse: הָרֹעֶה or
   הָרוֹעֶה?
3. **Concept:** for example a formal panel (like Modim deRabanan); the two
   halves facing each other (אני לדודי / ודודי לי) to show the mirroring of
   the words; a shaped text (a heart, or lilies, שושנים, from the verse); or
   a picture of an example he likes (he has sent photos before; take the
   structure, never copy a design).
4. **Size and printing:** which of the four formats (or another size), and
   how it will be printed or framed. Personal only, or also for sale?
5. **Style:** frame or border, ornament, colour or black only.

## 7. Suggested first steps

1. Install the pre-commit hook and confirm LuaLaTeX works.
2. Ask §6 question 1. While waiting, set up `ani-ledodi/` (`main.tex`,
   `sources.md` with the text and its license) along the lines of
   `modim-derabanan/`.
3. Build a first draft as soon as the text is settled, so he can react to
   it in Overleaf. Then iterate one decision at a time, merging each change
   so Overleaf sees it.
