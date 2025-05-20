-- SensorEvolve MacroVault Core
local M = {}

local active_macros_table = {}
M.MAX_MACROS = 100

function M.setup(macros_from_loader)
	if type(macros_from_loader) ~= "table" then
		vim.notify("MacroVault Core Error: Provided macros is not a table.", vim.log.levels.ERROR)
		active_macros_table = {}
		return
	end
	active_macros_table = macros_from_loader

	for i = 1, M.MAX_MACROS do
		if active_macros_table[i] == nil then
			active_macros_table[i] = nil
		end
	end
end

function M.get_macro(slot)
	if type(slot) ~= "number" or slot < 1 or slot > M.MAX_MACROS then
		-- Kept this error notify as it's a direct API misuse
		vim.notify(
			"MacroVault Core Error: Macro slot " .. tostring(slot) .. " is out of range (1-" .. M.MAX_MACROS .. ").",
			vim.log.levels.ERROR
		)
		return nil
	end
	if not active_macros_table or next(active_macros_table) == nil then
		vim.notify(
			"MacroVault Core Error: Macros table not initialized or empty. Requested slot: " .. slot,
			vim.log.levels.ERROR
		)
		return nil
	end

	local content = active_macros_table[slot]
	return content
end

function M.set_macro_session(slot, content)
	if type(slot) ~= "number" or slot < 1 or slot > M.MAX_MACROS then
		vim.notify(
			"MacroVault Core Error: Macro slot " .. tostring(slot) .. " is out of range (1-" .. M.MAX_MACROS .. ").",
			vim.log.levels.ERROR
		)
		return false
	end
	if type(content) ~= "string" then
		vim.notify("MacroVault Core Error: Macro content must be a string.", vim.log.levels.ERROR)
		return false
	end
	if not active_macros_table then
		vim.notify("MacroVault Core Error: Macros table not initialized.", vim.log.levels.ERROR)
		return false
	end

	active_macros_table[slot] = content
	return true
end

function M.clear_macro_session(slot)
	if type(slot) ~= "number" or slot < 1 or slot > M.MAX_MACROS then
		vim.notify(
			"MacroVault Core Error: Macro slot " .. tostring(slot) .. " is out of range (1-" .. M.MAX_MACROS .. ").",
			vim.log.levels.ERROR
		)
		return false
	end
	if not active_macros_table then
		vim.notify("MacroVault Core Error: Macros table not initialized.", vim.log.levels.ERROR)
		return false
	end
	active_macros_table[slot] = nil
	return true
end

return M
