-- Configuration defaults for MacroVault
local M = {}

-- Default configuration
M.defaults = {
  -- Storage path for persistent macros (relative to nvim data directory)
  storage_path = "macrovault-macros.json",

  -- Auto-save macros after changes
  auto_save = true,

  -- Maximum number of macros
  max_macros = 100,

  -- Default macros (user can override in setup)
  macros = {},

  -- UI settings
  ui = {
    border = "rounded",
    max_height = 25,
    max_width_percent = 0.8,
    title = " MacroVault ",
  },
}

-- Merged configuration
M.options = vim.deepcopy(M.defaults)

-- Setup function to merge user config
function M.setup(user_config)
  M.options = vim.tbl_deep_extend("force", M.defaults, user_config or {})
  return M.options
end

-- Get current configuration
function M.get()
  return M.options
end

return M
