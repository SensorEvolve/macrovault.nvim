# MacroVault - 10 Essential Default Macros

These 10 macros are included in the documentation as recommended defaults. They cover the most common text editing tasks that developers need.

## The 10 Essential Macros

### Text Cleanup & Formatting (1-4)

**[1] Remove Trailing Whitespace**
```lua
[1] = [[%s/\s\+$//]]
```
Removes all trailing whitespace from every line in the file.
- **Use case**: Clean up code before committing
- **Works on**: All file types

**[2] Delete Empty Lines**
```lua
[2] = [[g/^\s*$/d]]
```
Deletes all lines that are empty or contain only whitespace.
- **Use case**: Compact code, remove excessive blank lines
- **Works on**: All file types

**[3] Reindent Entire File**
```lua
[3] = [[gg=G``]]
```
Reindents the entire file using Neovim's built-in indentation, then returns cursor to original position.
- **Use case**: Fix indentation after paste or code generation
- **Works on**: Code files with proper filetype detected
- **Note**: `` returns cursor to previous position

**[4] Convert Tabs to Spaces**
```lua
[4] = [[%s/\t/  /g]]
```
Converts all tab characters to 2 spaces throughout the file.
- **Use case**: Standardize indentation
- **Works on**: All file types
- **Customizable**: Change number of spaces as needed

### Line Operations (5-7)

**[5] Sort Lines Alphabetically**
```lua
[5] = [[%!sort]]
```
Sorts all lines in the file alphabetically using the system `sort` command.
- **Use case**: Organize imports, sort lists, alphabetize data
- **Works on**: All file types
- **Note**: Requires `sort` command (available on Unix/Windows)

**[6] Sort and Remove Duplicates**
```lua
[6] = [[%!sort | uniq]]
```
Sorts lines and removes duplicate entries.
- **Use case**: Clean up lists, remove duplicate imports
- **Works on**: All file types
- **Note**: Requires `sort` and `uniq` commands (Unix-style)

**[7] Reverse Line Order**
```lua
[7] = [[g/^/m0]]
```
Reverses the order of all lines in the file (last line becomes first).
- **Use case**: Reverse chronological lists, flip data order
- **Works on**: All file types
- **How it works**: Moves each line to the top (line 0)

### Code Helpers (8-9)

**[8] Add Missing Semicolons**
```lua
[8] = [[%s/\([^;]\)$/\1;/]]
```
Adds semicolons to the end of lines that don't already have them.
- **Use case**: Fix missing semicolons in JavaScript, C, Java, etc.
- **Works on**: Code that uses semicolons
- **Note**: Only adds if line doesn't end with semicolon

**[9] Remove Semicolons**
```lua
[9] = [[%s/;\s*$/]]
```
Removes semicolons from the end of all lines.
- **Use case**: Convert JS to Python-style, clean up code
- **Works on**: Any file with trailing semicolons
- **Note**: Also removes any trailing whitespace after semicolon

### Quick File Operations (10)

**[10] Write All and Quit**
```lua
[10] = [[wqa]]
```
Saves all open buffers and quits Neovim.
- **Use case**: Quick exit after editing multiple files
- **Works on**: All files
- **Shortcut for**: `:wqa<CR>`

## How to Use These Macros

### 1. Include in Your Config

Add these to your `lua/plugins/macrovault.lua`:

```lua
return {
  "sensorevolve/macrovault.nvim",
  config = function()
    require("macrovault").setup({
      macros = {
        -- Text Cleanup & Formatting
        [1] = [[%s/\s\+$//]],
        [2] = [[g/^\s*$/d]],
        [3] = [[gg=G``]],
        [4] = [[%s/\t/  /g]],

        -- Line Operations
        [5] = [[%!sort]],
        [6] = [[%!sort | uniq]],
        [7] = [[g/^/m0]],

        -- Code Helpers
        [8] = [[%s/\([^;]\)$/\1;/]],
        [9] = [[%s/;\s*$/]],

        -- Quick File Operations
        [10] = [[wqa]],
      },
    })
  end,
}
```

### 2. Execute Macros

1. Open MacroVault: `:MacroVault` or `<leader>mv`
2. Navigate with `j`/`k`
3. Press `Enter` on desired macro
4. Review command on command line
5. Press `Enter` again to execute

### 3. Customize

Modify any macro to suit your needs:

```vim
:MacroVaultEdit
" Enter slot: 4
" Change from 2 spaces to 4 spaces:
%s/\t/    /g
```

## Additional Useful Macros

### More ideas for slots 11-100:

**Text Transformations:**
```lua
[11] = [[gUU]],           -- Uppercase current line
[12] = [[guu]],           -- Lowercase current line
[13] = [[%s/\r//g]],      -- Remove Windows line endings
```

**Search & Replace:**
```lua
[20] = [[%s///gc]],       -- Find/replace with confirmation
[21] = [[%s/\<\>//g]],    -- Replace whole words only
```

**File Formatting:**
```lua
[30] = [[%!python -m json.tool]],  -- Format JSON
[31] = [[%!prettier --write %]],    -- Format with Prettier
[32] = [[%!black %]],               -- Format Python with Black
```

**Git Operations:**
```lua
[40] = [[!git add %]],    -- Stage current file
[41] = [[!git diff %]],   -- Show diff
```

## Platform Compatibility

**Works on all platforms:**
- Macros 1-4: Pure Vim commands
- Macro 7: Pure Vim commands
- Macros 8-10: Pure Vim commands

**Requires external tools:**
- Macros 5-6: Requires `sort` and `uniq`
  - ✅ Linux/macOS: Built-in
  - ✅ Windows: Available via Git Bash, WSL, or GnuWin32

## Tips

1. **Preview before executing**: The macro appears on the command line for review before execution
2. **Undo is your friend**: All macros can be undone with `u`
3. **Visual selection**: Many macros work on visual selections too (select first, then run)
4. **Combine macros**: Execute multiple macros in sequence for complex operations

## Contributing More Macros

Have a useful macro? Share it!
- Open an issue on GitHub
- Submit a PR to the documentation
- Share in discussions

Popular contributed macros may be added to future default sets!
