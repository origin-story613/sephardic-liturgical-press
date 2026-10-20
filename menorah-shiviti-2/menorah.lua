-- menorah.lua (Shiviti 2)
-- Geometry and text placement for Shiviti 2, which began as a copy of
-- Shiviti 1 (menorah-shiviti/menorah.lua). Its Lua table is `shiviti2`, so
-- both shivitis can be used in one document.
--
-- Draft layout: three nested branches on each side of a central shaft, each
-- an upright stem over a quarter circle, so all seven lamps share one line.
-- Verse 1 runs across the top, its letters grouped over the seven lamps. The other verses run down
-- the branches from the lamp toward the shaft, in order from left to right:
-- verses 2, 3, 4 on the left branches (outer to inner), verse 5 straight
-- down the shaft, verses 6, 7, 8 on the right branches (inner to outer).
-- The last words of verse 5 form the base, arched under the shaft. Above
-- the menorah, Psalm 16:8 with the Name large in the centre: shviti to its
-- right, lenegdi to its left, tamid beneath it. Above it all, in smaller
-- letters, "da lifnei mi atah omed".
-- The text is letters only (see psalm67.lua).
-- Each word is a separate TikZ node rotated to the direction of its path.
--
-- Lengths are fractions of the page width unless noted, so every format is
-- the same design scaled. shiviti2-setup.tex loads this file and the text;
-- \shivitiII calls measure() then draw(), each printing TeX that runs
-- before the next. The page size is read from the document, so the same
-- drawing fits the poster formats and the books' pages.

local M = {}

-- Page sizes in inches. Poster size is a placeholder until Yosef chooses.
M.formats = {
  aceo   = { w = 2.5,  h = 3.5  },
  siddur = { w = 3.5,  h = 4.75 },  -- Shabbat siddur page
  birkon = { w = 4.25, h = 5.5  },  -- birkon and Seder HaShulchan page
  poster = { w = 12,   h = 18   },
}

