# Handoff: Seder HaShulchan

A new pocket book in the `sephardic-liturgical-press` repo, built on everything
established for the birkon. Read this whole file before doing anything.

## 1. The goal

**Seder HaShulchan** (סֵדֶר הַשֻּׁלְחָן): the order of the table, in the Seattle
Turkish Sephardic nusach.

1. **Netilat yadayim** (washing before bread)
2. **Hamotzi**
3. **Kiddush**, every variation:
   - Friday night (Shabbat evening)
   - Shabbat day
   - Shalosh Regalim (Pesah, Shavuot, Sukkot, Shemini Atzeret): night and day,
     including when the festival falls on Shabbat, and Motzei Shabbat into Yom
     Tov (the Havdalah insertion)
   - Rosh HaShanah: night and day, including on Shabbat
   - Shehecheyanu, where it applies
4. **Birkat HaMazon**, exactly as finished in the birkon (see §6), plus
   Me'ein Shalosh and Borei Nefashot.

Scope questions to ask Yosef early (one clear question each, see §3):
- Include the Rosh HaShanah simanim (the Yehi Ratzon over the symbolic foods)?
- Include Friday-night extras (Shalom Aleichem, Eshet Hayil)? The birkon plan
  has them; they may belong in one book, the other, or both.
- Include Havdalah (Motzei Shabbat, Motzei Yom Tov) as its own section?
- Title wording, imprint, and nusach line for the title page (the birkon's
  answers are in §6 and are a good default).

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
- Overleaf settings: **Compiler: LuaLaTeX**, **Main document** set to the book's
  `main.tex`.
- **He wants decisions asked clearly.** When the siddur and the base text
  differ, ask **one specific question per difference**, quoting both readings
  in Hebrew, with options such as "Match my siddur" / "Keep as now". Never
  decide nusach yourself. He reviews and answers quickly.
- He sends **photos of his siddur**. They are often sideways or upside down:
  rotate (PIL `rotate(90, expand=True)` or `-90`), crop, and read at full
  resolution. Say so if a page edge is cut off and ask for a new photo rather
  than guessing.

## 3. Hard rules (non-negotiable)

1. **The divine name is never written out in any file in the repo**: not in
   `.tex`, not in `.md` notes, not in comments or commit messages. Use the
   `\Shem{}` macro (§5). In prose, describe it ("the Name", "printed in full")
   or use the double-yod abbreviation. This was violated once in a notes file
   and had to be fixed; don't repeat it.
2. **Local safeguard:** in every fresh clone, install this pre-commit hook in
   `.git/hooks/pre-commit` (it is deliberately *not* part of the repo):

   ```python
   #!/usr/bin/env python3
   import re, subprocess, sys
   M = '֑-ׇ'
   pat = re.compile(rf'י[{M}]*ה[{M}]*ו[{M}]*ה')
   files = subprocess.run(['git','diff','--cached','--name-only','--diff-filter=ACM'],
                          capture_output=True, text=True).stdout.split()
   bad = [f for f in files if not f.endswith(('.ttf','.otf')) and
          pat.search(subprocess.run(['git','show',':'+f],capture_output=True).stdout.decode('utf-8','ignore'))]
   if bad:
       print('Commit refused: the Name appears in', ', '.join(bad)); sys.exit(1)
   ```
   `chmod +x` it and test it with a staged file containing the Name.
3. **No leftover artifacts.** When Yosef reverses a decision, remove the code,
   notes and docs that supported it, not just the output.
4. **Never rewrite git history without asking.** He has said to leave the
   existing history as is.
5. **Licensing.** Only use text that is public domain, traditional liturgy, or
   Yosef's own decision. Record the source and license of every section.

## 4. Repository and tooling

- Repo: `github.com/origin-story613/sephardic-liturgical-press` (private),
  branch `main`. Commit author `origin-story613`.
- Layout today:
  ```
  shared/fonts/                     Gentium Plus (bundled, OFL)
  shared/macros/hebrew-layout.sty   house style (languages, fonts, macros)
  shared/geometry/pocket-dimensions.sty   3.5in x 4.75in page
  birkon/main.tex                   the finished birkon
  birkon/sections/                  front-matter, birkat-hamazon, after-blessings
  birkon/sources/                   source + license + edits + decisions per section
  shabbat-siddur/, menorah-shiviti/ planned, not started
  seder-hashulchan/                 this project (only this file so far)
  ```
- `birkon/main.tex` finds the shared files whether compiled from its own
  folder (local) or from the project root (Overleaf) via `\pressroot` and
  `\input@path`. Copy that preamble for `seder-hashulchan/main.tex`.
