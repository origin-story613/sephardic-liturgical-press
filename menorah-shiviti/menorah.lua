-- menorah.lua
-- Geometry and text placement for the Menorah Shiviti (Psalm 67).
--
-- Draft layout: three nested branches on each side of a central shaft, each
-- an upright stem over a quarter circle, so all seven lamps share one line.
-- Verse 1 runs across the top, above the lamps. The other verses run down
-- the branches from the lamp toward the shaft, in order from left to right:
-- verses 2, 3, 4 on the left branches (outer to inner), verse 5 straight
-- down the shaft, verses 6, 7, 8 on the right branches (inner to outer).
-- Each word is a separate TikZ node rotated to the direction of its path,
-- so nikud and te'amim stay attached to their letters.
--
-- Lengths are fractions of the page width unless noted, so every format is
-- the same design scaled. main.tex calls setup(format), measure(), draw().
-- Each step prints TeX that runs before the next.

local M = {}

-- Page sizes in inches. Poster size is a placeholder until Yosef chooses.
M.formats = {
  aceo   = { w = 2.5,  h = 3.5,  teamim = false },
  book   = { w = 3.5,  h = 4.75, teamim = false },
  poster = { w = 12,   h = 18,   teamim = true  },
}

-- Layout parameters.
M.p = {
  cy     = 0.40,  -- height of the arc centres, as a fraction of page height
  radii  = { 0.20, 0.31, 0.42 },  -- inner, middle, outer branch
  stem   = 0.44,  -- straight upright part of every branch, above the arcs
  foot   = 0.08,  -- shaft length below the outer arc
  shaft_half = 0.03, -- half the width of the shaft line of text
  pad    = 0.02,  -- clearance between branch text and the shaft
  fill   = 0.86,  -- share of a branch taken by words at the fitted size
  shaft_fill = 0.95, -- the same for the shaft (verse 5 is the longest)
  title  = 0.05,  -- gap between the lamp line and the verse 1 baseline
  guides = true,  -- draw faint construction lines (draft only)
}

local CM_PER_PT = 2.54 / 72.27
local SP_PER_PT = 65536
local BASE = 10  -- measuring size, pt

local text, fmt, W, H
local widths = {}  -- widths[v][i]: word width at BASE pt, in pt
local size         -- fitted font size, pt

local function strip_teamim(w)
  w = w:gsub('\xD6[\x91-\xAF]', '')   -- U+0591..U+05AF accents
  w = w:gsub('\xD6\xBD', '')          -- U+05BD meteg
  w = w:gsub(' ?\xD7\x80', '')        -- U+05C0 paseq
  return w
end

local function heb(sz, s)
  return string.format(
    '\\foreignlanguage{hebrew}{\\fontsize{%.3f}{%.3f}\\selectfont %s}',
    sz, sz * 1.25, s)
end

local function sum(t) local s = 0 for _, x in ipairs(t) do s = s + x end return s end

function M.setup(name, dir)
  fmt = M.formats[name] or error('unknown format ' .. tostring(name))
  W, H = fmt.w * 2.54, fmt.h * 2.54
  text = dofile(dir .. 'psalm67.lua')
  if not fmt.teamim then
    for _, verse in ipairs(text) do
      for i, w in ipairs(verse) do verse[i] = strip_teamim(w) end
    end
  end
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
  local shaft_len = L + M.p.radii[3] * W + M.p.foot * W
  out[#out + 1] = { verse = 5, len = shaft_len, fill = M.p.shaft_fill,
    pos = function(d) return cx, cy + L - d, 0, -1 end }
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

function M.draw()
  local cx, cy, L = W / 2, M.p.cy * H, M.p.stem * W
  local ps = paths()
  size = fit_size(ps)
  local out = { '\\begin{otherlanguage}{english}',
    '\\begin{tikzpicture}[remember picture,overlay,shift={(current page.south west)}]' }

  if M.p.guides then
    out[#out + 1] = '\\begin{scope}[line width=0.3pt,black!15]'
    for _, r in ipairs(M.p.radii) do
      out[#out + 1] = string.format(
        '\\draw (%.4f,%.4f) -- ++(0,%.4f) arc (0:-180:%.4f) -- ++(0,%.4f);',
        cx + r * W, cy + L, -L, r * W, L)
    end
    out[#out + 1] = string.format('\\draw (%.4f,%.4f) -- ++(0,%.4f);',
      cx, cy + L, -ps[#ps].len)
    out[#out + 1] = '\\end{scope}'
  end

  for _, p in ipairs(ps) do place(out, p) end

  -- verse 1 across the top, spread over the width of the menorah
  local span = 2 * M.p.radii[3] * W
  out[#out + 1] = string.format(
    '\\node[anchor=base,inner sep=0pt,text width=%.4fcm] at (%.4f,%.4f) ' ..
    '{%s\\par};', span, cx, cy + L + M.p.title * W,
    heb(size, '\\leavevmode ' .. table.concat(text[1], ' \\hfill ')))

  out[#out + 1] = '\\end{tikzpicture}'
  out[#out + 1] = '\\end{otherlanguage}'
  tex.print(out)
  texio.write_nl(string.format('menorah: font size %.2f pt', size))
end

return M
