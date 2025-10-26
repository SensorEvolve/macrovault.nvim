-- Persistence layer for MacroVault
local M = {}

-- Get full storage path
local function get_storage_path()
  local config = require("macrovault.config").get()
  local data_path = vim.fn.stdpath("data")
  return data_path .. "/" .. config.storage_path
end

-- Save macros to disk
function M.save(macros)
  local path = get_storage_path()

  -- Convert sparse table to dense array for JSON encoding
  local macro_list = {}
  for i = 1, 100 do
    if macros[i] and macros[i] ~= "" then
      table.insert(macro_list, { slot = i, content = macros[i] })
    end
  end

  -- Encode to JSON
  local ok, json = pcall(vim.json.encode, { version = "1.0", macros = macro_list })
  if not ok then
    vim.notify("MacroVault: Failed to encode macros to JSON", vim.log.levels.ERROR)
    return false
  end

  -- Write to file
  local file = io.open(path, "w")
  if not file then
    vim.notify("MacroVault: Could not open storage file for writing: " .. path, vim.log.levels.ERROR)
    return false
  end

  file:write(json)
  file:close()

  return true
end

-- Load macros from disk
function M.load()
  local path = get_storage_path()
  local macros = {}

  -- Check if file exists
  local file = io.open(path, "r")
  if not file then
    -- File doesn't exist yet, return empty table
    return macros
  end

  -- Read file content
  local content = file:read("*all")
  file:close()

  if not content or content == "" then
    return macros
  end

  -- Decode JSON
  local ok, data = pcall(vim.json.decode, content)
  if not ok or not data or not data.macros then
    vim.notify("MacroVault: Failed to decode storage file", vim.log.levels.WARN)
    return macros
  end

  -- Convert array back to sparse table
  for _, entry in ipairs(data.macros) do
    if entry.slot and entry.content then
      macros[entry.slot] = entry.content
    end
  end

  return macros
end

-- Check if storage file exists
function M.exists()
  local path = get_storage_path()
  local file = io.open(path, "r")
  if file then
    file:close()
    return true
  end
  return false
end

-- Get storage file path (for user reference)
function M.get_path()
  return get_storage_path()
end

return M
