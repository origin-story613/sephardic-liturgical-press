-- menorah.lua
-- Geometry and text placement for the Menorah Shiviti (Psalm 67).
--
-- Draft layout: three nested branches on each side of a central shaft, each
-- an upright stem over a quarter circle, so all seven lamps share one line.
-- Verse 1 runs across the top, its letters grouped over the seven lamps. The other verses run down
-- the branches from the lamp toward the shaft, in order from left to right:
-- verses 2, 3, 4 on the left branches (outer to inner), verse 5 straight
-- down the shaft, verses 6, 7, 8 on the right branches (inner to outer).
-- The last words of verse 5 form the base, arched under the shaft. Above
-- the menorah, Psalm 16:8 with the Name large in the centre: shviti to its
-- right, lenegdi to its left, tamid beneath it.
-- The text is letters only (see psalm67.lua).
-- Each word is a separate TikZ node rotated to the direction of its path.
--
-- Lengths are fractions of the page width unless noted, so every format is
-- the same design scaled. main.tex calls setup(format), measure(), draw().
-- Each step prints TeX that runs before the next.

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
  cy     = 0.48,  -- height of the arc centres, as a fraction of page height
  radii  = { 0.20, 0.31, 0.42 },  -- inner, middle, outer branch
  stem   = 0.44,  -- straight upright part of every branch, above the arcs
  foot   = 0.10,  -- shaft length below the outer arc
  base_words = 3, -- last words of verse 5 set as the base
  base_gap   = 0.04, -- from the end of the shaft to the top of the base arch
  base_width = 0.40, -- length of the base arch
  base_radius = 0.40, -- radius of the base arch
  shaft_half = 0.03, -- half the width of the shaft line of text
  pad    = 0.02,  -- clearance between branch text and the shaft
  fill   = 0.86,  -- share of a branch taken by words at the fitted size
  shaft_fill = 0.95, -- the same for the shaft (verse 5 is the longest)
  title  = 0.05,  -- gap between the lamp line and the verse 1 baseline
  lamp_groups = { 3, 3, 3, 2, 3, 3, 3 },  -- verse 1 letters per lamp, right to left
  top    = 0.05,  -- page margin above the Name
  name_scale = 2.6, -- size of the Name, relative to the text size
  name_gap   = 0.03, -- between the Name and the words beside it
  guides = false, -- draw faint construction lines (layout checks only)
  label  = true,  -- small corner label: format, page and text size (draft only)
}

local CM_PER_PT = 2.54 / 72.27
local SP_PER_PT = 65536
local BASE = 10  -- measuring size, pt

-- Psalm 16:8 around the Name: the words before and after it, and the one
-- set beneath it (Leningrad, letters only; same in Yosef's siddur).
local SHVITI, LENEGDI, TAMID = 'שויתי', 'לנגדי', 'תמיד'

-- The Name, unpointed, assembled from code points so it is never written
-- out in any file.
local function the_name()
  return utf8.char(0x05D9, 0x05D4, 0x05D5, 0x05D4)
end

-- W, H: the design box, always M.p.ratio tall for its width, fitted inside
-- the page (PW, PH) and centred at offset (OX, OY), so every format has the
-- same proportions whatever its page shape.
local text, fmt, W, H, PW, PH, OX, OY, shaft_len
local widths = {}  -- widths[v][i]: word width at BASE pt, in pt
local size         -- fitted font size, pt

local function heb(sz, s)
  return string.format(
    '\\foreignlanguage{hebrew}{\\stamfont\\fontsize{%.3f}{%.3f}\\selectfont %s}',
    sz, sz * 1.25, s)
end

local function sum(t) local s = 0 for _, x in ipairs(t) do s = s + x end return s end

function M.setup(name, dir)
  fmt = M.formats[name] or error('unknown format ' .. tostring(name))
  fmt.name = name
  PW, PH = fmt.w * 2.54, fmt.h * 2.54
  W = math.min(PW, PH / M.p.ratio)
  H = W * M.p.ratio
  OX, OY = (PW - W) / 2, (PH - H) / 2
  text = dofile(dir .. 'psalm67.lua')
  -- Split verse 5: the shaft keeps the start, the base ("verse 9") the end.
  local v5, n = text[5], #text[5] - M.p.base_words
  text[9] = { table.unpack(v5, n + 1) }
  text[5] = { table.unpack(v5, 1, n) }
  tex.sprint(string.format(
    '\\geometry{paperwidth=%.4fin,paperheight=%.4fin,margin=0pt}', fmt.w, fmt.h))
end

-- Box every word at BASE size and record its width.
function M.measure()
  for v, verse in ipairs(text) do
    widths[v] = {}
    for i, w in ipairs(verse) do
      tex.sprint('\\setbox0\\hbox{' .. heb(BASE, w) .. '}' ..
        string.format('\\directlua{menorah.record(%d,%d)}', v, i))
    end
  end
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
-- direction of travel.
local function place(out, p)
  local ws = {}
  for i, w in ipairs(widths[p.verse]) do ws[i] = w * size / BASE * CM_PER_PT end
  local gap = (p.len - sum(ws)) / #ws          -- half a gap at each end
  local d = gap / 2
  for i, w in ipairs(text[p.verse]) do
    local x, y, tx, ty = p.pos(d + ws[i] / 2)
    out[#out + 1] = string.format(
      '\\node[rotate=%.3f,anchor=base,inner sep=0pt] at (%.4f,%.4f) {%s};',
      math.deg(math.atan(-ty, -tx)), x, y, heb(size, w))
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
      W / 2 + xs[g] * W, y, heb(size, table.concat(letters, '', k + 1, k + n)))
    k = k + n
  end
end

function M.draw()
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

  if M.p.label then
    -- draft label in the bottom-right corner: format, page size, text size
    out[#out + 1] = string.format(
      '\\node[anchor=south east,inner sep=0pt,black!40,font=\\fontsize{%.2f}{%.2f}\\selectfont] ' ..
      'at (%.4f,%.4f) {DRAFT: %s, %s x %s in, text %.1f pt};',
      size * 0.3, size * 0.36, PW - OX - 0.02 * W, 0.02 * W - OY,
      fmt.name, fmt.w, fmt.h, size)
  end

  for _, p in ipairs(ps) do place(out, p) end

  -- verse 1 across the top, in letter groups over the lamps
  lamp_groups(out, cy + L + M.p.title * W)

  -- Psalm 16:8: the Name large in the centre near the top of the page,
  -- shviti on its right (east), lenegdi on its left (west).
  local g = M.p.name_gap * W
  out[#out + 1] = string.format(
    '\\node[anchor=north,inner sep=0pt] (name) at (%.4f,%.4f) {%s};',
    cx, H - M.p.top * W, heb(size * M.p.name_scale, the_name()))
  out[#out + 1] = string.format(
    '\\node[anchor=base west,inner sep=0pt] at ([xshift=%.4fcm]name.base east) {%s};',
    g, heb(size, SHVITI))
  out[#out + 1] = string.format(
    '\\node[anchor=base east,inner sep=0pt] at ([xshift=%.4fcm]name.base west) {%s};',
    -g, heb(size, LENEGDI))
  out[#out + 1] = string.format(
    '\\node[anchor=north,inner sep=0pt] at ([yshift=%.4fcm]name.south) {%s};',
    -g, heb(size, TAMID))

  out[#out + 1] = '\\end{scope}'
  out[#out + 1] = '\\end{tikzpicture}'
  out[#out + 1] = '\\end{otherlanguage}'
  tex.print(out)
  texio.write_nl(string.format('menorah: font size %.2f pt', size))
end

return M
