-- menorah.lua
-- Geometry and text placement for the Menorah Shiviti (Psalm 67).
--
-- Draft layout: three nested branches on each side of a central shaft, each
-- an upright stem over a quarter circle, so all seven lamps share one line. Verses 2, 3, 4 run down the right branches (outer to inner), verses
-- 8, 7, 6 up the left ones; verse 5 fills the shaft and verse 1 sits on the
-- base. Each word is a separate TikZ node rotated to the arc tangent, so
-- nikud and te'amim stay attached to their letters.
--
-- All lengths are fractions of the page width, so every format is the same
-- design scaled. main.tex calls, in order: setup(format), measure(),
-- measure_shaft(), draw(). Each step prints TeX that runs before the next.

local M = {}

-- Page sizes in inches. Poster size is a placeholder until Yosef chooses.
M.formats = {
  aceo   = { w = 2.5,  h = 3.5,  teamim = false },
  book   = { w = 3.5,  h = 4.75, teamim = false },
  poster = { w = 12,   h = 18,   teamim = true  },
}

-- Layout parameters, as fractions of the page width unless noted.
M.p = {
  cy     = 0.58,  -- height of the arc centres, as a fraction of page height
  radii  = { 0.24, 0.34, 0.44 },  -- inner, middle, outer branch
  stem   = 0.16,  -- straight upright part of every branch, above the arcs
  shaft  = 0.065, -- half-width of the shaft
  pad    = 0.03,  -- clearance between branch text and the shaft
  fill   = 0.88,  -- share of each branch length taken by words
  guides = true,  -- draw faint construction lines (draft only)
}

local CM_PER_PT = 2.54 / 72.27
local SP_PER_PT = 65536
local BASE = 10  -- measuring size, pt

local text = nil
local fmt, W, H = nil, nil, nil
local widths = {}       -- widths[v][i] at BASE pt, in pt
local size = nil        -- final font size, pt
local shaft_h = nil     -- height + depth of the verse-5 block, cm

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

-- The six branches, in reading order (right to left). Each is an upright
-- stem plus a quarter arc. The right branches run from the lamp down the
-- stem and around toward the shaft; the left ones from the shaft around and
-- up the stem to the lamp. pos(d) gives x, y and the text angle at distance d.
local function branches()
  local out = {}
  local cx, cy, L = W / 2, M.p.cy * H, M.p.stem * W
  local sides = { { 2, 3, 4 }, { 8, 7, 6 } }  -- outer to inner
  for k = 1, 3 do
    local r = M.p.radii[4 - k] * W
    local cut = math.asin(math.min(1, (M.p.shaft + M.p.pad) * W / r))
    local arc = r * (math.pi / 2 - cut)
    out[#out + 1] = { verse = sides[1][k], len = L + arc, pos = function(d)
      if d <= L then return cx + r, cy + L - d, 90 end
      local t = -(d - L) / r
      return cx + r * math.cos(t), cy + r * math.sin(t), math.deg(t) + 90
    end }
    out[#out + 1] = { verse = sides[2][k], len = arc + L, pos = function(d)
      if d < arc then
        local t = -math.pi / 2 - cut - d / r
        return cx + r * math.cos(t), cy + r * math.sin(t), math.deg(t) + 90
      end
      return cx - r, cy + (d - arc), -90
    end }
  end
  return out
end

local function sum(t) local s = 0 for _, x in ipairs(t) do s = s + x end return s end

-- Common font size: the largest that lets every branch fit at M.p.fill.
local function fit_size()
  local s = math.huge
  for _, b in ipairs(branches()) do
    local len = b.len                                        -- cm
    local need = sum(widths[b.verse]) * CM_PER_PT / BASE     -- cm per pt
    s = math.min(s, M.p.fill * len / need)
  end
  return s
end

function M.measure_shaft()
  size = fit_size()
  local wd = 2 * M.p.shaft * W
  tex.sprint(string.format(
    '\\setbox0\\vbox{\\hsize=%.4fcm\\centering %s\\par}' ..
    '\\directlua{menorah.record_shaft()}',
    wd, heb(size, table.concat(text[5], ' '))))
end

function M.record_shaft()
  local b = tex.box[0]
  shaft_h = (b.height + b.depth) / SP_PER_PT * CM_PER_PT
end

local function place_branch(out, b)
  local ws = {}
  for i, w in ipairs(widths[b.verse]) do ws[i] = w * size / BASE * CM_PER_PT end
  local gap = (b.len - sum(ws)) / #ws         -- half a gap at each end
  local d = gap / 2
  for i, w in ipairs(text[b.verse]) do
    local x, y, a = b.pos(d + ws[i] / 2)
    out[#out + 1] = string.format(
      '\\node[rotate=%.3f,anchor=base,inner sep=0pt] at (%.4f,%.4f) {%s};',
      a, x, y, heb(size, w))
    d = d + ws[i] + gap
  end
end

function M.draw()
  local cx, cy = W / 2, M.p.cy * H
  local out = { '\\begin{otherlanguage}{english}',
    '\\begin{tikzpicture}[remember picture,overlay,shift={(current page.south west)}]' }
  local rmax = M.p.radii[3] * W
  local top = cy + M.p.stem * W                    -- shaft text starts here
  local bottom = math.min(top - shaft_h, cy - rmax) -- whichever reaches lower
  local base_y = bottom - 0.04 * W

  if M.p.guides then
    out[#out + 1] = '\\begin{scope}[line width=0.3pt,black!15]'
    for _, r in ipairs(M.p.radii) do
      out[#out + 1] = string.format(
        '\\draw (%.4f,%.4f) -- ++(0,%.4f) arc (0:-180:%.4f) -- ++(0,%.4f);',
        cx + r * W, cy + M.p.stem * W, -M.p.stem * W, r * W, M.p.stem * W)
    end
    out[#out + 1] = string.format('\\draw (%.4f,%.4f) rectangle (%.4f,%.4f);',
      cx - M.p.shaft * W, top, cx + M.p.shaft * W, base_y)
    out[#out + 1] = '\\end{scope}'
  end

  for _, b in ipairs(branches()) do place_branch(out, b) end

  -- verse 5 down the shaft
  out[#out + 1] = string.format(
    '\\node[anchor=north,inner sep=0pt,text width=%.4fcm,align=center] at (%.4f,%.4f) {%s};',
    2 * M.p.shaft * W, cx, top, heb(size, table.concat(text[5], ' ')))

  -- verse 1 on the base
  out[#out + 1] = string.format(
    '\\node[anchor=north,inner sep=0pt] at (%.4f,%.4f) {%s};',
    cx, base_y - 0.02 * W, heb(size, table.concat(text[1], ' ')))

  out[#out + 1] = '\\end{tikzpicture}'
  out[#out + 1] = '\\end{otherlanguage}'
  tex.print(out)
  texio.write_nl(string.format('menorah: font size %.2f pt', size))
end

return M
