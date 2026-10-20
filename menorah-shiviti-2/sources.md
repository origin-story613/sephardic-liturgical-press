# Shiviti 2: sources and decisions

Shiviti 2 starts from Shiviti 1 exactly as it stood on 2026-10-19 (`main`
at commit 8410888): same text (`psalm67.lua`), spelling, font, layout and
sizes. The text source, counts, licenses and Shiviti 1's decisions are in
`menorah-shiviti/sources.md`; they hold here unless listed below.

The Name and Adonai are assembled from code points, never written out, as
in Shiviti 1.

## How Shiviti 2 differs from Shiviti 1

- **Top line (Yosef):** the whole passage across the very top, above the
  Name: דע לפני מי אתה עומד לפני מלך מלכי המלכים הקב"ה (Berakhot 28b),
  spelled as in his siddur (עומד with vav). At 0.8 of the text size
  (`header_scale`), shrinking only if it would take more than 90% of the
  width (`header_width`). Stam Sefarad has no gershayim (U+05F4), so the
  abbreviation הקב"ה takes a plain double quote, which the font has.
  To make room, the top margin is 0.03 of the width (was 0.05) and the
  menorah sits a little lower (`cy` 0.465, was 0.48).
- **Combined names (Yosef):** the letters of the Name and of Adonai
  alternating. Name first on the right under שויתי, Adonai first on the left
  under לנגדי, both on one line level with תמיד (Yosef; his siddur staggers
  them, he wants them aligned). At 0.9 of the text size (`combined_scale`).
  Built in
  `menorah.lua` by interleaving the two words' code points (`interleave()`),
  never written out; letter order checked from the compiled PDF. The
  pre-commit check would not catch an interleaved form typed into a file, so
  never type them. To make room: תמיד sits closer under the Name
  (`tamid_gap` 0.012 of the width) and the menorah a little lower (`cy`
  0.455).
- **שויתי, לנגדי, תמיד** 20% larger than the text (`verse_scale`, Yosef).
- **Ana BeKoach (Yosef):** two even blocks either side of the base, made of
  the prayer's initials: each of its seven lines gives six letters, set as
  two triads (42 letters in all), and the closing line ברוך שם כבוד מלכותו
  לעולם ועד gives a further six letters, added by Yosef so the blocks are
  even, set as one word with the acronym mark before its last letter:
  בשכמל"ו (a plain double quote; Stam Sefarad has no gershayim). Each row of a block is one whole line, its two triads
  side by side: the right block holds lines 1-4, the left block lines 5-7
  and the closing line, four rows each. Order checked against the prayer's
  lines. Stored as code points in `menorah.lua` (`ANA_BEKOACH`), not
  written out. Sized and placed to fill the lower corners (Yosef): each
  square's side is 0.24 of the width (`ana_side`; the text size follows from
  it), centred 0.345 of the width from the middle (`ana_x`), the last rows
  0.045 of the width above the foot (`ana_bottom`). Checked clear of the
  outer branches' curves and the base.
- **Ana BeKoach blocks are squares (Yosef):** every row is set to the same
  width, 1.12 times the widest row's natural width (`ana_square_pad`), by
  drawing out one or two letters, as a scribe fills a line; the rows are
  spaced so each block is as tall as it is wide. Letters drawn out, by
  priority: the traditional dilatable letters present (tav, he, lamed; alef
  has no straight stroke in this font and final mem too short a one), else
  dalet, resh, chet (`STRETCHABLE` in `menorah.lua`, stretches measured from
  the font). Per row: אבג יתץ tav; קרע שטן resh; נגד יכש dalet; בטר צתג resh
  and tav; חקב טנע chet; יגל פזק lamed; שקו צית tav; בשכמל"ו lamed. Same
  three-slice method as the Name's he (`stretched()`, now shared by both).
  The space between a row's triads is a control space: where the drawn-out
  letter ended the first triad, the second triad's piece began with a plain
  space, which TeX drops, so the triads ran together (Yosef noticed, in
  נגד יכש, בטר צתג and יגל פזק).

