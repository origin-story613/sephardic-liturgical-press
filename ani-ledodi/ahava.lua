-- ani-ledodi/ahava.lua
-- 1. The background: all of Shir HaShirim as one justified block that
--    fills the text area exactly. The type size is searched so the text
--    fits in the area's height with its last line (nearly) full; the lines
--    are then spread to the full height and the last line justified too.
-- 2. The large letters: sized and placed by their ink (the extents of the
--    glyph outlines), so the gaps between them are exact.

local M = {}

-- line breaking: no overfull lines (Hebrew is not hyphenated)
local BREAKS = '\\tolerance=9999\\emergencystretch=1em' ..
  -- always the same baseline distance, even where the tall letters of the
  -- Stam face (lamed, tagin) would reach the line above
  '\\lineskiplimit=-\\maxdimen'

local function run(s) tex.runtoks(function() tex.sprint(s) end) end

-- The paragraph, set at size s (scaled points) with baseline distance
-- s * lead, into box \ahavabg. `to` (TeX dimension or nil) fixes the
-- height, the lines spreading evenly. The \begingroup keeps \color's reset
-- inside the box.
local function set_at(s, lead, to)
  local b = math.floor(s * lead)
  run(string.format(
    '\\setbox\\ahavabg\\vbox%s{\\begingroup\\hsize=\\textwidth\\bgfont' ..
    '%s%s\\fontsize{%dsp}{%dsp}\\selectfont\\leftskip=0pt\\rightskip=0pt' ..
    '\\parindent=0pt\\parfillskip=0pt plus 1fil\\baselineskip=%dsp%s' ..
    '\\ahavatext\\par\\endgroup}',
    to and (' to ' .. to) or '',
    to and '' or '\\hbadness=10000\\hfuzz=\\maxdimen',   -- quiet trial runs
    BREAKS, s, b, b, to and ' plus 1fil' or ''))
end

-- The last line of box \ahavabg, and how full it is (0..1).
local function last_line()
  local line
  for n in node.traverse_id(node.id('hlist'), tex.box.ahavabg.list) do line = n end
  return line, node.dimensions(line.head) / line.width
end

-- lead: baseline distance / type size; fillmin: how full the last line
-- must be (it is then justified). Puts the finished block on the page.
function M.background(lead, fillmin)
  local H = tex.dimen.textheight
  -- largest size that fits, by bisection (40pt: above any size used, but
  -- small enough that no trial box overflows TeX's largest dimension)
  local lo, hi = 65536, 65536 * 40
  while hi - lo > 64 do
    local s = (lo + hi) // 2
    set_at(s, lead)
    local b = tex.box.ahavabg
    if b.height + b.depth <= H then lo = s else hi = s end
  end
  -- step down from there until the last line is full enough
  local s = lo
  for _ = 1, 400 do
    set_at(s, lead)
    local b = tex.box.ahavabg
    local _, fill = last_line()
    if b.height + b.depth <= H and fill >= fillmin then break end
    s = math.floor(s * 0.999)
  end
  set_at(s, lead, '\\textheight')
  -- justify the last line: drop the parfillskip's stretch and repack
  local line = last_line()
  for g in node.traverse_id(node.id('glue'), line.head) do
    if node.subtypes('glue')[g.subtype] == 'parfillskip' then
      g.width, g.stretch, g.stretch_order = 0, 0, 0
    end
  end
  local packed = node.hpack(line.head, line.width, 'exactly')
  line.glue_set, line.glue_sign, line.glue_order =
    packed.glue_set, packed.glue_sign, packed.glue_order
  packed.head = nil
  node.free(packed)
  texio.write_nl(string.format('ahava: background type %.3fpt', s / 65536))
  tex.sprint('\\par\\nointerlineskip\\box\\ahavabg')
end

-- The grid, right to left: top row alef, he; bottom row bet, he.
local CELLS = {
  { name = 'TR', char = 0x05D0, col = 'R', row = 'T' },
  { name = 'TL', char = 0x05D4, col = 'L', row = 'T' },
  { name = 'BR', char = 0x05D1, col = 'R', row = 'B' },
  { name = 'BL', char = 0x05D4, col = 'L', row = 'B' },
}

-- size: the larger of the block's ink width and height; gap: between the
-- letters' ink, across and down (both scaled points). Each letter is
-- centred across its column; the letters of a row share a baseline, set
-- so the row's lowest ink is on the row's lower edge. Defines \ahavasize (type size) and, per cell, \ahavaX<cell>
-- and \ahavaY<cell>: the letter's origin (left end, baseline) from the
-- page centre.
function M.letters(size, gap)
  run('\\setbox\\ahavabg\\hbox{\\bigfont\\fontsize{100pt}{100pt}\\selectfont' ..
      '\\directlua{ahava.fid = font.current()}}')
  local f = fonts.hashes.identifiers[M.fid]
  local per = 1 / f.parameters.units   -- font units -> type size
  -- ink boxes in multiples of the type size
  local colw, rowh, rowlow = { R = 0, L = 0 }, { T = 0, B = 0 }, { T = 0, B = 0 }
  for _, c in ipairs(CELLS) do
    local bb = f.descriptions[c.char].boundingbox
    c.x0, c.y0, c.x1, c.y1 = bb[1] * per, bb[2] * per, bb[3] * per, bb[4] * per
    colw[c.col] = math.max(colw[c.col], c.x1 - c.x0)
    rowlow[c.row] = math.min(rowlow[c.row], c.y0)
  end
  for _, c in ipairs(CELLS) do
    rowh[c.row] = math.max(rowh[c.row], c.y1 - rowlow[c.row])
  end
  -- type size: the block (ink plus one gap each way) is `size` at most
  local w, h = colw.R + colw.L, rowh.T + rowh.B
  local s = (size - gap) / math.max(w, h)
  local W, Hb = w * s + gap, h * s + gap
  -- column and row edges, from the page centre (x right, y up)
  local left = { L = -W / 2, R = -W / 2 + colw.L * s + gap }
  local low = { B = -Hb / 2, T = -Hb / 2 + rowh.B * s + gap }
  for _, c in ipairs(CELLS) do
    local inkx = left[c.col] + (colw[c.col] - (c.x1 - c.x0)) * s / 2
    local x = inkx - c.x0 * s                  -- origin = ink left - bearing
    local y = low[c.row] - rowlow[c.row] * s   -- baseline above the row line
    tex.sprint(string.format('\\gdef\\ahavaX%s{%dsp}\\gdef\\ahavaY%s{%dsp}',
      c.name, math.floor(x), c.name, math.floor(y)))
  end
  tex.sprint(string.format('\\gdef\\ahavasize{%dsp}', math.floor(s)))
  texio.write_nl(string.format('ahava: letters %.2fpt, block %.2f x %.2fpt',
    s / 65536, W / 65536, Hb / 65536))
end

return M
