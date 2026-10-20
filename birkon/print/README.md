# Birkon: files for the printer

The birkon is one folded section of 16 pages (15 printed, the last blank),
4.25″ × 5.5″ when folded, bound by hand. It is a **Hebrew book and opens from
the right**: the pages are already imposed for that, so the printer must
**not** apply its own booklet or imposition setting.

## Files

| File | What it is | How to print |
|---|---|---|
| [`birkon-text-letter.pdf`](birkon-text-letter.pdf) | The text on letter paper, two half-sheets to each letter page (4 pages = 2 letter sheets, both sides) | Duplex, **flip on long edge**, 100% (no "fit to page"), then cut each sheet in half across, at 5.5″. One run of the file makes **1 book**. |
| [`birkon-text-half-letter.pdf`](birkon-text-half-letter.pdf) | The same text on half-letter sheets, 8.5″ × 5.5″ landscape (8 pages = 4 sheets, both sides) | For a shop that prints half-letter directly: duplex, **flip on short edge**, 100%. One run of the file makes **1 book**. |
| [`birkon-cover-labels.pdf`](birkon-cover-labels.pdf) | Two front-cover labels, 3.25″ × 4.5″, with crop marks, on one letter page | One-sided, 100%, then trim at the crop marks. |

Use **one** of the two text files, not both.

## What to tell the printer

- **Ink:** black only. Everything is black or grey; there is no colour.
- **Scale:** 100% / actual size. No "fit", no "shrink to printable area", no
  booklet setting.
- **Text paper:** uncoated text stock, about 70 lb text (100–105 gsm), white
  or natural/cream, **long grain** letter. Cut in half, long-grain letter
  gives sheets with the grain parallel to the fold, which is what the binding
  needs.
- **Label paper:** text weight (70–80 lb text) rather than card stock, since
  it is glued onto the board.
- **Bleed:** none. Nothing prints to the edge; no trimming of the text is
  needed except cutting the letter sheets in half.
- **Quantity:** one run of the letter file (2 letter sheets) makes one book.
  One label page has two labels: one for the book and a spare.

## Check the first sheet

Before a full run, ask for **one** copy of the first letter sheet:

- **Front:** in the top half, the title page (סֵדֶר בִּרְכַּת הַמָּזוֹן) on
  the left and a blank page on the right.
- **Back:** the copyright page must sit directly behind the title page,
  right side up. If it is upside down, the duplex flip setting is wrong (long
  edge ↔ short edge).

## Assembling

1. Cut the letter sheets in half at 5.5″ (letter file only).
2. Stack the four half-sheets in printed order: the one with the title page
   on the outside, then the other half of the same letter sheet, then the top
   and bottom halves of the second letter sheet. The innermost one carries the
   two centre pages (pages 8 and 9).
3. Fold the stack in half together, with the title page facing out. Held
   with the fold on the right, the title page is the front: the fold is the
   spine, on the right side of the book.

With only four sheets, the inner pages push out very slightly at the fore
edge (well under 1 mm). This can be left as is or trimmed after sewing.

## Rebuilding these files

After any change to the book or the cover, rebuild in this order (pdfLaTeX or
LuaLaTeX for the files here):

1. `birkon/main.tex` (LuaLaTeX, twice) → `birkon/main.pdf`
2. `birkon/cover/front-cover.tex` (LuaLaTeX) → `front-cover.pdf`
3. `birkon-text-half-letter.tex`, then `birkon-text-letter.tex`, then
   `birkon-cover-labels.tex`

The imposition assumes exactly 16 pages. If the book's page count changes,
the page list in `birkon-text-half-letter.tex` must be redone. The rule is in
the file's comments.
