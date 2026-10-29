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

- **Stam Sefarad CLM** (Culmus, GPL with font exception), as shipped with
  TeX Live (`StamSefaradCLM.ttf`), for both the background and the large
  letters. Not copied into the repo.

## Decisions by Yosef

- **Concept:** a dense, justified block of tiny unvowelled Shir HaShirim
  as the background, with a large 2x2 block of אהבה over its centre (his
  description: in the manner of Robert Indiana's LOVE layout, the letters
  in Stam Sefarad, in gold leaf, the background showing through the gaps).
  Indiana made a Hebrew AHAVA himself (1977); the poster takes only the
  idea of a 2x2 letter grid, not his letterforms or tilted letter.
- **This replaces the earlier plan** (option a): no separate Ani LeDodi
  verse, no Pirkei Avot line, no dedication line.

## Draft (not yet Yosef's design decisions)

`main.tex`, compiled with LuaLaTeX (twice), in the four formats (aceo,
siddur, birkon, poster; `\ahavaformat`). Everything scales from one unit,
1% of the largest 2:3 box that fits the page.

- Background (`ahava.lua`): black, justified edge to edge inside a margin
  of 5 units; the type size is searched so the book fills the area exactly
  with a full last line (about 15.6pt on the poster, 3.3pt on an ACEO card).
  Baseline distance 1.25 times the type size.
- Letters: flat gold (RGB 191,149,63) as a stand-in for gold leaf or foil,
  each with a paper-coloured edge of 0.8 units so the text does not touch
  it. Placed by their ink: the block is 78 units tall, the ink gap between
  letters at least 4 units across and down, centred on the page (measured
  within 0.1 unit in all four formats).
