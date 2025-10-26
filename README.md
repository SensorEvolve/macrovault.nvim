# MacroVault.nvim

A modern, persistent macro management plugin for Neovim with proper configuration support and disk persistence.

## Features

✨ **Proper Configuration** - Setup via `setup()` function in your Neovim config
💾 **Disk Persistence** - Macros automatically save to JSON and persist between sessions
🚀 **Optimized Code** - Clean, efficient implementation
🎨 **Better UX** - Add/edit macros on the fly with `:MacroVaultAdd` and `:MacroVaultEdit`
📦 **100 Macro Slots** - Store up to 100 custom macros
⚡ **Auto-save** - Optional automatic saving after changes

## Installation

Requires Neovim 0.7+

### Using lazy.nvim

```lua
-- lua/plugins/macrovault.lua
return {
  "sensorevolve/macrovault.nvim",
  config = function()
    require("macrovault").setup({
      -- Your configuration here
      macros = {
        [1] = [[%s/\s\+$//]],              -- Remove trailing whitespace
        [2] = [[%s/\r//g]],                 -- Remove Windows line endings
        [3] = [[gg=G``]],                   -- Reindent entire file
        [10] = [[wqa]],                     -- Write and quit all
      },
      auto_save = true,
    })
  end,
  keys = {
    { "<leader>mv", "<cmd>MacroVault<cr>", desc = "MacroVault: Show macros" },
    { "<leader>ma", "<cmd>MacroVaultAdd<cr>", desc = "MacroVault: Add macro" },
    { "<leader>me", "<cmd>MacroVaultEdit<cr>", desc = "MacroVault: Edit macro" },
  },
}
```

### Using packer.nvim

```lua
use {
  "sensorevolve/macrovault.nvim",
  config = function()
    require("macrovault").setup({
      macros = {
        [1] = [[your macro here]],
      },
    })
  end
}
```

### Using vim-plug

```vim
Plug 'sensorevolve/macrovault.nvim'

lua << EOF
require("macrovault").setup({
  macros = {
    [1] = [[your macro here]],
  },
})
EOF
```

## Configuration

```lua
require("macrovault").setup({
  -- Storage path (relative to nvim data directory)
  storage_path = "macrovault-macros.json",

  -- Auto-save macros after changes
  auto_save = true,

  -- Maximum number of macros (default 100)
  max_macros = 100,

  -- Initial macros (only used if no saved macros exist)
  macros = {
    [1] = [[your macro here]],
    [2] = [[another macro]],
  },

  -- UI settings
  ui = {
    border = "rounded",       -- Border style
    max_height = 25,          -- Maximum window height
    max_width_percent = 0.8,  -- Max width as % of editor
    title = " MacroVault ",   -- Window title
  },
})
```

## Commands

| Command | Description |
|---------|-------------|
| `:MacroVault` | Show macro list in floating window |
| `:MacroVaultAdd` | Add a new macro interactively |
| `:MacroVaultEdit` | Edit an existing macro |
| `:MacroVaultSave` | Manually save macros to disk |
| `:MacroVaultReload` | Reload macros from disk |
| `:MacroVaultPath` | Show storage file path |

## Usage

### Viewing and Executing Macros

1. Run `:MacroVault` (or use your keymap)
2. Navigate with `j`/`k`, `gg`/`G`, `PageUp`/`PageDown`
3. Press `Enter` to select a macro (appears on command line for review)
4. Press `Enter` again to execute, or `Esc` to cancel
5. Press `q` or `Esc` in the list to close without selecting

### Adding Macros

**Interactively:**
```vim
:MacroVaultAdd
" Enter slot number: 5
" Enter macro content: :echo "Hello!"
```

**Programmatically:**
```lua
require("macrovault").set_macro(5, ":echo 'Hello!'")
```

### Editing Macros

**Interactively:**
```vim
:MacroVaultEdit
" Enter slot to edit: 5
" Modify the pre-filled content
```

**Programmatically:**
```lua
local mv = require("macrovault")
mv.set_macro(5, "new content")
mv.clear_macro(10)  -- Clear slot 10
```

## Macro Syntax

Macros use Lua long string brackets `[[...]]` to safely contain special characters:

```lua
macros = {
  -- Normal mode sequence
  [1] = [[ddONew line here<Esc>]],

  -- Ex command (find/replace)
  [2] = [[%s/old/new/g]],

  -- Delete empty lines
  [3] = [[g/^\s*$/d]],

  -- Insert text
  [4] = [[iYour text<Esc>]],

  -- Multiple commands
  [5] = [[gg=G:w<CR>]],
}
```

## API Reference

```lua
local mv = require("macrovault")

-- Setup plugin
mv.setup({ macros = {...}, auto_save = true })

-- UI functions
mv.show()         -- Show macro list
mv.add()          -- Add macro interactively
mv.edit()         -- Edit macro interactively

-- Macro operations
mv.set_macro(slot, content, save_now)  -- Set macro
mv.get_macro(slot)                      -- Get macro content
mv.clear_macro(slot, save_now)          -- Clear macro
mv.get_all()                            -- Get all macros
mv.count()                              -- Get macro count

-- Storage operations
mv.save()          -- Save to disk
mv.reload()        -- Reload from disk
mv.storage_path()  -- Get storage file path
```

## Storage Location

Macros are saved to: `{nvim-data-dir}/macrovault-macros.json`

To find your data directory:
```vim
:echo stdpath('data')
```

**Default locations:**
- Windows: `C:\Users\{user}\AppData\Local\nvim-data\`
- Linux: `~/.local/share/nvim/`
- macOS: `~/.local/share/nvim/`

## Example Macros

```lua
require("macrovault").setup({
  macros = {
    -- Text cleanup
    [1] = [[%s/\s\+$//]],              -- Remove trailing whitespace
    [2] = [[%s/\r//g]],                 -- Remove Windows line endings
    [3] = [[gg=G``]],                   -- Reindent file

    -- Navigation
    [10] = [[ggVG]],                    -- Select all
    [11] = [[gg]],                      -- Jump to top
    [12] = [[G]],                       -- Jump to bottom

    -- File operations
    [20] = [[wa]],                      -- Write all
    [21] = [[wqa]],                     -- Write and quit all
    [22] = [[qa!]],                     -- Quit all without saving

    -- Custom commands
    [50] = [[!pandoc % -o %:r.pdf]],   -- Markdown to PDF
    [51] = [[!prettier --write %]],     -- Format with Prettier
  },
})
```

## Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/sensorevolve/macrovault.nvim/issues).

## License

This project is licensed under the Apache License 2.0.

## Credits

Created by [SensorEvolve](https://github.com/sensorevolve)
