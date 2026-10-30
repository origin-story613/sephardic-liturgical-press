# Ani LeDodi (Ahava poster): sources and decisions

## Text

### Background: the whole of Shir HaShirim

Westminster Leningrad Codex, "Tanach with Ta'amei Hamikra", **public
domain**, from the Sefaria export
(`json/Tanakh/Writings/Song of Songs/Hebrew/Tanach with Ta'amei Hamikra.json`).
`make-text.py` turns it into `text.tex`: letters only (no vowels or
te'amim), a maqaf becomes a space, the paseq, sof pasuq and the section
marks (ס)/(פ) are dropped, so the book is one continuous run of words.
1,250 words, 5,151 letters. The four-letter Name does not occur in the
book. 6:3 (אני לדודי ודודי לי הרעה בשושנים) is part of it.

**Not yet decided by Yosef** (the draft follows Leningrad's written text):

- **Ketiv/qere.** Four words are written one way and read another. The
  draft has the written form (as a scroll would):
  1:17 רחיטנו (read רהיטנו), 2:11 הסתו (read הסתיו), 2:13 לכי (read לך),
  4:9 באחד (read באחת).
- **8:6 שלהבתיה**, one word in Leningrad; some read its ending as a divine
  name, and some printings split it in two.

### The large letters

אהבה, in a 2x2 grid, right to left: top row א ה, bottom row ב ה.

## Fonts

- **Keter Aram Tsova** (Yoram Gnat, 2012, after the Aleppo Codex; GPL-2
  with font exception), for the background. Not in TeX Live, so it is in
  `fonts/` with its licence (`fonts/README.md`, `fonts/GPL-2.txt`), taken
  unmodified from Culmus Fancy Fonts as packaged in Debian (`culmus-fancy`
  0.0.20140315-1).
- **Hofesh** (Meir Sadan, Oketz, version 2.00, 1998-2003), for the large
  letters. From hebrewfont.net (`download/Hofesh.zip`), unmodified, in
  `fonts/` with its licence (`fonts/README.md`). Licence, embedded in the
  font: **Creative Commons Attribution-NoDerivs-NonCommercial 1.0**:
  personal use with credit to Meir Sadan is fine; **selling the poster
  needs his permission** (meir@sadan.com); the font may not be altered.

## Decisions by Yosef

- **Concept:** a dense, justified block of tiny unvowelled Shir HaShirim
  as the background, with a large 2x2 block of אהבה over its centre (his
  description: in the manner of Robert Indiana's LOVE layout, the letters
  in Stam Sefarad, in gold leaf, the background showing through the gaps).
  Indiana made a Hebrew AHAVA himself (1977); the poster takes only the
  idea of a 2x2 letter grid, not his letterforms or tilted letter.
- **This replaces the earlier plan** (option a): no separate Ani LeDodi
  verse, no Pirkei Avot line, no dedication line.
- **Background font: Keter Aram Tsova** (his choice, from the Open Siddur
  font list).
- **Large letters: Hofesh**, from hebrewfont.net (his choice). It is
  Meir Sadan's free font (above), not the commercial Hofesh MF sold by
  Masterfont. **Weight: as it is** (option a), not thickened. Kept after
  comparing it with the other candidates, Busta among them (option a).
- **Busta and Latet Bold on the poster, to compare** (his requests): a
  switch at the top of `main.tex` (`\ahavaletters`: LatetBold, Busta or
  Hofesh) until he chooses; the draft shows Latet Bold. Both are Meir
  Sadan's, with the same licence as Hofesh (`fonts/README.md`).

## Draft (not yet Yosef's design decisions)

`main.tex`, compiled with LuaLaTeX (twice), in the four formats (aceo,
siddur, birkon, poster; `\ahavaformat`). Everything scales from one unit,
1% of the largest 2:3 box that fits the page.

- Background (`ahava.lua`): black, justified edge to edge inside a margin
  of 5 units; the type size is searched so the book fills the area exactly
  with a full last line (15.3pt on the poster in Keter Aram Tsova).
  Baseline distance 1.25 times the type size.
- Letters: Latet Bold, Busta or Hofesh (`\ahavaletters`), flat gold (RGB 191,149,63) as a stand-in for gold leaf or foil,
  each with a paper-coloured edge of 0.8 units so the text does not touch
  it. Placed by their ink: the block is 78 units tall, the ink gap between
  letters at least 4 units across and down, centred on the page (measured
  in Hofesh on the poster, each letter drawn alone: 4.8 units across, 4.1
  down; centred within 0.1 unit. In Busta, whose letters differ more in
  size: 4.2 units at the closest, up to 10.8 where a short ה stands next
  to a tall א; centred within 0.12 unit. In Latet Bold: 4.2 to 4.6
  units; centred within 0.1 unit).
