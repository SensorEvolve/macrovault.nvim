-- MacroVault - Main module
-- A modern, persistent macro management plugin for Neovim

local M = {}

-- Setup function (called by user in their config)
function M.setup(opts)
  local core = require("macrovault.core")
  return core.setup(opts)
end

-- Show macro list
function M.show()
  local ui = require("macrovault.ui")
  ui.show()
end

-- Add a new macro
function M.add()
  local ui = require("macrovault.ui")
  ui.add_macro()
end

-- Edit an existing macro
function M.edit()
  local ui = require("macrovault.ui")
  ui.edit_macro()
end

-- Save macros to disk
function M.save()
  local core = require("macrovault.core")
  return core.save()
end

-- Reload macros from disk
function M.reload()
  local core = require("macrovault.core")
  return core.reload()
end

-- Get a specific macro
function M.get_macro(slot)
  local core = require("macrovault.core")
  return core.get_macro(slot)
end

-- Set a specific macro
function M.set_macro(slot, content, save_now)
  local core = require("macrovault.core")
  return core.set_macro(slot, content, save_now)
end

-- Clear a specific macro
function M.clear_macro(slot, save_now)
  local core = require("macrovault.core")
  return core.clear_macro(slot, save_now)
end

-- Get all macros
function M.get_all()
  local core = require("macrovault.core")
  return core.get_all_macros()
end

-- Get macro count
function M.count()
  local core = require("macrovault.core")
  return core.get_macro_count()
end

-- Get storage path
function M.storage_path()
  local storage = require("macrovault.storage")
  return storage.get_path()
end

return M
