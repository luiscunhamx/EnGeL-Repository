-- EnGeL-UC protocol filter (all output formats).
-- 1. Protocols (documents with `protocol-id`): inserts the information box at the top, and fills
--    the placeholders ::: {.engel-equipment}, ::: {.engel-reagents}, ::: {.engel-history} from the YAML.
-- 2. Every document: highlights [TO CONFIRM ...] marks.

local LAB = 'Environmental Genomics Laboratory (EnGeL-UC), Environmental Ecology & Ecotoxicology Group (E3G), Centre for Functional Ecology, Department of Life Sciences, University of Coimbra · Laboratório Associado TERRA'

local function str(x) if x == nil then return '' end return pandoc.utils.stringify(x) end
local function is_typst() return quarto.doc.is_format('typst') end
local function is_html() return quarto.doc.is_format('html') end
local function is_docx() return quarto.doc.is_format('docx') end

local function md(s) return pandoc.read(s, 'markdown').blocks end
local function cell(s) return (s:gsub('|', '\\|'):gsub('\n', ' ')) end

local function author_list(meta)
  local out = {}
  local a = meta.authors or meta.author
  if a == nil then return out end
  if a.t ~= 'MetaList' and type(a) ~= 'table' then a = {a} end
  for _, x in ipairs(a) do
    local name, orcid = '', ''
    if type(x) == 'table' and x.name ~= nil then
      name = str(x.name.literal or x.name); orcid = str(x.orcid)
    else name = str(x) end
    table.insert(out, {name = name, orcid = orcid})
  end
  return out
end

