-- spiral.lua (Birkat Kohanim poster)
-- Numbers 6:24-26, letters only, set letter by letter along a spiral that
-- starts in the bottom right quadrant and runs to the left along the
-- bottom, clockwise and inward (Yosef). So that the Hebrew reads right to
-- left, the letters' tops face the centre. A hamsa in the middle.
--
-- The letters shrink a little toward the centre (Yosef): their size falls
-- in proportion to the radius from the outermost letter to the innermost,
-- which is `shrink` of it. Turns are lead letter bodies apart, so they
-- close up a little as the letters shrink.
--
-- Lengths are in cm and scale with the design box: the largest 2:3 box
-- that fits the page (parameters are fractions of its width W), so every
-- format is the same design. main.tex calls measure() then draw(); each
-- prints TeX that runs before the next.

local M = {}

-- Page sizes in inches. Poster size is a placeholder until Yosef chooses.
M.formats = {
  aceo   = { w = 2.5,  h = 3.5  },
  siddur = { w = 3.5,  h = 4.75 },
  birkon = { w = 4.25, h = 5.5  },
  poster = { w = 12,   h = 18   },
}

M.p = {
  ratio      = 1.5,   -- design box height over width
  cy         = 0.5,   -- spiral centre, as a fraction of the box height
  outer      = 0.46,  -- outermost reach of the letters, from the centre
  inner      = 0.17,  -- innermost reach of the letters (clear of the hamsa)
  start      = -45,   -- where the text begins, degrees counter-clockwise from
                      -- the right (-45: the middle of the bottom right quadrant)
  lead       = 2.0,   -- distance between turns, in letter bodies
  shrink     = 0.8,   -- innermost letter size over outermost
  verse_gap  = 2,     -- space between verses, in word spaces
  hamsa      = 0.115, -- half the hamsa's height
  hamsa_line = 0.004, -- hamsa outline width
  label      = true,  -- small grey draft label (off for final output)
}

local CM_PER_PT = 2.54 / 72.27
local SP_PER_PT = 65536
local BASE = 10      -- measuring size, pt

-- The Name, unpointed, assembled from code points so it is never written
-- out in any file.
local NAME = utf8.char(0x05D9, 0x05D4, 0x05D5, 0x05D4)

local text, fmt
local PW, PH, W, H, OX, OY
local widths = {}    -- widths[ch]: advance width at BASE pt, in pt
local bounds         -- ink outlines of the letters (glyph-bounds.lua)
local body           -- body height of a letter (bet) at BASE pt, in pt

local function heb(sz, s)
  return string.format(
    '\\foreignlanguage{hebrew}{\\fontsize{%.3f}{%.3f}\\selectfont %s}',
    sz, sz * 1.25, s)
end

function M.load(dir)
  text = dofile(dir .. 'text.lua')
  bounds = dofile(dir .. 'glyph-bounds.lua')
  for _, verse in ipairs(text) do
    for i, w in ipairs(verse) do
      if w == 'NAME' then verse[i] = NAME end
    end
  end
end

function M.page_format(name)
  fmt = M.formats[name] or error('unknown format ' .. tostring(name))
  fmt.name = name
  tex.sprint(string.format(
    '\\geometry{paperwidth=%.4fin,paperheight=%.4fin,margin=0pt}', fmt.w, fmt.h))
end

local function fit_page()
  PW = tex.dimen.paperwidth / SP_PER_PT * CM_PER_PT
  PH = tex.dimen.paperheight / SP_PER_PT * CM_PER_PT
  W = math.min(PW, PH / M.p.ratio)
  H = W * M.p.ratio
  OX, OY = (PW - W) / 2, (PH - H) / 2
end

