-- SensorEvolve MacroVault UI
-- File: lua/macrovault/ui.lua
-- This file should be in your Git repository at macrovault.nvim/lua/macrovault/ui.lua

local core = require("macrovault.core") -- CORRECTED require for core
local api = vim.api
local fn = vim.fn

local M = {}

local floating_win = {
	bufnr = nil,
	win_id = nil,
	original_win = nil,
	non_empty_macros_map = {},
}

local function close_macro_window()
	if floating_win.win_id and api.nvim_win_is_valid(floating_win.win_id) then
		api.nvim_win_close(floating_win.win_id, true)
	end
	if floating_win.bufnr and api.nvim_buf_is_valid(floating_win.bufnr) then
		if api.nvim_get_option_value("modifiable", { buf = floating_win.bufnr }) == false then
			api.nvim_set_option_value("modifiable", true, { buf = floating_win.bufnr })
		end
		api.nvim_buf_delete(floating_win.bufnr, { force = true })
	end
	floating_win.bufnr = nil
	floating_win.win_id = nil
	floating_win.non_empty_macros_map = {}
end

function M.show_macro_list()
	if floating_win.win_id and api.nvim_win_is_valid(floating_win.win_id) then
		api.nvim_set_current_win(floating_win.win_id)
		return
	end

	floating_win.original_win = api.nvim_get_current_win()

	local display_lines = {}
	floating_win.non_empty_macros_map = {}
	local display_line_idx = 0

	for i = 1, core.MAX_MACROS do
		local macro = core.get_macro(i)
		if macro and macro ~= "" then
			display_line_idx = display_line_idx + 1
			table.insert(display_lines, string.format("%3d: %s", i, macro))
			floating_win.non_empty_macros_map[display_line_idx] = i
		end
	end

	if #display_lines == 0 then
		vim.notify("MacroVault: No macros defined or all are empty.", vim.log.levels.INFO)
		return
	end

	floating_win.bufnr = api.nvim_create_buf(false, true)
	api.nvim_buf_set_option(floating_win.bufnr, "buftype", "nofile")
	api.nvim_buf_set_option(floating_win.bufnr, "bufhidden", "wipe")
	api.nvim_buf_set_option(floating_win.bufnr, "swapfile", false)

	api.nvim_buf_set_lines(floating_win.bufnr, 0, -1, false, display_lines)
	api.nvim_buf_set_option(floating_win.bufnr, "modifiable", false)

	local width = fn.float2nr(fn.winwidth(0) * 0.8)
	local max_macro_len = 0
	for _, line in ipairs(display_lines) do
		if fn.strwidth(line) > max_macro_len then
			max_macro_len = fn.strwidth(line)
		end
	end
	width = math.min(width, max_macro_len + 6)
	width = math.max(width, 50)

	local height = math.min(#display_lines, fn.float2nr(fn.winheight(0) * 0.7), 25)

	local win_config = {
		relative = "editor",
		width = width,
		height = height,
		col = fn.float2nr((fn.winwidth(0) - width) / 2),
		row = fn.float2nr((fn.winheight(0) - height) / 2),
		anchor = "NW",
		style = "minimal",
		border = "rounded",
		title = "MacroVault (Select Macro)",
		title_pos = "center",
		zindex = 100,
	}

	floating_win.win_id = api.nvim_open_win(floating_win.bufnr, true, win_config)
	api.nvim_win_set_option(
		floating_win.win_id,
		"winhl",
		"Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:Visual"
	)
	api.nvim_win_set_option(floating_win.win_id, "cursorline", true)
	api.nvim_win_set_option(floating_win.win_id, "number", false)
	api.nvim_win_set_option(floating_win.win_id, "relativenumber", false)

	if #display_lines > 0 then
		api.nvim_win_set_cursor(floating_win.win_id, { 1, 0 })
	end

	local map_opts = { noremap = true, silent = true }

	-- CORRECTED require paths for the module this file itself defines ('macrovault.ui')
	api.nvim_buf_set_keymap(
		floating_win.bufnr,
		"n",
		"q",
		"<Cmd>lua require('macrovault.ui')._close_window_callback()<CR>",
		map_opts
	)
	api.nvim_buf_set_keymap(
		floating_win.bufnr,
		"n",
		"<Esc>",
		"<Cmd>lua require('macrovault.ui')._close_window_callback()<CR>",
		map_opts
	)
	api.nvim_buf_set_keymap(
		floating_win.bufnr,
		"n",
		"<CR>",
		"<Cmd>lua require('macrovault.ui')._select_callback()<CR>",
		map_opts
	)
	api.nvim_buf_set_keymap(
		floating_win.bufnr,
		"n",
		"j",
		"<Cmd>lua require('macrovault.ui')._navigate('down')<CR>",
		map_opts
	)
	api.nvim_buf_set_keymap(
		floating_win.bufnr,
		"n",
		"<Down>",
		"<Cmd>lua require('macrovault.ui')._navigate('down')<CR>",
		map_opts
	)
	api.nvim_buf_set_keymap(
		floating_win.bufnr,
		"n",
		"k",
		"<Cmd>lua require('macrovault.ui')._navigate('up')<CR>",
		map_opts
	)
	api.nvim_buf_set_keymap(
		floating_win.bufnr,
		"n",
		"<Up>",
		"<Cmd>lua require('macrovault.ui')._navigate('up')<CR>",
		map_opts
	)
	api.nvim_buf_set_keymap(
		floating_win.bufnr,
		"n",
		"<PageDown>",
		"<Cmd>lua require('macrovault.ui')._navigate('pagedown')<CR>",
		map_opts
	)
	api.nvim_buf_set_keymap(
		floating_win.bufnr,
		"n",
		"<PageUp>",
		"<Cmd>lua require('macrovault.ui')._navigate('pageup')<CR>",
		map_opts
	)
	api.nvim_buf_set_keymap(
		floating_win.bufnr,
		"n",
		"gg",
		"<Cmd>lua require('macrovault.ui')._navigate('top')<CR>",
		map_opts
	)
	api.nvim_buf_set_keymap(
		floating_win.bufnr,
		"n",
		"G",
		"<Cmd>lua require('macrovault.ui')._navigate('bottom')<CR>",
		map_opts
	)

	api.nvim_buf_set_keymap(floating_win.bufnr, "n", "<C-h>", "<Nop>", map_opts)
	api.nvim_buf_set_keymap(floating_win.bufnr, "n", "<C-j>", "<Nop>", map_opts)
	api.nvim_buf_set_keymap(floating_win.bufnr, "n", "<C-k>", "<Nop>", map_opts)
	api.nvim_buf_set_keymap(floating_win.bufnr, "n", "<C-l>", "<Nop>", map_opts)
end

function M._close_window_callback()
	close_macro_window()
end

function M._select_callback()
	if not floating_win.bufnr or not floating_win.win_id or not api.nvim_win_is_valid(floating_win.win_id) then
		return
	end

	local display_line_num = api.nvim_win_get_cursor(floating_win.win_id)[1]
	local actual_macro_slot = floating_win.non_empty_macros_map[display_line_num]

	if not actual_macro_slot then
		vim.notify("MacroVault Error: Could not map display line to macro slot.", vim.log.levels.ERROR)
		close_macro_window()
		return
	end

	local macro_content = core.get_macro(actual_macro_slot)
	local original_win_temp = floating_win.original_win
	close_macro_window()

	if macro_content and macro_content ~= "" then
		if original_win_temp and api.nvim_win_is_valid(original_win_temp) then
			api.nvim_set_current_win(original_win_temp)
			fn.setreg('"', ":" .. macro_content)
			api.nvim_feedkeys(api.nvim_replace_termcodes(':<C-r>"', true, true, true), "n", false)
			vim.notify(
				"MacroVault: Macro from slot "
					.. actual_macro_slot
					.. " placed on command line. Press Enter to execute.",
				vim.log.levels.INFO
			)
		else
			vim.notify("MacroVault Error: Original window is no longer valid.", vim.log.levels.ERROR)
		end
	elseif macro_content == "" then
		vim.notify("MacroVault: Selected slot " .. actual_macro_slot .. " is defined but empty.", vim.log.levels.WARN)
	else
		vim.notify("MacroVault: Selected slot " .. actual_macro_slot .. " is nil.", vim.log.levels.WARN)
	end
end

function M._navigate(direction)
	if not floating_win.win_id or not api.nvim_win_is_valid(floating_win.win_id) then
		return
	end
	local current_line = api.nvim_win_get_cursor(floating_win.win_id)[1]
	local total_lines = api.nvim_buf_line_count(floating_win.bufnr)
	local page_size = math.max(1, api.nvim_win_get_height(floating_win.win_id) - 2)
	if direction == "down" then
		current_line = math.min(current_line + 1, total_lines)
	elseif direction == "up" then
		current_line = math.max(current_line - 1, 1)
	elseif direction == "pagedown" then
		current_line = math.min(current_line + page_size, total_lines)
	elseif direction == "pageup" then
		current_line = math.max(current_line - page_size, 1)
	elseif direction == "top" then
		current_line = 1
	elseif direction == "bottom" then
		current_line = total_lines
	end
	api.nvim_win_set_cursor(floating_win.win_id, { current_line, 0 })
end

return M
