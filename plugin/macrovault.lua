-- MacroVault - Plugin commands
-- Auto-loaded by Neovim

if vim.g.loaded_macrovault then
  return
end
vim.g.loaded_macrovault = 1

-- Create user commands
vim.api.nvim_create_user_command("MacroVault", function()
  require("macrovault").show()
end, { desc = "Show MacroVault macro list" })

vim.api.nvim_create_user_command("MacroVaultAdd", function()
  require("macrovault").add()
end, { desc = "Add a new macro to MacroVault" })

vim.api.nvim_create_user_command("MacroVaultEdit", function()
  require("macrovault").edit()
end, { desc = "Edit an existing macro in MacroVault" })

vim.api.nvim_create_user_command("MacroVaultSave", function()
  require("macrovault").save()
end, { desc = "Save MacroVault macros to disk" })

vim.api.nvim_create_user_command("MacroVaultReload", function()
  require("macrovault").reload()
end, { desc = "Reload MacroVault macros from disk" })

vim.api.nvim_create_user_command("MacroVaultPath", function()
  local path = require("macrovault").storage_path()
  vim.notify("MacroVault storage: " .. path, vim.log.levels.INFO)
  print(path)
end, { desc = "Show MacroVault storage path" })
