local Utils = {}

-- Utility function to safely get a value from a table
function Utils.get_table_value(tbl, key, default)
  if tbl[key] ~= nil then
    return tbl[key]
  else
    return default
  end
end

function Utils.get_repository_name(repo_url)
  if not repo_url then
    return nil
  end
  local name = repo_url:match("^.+/(.+)%.git$") or repo_url:match("^.+/(.+)$")
  return name
end

-- Date parsing utilities for timeline events
-- Month names mapping (short form)
local month_names = {
  "Jan", "Feb", "Mar", "Apr", "May", "Jun",
  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
}

-- Parse date in yyyy-mm-dd or yyyy-mm format and return formatted string
function Utils.parse_date(date_str)
  if not date_str or date_str == "" then
    return nil
  end
  
  -- Handle special case: "Present"
  if date_str == "Present" then
    return "Present"
  end
  
  -- Try to match yyyy-mm-dd format
  local year, month, day = date_str:match("^(%d%d%d%d)%-(%d%d)%-(%d%d)$")
  if year and month and day then
    local month_num = tonumber(month)
    if month_num >= 1 and month_num <= 12 then
      return month_names[month_num] .. " " .. year
    end
  end
  
  -- Try to match yyyy-mm format
  year, month = date_str:match("^(%d%d%d%d)%-(%d%d)$")
  if year and month then
    local month_num = tonumber(month)
    if month_num >= 1 and month_num <= 12 then
      return month_names[month_num] .. " " .. year
    end
  end
  
  -- If no pattern matches, return the original string
  return date_str
end

--- Capitalize the first character of the string
--- @param str string target string
--- @return string - the string with capitalized first character
function Utils.capitalizeFirst(str)
  return str:sub(1, 1):upper() .. str:sub(2):lower()
end

-- Simple test function to verify Lua is working
function Utils.test_function()
  return "Lua Utils is working!"
end

--- Function to get the LaTeX3 boolean state as a native Lua boolean
--- Enhanced with error handling and proper backslash processing
--- @param boolname string The name of the LaTeX3 boolean (with or without backslashes)
--- @return boolean true if the LaTeX3 boolean is true, false otherwise
function Utils.get_latex3_boolean(boolname)
  local success, result = pcall(function()
    -- Clean the boolean name - remove leading backslashes if present
    local clean_name = boolname:gsub("^\\+", "")
    
    -- Pre-create token objects for the specific boolean and a "true" constant for comparison
    local bool_token = token.create(clean_name)
    local true_token = token.create("c_true_bool")

    -- The mode of the boolean token is what determines its state (0 or 1)
    -- Comparing it to the mode of a known true boolean gives a Lua boolean result
    return bool_token.mode == true_token.mode
  end)
  
  if success then
    return result
  else
    -- Enhanced error reporting
    texio.write_nl("WARNING: Failed to read LaTeX3 boolean '" .. tostring(boolname) .. "', defaulting to false")
    texio.write_nl("ERROR: " .. tostring(result))
    return false
  end
end

return Utils