- **Local compiling** (cloud session): `apt-get install texlive-luatex
  texlive-latex-extra texlive-lang-other fonts-sil-gentiumplus poppler-utils`
  (run `dpkg --configure -a` / `apt-get update` if apt complains). Then
  `cd seder-hashulchan && lualatex main.tex`.
- **Do not install the Debian `culmus` package**, and never bundle
  `DavidCLM-*.otf` in `shared/fonts/`. TeX Live already ships David CLM under
  those file names; a second copy confuses the LuaTeX font cache and the Hebrew
  prints as scrambled glyphs. If that happens: remove the extra copy and delete
  `/var/lib/texmf/luatex-cache/generic/fonts/otl/davidclm-*`.
- Hebrew font: **Taamey David CLM** if Yosef uploads it to `shared/fonts/`,
  otherwise TeX Live's David CLM (automatic, with a warning).
  `\pressHebrewFontName` holds whichever is loaded (used on the copyright page).
- **Always verify visually**: `pdftoppm -r 150 -png main.pdf out` and look at
  the pages. Several bugs were only caught this way.
- **GitHub pushes sometimes fail with "Internal Server Error".** It's
  transient; retry with backoff (2s, 4s, 8s, 16s).
- Network: `sefaria.org` and `wikipedia.org` are blocked from the container.
  Sefaria texts are available from the public GCS bucket (§7).

## 5. House style (`shared/macros/hebrew-layout.sty`)

| Markup | Use |
|---|---|
| `\rubric{...}` | English instruction line, small italic, sits tight against the text below |
| `\sectiontitle{...}` | Centered bold title |
| `\begin{seasonal}{rubric} ... \end{seasonal}` | Conditional/seasonal insertion: rubric above, body indented 0.2in from the right |
| `\whispered{...}` | Whispered words, in parentheses |
| `\divider` | Centered rule between sections |
| `\begin{textbox}{title} ... \end{textbox}` | Boxed Latin-script passage (Ladino), never split across pages |
| `\Shem{prefix}` | The Name, assembled from code points: `\Shem{}`, `\Shem{לַ}`, `\Shem{בַּ}`, `\Shem{מֵ}` (sheva kept after מֵ) |