-- The text as one run in reading order: { ch = letter } or
-- { ch = ' ', n = number of word spaces }.
local function items()
  local out = {}
  for _, verse in ipairs(text) do
    for i, w in ipairs(verse) do
      if #out > 0 then
        out[#out + 1] = { ch = ' ', n = (i == 1) and M.p.verse_gap or 1 }
      end
      for _, c in utf8.codes(w) do out[#out + 1] = { ch = utf8.char(c) } end
    end
  end
  return out
end

-- Measure every letter, a word space and the body height (bet). Keys pass
-- through TeX as code points.
function M.measure()
  local seen = {}
  local function m(ch, s)
    if seen[ch] then return end
    seen[ch] = true
    tex.sprint('\\setbox0\\hbox{' .. heb(BASE, s) .. '}' ..
      string.format('\\directlua{birkat.record(%d)}', utf8.codepoint(ch)))
  end
  for _, it in ipairs(items()) do
    if it.ch ~= ' ' then m(it.ch, it.ch) end
  end
  m('ב', 'ב')
  m(' ', 'ב\\ ב')                     -- two bets and a space
end

function M.record(cp)
  local b = tex.box[0]
  if cp == 32 then
    widths[' '] = b.width / SP_PER_PT - 2 * widths['ב']
  else
    local ch = utf8.char(cp)
    widths[ch] = b.width / SP_PER_PT
    if ch == 'ב' then body = b.height / SP_PER_PT end
  end
end

-- The spiral of the letters' centre line for outermost letter size S.
-- It runs from half a body inside the outer reach (radius r0, size S) to
-- half a body outside the inner reach (radius ri, size shrink * S), the
-- size linear in the radius between them; per radian turned the radius
-- falls by lead bodies / 2 pi at the current size. Returns a table of
-- { t, r, u } (t the angle turned, u the text taken so far, in widths at
-- BASE pt) and the size function.
local cm_body = function(sz) return body * sz / BASE * CM_PER_PT end
local function spiral_for(S)
  local r0 = M.p.outer * W - cm_body(S) / 2
  local ri = M.p.inner * W + cm_body(M.p.shrink * S) / 2
  local function size(r)
    if r0 <= ri then return S end
    return M.p.shrink * S + (1 - M.p.shrink) * S * (r - ri) / (r0 - ri)
  end
  local function drdt(r) return -M.p.lead * cm_body(size(r)) / (2 * math.pi) end
  local tab, t, r, u, dt = { { t = 0, r = r0, u = 0 } }, 0, r0, 0, 0.002
  while r0 > ri do
    local rm = r + drdt(r) * dt / 2
    local rn = r + drdt(rm) * dt
    if rn < ri then break end
    local ds = math.sqrt(rm * rm + drdt(rm) ^ 2) * dt
    u = u + ds / (size(rm) / BASE * CM_PER_PT)
    t, r = t + dt, rn
    tab[#tab + 1] = { t = t, r = r, u = u }
  end
  return tab, size, drdt
end

-- The text's length in widths at BASE pt.
local function text_units(its)
  local L = 0
  for _, it in ipairs(its) do L = L + (it.n or 1) * widths[it.ch] end
  return L
end

-- The largest outermost size at which the text fits the spiral.
local function fit_size(its)
  local L, lo, hi = text_units(its), 1, 400
  for _ = 1, 40 do
    local mid = (lo + hi) / 2
    local tab = spiral_for(mid)
    if L <= tab[#tab].u then lo = mid else hi = mid end
  end
  return lo
end

-- Angle turned and radius where the text taken reaches u.
local function at(tab, u)
  local a, b = 1, #tab
  while b - a > 1 do
    local m = (a + b) // 2
    if tab[m].u < u then a = m else b = m end
  end
  local f = (u - tab[a].u) / (tab[b].u - tab[a].u)
  return tab[a].t + f * (tab[b].t - tab[a].t), tab[a].r + f * (tab[b].r - tab[a].r)
end

-- The hamsa: one closed smooth outline, fingers up, centred on (0,0),
-- y from -1 to 1. Right half from the wrist up over the thumb and the
-- fingers; the left half mirrors it.
local HAMSA_RIGHT = {
  { 0.30, -0.97 }, { 0.50, -0.86 }, { 0.60, -0.66 },        -- wrist, palm
  { 0.66, -0.40 }, { 0.76, -0.16 }, { 0.88, 0.06 },          -- thumb, outer
  { 0.93, 0.26 }, { 0.86, 0.36 }, { 0.75, 0.28 },            -- tip, curling out
  { 0.64, 0.10 }, { 0.54, 0.02 },                            -- inner, crotch
  { 0.52, 0.30 }, { 0.53, 0.60 }, { 0.47, 0.78 },            -- side finger
  { 0.38, 0.80 }, { 0.30, 0.68 }, { 0.255, 0.42 },           -- tip, crotch
  { 0.22, 0.70 }, { 0.17, 0.92 }, { 0.09, 1.00 },            -- middle finger
}
local function hamsa(out, cx, cy, scale)
  local pts = { { 0, -1.0 } }
  for _, q in ipairs(HAMSA_RIGHT) do pts[#pts + 1] = q end
  pts[#pts + 1] = { 0, 1.02 }
  for i = #HAMSA_RIGHT, 1, -1 do
    pts[#pts + 1] = { -HAMSA_RIGHT[i][1], HAMSA_RIGHT[i][2] }
  end
  local c = {}
  for _, q in ipairs(pts) do
    c[#c + 1] = string.format('(%.4f,%.4f)', cx + q[1] * scale, cy + q[2] * scale)
  end
  out[#out + 1] = string.format(
    '\\draw[line width=%.4fcm,line join=round] plot[smooth cycle,tension=0.6] coordinates {%s};',
    M.p.hamsa_line * W, table.concat(c, ' '))
end

function M.draw()
  fit_page()
  local its = items()
  local S = fit_size(its)
  local tab, size, drdt = spiral_for(S)
  local t0 = math.rad(M.p.start)

  local out = { '\\begin{otherlanguage}{english}',
    '\\begin{tikzpicture}[remember picture,overlay,shift={(current page.south west)}]',
    string.format('\\begin{scope}[shift={(%.4f,%.4f)}]', OX, OY) }

  -- the text: each letter a node centred on the spiral, turned to it.
  -- Positions are relative to the spiral's centre; the corners of each
  -- letter's ink give the drawing's extent, so it can be centred.
  local letters, x0, x1, y0, y1 = {}, 0, 0, 0, 0
  local inner_size
  local s = 0                                     -- text taken, BASE widths
  for _, it in ipairs(its) do
    local w = (it.n or 1) * widths[it.ch]
    if it.ch ~= ' ' then
      local tm, r = at(tab, s + w / 2)
      local th = t0 - tm                          -- clockwise
      local sz = size(r)
      local f = sz / BASE * CM_PER_PT             -- cm per BASE pt
      local half = cm_body(sz) / 2
      local k = -drdt(r)                          -- radius lost per radian
      local x, y = r * math.cos(th), r * math.sin(th)
      -- direction of travel (clockwise, inward). The text reads against
      -- the letters' own x axis, so their up is the travel turned a
      -- quarter turn clockwise: toward the centre.
      local tx = -k * math.cos(th) + r * math.sin(th)
      local ty = -k * math.sin(th) - r * math.cos(th)
      local n = math.sqrt(tx * tx + ty * ty)
      local ux, uy = ty / n, -tx / n
      -- the letter's ink outline (from the font), about the middle of
      -- its baseline, where the node is anchored; the letter's own x axis
      -- is (uy, -ux)
      local bx, by = x - half * ux, y - half * uy
      local g = bounds[utf8.codepoint(it.ch)]
      local u = sz * CM_PER_PT / bounds.units_per_em   -- cm per font unit
      local mid = widths[it.ch] * f / 2
      for j = 1, #g, 2 do
        local gx, up = g[j] * u - mid, g[j + 1] * u
        local px = bx + gx * uy + up * ux
        local py = by - gx * ux + up * uy
        x0, x1 = math.min(x0, px), math.max(x1, px)
        y0, y1 = math.min(y0, py), math.max(y1, py)
      end
      letters[#letters + 1] = { x = bx, y = by,
        a = math.deg(math.atan(uy, ux)) - 90, sz = sz, ch = it.ch }
      inner_size = sz
    end
    s = s + w
  end

  -- the spiral's centre, placed so the drawing is centred in the box
  local cx = W / 2 - (x0 + x1) / 2
  local cy = M.p.cy * H - (y0 + y1) / 2
  for _, l in ipairs(letters) do
    out[#out + 1] = string.format(
      '\\node[rotate=%.3f,anchor=base,inner sep=0pt] at (%.4f,%.4f) {%s};',
      l.a, cx + l.x, cy + l.y, heb(l.sz, l.ch))
  end

  hamsa(out, cx, cy, M.p.hamsa * W)

  if M.p.label and fmt then
    out[#out + 1] = string.format(
      '\\node[anchor=south east,inner sep=0pt,black!40,font=\\fontsize{%.2f}{%.2f}\\selectfont] ' ..
      'at (%.4f,%.4f) {DRAFT: %s, %s x %s in, letters %.1f to %.1f pt};',
      W * 0.012 / CM_PER_PT, W * 0.015 / CM_PER_PT, PW - OX - 0.02 * W,
      0.02 * W - OY, fmt.name, fmt.w, fmt.h, S, inner_size)
  end

  out[#out + 1] = '\\end{scope}\\end{tikzpicture}\\end{otherlanguage}'
  tex.sprint(table.concat(out, ' '))
end

return M