-- Layout parameters.
M.p = {
  ratio  = 1.5,   -- height of the design box over its width (the poster's)
  cy     = 0.455,  -- height of the arc centres, as a fraction of page height
  radii  = { 0.20, 0.31, 0.42 },  -- inner, middle, outer branch
  stem   = 0.44,  -- straight upright part of every branch, above the arcs
  foot   = 0.10,  -- shaft length below the outer arc
  base_words = 3, -- last words of verse 5 set as the base
  base_gap   = 0.04, -- from the end of the shaft to the top of the base arch
  base_width = 0.40, -- length of the base arch
  base_radius = 0.40, -- radius of the base arch
  ana_side   = 0.24, -- side of each Ana BeKoach square, in widths (sets its text size)
  ana_x      = 0.345, -- centre of each square, from the middle, in widths
  ana_bottom = 0.045, -- baseline of the last row, above the design's foot
  ana_square_pad = 1.12, -- the square's side, over the widest row's natural width
  shaft_half = 0.03, -- half the width of the shaft line of text
  pad    = 0.02,  -- clearance between branch text and the shaft
  fill   = 0.86,  -- share of a branch taken by words at the fitted size
  shaft_fill = 0.95, -- the same for the shaft (verse 5 is the longest)
  title  = 0.015, -- gap between the lamp line and the verse 1 baseline
  lamp_groups = { 3, 3, 3, 2, 3, 3, 3 },  -- verse 1 letters per lamp, right to left
  lamp_scale  = 1.2, -- size of the verse 1 letter groups, relative to the text size
  top    = 0.03,  -- page margin above the top line
  header_scale = 0.8, -- size of the top line, relative to the text size
  header_width = 0.90, -- the most of the width the top line may take
  combined_scale = 0.9, -- size of the combined names, relative to the text size
  header_gap   = 0.015, -- between the top line and the Name
  name_scale = 3.3, -- size of the Name, relative to the text size
  name_gap   = 0.03, -- between the Name and the words beside it
  tamid_gap  = 0.012, -- between the Name and tamid below it
  verse_scale = 1.2, -- size of shviti, lenegdi and tamid, relative to the text size
  adonai_scale = 0.33, -- size of Adonai inside the final he, relative to the Name
  adonai_pad   = 0.12, -- space each side of Adonai, in he widths
  adonai_rise  = 0.10, -- Adonai's baseline above the Name's, in Name sizes
  guides = false, -- draw faint construction lines (layout checks only)
  label  = true,  -- small corner label: format, page and text size (standalone
                  -- drafts only; never in the books)
}

local CM_PER_PT = 2.54 / 72.27
local SP_PER_PT = 65536
local BASE = 10  -- measuring size, pt

-- Psalm 16:8 around the Name: the words before and after it, and the one
-- set beneath it (Leningrad, letters only; same in Yosef's siddur).
local SHVITI, LENEGDI, TAMID = 'שויתי', 'לנגדי', 'תמיד'

-- Across the very top, in smaller letters (Yosef): "Know before whom you
-- stand, before the King of kings, the Holy One, blessed be He", spelled as
-- in his siddur. Stam Sefarad has no gershayim (U+05F4), so the abbreviation
-- takes a plain double quote, which the font does have.
local HEADER = 'דע לפני מי אתה עומד לפני מלך מלכי המלכים הקב"ה'

-- The Name, unpointed, and the name Adonai set inside its final he, both
-- assembled from code points so they are never written out in any file.
-- NAME_HEAD is the Name's first three letters; its last letter is HE.
local NAME_HEAD = utf8.char(0x05D9, 0x05D4, 0x05D5)
local HE = utf8.char(0x05D4)
local ADONAI = utf8.char(0x05D0, 0x05D3, 0x05E0, 0x05D9)

-- The combined names: the letters of the Name and of Adonai alternating,
-- Name first and Adonai first. Built letter by letter from the two words'
-- code points, so neither is ever written out.
local function interleave(a, b)
  local out = {}
  for i = 1, 4 do
    out[#out + 1] = utf8.char(utf8.codepoint(a, utf8.offset(a, i)))
    out[#out + 1] = utf8.char(utf8.codepoint(b, utf8.offset(b, i)))
  end
  return table.concat(out)
end
local NAME = NAME_HEAD .. HE

-- Ana BeKoach: the initials of its seven lines, each line's six letters as
-- two triads (the 42-letter name), then those of its closing line. Stored as code points, never written
-- out. Each row of a block is one whole line (its two triads); the right
-- block holds lines 1-4, the left block lines 5-7 and the closing line.
local ANA_BEKOACH = {
  { "\u{05D0}\u{05D1}\u{05D2}", "\u{05D9}\u{05EA}\u{05E5}" },
  { "\u{05E7}\u{05E8}\u{05E2}", "\u{05E9}\u{05D8}\u{05DF}" },
  { "\u{05E0}\u{05D2}\u{05D3}", "\u{05D9}\u{05DB}\u{05E9}" },
  { "\u{05D1}\u{05D8}\u{05E8}", "\u{05E6}\u{05EA}\u{05D2}" },
  { "\u{05D7}\u{05E7}\u{05D1}", "\u{05D8}\u{05E0}\u{05E2}" },
  { "\u{05D9}\u{05D2}\u{05DC}", "\u{05E4}\u{05D6}\u{05E7}" },
  { "\u{05E9}\u{05E7}\u{05D5}", "\u{05E6}\u{05D9}\u{05EA}" },
  -- the closing line, baruch shem kevod malchuto le'olam va'ed: one word,
  -- marked as an acronym before its last letter (a plain double quote; the
  -- font has no gershayim)
  { "\u{05D1}\u{05E9}\u{05DB}\u{05DE}\u{05DC}\"\u{05D5}" },
}
local COMBINED_NAME_FIRST = interleave(NAME, ADONAI)
local COMBINED_ADONAI_FIRST = interleave(ADONAI, NAME)

-- The stretched he: Stam Sefarad's he, measured as fractions of its width.
-- Only the plain roof between STRETCH_A and STRETCH_B is widened; the left
-- leg with its stem and ball, and the right leg, keep their own shape.
local STRETCH_A, STRETCH_B = 0.32, 0.68
local LEFT_LEG_END, RIGHT_LEG_START = 0.27, 0.75

-- Letters a scribe may draw out to fill a line, with the stretch of each in
-- Stam Sefarad that is a plain horizontal stroke (fractions of the glyph's
-- width, measured from the font, inner part of the plain run). Priority 1:
-- the traditional dilatable letters (of אהלתם; alef has no straight run in
-- this font, final mem too short a one); 2: dalet, resh, chet.
local STRETCHABLE = {
  [0x05EA] = { a = 0.476, b = 0.716, pri = 1 },  -- tav: roof
  [0x05D4] = { a = STRETCH_A, b = STRETCH_B, pri = 1 },  -- he: roof
  [0x05DC] = { a = 0.287, b = 0.403, pri = 1 },  -- lamed: bar
  [0x05D3] = { a = 0.334, b = 0.660, pri = 2 },  -- dalet: roof
  [0x05E8] = { a = 0.246, b = 0.619, pri = 2 },  -- resh: roof
  [0x05D7] = { a = 0.349, b = 0.704, pri = 2 },  -- chet: roof
}

-- W, H: the design box, always M.p.ratio tall for its width, fitted inside
-- the page (PW, PH) and centred at offset (OX, OY), so every format has the
-- same proportions whatever its page shape.
local text, fmt, W, H, PW, PH, OX, OY, shaft_len
local letter_h     -- letter body height at BASE pt, in pt
local widths = {}  -- widths[v][i]: word width at BASE pt, in pt
local size         -- fitted font size, pt

local function heb(sz, s)
  return string.format(
    '\\foreignlanguage{hebrew}{\\stamfont\\fontsize{%.3f}{%.3f}\\selectfont %s}',
    sz, sz * 1.25, s)
end

local function sum(t) local s = 0 for _, x in ipairs(t) do s = s + x end return s end

-- Load the text once: from shiviti2-setup.tex, in the standalone main.tex
-- and in each book that carries the shiviti.
function M.load(dir)
  text = dofile(dir .. 'psalm67.lua')
  -- Split verse 5: the shaft keeps the start, the base ("verse 9") the end.
  local v5, n = text[5], #text[5] - M.p.base_words
  text[9] = { table.unpack(v5, n + 1) }
  text[5] = { table.unpack(v5, 1, n) }
end

-- Standalone output only (menorah-shiviti-2/main.tex): set the page to one of
-- M.formats. In a book the page is the book's own.
function M.page_format(name)
  fmt = M.formats[name] or error('unknown format ' .. tostring(name))
  fmt.name = name
  tex.sprint(string.format(
    '\\geometry{paperwidth=%.4fin,paperheight=%.4fin,margin=0pt}', fmt.w, fmt.h))
end

-- Fit the design box to the current page.
local function fit_page()
  PW = tex.dimen.paperwidth / SP_PER_PT * CM_PER_PT
  PH = tex.dimen.paperheight / SP_PER_PT * CM_PER_PT
  W = math.min(PW, PH / M.p.ratio)
  H = W * M.p.ratio
  OX, OY = (PW - W) / 2, (PH - H) / 2
end

-- Box a string at BASE size and record it under key (see record_box). Keys
-- are plain ASCII, since they pass through TeX.
local function measure_box(key, str)
  tex.sprint('\\setbox0\\hbox{' .. heb(BASE, str) .. '}' ..
    string.format('\\directlua{shiviti2.record_box("%s")}', key))
end

-- Ana BeKoach rows, each split into pieces for setting it to a fixed width:
-- runs of plain text, and the one or two letters to be drawn out (by
-- STRETCHABLE priority, then reading order). Pieces are in reading order,
-- so right to left.
local ana_plans
function M.ana_plans()
  if ana_plans then return ana_plans end
  ana_plans = {}
  for r, line in ipairs(ANA_BEKOACH) do
    local chars = {}
    for _, c in utf8.codes(table.concat(line, ' ')) do chars[#chars + 1] = c end
    local cand = {}
    for i, c in ipairs(chars) do
      if STRETCHABLE[c] then cand[#cand + 1] = i end
    end
    table.sort(cand, function(x, y)
      local px, py = STRETCHABLE[chars[x]].pri, STRETCHABLE[chars[y]].pri
      if px ~= py then return px < py end
      return x < y
    end)
    local pick = {}
    for k = 1, math.min(2, #cand) do pick[cand[k]] = true end
    if #cand == 0 then error('Ana BeKoach row ' .. r .. ' has no letter to draw out') end
    local plan, run = {}, {}
    local function flush()
      if #run > 0 then
        plan[#plan + 1] = { str = utf8.char(table.unpack(run)) }
        run = {}
      end
    end
    for i, c in ipairs(chars) do
      if pick[i] then
        flush()
        plan[#plan + 1] = { str = utf8.char(c), stretch = STRETCHABLE[c] }
      else
        run[#run + 1] = c
      end
    end
    flush()
    for j, seg in ipairs(plan) do seg.key = string.format('ana%d_%d', r, j) end
    ana_plans[r] = plan
  end
  return ana_plans
end

-- Box every word at BASE size and record its width.
function M.measure()
  for v, verse in ipairs(text) do
    widths[v] = {}
    for i, w in ipairs(verse) do
      tex.sprint('\\setbox0\\hbox{' .. heb(BASE, w) .. '}' ..
        string.format('\\directlua{shiviti2.record(%d,%d)}', v, i))
    end
  end
  -- body height of a letter (bet: no ascender or descender), and the pieces
  -- of the Name
  for _, plan in ipairs(M.ana_plans()) do
    for _, seg in ipairs(plan) do measure_box(seg.key, seg.str) end
  end
  for key, str in pairs({ bet = utf8.char(0x05D1), head = NAME_HEAD, he = HE,
                          adonai = ADONAI, header = HEADER }) do
    measure_box(key, str)
  end
end

-- boxes[key] = { w, h, d } at BASE pt, in pt
local boxes = {}
function M.record_box(key)
  local b = tex.box[0]
  boxes[key] = { w = b.width / SP_PER_PT, h = b.height / SP_PER_PT,
                 d = b.depth / SP_PER_PT }
  if key == 'bet' then letter_h = boxes.bet.h end
end

function M.record(v, i)
  widths[v][i] = tex.box[0].width / SP_PER_PT
end

-- Text paths, each running from its lamp toward the base. pos(d) returns
-- x, y and the unit direction of travel at distance d along the path.
local function paths()
  local cx, cy, L = W / 2, M.p.cy * H, M.p.stem * W
  local out = {}
  local left, right = { 2, 3, 4 }, { 8, 7, 6 }  -- outer to inner
  for k = 1, 3 do
    local r = M.p.radii[4 - k] * W
    local cut = math.asin(math.min(1, (M.p.shaft_half + M.p.pad) * W / r))
    local arc = r * (math.pi / 2 - cut)
    for _, side in ipairs({ -1, 1 }) do
      out[#out + 1] = {
        verse = side < 0 and left[k] or right[k], len = L + arc,
        pos = function(d)
          if d <= L then return cx + side * r, cy + L - d, 0, -1 end
          local a = (d - L) / r            -- angle turned from the bottom-up
          return cx + side * r * math.cos(a), cy - r * math.sin(a),
                 -side * math.sin(a), -math.cos(a)
        end }
    end
  end
  shaft_len = L + M.p.radii[3] * W + M.p.foot * W
  out[#out + 1] = { verse = 5, len = shaft_len, fill = M.p.shaft_fill,
    pos = function(d) return cx, cy + L - d, 0, -1 end }
  -- the base: an arch under the shaft, read right to left over its top
  local R, top = M.p.base_radius * W, cy + L - shaft_len - M.p.base_gap * W
  local blen = M.p.base_width * W
  out[#out + 1] = { verse = 9, len = blen, pos = function(d)
    local t = math.pi / 2 - (blen / 2 - d) / R
    return cx + R * math.cos(t), top - R + R * math.sin(t),
           -math.sin(t), math.cos(t)
  end }
  return out
end

-- Common font size: the largest that fits every path at its fill.
local function fit_size(ps)
  local s = math.huge
  for _, p in ipairs(ps) do
    local need = sum(widths[p.verse]) * CM_PER_PT / BASE  -- cm per pt
    s = math.min(s, (p.fill or M.p.fill) * p.len / need)
  end
  return s
end

-- Hebrew reads right to left, so a word's own x-axis points against the
-- direction of travel. Each word is centred on its path: its baseline is
-- moved half a letter height away from the side its tops face, so text
-- turned either way (the upside-down lower left curves, the upright lower
-- right ones) meets the shaft at the same height.
local function place(out, p)
  local half = letter_h * size / BASE * CM_PER_PT / 2
  local ws = {}
  for i, w in ipairs(widths[p.verse]) do ws[i] = w * size / BASE * CM_PER_PT end
  local gap = (p.len - sum(ws)) / #ws          -- half a gap at each end
  local d = gap / 2
  for i, w in ipairs(text[p.verse]) do
    local x, y, tx, ty = p.pos(d + ws[i] / 2)
    local a = math.atan(-ty, -tx)                -- the word's rotation
    local ux, uy = -math.sin(a), math.cos(a)     -- where its tops point
    out[#out + 1] = string.format(
      '\\node[rotate=%.3f,anchor=base,inner sep=0pt] at (%.4f,%.4f) {%s};',
      math.deg(a), x - half * ux, y - half * uy, heb(size, w))
    d = d + ws[i] + gap
  end
end

-- Verse 1 over the seven lamps: its letters run together and are cut into
-- groups, three over each branch and two over the shaft, reading right to
-- left. Letters keep their in-word forms (no final forms at the cuts).
local function lamp_groups(out, y)
  local letters = {}
  for _, w in ipairs(text[1]) do
    for _, c in utf8.codes(w) do letters[#letters + 1] = utf8.char(c) end
  end
  local sizes = M.p.lamp_groups
  if sum(sizes) ~= #letters then
    error(string.format('verse 1 has %d letters, lamp groups need %d',
      #letters, sum(sizes)))
  end
  local r = M.p.radii
  local xs = { r[3], r[2], r[1], 0, -r[1], -r[2], -r[3] }  -- right to left
  local k = 0
  for g, n in ipairs(sizes) do
    out[#out + 1] = string.format(
      '\\node[anchor=base,inner sep=0pt] at (%.4f,%.4f) {%s};',
      W / 2 + xs[g] * W, y,
      heb(size * M.p.lamp_scale, table.concat(letters, '', k + 1, k + n)))
    k = k + n
  end
end

-- Draw one letter drawn out by extra cm: the glyph is cut into three
-- slices at fractions a and b of its width; only the middle slice (a plain
-- horizontal stroke) is widened, the rest keep their shape. xl is the
-- letter's left edge, yb its baseline, sz its size in pt, w its natural
-- width in cm.
local function stretched(out, ch, sz, xl, yb, w, a, b, extra)
  local em = sz * CM_PER_PT
  local function piece(x0, x1, at, sx)
    out[#out + 1] = string.format(
      '\\begin{scope}\\clip (%.4f,%.4f) rectangle (%.4f,%.4f);' ..
      '\\node[anchor=base west,inner sep=0pt] at (%.4f,%.4f) {\\scalebox{%.4f}[1]{%s}};' ..
      '\\end{scope}',
      x0, yb - em, x1, yb + 2 * em, at, yb, sx, heb(sz, ch))
  end
  local mid = (b - a) * w + extra                     -- widened stroke
  local eps = 0.002 * w                               -- overlap, no hairline seams
  local xa, xb = xl + a * w, xl + a * w + mid
  local k = mid / ((b - a) * w)
  piece(xl - w, xa + eps, xl, 1)
  piece(xa, xb, xa - k * a * w, k)
  piece(xb - eps, xl + w + extra + w, xb - b * w, 1)
end

function M.draw()
  fit_page()
  local cx, cy, L = W / 2, M.p.cy * H, M.p.stem * W
  local ps = paths()
  size = fit_size(ps)
  local out = { '\\begin{otherlanguage}{english}',
    '\\begin{tikzpicture}[remember picture,overlay,shift={(current page.south west)}]',
    string.format('\\begin{scope}[shift={(%.4f,%.4f)}]', OX, OY) }

  if M.p.guides then
    out[#out + 1] = '\\begin{scope}[line width=0.3pt,black!15]'
    for _, r in ipairs(M.p.radii) do
      out[#out + 1] = string.format(
        '\\draw (%.4f,%.4f) -- ++(0,%.4f) arc (0:-180:%.4f) -- ++(0,%.4f);',
        cx + r * W, cy + L, -L, r * W, L)
    end
    out[#out + 1] = string.format('\\draw (%.4f,%.4f) -- ++(0,%.4f);',
      cx, cy + L, -shaft_len)
    out[#out + 1] = '\\end{scope}'
  end

  if M.p.label and fmt then
    -- draft label in the bottom-right corner: format, page size, text size
    out[#out + 1] = string.format(
      '\\node[anchor=south east,inner sep=0pt,black!40,font=\\fontsize{%.2f}{%.2f}\\selectfont] ' ..
      'at (%.4f,%.4f) {DRAFT: %s, %s x %s in, text %.1f pt};',
      size * 0.3, size * 0.36, PW - OX - 0.02 * W, 0.02 * W - OY,
      fmt.name, fmt.w, fmt.h, size)
  end

  for _, p in ipairs(ps) do place(out, p) end

  -- Ana BeKoach: two square blocks either side of the base, one line of the
  -- prayer per row. Every row is set to the block's width by drawing out
  -- its chosen letters; the rows are spaced so the block is as tall as wide.
  -- The square's side is set; the text size follows from it: the widest
  -- row's natural width is 1/ana_square_pad of the side.
  local plans = M.ana_plans()
  local side = M.p.ana_side * W                       -- the square's side, cm
  local widest = 0                                    -- at BASE pt, in pt
  for _, plan in ipairs(plans) do
    local w = 0
    for _, seg in ipairs(plan) do w = w + boxes[seg.key].w end
    widest = math.max(widest, w)
  end
  local as = BASE * side / (M.p.ana_square_pad * widest * CM_PER_PT)
  local function wcm(key) return boxes[key].w * as / BASE * CM_PER_PT end
  local natural = {}
  for r, plan in ipairs(plans) do
    natural[r] = 0
    for _, seg in ipairs(plan) do natural[r] = natural[r] + wcm(seg.key) end
  end
  local right_rows = math.ceil(#plans / 2)
  local body = letter_h * as / BASE * CM_PER_PT
  local lh = (side - body) / (right_rows - 1)         -- baseline to baseline
  for r, plan in ipairs(plans) do
    local dir, row = 1, r
    if r > right_rows then dir, row = -1, r - right_rows end
    local y = M.p.ana_bottom * W + (right_rows - row) * lh
    local x = cx + dir * M.p.ana_x * W + side / 2      -- right edge of the row
    local n = 0
    for _, seg in ipairs(plan) do if seg.stretch then n = n + 1 end end
    local extra = (side - natural[r]) / n
    for _, seg in ipairs(plan) do
      local w = wcm(seg.key)
      if seg.stretch then
        stretched(out, seg.str, as, x - w - extra, y, w,
          seg.stretch.a, seg.stretch.b, extra)
        x = x - w - extra
      else
        out[#out + 1] = string.format(
          '\\node[anchor=base east,inner sep=0pt] at (%.4f,%.4f) {%s};',
          x, y, heb(as, seg.str))
        x = x - w
      end
    end
  end

  -- verse 1 across the top, in letter groups over the lamps
  lamp_groups(out, cy + L + M.p.title * W)

  -- Psalm 16:8: the Name large in the centre near the top of the page,
  -- shviti on its right (east), lenegdi on its left (west). The Name's final
  -- he is stretched, with Adonai written small beneath its roof.
  local g = M.p.name_gap * W
  local ns = size * M.p.name_scale                    -- Name size, pt
  local function cm(key, f) return boxes[key][f] * ns / BASE * CM_PER_PT end
  local hw = cm('he', 'w')
  local aw = cm('adonai', 'w') * M.p.adonai_scale
  -- widen the roof so Adonai fits between the legs with padding
  local extra = math.max(0, aw + 2 * M.p.adonai_pad * hw
                            - (RIGHT_LEG_START - LEFT_LEG_END) * hw)
  local he_w = hw + extra
  local name_w = cm('head', 'w') + he_w
  local nh = math.max(cm('head', 'h'), cm('he', 'h'))
  local nd = math.max(cm('head', 'd'), cm('he', 'd'))
  local xl = cx - name_w / 2                          -- left edge of the Name
  -- the top line, then the Name below it
  local hs = math.min(size * M.p.header_scale,       -- shrink to fit the width
    BASE * M.p.header_width * W / (boxes.header.w * CM_PER_PT))
  local top_line_h = (boxes.header.h + boxes.header.d) * hs / BASE * CM_PER_PT
  out[#out + 1] = string.format(
    '\\node[anchor=north,inner sep=0pt] at (%.4f,%.4f) {%s};',
    cx, H - M.p.top * W, heb(hs, HEADER))
  local yb = H - M.p.top * W - top_line_h - M.p.header_gap * W - nh  -- Name baseline
  stretched(out, HE, ns, xl, yb, hw, STRETCH_A, STRETCH_B, extra)
  out[#out + 1] = string.format(
    '\\node[anchor=base east,inner sep=0pt] at (%.4f,%.4f) {%s};',
    xl + name_w, yb, heb(ns, NAME_HEAD))
  -- Adonai, centred between the legs
  local gap_mid = xl + (LEFT_LEG_END * hw + RIGHT_LEG_START * hw + extra) / 2
  out[#out + 1] = string.format(
    '\\node[anchor=base,inner sep=0pt] at (%.4f,%.4f) {%s};',
    gap_mid, yb + M.p.adonai_rise * ns * CM_PER_PT,
    heb(ns * M.p.adonai_scale, ADONAI))
  -- an empty node the size of the whole Name, for placing the words around it
  out[#out + 1] = string.format(
    '\\node[anchor=base west,inner sep=0pt,minimum width=%.4fcm,' ..
    'text height=%.4fcm,text depth=%.4fcm] (name) at (%.4f,%.4f) {};',
    name_w, nh, nd, xl, yb)
  out[#out + 1] = string.format(
    '\\node[anchor=base west,inner sep=0pt] (shviti) at ([xshift=%.4fcm]name.base east) {%s};',
    g, heb(size * M.p.verse_scale, SHVITI))
  out[#out + 1] = string.format(
    '\\node[anchor=base east,inner sep=0pt] (lenegdi) at ([xshift=%.4fcm]name.base west) {%s};',
    -g, heb(size * M.p.verse_scale, LENEGDI))
  out[#out + 1] = string.format(
    '\\node[anchor=north,inner sep=0pt] (tamid) at ([yshift=%.4fcm]name.south) {%s};',
    -M.p.tamid_gap * W, heb(size * M.p.verse_scale, TAMID))
  -- The combined names: Name first under shviti, Adonai first under
  -- lenegdi, both on one line level with tamid.
  local cs = size * M.p.combined_scale
  out[#out + 1] = string.format(
    '\\node[anchor=base,inner sep=0pt] at (shviti.center |- tamid.base) {%s};',
    heb(cs, COMBINED_NAME_FIRST))
  out[#out + 1] = string.format(
    '\\node[anchor=base,inner sep=0pt] at (lenegdi.center |- tamid.base) {%s};',
    heb(cs, COMBINED_ADONAI_FIRST))

  out[#out + 1] = '\\end{scope}'
  out[#out + 1] = '\\end{tikzpicture}'
  out[#out + 1] = '\\end{otherlanguage}'
  tex.print(out)
  texio.write_nl(string.format('shiviti2: font size %.2f pt', size))
end

return M