local function cite_name(n)
  local parts = {}
  for w in n:gmatch('%S+') do table.insert(parts, w) end
  if #parts < 2 then return n end
  local initials = ''
  for i = 1, #parts - 1 do initials = initials .. pandoc.text.sub(parts[i], 1, 1) end
  return parts[#parts] .. ' ' .. initials
end

local function meta_box(meta)
  local id, ver = str(meta['protocol-id']), str(meta.version)
  local auth = {}
  for _, a in ipairs(author_list(meta)) do
    local s = a.name
    if a.orcid ~= '' then s = s .. ' ([ORCID ' .. a.orcid .. '](https://orcid.org/' .. a.orcid .. '))' end
    table.insert(auth, s)
  end
  local rows = {
    {'Protocol ID', id}, {'Version', ver}, {'Date', str(meta.date)}, {'Status', str(meta.status)},
    {'Area', str(meta.area)}, {'Authors', table.concat(auth, '; ')},
  }
  if meta.contributors then
    local c = {}
    for _, x in ipairs(meta.contributors) do table.insert(c, str(x)) end
    table.insert(rows, {'Contributors', table.concat(c, '; ')})
  end
  if meta['reviewed-by'] then table.insert(rows, {'Reviewed and approved by', str(meta['reviewed-by'])}) end
  table.insert(rows, {'Laboratory', meta.laboratory and str(meta.laboratory) or LAB})
  table.insert(rows, {'Contact', str(meta.contact)})
  table.insert(rows, {'Licence', 'Text: CC BY 4.0 · Code: MIT'})
  if meta.hazards then
    local h = {}
    for _, x in ipairs(meta.hazards) do table.insert(h, str(x)) end
    table.insert(rows, {'Main hazards', table.concat(h, '; ')})
  end
  if is_html() then
    table.insert(rows, {'Downloads', 'Protocol: [PDF](' .. id .. '.pdf) · [Word](' .. id .. '.docx). Bench sheet: [PDF](../../bench/' .. id .. '-bench.pdf) · [web page](../../bench/' .. id .. '-bench.html)'})
  end
  local t = {'| | |', '|:--|:--|'}
  for _, r in ipairs(rows) do table.insert(t, '| **' .. r[1] .. '** | ' .. cell(r[2]) .. ' |') end
  return pandoc.Div(md(table.concat(t, '\n')), pandoc.Attr('', {'engel-meta'}))
end

local function bullets(list)
  local items = {}
  for _, x in ipairs(list or {}) do
    if type(x) == 'table' and x.text ~= nil then
      local item = {pandoc.Plain(md(str(x.text))[1].content)}
      if x.components then
        local sub = {}
        for _, c in ipairs(x.components) do
          local t = (type(c) == 'table' and c.text ~= nil) and c.text or c
          table.insert(sub, {pandoc.Plain(md(str(t))[1].content)})
        end
        table.insert(item, pandoc.BulletList(sub))
      end
      table.insert(items, item)
    else
      table.insert(items, {pandoc.Plain(md(str(x))[1].content)})
    end
  end
  return pandoc.BulletList(items)
end

local function history(meta)
  local t = {'| Version | Date | Change | By |', '|:--|:--|:--|:--|'}
  for _, h in ipairs(meta['version-history'] or {}) do
    table.insert(t, '| ' .. str(h.version) .. ' | ' .. str(h.date) .. ' | ' .. cell(str(h.change)) .. ' | ' .. cell(str(h.by)) .. ' |')
  end
  local names = {}
  for _, a in ipairs(author_list(meta)) do table.insert(names, cite_name(a.name)) end
  local year = str(meta.date):sub(1, 4)
  local doi = meta['protocol-doi'] and str(meta['protocol-doi']) or '[TO CONFIRM]'
  local cite = table.concat(names, ', ') .. ' (' .. year .. '). ' .. str(meta.title) .. '. EnGeL-UC protocol ' ..
    str(meta['protocol-id']) .. ', version ' .. str(meta.version) .. '. Zenodo. DOI ' .. doi .. '.'
  local blocks = md(table.concat(t, '\n'))
  blocks:extend(md('**How to cite**\n\n' .. cite .. '\n\n**Licence**\n\nText: CC BY 4.0. Code: MIT. Logos are the property of their institutions and are not covered by the licence.'))
  return blocks
end

local function build(doc)
  local meta = doc.meta
  if meta['protocol-id'] == nil or meta['engel-bench'] then return doc end
  local blocks = pandoc.Blocks{meta_box(meta)}
  for _, b in ipairs(doc.blocks) do
    if b.t == 'Div' and b.classes:includes('engel-equipment') then blocks:insert(bullets(meta.equipment))
    elseif b.t == 'Div' and b.classes:includes('engel-consumables') then blocks:insert(bullets(meta.consumables))
    elseif b.t == 'Div' and b.classes:includes('engel-reagents') then blocks:insert(bullets(meta.reagents))
    elseif b.t == 'Div' and b.classes:includes('engel-history') then blocks:extend(history(meta))
    else blocks:insert(b) end
  end
  doc.blocks = blocks
  return doc
end

local function tc_span(inl)
  if is_typst() then
    local out = pandoc.Inlines{pandoc.RawInline('typst', '#highlight(fill: rgb("#FFF3B0"))[')}
    out:extend(inl); out:insert(pandoc.RawInline('typst', ']'))
    return out
  elseif is_docx() then
    return pandoc.Inlines{pandoc.Span(inl, pandoc.Attr('', {}, {['custom-style'] = 'To confirm'}))}
  end
  return pandoc.Inlines{pandoc.Span(inl, pandoc.Attr('', {'tc'}))}
end

local function mark(inlines)
  local out, i, n = pandoc.Inlines{}, 1, #inlines
  while i <= n do
    local el = inlines[i]
    local nx, nx2 = inlines[i + 1], inlines[i + 2]
    if el.t == 'Str' and el.text:match('%[TO$') and nx and nx.t == 'Space' and nx2 and nx2.t == 'Str' and nx2.text:match('^CONFIRM') then
      local pre, j = el.text:sub(1, #el.text - 3), i + 2
      while j <= n and not (inlines[j].t == 'Str' and inlines[j].text:find(']', 1, true)) do j = j + 1 end
      if j > n then out:insert(el); i = i + 1
      else
        if pre ~= '' then out:insert(pandoc.Str(pre)) end
        local last = inlines[j].text
        local k = last:find(']', 1, true)
        local span = pandoc.Inlines{pandoc.Str('[TO')}
        for m = i + 1, j - 1 do span:insert(inlines[m]) end
        span:insert(pandoc.Str(last:sub(1, k)))
        out:extend(tc_span(span))
        if k < #last then out:insert(pandoc.Str(last:sub(k + 1))) end
        i = j + 1
      end
    else out:insert(el); i = i + 1 end
  end
  return out
end

local COLOURS = {['callout-important'] = '#B3261E', ['callout-warning'] = '#B3261E', ['callout-tip'] = '#2E7D32', ['callout-note'] = '#5753A4', ['callout-caution'] = '#B26A00'}
-- Typst: draw callouts as plain coloured boxes (no icon fonts or online packages needed).
local function typst_callout(div)
  if not is_typst() then return nil end
  for cls, colour in pairs(COLOURS) do
    if div.classes:includes(cls) then
      local title = div.attributes.title or ''
      local out = pandoc.Blocks{pandoc.RawBlock('typst', '#block(width: 100%, fill: rgb("' .. colour .. '").lighten(92%), stroke: (left: 2.5pt + rgb("' .. colour .. '")), inset: (x: 8pt, y: 6pt), radius: 2pt, breakable: true)[')}
      if title ~= '' then out:insert(pandoc.RawBlock('typst', '#text(weight: "bold", fill: rgb("' .. colour .. '"))[' .. title .. ']')) end
      out:extend(div.content)
      out:insert(pandoc.RawBlock('typst', ']'))
      return out
    end
  end
end

local function typst_callout_node(c)
  if not is_typst() then return nil end
  local colour = COLOURS['callout-' .. (c.type or 'note')] or '#5753A4'
  local out = pandoc.Blocks{pandoc.RawBlock('typst', '#block(width: 100%, fill: rgb("' .. colour .. '").lighten(92%), stroke: (left: 2.5pt + rgb("' .. colour .. '")), inset: (x: 8pt, y: 6pt), radius: 2pt, breakable: true)[')}
  if c.title then
    out:insert(pandoc.RawBlock('typst', '#text(weight: "bold", fill: rgb("' .. colour .. '"))[' .. str(c.title) .. ']'))
  end
  if c.content.t == nil then out:extend(c.content) else out:insert(c.content) end
  out:insert(pandoc.RawBlock('typst', ']'))
  return out
end

-- Steps are written as (@) so numbering runs through the whole procedure (also across includes); show them as 1. 2. 3.
local function steps(ol)
  if ol.listAttributes.style == 'Example' then
    ol.listAttributes = pandoc.ListAttributes(ol.listAttributes.start, 'Decimal', 'Period')
    return ol
  end
end

return { {Div = typst_callout, Callout = typst_callout_node, OrderedList = steps}, {Pandoc = build}, {Inlines = mark} }
