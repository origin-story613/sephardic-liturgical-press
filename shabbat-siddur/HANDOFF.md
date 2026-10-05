# Handoff: Shabbat Siddur (Mincha, Motzei Shabbat Arvit, Havdalah)

A pocket siddur in the `sephardic-liturgical-press` repo, the third book after
the birkon and Seder HaShulchan. Read this whole file before doing anything.

## 1. The goal

A pocket siddur (3.5in x 4.75in, the shared page size) for the Shabbat
afternoon and evening services, in the **Turkish Sephardic nusach**:

**Shabbat Mincha**
1. Korbanot block (Pitum HaKetoret, Eizehu Mekoman, Rabbi Yishmael's 13 Principles)
2. Ashrei
3. Torah service (Torah reading at Mincha)
4. Half Kaddish
5. Amidah (seven blessings; the middle blessing is Atah Echad)
6. Chazzan's repetition with Kedushah
7. Tzidkatcha Tzedek (three verses)
8. Psalm 112
9. Kaddish Shalem
10. Aleinu
11. Mourner's Kaddish

**Motzei Shabbat Arvit**
1. Psalm 144 and Psalm 67 (opening)
2. Barechu
3. Blessings before Shema (Ma'ariv Aravim, Ahavat Olam)
4. Shema (three paragraphs)
5. Blessings after Shema (Emet VeEmunah, Hashkivenu)
6. Exodus 31:16–17 (וְשָׁמְרוּ)
7. Half Kaddish
8. Amidah (19 blessings, with Atah Honantanu in the fourth)
9. Kaddish Shalem
10. Vihi Noam (Psalm 90:17 and all of Psalm 91)
11. VeAtah Kadosh / Uva LeTziyon, with the Aramaic Kedushah deSidra in
    parentheses (whispered-passage convention)
12. Mourner's Kaddish
13. Aleinu
14. Barechu repeated
15. Mourner's Kaddish (second)

**Havdalah** (full text)

This outline is from Yosef's original planning. **Confirm it with him before
building**, one question per item that's in doubt.

### Nusach authority: ask first

The original plan names *Siddur Zechut Yosef* (Bne Issakhar Institute) as the
nusach, with a physical model: תְּפִלּוֹת שַׁבָּת, The Sephardic Library / Bne
Issakhar Institute, Jerusalem, 3.5in x 4.75in. The birkon and Seder HaShulchan
were checked against **Yosef's Turkish siddur** (Birkat HaMazon on pp.
343–350). **Ask him which book is the authority for this siddur**, and have
him photograph its pages.

Places flagged in the original plan where the Turkish wording must come from
his siddur, not the base text:
- **Kedushah at Mincha:** expanded Isaiah 6 wording, unique to Zechut Yosef.
- **Atah Echad:** congregational Amen responses at specific points in the
  chazzan's repetition.
- **Atah Honantanu:** verify the exact wording.
- **Havdalah opening verses:** may differ slightly.

### Scope questions to ask Yosef early (one clear question each)

- **Chazzan's repetition:** print it in full, or only the Kedushah and the
  responses?
- **Torah service at Mincha:** the service only (taking out and returning the
  Torah), or the Mincha reading too?
- **Korbanot:** the full block as listed, or a shorter selection?
- **Kaddish:** which Kaddishes in full, and the congregational responses.
- **Special days:**
  - Tzidkatcha is omitted on certain Shabbatot.
  - Motzei Shabbat into Yom Tov uses VaTodi'enu, and Havdalah becomes part of
    Kiddush.
  - Which of these, if any, to include?
- **After Havdalah:** Motzei Shabbat songs (HaMavdil, Eliyahu HaNavi), and
  VeYiten Lecha?
- **Title page:** title, nusach or family line, imprint. The birkon and Seder
  HaShulchan answers in §6 are good defaults.

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
   or use the double-yod abbreviation. A siddur has the Name on almost every
   line, so convert every occurrence when importing source text.
2. **Local safeguard:** in every fresh clone, install the pre-commit hook given
   in `seder-hashulchan/HANDOFF.md` §3 as `.git/hooks/pre-commit` (it is
   deliberately *not* part of the repo). `chmod +x` it and test it with a
   staged file containing the Name.
3. **No leftover artifacts.** When Yosef reverses a decision, remove the code,
   notes and docs that supported it, not just the output.
4. **Never rewrite git history without asking.** He has said to leave the
   existing history as is.
5. **Licensing.** Only use text that is public domain, traditional liturgy, or
   Yosef's own decision. Record the source and license of every section.
   *Siddur Zechut Yosef* is under copyright: use it as a nusach reference and
   record what came from it.
6. **Other sessions edit this repo too.** The Seder HaShulchan session may be
   active. `git pull` before every edit, push with `git pull --rebase` on
   conflict, and tell Yosef when you change anything in `shared/`, so the other
   session doesn't overwrite it.

## 4. Repository and tooling

- Repo: `github.com/origin-story613/sephardic-liturgical-press` (private),
  branch `main`. Commit author `origin-story613`.
- Layout:
  ```
  shared/fonts/                     Gentium Plus (bundled, OFL)
  shared/macros/hebrew-layout.sty   house style (languages, fonts, macros)
  shared/geometry/pocket-dimensions.sty   3.5in x 4.75in page
  shared/texts/                     texts used by more than one book
                                    (Birkat HaMazon, Me'ein Shalosh) + sources/
  birkon/                           finished
  seder-hashulchan/                 in progress (has its own HANDOFF.md)
  shabbat-siddur/                   this project (only this file so far)
  menorah-shiviti/                  planned
  ```
- Each book's `main.tex` finds the shared files whether compiled from its own
  folder (local) or from the project root (Overleaf) via `\pressroot` and
  `\input@path`. Copy the preamble from `birkon/main.tex` or
  `seder-hashulchan/main.tex`.
- **Local compiling** (cloud session): `apt-get install texlive-luatex
  texlive-latex-extra texlive-lang-other fonts-sil-gentiumplus poppler-utils`
  (run `dpkg --configure -a` / `apt-get update` if apt complains). Then
  `cd shabbat-siddur && lualatex main.tex`.
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
| `\begin{reading}{title} ... \end{reading}` | Latin-script passage (Ladino): title between short rules, never split across pages |
| `\Shem{prefix}` | The Name, assembled from code points: `\Shem{}`, `\Shem{לַ}`, `\Shem{בַּ}`, `\Shem{מֵ}` (sheva kept after מֵ) |

Typographic decisions already made (don't change without asking):
- No paragraph indent; small gap between paragraphs; `\raggedbottom`.
- Repeated lines printed in full, not abbreviated.
- Optional words in **square brackets**, explained by the rubric above.
- Whispered words in **parentheses** (the Kedushah deSidra targum, for
  example). Headings like (עַל אַרְצֵנוּ …) also appear in parentheses, as in
  the siddur.
- Seasonal insertions are indented, with a single English rubric above.
- English rubrics are our own wording. Hebrew inside an English rubric uses
  `\foreignlanguage{hebrew}{…}` and is kept upright.
- **Bidi pitfall:** English punctuation directly after a Hebrew word inside a
  rubric can jump to the wrong side. Reword so the punctuation follows English,
  or check the render. A final period after Hebrew renders fine.
- Bold opening word of each blessing (from the source).
- Margins: 0.5in inner gutter. babel's RTL mode already puts it at the spine;
  no mirroring code is needed.
- The Ladino box was replaced with rules because a double-ruled box resembled
  the Turkish siddur's design. **Keep our design visibly our own**: don't
  imitate the siddur's boxes, shading or layout.

## 6. Decisions from the other books (reuse them)

Read `shared/texts/sources/birkat-hamazon.md` and the files in
`seder-hashulchan/sources/` first. They hold every decision, with reasons.
Points that apply here:
- **The Name** is printed in full with the source's pointing, via `\Shem{}`.
  The Turkish siddur prints the double-yod abbreviation; Yosef chose not to
  follow it.
- **"-ach" endings** (עַמָּךְ, עִירָךְ, כְּבוֹדָךְ), not the siddur's -ֶךָ
  forms. Expect this question again in the Amidah and ask, since it may differ
  by passage.
- **Havdalah already exists** as a draft in
  `seder-hashulchan/sections/havdalah.tex` (from Torat Emet; not yet checked
  against the siddur; the "Before Havdalah" material was excluded by Yosef).
  This siddur needs Havdalah too. **Recommend moving it to `shared/texts/`**
  so both books use one text, as was done for Birkat HaMazon. Ask Yosef first,
  and coordinate with the Seder HaShulchan session (rule 6), since that moves
  a file it uses.
- **Front matter pattern:** `birkon/sections/front-matter.tex`. Title page,
  then a copyright page with source credit, font credit
  (`\pressHebrewFontName`), edition line and a boxed Hebrew/English genizah
  notice. Imprint and copyright holder "Sephardic Liturgical Press"; first
  edition 5787 / 2026. The birkon's nusach line is "According to the custom of
  the Turkish Sephardic community of Seattle"; Seder HaShulchan's is the Maayan
  family custom (see its handoff). Ask which this book uses.

## 7. Sources

- **Base text: Siddur Edot HaMizrach, "Torat Emet 357", Public Domain.**
  `https://storage.googleapis.com/sefaria-export/json/Liturgy/Siddur/Siddur%20Edot%20HaMizrach/Hebrew/Torat%20Emet%20357.json`
  (the index of all texts is `books.json` in the public `Sefaria/Sefaria-Export`
  GitHub repo). Nodes located so far:
  - `Shabbat Mincha/Offerings`: Mincha opening, including Pitum HaKetoret
  - `Shabbat Mincha/Uva LeSion`: Shabbat Mincha opening (Ashrei, Uva LeTziyon)
  - `Shabbat Mincha/Amida`: includes Atah Echad (segment 9) and Tzidkatcha
    (segment 36)
  - `Shabbat Mincha/Alenu`
  - `Shabbat Shacharit/Torah Reading`: taking out and returning the Torah
    (check its fit for Mincha)
  - `Weekday Shacharit/Incense Offering`: Eizehu Mekoman (segment 20) and
    Rabbi Yishmael (segment 28), for the Mincha korbanot block
  - `Weekday Arvit/Barchu`, `/The Shema`, `/Amidah` (Atah Honantanu at
    segments 8–9; VeAtah Kadosh / Uva LeTziyon at segment 59), `/Alenu`
  - `Havdalah/Before Havdalah`, `/Havdala`, `/Motzei Shabbat Songs`,
    `/Veyiten Lecha`
  - Vihi Noam occurs in `Weekday Arvit/Barchu` (segment 3) and elsewhere
- **Not found yet:** Psalm 144 (לְדָוִד בָּרוּךְ …) for the Motzei Shabbat
  opening. Search the other nodes, take it from a public-domain Tanakh text on
  Sefaria (check the version's `license`), or use Yosef's siddur.
- Kaddish occurs in many places; pick the forms Yosef's siddur uses.
- Check every Sefaria version's `license` field. Do **not** use the
  "Shaliehsaboo Edition" (license unknown).

### Text-handling pitfalls (learned the hard way)

- **Unicode mark order.** Sefaria's text orders vowel marks differently from
  typed text (e.g. shin dot before or after qamats). Plain find-and-replace
  silently misses, which happened four times in the birkon. Always compare
  with `unicodedata.normalize('NFC', …)`, and **verify each replacement
  count**.
- **The Name in the source** appears in several irregular spellings
  (with or without holam or sheva, the vowels in different orders, prefixed
  forms like לַ / בַּ / וַ / כַּ / מֵ). Convert every form to `\Shem{prefix}`
  with a regex that matches yod-he-vav-he with any marks in between, then
  confirm with the hook that none remain.
- Source typos exist: missing sheva, stray dagesh, misplaced vowels. Log every
  correction in the section's `sources/*.md`.
- Source rubrics are Hebrew; ours are English.
- After editing, review the full `git diff` and the rendered pages. A leftover
  line from a replaced passage slipped through once.

## 8. Suggested first steps

1. Clone the repo, install the pre-commit hook (§3), and compile the birkon to
   confirm the toolchain.
2. Ask Yosef which siddur is the nusach authority, and the scope questions in
   §1, one clear question each.
3. Scaffold `shabbat-siddur/` (`main.tex`, `sections/`, `sources/`), copying a
   book's preamble and front-matter pattern.
4. Propose sharing Havdalah (§6).
5. Draft from Torat Emet in service order, one section per file with a
   `sources/*.md` record each. Then ask for siddur photos and resolve
   differences one question at a time. Start with the flagged places (§1):
   Kedushah, Atah Echad, Atah Honantanu, the Havdalah verses.
