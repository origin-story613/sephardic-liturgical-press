# Modim deRabanan: sources and decisions

## Text

*Siddur Edot HaMizrach*, version "Torat Emet 357" (Torat Emet freeware,
toratemetfreeware.com), **public domain**, from the Sefaria export
(`json/Liturgy/Siddur/Siddur Edot HaMizrach/Hebrew/Torat Emet 357.json`).
The same base text as the books in this repo.

Torat Emet gives Modim deRabanan identically in three places: Weekday
Shacharit (Amida, 45), Weekday Mincha (Amida, 44) and Shabbat Shacharit
(Amidah, 24), headed: מודים דרבנן — בחזרת הש"ץ כשהוא אומר מודים, הקהל
אומרים.

44 words, with nikud, beginning מוֹדִים אֲנַחְנוּ לָךְ, שָׁאַתָּה הוּא ה׳
אֱלֹהֵינוּ וֵאלֹהֵי אֲבוֹתֵינוּ and ending עַל שֶׁאֲנַחְנוּ מוֹדִים לָךְ, בָּרוּךְ
אֵל הַהוֹדָאוֹת. (The Name appears once; written here as ה׳.)

### Yosef's siddur (photo of its Modim deRabanan, Edot HaMizrach)

The poster follows his siddur. Against Torat Emet:

| Torat Emet | His siddur |
|---|---|
| עַל שֶׁאֲנַחְנוּ מוֹדִים לָךְ | עַל **שֶׁאָנוּ** מוֹדִים לָךְ |
| לִשְׁמֹר חֻקֶּיךָ | **לִשְׁמוֹר** חֻקֶּיךָ (full spelling) |
| בְלֵבָב שָׁלֵם | **בְּ**לֵבָב שָׁלֵם (dagesh) |
| כָל בָּשָׂר | כָּל־בָּשָׂר (maqaf) |
| יוֹצְרֵנוּ יוֹצֵר | יוֹצְרֵנוּ, יוֹצֵר (comma) |

His siddur prints the Name as יְיָ. Heading: מודים דרבנן.

Also corrected: Torat Emet has בָּשָׁר with a shin dot, a slip for בָּשָׂר
(sin), as in his siddur. His siddur's punctuation is followed too: commas
after וּתְחָנֵּנוּ and רְצוֹנְךָ, a full stop after מוֹדִים לָךְ, and a colon at the
end. The finished text is `text.tex`.

## Decisions by Yosef

- A poster of Modim deRabanan, "not exactly a shiviti".
- **Concept: a formal text panel** (option B): the prayer as a set block
  with a heading, the Name treated specially, a frame or border. Text per
  his siddur (above).

- **Nikud (Yosef):** with vowel points, like his siddur, so the face is
  **Taamey David CLM** (the books' font, via `shared/macros/hebrew-layout.sty`).
- **The Name (Yosef):** printed יְיָ, as in his siddur. It is not the
  four-letter Name, so it is written directly in `text.tex`.
- **Formats:** the shivitis' four (aceo, siddur, birkon, poster), chosen by
  `\modimformat` in `main.tex`. Everything scales from one unit, 1% of the
  largest 2:3 box that fits the page, so each size has the same design.

## Draft (not yet Yosef's design decisions)

`main.tex`: heading מודים דרבנן in Stam Sefarad CLM, letters only (a trial
Yosef asked to see; the font has no vowel points or bold), a thin frame.
Sizes in units: text 6, heading 8.5, frame 6 from the page edge, text 6
inside the frame. Only scaled spacing is used (the house style's paragraph
gap is set to zero here), so the small formats fit.

- **Text as a block (Yosef):** justified with TeX's ordinary line breaks,
  the block centred on the page. The last line is stretched edge to edge
  when it is naturally at least 85% full (`\lastlinemin`); otherwise it is
  centred (Yosef: "if the last line cannot easily be made to fit, centre
  it"). Done in `modim.lua` after TeX sets the paragraph. Letters are not
  drawn out here: with nikud, points under a stretched stroke would be
  distorted.

## Notes

- Stam Sefarad CLM (the shivitis' font) has **no vowel points**: they drop
  out silently. A pointed text needs another face (e.g. Taamey David CLM,
  the books' font).
