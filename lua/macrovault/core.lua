-- Core macro management for MacroVault
local M = {}

-- Active macros table
local active_macros = {}

-- Initialization flag
local initialized = false

-- Validate slot number
local function is_valid_slot(slot)
  local config = require("macrovault.config").get()
  return type(slot) == "number" and slot >= 1 and slot <= config.max_macros
end

-- Initialize the plugin
function M.setup(user_config)
  if initialized then
    return true
  end

  local config = require("macrovault.config")
  config.setup(user_config or {})

  local storage = require("macrovault.storage")

  -- Load from disk first (priority)
  local saved_macros = storage.load()

  -- Merge with user-provided macros (saved macros take precedence)
  local opts = config.get()
  for slot, content in pairs(opts.macros or {}) do
    if not saved_macros[slot] then
      saved_macros[slot] = content
    end
  end

  active_macros = saved_macros
  initialized = true

  local count = M.get_macro_count()
  if count > 0 then
    vim.notify(
      string.format("MacroVault: Loaded %d macro%s", count, count == 1 and "" or "s"),
      vim.log.levels.INFO
    )
  end

  return true
end

-- Get a macro by slot number
function M.get_macro(slot)
  if not is_valid_slot(slot) then
    vim.notify("MacroVault: Invalid slot number: " .. tostring(slot), vim.log.levels.ERROR)
    return nil
  end

  return active_macros[slot]
end

-- Set a macro (in session and optionally save)
function M.set_macro(slot, content, save_now)
  if not is_valid_slot(slot) then
    vim.notify("MacroVault: Invalid slot number: " .. tostring(slot), vim.log.levels.ERROR)
    return false
  end

  if content ~= nil and type(content) ~= "string" then
    vim.notify("MacroVault: Macro content must be a string or nil", vim.log.levels.ERROR)
    return false
  end

  active_macros[slot] = content

  -- Auto-save if enabled or explicitly requested
  local config = require("macrovault.config").get()
  if save_now or config.auto_save then
    return M.save()
  end

  return true
end

-- Clear a macro slot
function M.clear_macro(slot, save_now)
  return M.set_macro(slot, nil, save_now)
end

-- Get all macros
function M.get_all_macros()
  return vim.deepcopy(active_macros)
end

-- Get non-empty macros with their slots
function M.get_non_empty_macros()
  local result = {}
  local config = require("macrovault.config").get()

  for i = 1, config.max_macros do
    if active_macros[i] and active_macros[i] ~= "" then
      table.insert(result, { slot = i, content = active_macros[i] })
    end
  end

  return result
end

-- Count non-empty macros
function M.get_macro_count()
  local count = 0
  local config = require("macrovault.config").get()

  for i = 1, config.max_macros do
    if active_macros[i] and active_macros[i] ~= "" then
      count = count + 1
    end
  end

  return count
end

-- Save all macros to disk
function M.save()
  local storage = require("macrovault.storage")
  local success = storage.save(active_macros)

  if success then
    vim.notify("MacroVault: Saved " .. M.get_macro_count() .. " macros", vim.log.levels.INFO)
  end

  return success
end

-- Reload macros from disk (discards unsaved changes)
function M.reload()
  local storage = require("macrovault.storage")
  active_macros = storage.load()
  vim.notify("MacroVault: Reloaded " .. M.get_macro_count() .. " macros", vim.log.levels.INFO)
  return true
end

return M
