-- macrovault.nvim/plugin/macrovault.lua

-- Don't run if already loaded or if disabled
if vim.g.loaded_macrovault then
	return
end
vim.g.loaded_macrovault = 1

-- Require your core and ui modules
-- The require path starts from 'lua/', so 'macrovault.core' and 'macrovault.ui'
local core = require("macrovault.core")
local ui = require("macrovault.ui")

-- Define your macros here (or load them from a config module if you prefer)
-- This is the same table you had in your LazyVim loader.
local my_defined_macros = {
	[1] = "0f's{`^[;s`}^[",
	[2] = "%s/^w/U&/", -- Uppercase the first word
	[3] = "g/^s*$/d", -- Delete empty lines
	[4] = "%s/(l)(\u)/\1_l\2/g", -- CamelCase to snake_case
	[5] = "%s/<foo>/bar/gc", -- Replace "foo" with "bar"
}

-- Initialize the core module with your defined macros
if core and core.setup then
	core.setup(my_defined_macros)
else
	vim.notify("MacroVault Error: macrovault.core or core.setup not found.", vim.log.levels.ERROR)
	return -- Stop if core setup fails
end

-- Create the user command
vim.api.nvim_create_user_command("ShowMacroVault", function()
	if ui and ui.show_macro_list then
		ui.show_macro_list()
	else
		vim.notify("MacroVault Error: ui module or show_macro_list not found.", vim.log.levels.ERROR)
	end
end, { desc = "Show the MacroVault list", nargs = 0 })

-- vim.notify("MacroVault plugin loaded from Git repo! Use :ShowMacroVault", vim.log.levels.INFO) -- Optional: for testing
