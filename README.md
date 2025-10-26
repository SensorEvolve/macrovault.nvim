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
      -- 10 essential macros included by default
      macros = {
        -- Text Cleanup & Formatting
        [1] = [[%s/\s\+$//]],                     -- Remove trailing whitespace
        [2] = [[g/^\s*$/d]],                      -- Delete empty/whitespace-only lines
        [3] = [[gg=G``]],                         -- Reindent entire file and return to position
        [4] = [[%s/\t/  /g]],                     -- Convert tabs to 2 spaces

        -- Line Operations
        [5] = [[%!sort]],                         -- Sort all lines alphabetically
        [6] = [[%!sort | uniq]],                  -- Sort and remove duplicate lines
        [7] = [[g/^/m0]],                         -- Reverse line order

        -- Code Helpers
        [8] = [[%s/\([^;]\)$/\1;/]],             -- Add semicolons to end of lines
        [9] = [[%s/;\s*$/]],                      -- Remove semicolons from end of lines

        -- Quick File Operations
        [10] = [[wqa]],                           -- Write all buffers and quit
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
  -- Ex commands (most common)
  [1] = [[%s/old/new/g]],          -- Find and replace
  [2] = [[g/pattern/d]],            -- Delete lines matching pattern
  [3] = [[%!sort]],                 -- Filter through external command

  -- Normal mode sequences
  [4] = [[gg=G]],                   -- Reindent entire file
  [5] = [[ddONew line<Esc>]],      -- Delete line, open below, insert text

  -- Insert mode operations
  [6] = [[iYour text<Esc>]],       -- Enter insert, type text, exit

  -- Shell commands
  [7] = [[!prettier --write %]],   -- Run external command on file

  -- Visual operations
  [8] = [[ggVG"+y]],               -- Select all and copy to clipboard

  -- Complex multi-step
  [9] = [[gg=G:w<CR>]],            -- Reindent and save
}
```

### Quick Reference

**Ex commands** (start with `:` when executed):
- `%s/old/new/g` - Replace in entire file
- `g/pattern/d` - Delete matching lines
- `%!command` - Filter file through shell command

**Normal mode** (vim motions):
- `gg` - Go to top
- `G` - Go to bottom
- `dd` - Delete line
- `yy` - Yank (copy) line

**Special characters**:
- `<Esc>` - Escape key
- `<CR>` - Enter/Return
- `<Tab>` - Tab key

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

## Example Macros - 10 Essential Defaults

Here are 10 practical macros that cover common text editing tasks:

```lua
require("macrovault").setup({
  macros = {
    -- Text Cleanup & Formatting
    [1] = [[%s/\s\+$//]],                     -- Remove trailing whitespace
    [2] = [[g/^\s*$/d]],                      -- Delete empty/whitespace-only lines
    [3] = [[gg=G``]],                         -- Reindent entire file and return to position
    [4] = [[%s/\t/  /g]],                     -- Convert tabs to 2 spaces

    -- Line Operations
    [5] = [[%!sort]],                         -- Sort all lines alphabetically
    [6] = [[%!sort | uniq]],                  -- Sort and remove duplicate lines
    [7] = [[g/^/m0]],                         -- Reverse line order

    -- Code Helpers
    [8] = [[%s/\([^;]\)$/\1;/]],             -- Add semicolons to end of lines (missing them)
    [9] = [[%s/;\s*$/]],                      -- Remove semicolons from end of lines

    -- Quick File Operations
    [10] = [[wqa]],                           -- Write all buffers and quit
  },
})
```

### Additional Useful Macros

```lua
-- More examples you can add:
macros = {
  -- Text transformations
  [11] = [[gUU]],                            -- Uppercase current line
  [12] = [[guu]],                            -- Lowercase current line
  [13] = [[%s/\r//g]],                       -- Remove Windows line endings (^M)
  [14] = [[:%j]],                            -- Join all lines into one

  -- Search and replace templates
  [20] = [[%s///gc]],                        -- Find and replace with confirmation
  [21] = [[%s/\<\>//g]],                     -- Replace whole words only

  -- Common edits
  [30] = [[ggVG"+y]],                        -- Copy entire file to clipboard
  [31] = [[ggdG]],                           -- Delete all lines
  [32] = [[:%s/\v\s+$//]],                   -- Remove trailing spaces (very magic mode)

  -- File type specific
  [40] = [[%!python -m json.tool]],          -- Format JSON
  [41] = [[%!xmllint --format -]],           -- Format XML
  [42] = [[!prettier --write %]],            -- Format with Prettier (JS/TS/CSS)
  [43] = [[!black %]],                       -- Format Python with Black
  [44] = [[!rustfmt %]],                     -- Format Rust with rustfmt

  -- Git operations (requires vim-fugitive or similar)
  [50] = [[!git add %]],                     -- Stage current file
  [51] = [[!git diff %]],                    -- Show diff of current file

  -- External tools
  [60] = [[!pandoc % -o %:r.pdf]],          -- Markdown to PDF
  [61] = [[!typos %]],                       -- Check for typos
}
```

## Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/sensorevolve/macrovault.nvim/issues).

## License

This project is licensed under the Apache License 2.0.

## Credits

Created by [SensorEvolve](https://github.com/sensorevolve)
