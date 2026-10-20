-- modim.lua
-- The Modim deRabanan text as a block: justified with TeX's ordinary line
-- breaks. The last line is stretched edge to edge when it is already
-- nearly full (at least fillmin of the width); otherwise it is centred
-- (Yosef).

local M = {}

-- Print TeX that sets the paragraph at size f (in units of \unit) into box
-- \modimblock, settles its last line, and puts the block on the page.
function M.typeset(f, fillmin)
  M.fillmin = fillmin
  tex.sprint(string.format(
    '\\setbox\\modimblock\\vbox{\\fontsize{%.3f\\unit}{%.3f\\unit}\\selectfont' ..
    '\\leftskip=0pt\\rightskip=0pt\\parfillskip=0pt plus 1fil\\modimtext\\par}' ..
    '\\directlua{modim.last_line()}\\box\\modimblock', f, f * 1.65))
end

function M.last_line()
  local line
  for n in node.traverse_id(node.id('hlist'), tex.box.modimblock.list) do line = n end
  local names = node.subtypes('glue')
  -- natural width of the line's content (the parfillskip has none)
  local fill = node.dimensions(line.head) / line.width
  for g in node.traverse_id(node.id('glue'), line.head) do
    if names[g.subtype] == 'parfillskip' then
      g.width, g.stretch, g.stretch_order = 0, 0, 0
    end
  end
  if fill < M.fillmin then
    -- centre: equal fil glue at both ends of the line
    for _, at_end in ipairs({ false, true }) do
      local g = node.new('glue')
      g.stretch, g.stretch_order = 1, 2
      if at_end then
        line.head = node.insert_after(line.head, node.tail(line.head), g)
      else
        line.head = node.insert_before(line.head, line.head, g)
      end
    end
  end
  local packed = node.hpack(line.head, line.width, 'exactly')
  line.glue_set, line.glue_sign, line.glue_order =
    packed.glue_set, packed.glue_sign, packed.glue_order
  packed.head = nil
  node.free(packed)
end

return M