Typographic decisions already made (don't change without asking):
- No paragraph indent; small gap between paragraphs; `\raggedbottom`.
- Repeated lines printed in full, not abbreviated.
- Optional words in **square brackets**, explained by the rubric above.
- Whispered words in **parentheses**. Headings like (עַל אַרְצֵנוּ …) also appear
  in parentheses, as in the siddur.
- English rubrics are our own wording. Hebrew inside an English rubric uses
  `\foreignlanguage{hebrew}{…}` and is kept upright.
- **Bidi pitfall:** English punctuation directly after a Hebrew word inside a
  rubric (`…אֱלֹהֵינוּ};`) can jump to the wrong side. Reword so the punctuation
  follows English, or check the render. A final period after Hebrew renders fine.
- Bold opening word of each blessing (from the source).
- Margins: 0.5in inner gutter. babel's RTL mode already puts it at the spine
  (right side of odd pages); no mirroring code is needed.

## 6. What the birkon settled (reuse it)

- **Birkat HaMazon, Me'ein Shalosh, Borei Nefashot** are finished in
  `birkon/sections/birkat-hamazon.tex` and `after-blessings.tex`. Every
  decision is recorded in `birkon/sources/*.md`; read those files first.
  Seder HaShulchan should use **the same text, not a copy**. Recommended: move
  those two section files to a shared location (e.g. `shared/texts/`) and
  `\input` them from both books, so a fix lands in both. Ask Yosef before
  moving (it changes the Overleaf paths he pastes into).
- Nusach decisions that carry over:
  - The Name is printed in full with the source's pointing, via `\Shem{}`.
  - "-ach" endings (עַמָּךְ, עִירָךְ, כְּבוֹדָךְ), not the siddur's -ֶךָ forms.
  - No Shir HaMaalot / Al Naharot before Birkat HaMazon.
  - Lamnatzeach kept; Avarcha ends with (רַגְלִי עָמְדָה …).
  - Zimun, first blessing, Al HaNissim (Hanukkah), Rachem, Al HaKol, Retzeh
    (וְאַף עַל פִּי), Boneh Yerushalayim, closing verses, Harachaman changes, the
    guest's blessing: all per the Turkish siddur, as recorded.
  - No wedding material, no "if one forgot" blessings, no hands footnote on
    פּוֹתֵחַ אֶת יָדֶךָ.
  - Ya Komimos (Ladino) at the end, "our own rendering" in Aki Yerushalayim
    spelling.
- Front matter pattern: `birkon/sections/front-matter.tex` (title page;
  copyright page with source credit, font credit, edition line, and a boxed
  Hebrew/English genizah notice). Birkon answers: title סֵדֶר בִּרְכַּת הַמָּזוֹן,
  "According to the custom of the Turkish Sephardic community of Seattle",
  imprint and copyright holder "Sephardic Liturgical Press", first edition
  5787 / 2026.
- Me'ein Shalosh and Borei Nefashot were proofread by Yosef against his
  siddur (pp. 349–350); no open birkon items.

## 7. Sources

- **Base text: Siddur Edot HaMizrach, "Torat Emet 357", Public Domain.**
  `https://storage.googleapis.com/sefaria-export/json/Liturgy/Siddur/Siddur%20Edot%20HaMizrach/Hebrew/Torat%20Emet%20357.json`
  (the index of all texts is `books.json` in the public `Sefaria/Sefaria-Export`
  GitHub repo). Relevant nodes:
  - `Shabbat Evening/Kiddush`: Friday-night Kiddush (with optional
    kabbalistic preludes; ask Yosef which to include)
  - `Shabbat Evening/First Meal`: netilat yadayim (with a preparatory
    prayer) and Hamotzi
  - `Daytime Meal/Kiddush`: Shabbat-day Kiddush (Mizmor LeDavid, Im Tashiv …)
  - `Post Meal Blessing`, `Al Hamihya`, `Blessings on Enjoyments`
- **Festival and Rosh HaShanah Kiddush are not in this siddur.** Sefaria's
  *Machzor Rosh Hashanah Edot HaMizrach* has `Nighttime Kiddush` and
  `Daytime Kiddush`, but its license is **"unknown"**: don't use it as the
  printed source without resolving that. Options to put to Yosef: photos of his
  own siddur/machzor (he has a Rosh HaShanah machzor, "ערבית לראש השנה", p. 44
  was used for Harachaman), or another public-domain Sefaria version.
  Check every version's `license` field before using it.
- Do **not** use Sefaria's "Shaliehsaboo Edition" (license unknown).
- **Yosef's Turkish siddur** is the nusach authority. Birkat HaMazon is pp.
  343–350. Text copied from it may be under the publisher's copyright; record
  what came from it.

### Text-handling pitfalls (learned the hard way)

- **Unicode mark order.** Sefaria's text orders vowel marks differently from
  typed text (e.g. shin dot before or after qamats). Plain find-and-replace
  silently misses, which happened four times in the birkon. Always compare
  with `unicodedata.normalize('NFC', …)`, and **verify each replacement
  count**.
- Source typos exist: missing sheva, stray dagesh, misplaced vowels. Log every
  correction in the section's `sources/*.md`.
- Source rubrics are Hebrew; ours are English.
- After editing, review the full `git diff` and the rendered pages. A leftover
  line from a replaced passage slipped through once.

## 8. Suggested first steps

1. Clone the repo, install the pre-commit hook (§3), compile the birkon to
   confirm the toolchain.
2. Ask Yosef the scope questions in §1, one clear question each.
3. Scaffold `seder-hashulchan/` (`main.tex`, `sections/`, `sources/`),
   copying the birkon's preamble and front-matter pattern.
4. Propose where Birkat HaMazon lives so both books share it (§6).
5. Draft netilat yadayim, Hamotzi and the Shabbat Kiddushes from the Torat
   Emet source; then ask for siddur photos and resolve differences one question
   at a time. Then the festival and Rosh HaShanah Kiddush once a usable source
   is settled.

## 9. Progress

- **Scope (Yosef):** Rosh HaShanah simanim included; Shalom Aleichem and Eshet
  Hayil in this book only (not the birkon); Havdalah is its own section.
- **Shared texts (Yosef):** Birkat HaMazon, Me'ein Shalosh and Borei Nefashot
  moved to `shared/texts/` (records in `shared/texts/sources/`); both books
  `\input` them.
- **Scaffolded:** `main.tex`, `sections/front-matter.tex` (birkon defaults,
  title סֵדֶר הַשֻּׁלְחָן, awaiting Yosef's confirmation).
- **Drafted from Torat Emet, not yet checked against the siddur:** Friday night
  (Shalom Aleichem, Eshet Hayil, Kiddush), netilat yadayim and Hamotzi,
  Shabbat day Kiddush, Havdalah. Optional preludes left out pending Yosef's
  answers; each `sources/*.md` lists them.
- **To do:** festival and Rosh HaShanah Kiddush (needs a usable source),
  simanim, siddur comparison of every drafted section.
