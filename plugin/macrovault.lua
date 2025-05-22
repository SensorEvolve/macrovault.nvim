-- File: macrovault.nvim/plugin/macrovault.lua

-- Don't run if already loaded or if disabled
if vim.g.loaded_macrovault then
	return
end
vim.g.loaded_macrovault = 1

-- Require your core and ui modules
local core = require("macrovault.core")
local ui = require("macrovault.ui")

-- Define your macros here using long brackets [[...]] for robustness
local my_defined_macros = {
	[1] = [[!pandoc filename.md -o filename.pdf]], -- Convert Markdown to PDF
	[2] = [[%s/^w/U&/]], -- Uppercase the first word
	[3] = [[g/^s*$/d]], -- Delete empty lines
	[4] = [[%s//g]], -- Example from previous version
	[5] = [[%s/<foo>/bar/gc]], -- Replace "foo" with "bar"
	[6] = [[%s/\([^;]\)$/\1;/]], -- Add a semicolon at the end of each line
	[7] = [[%!column -t -s ',']], -- Format CSV
	[8] = [[%s/^\(.*\)\(\n\1\)\+$/\1/]], -- Delete duplicate lines
	[9] = [[g/^$/d]], -- Delete empty lines
	-- Example of a macro that itself uses double quotes:
	[10] = [[echo "Hello from MacroVault!"<CR>]],
	[100] = [[echo 'Hello from MacroVault slot 100!']], -- Using single quotes inside
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

-- No startup notification by default
