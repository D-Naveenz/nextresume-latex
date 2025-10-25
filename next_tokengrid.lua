-- NextResume Lua implementation of TokenGrid

local modulename = "Next TokenGrid"

-- TokenGrid class definition
local TokenGrid = {}
TokenGrid.__index = TokenGrid

-- Private function to get LaTeX formatted string for a field
local function get_latex_field_string(self, field_name, text, hyperlink)
  -- Get symbol once and cache it
  local symbol = self:get_symbol(field_name)
  if not symbol or symbol == "" then
    return "" -- Early return if symbol not found
  end

  -- Build symbol/field name part
  local symbol_part
  if self.hideFieldNames then
    symbol_part = string.format(
      "{\\BeginAccSupp{method=escape,ActualText={%s:}}\\normalfont%s\\EndAccSupp{}}",
      field_name, symbol
    )
  else
    symbol_part = string.format(
      "{\\normalfont%s\\hspace{0.3em}%s:}",
      symbol, field_name
    )
  end

  -- Build text part with optional hyperlink
  local text_part
  if hyperlink and hyperlink ~= "" then
    if self.hyperlinkEnabled then
      text_part = string.format("\\href{%s}{\\detokenize{%s}}", hyperlink, text)
    else
      -- Issue warning and concatenate hyperlink prefix with text
      luatexbase.module_warning(modulename, "Hyperlinks disabled but hyperlink provided. Use [withhyper] option.")
      -- tex.print("\\ClassWarning{nextresume}{Hyperlinks disabled but hyperlink provided. Use [withhyper] option.}")
      text_part = string.format("\\detokenize{%s%s}", hyperlink, text)
    end
  else
    text_part = string.format("\\detokenize{%s}", text)
  end

  -- Combine all parts efficiently
  return string.format(
    "\\mbox{\\textcolor{accent}{%s}~\\hspace{0.3em}%s\\hspace{2em}}",
    symbol_part, text_part
  )
end

-- Constructor for TokenGrid instances
function TokenGrid:new(hideFieldNames, withhyper)
  local instance = {
    fieldDefinitions = {},
    fields = {},
    hideFieldNames = hideFieldNames,
    hyperlinkEnabled = withhyper
  }
  setmetatable(instance, TokenGrid)
  return instance
end

-- Method to get the symbol by field name
function TokenGrid:get_symbol(field_name)
  local def = self.fieldDefinitions[field_name]
  if def and def.symbol then
    return def.symbol
  else
    tex.error("NextResume Error", "Unknown symbol '" .. field_name .. "'")
    return ""
  end
end

-- Method to get hyperlink prefix
function TokenGrid:get_hyperlink_prefix(field_name)
  local def = self.fieldDefinitions[field_name]
  if def and def.hyperlinkPrefix then
    return def.hyperlinkPrefix
  else
    return ""
  end
end

-- Method to create new info field by directly exposing Lua function as LaTeX command
function TokenGrid:create_info_field(field_name, symbol, custom_hyper, hyperlink_prefix)
  -- Register the field definition
  self.fieldDefinitions[field_name] = {
    symbol = symbol,
    hyperlinkPrefix = hyperlink_prefix
  }

  -- Create a new Lua function for the field
  local func_num = luatexbase.new_luafunction(field_name .."_handler")
  lua.get_functions_table()[func_num] = function()
      local text = token.scan_string()
      local hyperlink = ""
      if custom_hyper then
        hyperlink = token.scan_string()
      else
        hyperlink = hyperlink_prefix .. text
      end

      -- Add the formatted field to our collection
      table.insert(self.fields, get_latex_field_string(self, field_name, text, hyperlink))
    end

  -- Directly define the command as \luafunction
  tex.print("\\let\\" .. field_name .. "\\luafunction" .. func_num)
end

-- Method to create a table from fields
function TokenGrid:build_grid(num_columns)
  if #self.fields == 0 then
    return ""
  end

  local result = {}
  table.insert(result, "\\begin{tabular}{" .. string.rep("l", num_columns) .. "}")

  for i, field in ipairs(self.fields) do
    table.insert(result, field)

    -- Check if it's the last element or if a new row should start
    if i < #self.fields then
      if i % num_columns == 0 then
        table.insert(result, " \\\\") -- End of row
      else
        table.insert(result, " & ") -- Column separator
      end
    end
  end

  table.insert(result, "\\end{tabular}")
  return tex.print(table.concat(result))
end

-- Method to clear all fields (utility function)
function TokenGrid:clear_fields()
  self.fields = {}
end

-- Return the TokenGrid class for module usage
return TokenGrid