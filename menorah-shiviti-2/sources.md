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
