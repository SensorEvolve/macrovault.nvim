-- UI module for MacroVault
local M = {}

-- Window state
local state = {
  buf = nil,
  win = nil,
  macro_map = {}, -- Maps display line to macro slot
}

-- Close the macro window
local function close_window()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
  end

  if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
    vim.api.nvim_buf_delete(state.buf, { force = true })
  end

  state.buf = nil
  state.win = nil
  state.macro_map = {}
end

-- Execute selected macro
local function execute_macro()
  if not state.win or not vim.api.nvim_win_is_valid(state.win) then
    return
  end

  local cursor = vim.api.nvim_win_get_cursor(state.win)
  local line_num = cursor[1]
  local slot = state.macro_map[line_num]

  if not slot then
    vim.notify("MacroVault: No macro at this line", vim.log.levels.WARN)
    return
  end

  local core = require("macrovault.core")
  local macro = core.get_macro(slot)

  if not macro then
    vim.notify("MacroVault: Macro slot " .. slot .. " is empty", vim.log.levels.WARN)
    return
  end

  close_window()

  -- Place macro on command line for user to review
  vim.fn.feedkeys(":" .. macro, "n")
end

-- Setup keymaps for the floating window
local function setup_keymaps(bufnr)
  local opts = { buffer = bufnr, noremap = true, silent = true }

  -- Close window
  vim.keymap.set("n", "q", close_window, opts)
  vim.keymap.set("n", "<Esc>", close_window, opts)

  -- Execute macro
  vim.keymap.set("n", "<CR>", execute_macro, opts)

  -- Navigation
  vim.keymap.set("n", "j", "j", opts)
  vim.keymap.set("n", "k", "k", opts)
  vim.keymap.set("n", "<Down>", "j", opts)
  vim.keymap.set("n", "<Up>", "k", opts)
  vim.keymap.set("n", "gg", "gg", opts)
  vim.keymap.set("n", "G", "G", opts)
  vim.keymap.set("n", "<PageDown>", "<C-f>", opts)
  vim.keymap.set("n", "<PageUp>", "<C-b>", opts)

  -- Disable split navigation
  vim.keymap.set("n", "<C-h>", "<Nop>", opts)
  vim.keymap.set("n", "<C-j>", "<Nop>", opts)
  vim.keymap.set("n", "<C-k>", "<Nop>", opts)
  vim.keymap.set("n", "<C-l>", "<Nop>", opts)
end

-- Show the macro list
function M.show()
  local core = require("macrovault.core")
  local config = require("macrovault.config").get()
  local macros = core.get_non_empty_macros()

  if #macros == 0 then
    vim.notify("MacroVault: No macros defined", vim.log.levels.WARN)
    return
  end

  -- Build display lines and mapping
  local lines = {}
  state.macro_map = {}

  for _, entry in ipairs(macros) do
    local line = string.format("[%d] %s", entry.slot, entry.content)
    table.insert(lines, line)
    state.macro_map[#lines] = entry.slot
  end

  -- Calculate window dimensions (cache line widths)
  local max_width = 0
  for _, line in ipairs(lines) do
    local width = vim.fn.strdisplaywidth(line)
    if width > max_width then
      max_width = width
    end
  end

  local editor_width = vim.o.columns
  local editor_height = vim.o.lines

  local win_width = math.min(max_width + 4, math.floor(editor_width * config.ui.max_width_percent))
  local win_height = math.min(#lines, config.ui.max_height)

  -- Center the window
  local row = math.floor((editor_height - win_height) / 2)
  local col = math.floor((editor_width - win_width) / 2)

  -- Create buffer
  state.buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(state.buf, "modifiable", false)
  vim.api.nvim_buf_set_option(state.buf, "bufhidden", "wipe")

  -- Create floating window
  local win_config = {
    relative = "editor",
    width = win_width,
    height = win_height,
    row = row,
    col = col,
    style = "minimal",
    border = config.ui.border,
    title = config.ui.title,
    title_pos = "center",
  }

  state.win = vim.api.nvim_open_win(state.buf, true, win_config)

  -- Setup keymaps
  setup_keymaps(state.buf)

  -- Set cursor to first line
  vim.api.nvim_win_set_cursor(state.win, { 1, 0 })
end

-- Prompt user to add a new macro
function M.add_macro()
  local core = require("macrovault.core")

  vim.ui.input({ prompt = "Macro slot (1-100): " }, function(slot_input)
    if not slot_input then
      return
    end

    local slot = tonumber(slot_input)
    if not slot or slot < 1 or slot > 100 then
      vim.notify("MacroVault: Invalid slot number", vim.log.levels.ERROR)
      return
    end

    vim.ui.input({ prompt = "Macro content: " }, function(content)
      if not content or content == "" then
        return
      end

      if core.set_macro(slot, content) then
        vim.notify(string.format("MacroVault: Added macro to slot %d", slot), vim.log.levels.INFO)
      end
    end)
  end)
end

-- Edit an existing macro
function M.edit_macro()
  local core = require("macrovault.core")

  vim.ui.input({ prompt = "Macro slot to edit (1-100): " }, function(slot_input)
    if not slot_input then
      return
    end

    local slot = tonumber(slot_input)
    if not slot or slot < 1 or slot > 100 then
      vim.notify("MacroVault: Invalid slot number", vim.log.levels.ERROR)
      return
    end

    local current = core.get_macro(slot) or ""

    vim.ui.input({ prompt = "Macro content: ", default = current }, function(content)
      if not content then
        return
      end

      if content == "" then
        -- Clear the slot
        if core.clear_macro(slot) then
          vim.notify(string.format("MacroVault: Cleared slot %d", slot), vim.log.levels.INFO)
        end
      else
        if core.set_macro(slot, content) then
          vim.notify(string.format("MacroVault: Updated slot %d", slot), vim.log.levels.INFO)
        end
      end
    end)
  end)
end

return M
