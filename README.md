##MacroVault.nvim
MacroVault is a Neovim plugin that provides a persistent, quickly accessible list of your custom macros. Define up to 100 macros and execute them with ease via a floating window selector.

#Features
Persistent Macro Storage: Define your macros directly in your Neovim configuration.

Quick Access: Launch a floating window to view and select your macros.

Command Line Preview: Selected macros are placed on the command line for review before execution.

Modal Interface: Focused interaction within the macro selection window.

Easy Navigation: Use j/k, gg/G, PageUp/PageDown to navigate the macro list.

#Installation
Requires Neovim 0.7+ (or the version appropriate for the API usage).

#LazyVim
Add the following to your LazyVim plugin configuration:

-- lua/plugins/macrovault.lua (or your preferred file)
return {
  {
    "SensorEvolve/macrovault.nvim", -- Replace with your GitHub username if different
    lazy = false, -- Or use 'cmd = "ShowMacroVault"' for lazy loading
    -- No explicit config function needed here if using the default setup
  }
}

#Configuration
Macros are defined within the plugin/macrovault.lua file of this plugin. To customize your macros, you will need to fork the plugin or manage your macro definitions in your local clone.

The macro definitions look like this (inside plugin/macrovault.lua):

local my_defined_macros = {
    [1] = [[ddOhello world<Esc>]],
    [2] = [[%s/^w/U&/]],         -- Uppercase the first word
    [3] = [[g/^s*$/d]],         -- Delete empty lines
    -- ... up to 100 macros
    [100] = [[echo 'Hello from MacroVault!']],
}

Note on Macro Syntax:

Use Lua's long string brackets [[...]] to define macros, especially if they contain special characters like quotes or backslashes.

Macros are executed as if typed in Normal mode after being prefixed with : on the command line.

For Normal mode command sequences: [[ddOtext<Esc>]]

For Ex commands: [[wqa]] (the plugin will prefix it with :)

For direct text insertion: [[iYour text here<Esc>]]

Usage
Open MacroVault:
Run the command:

:ShowMacroVault

You can map this command to a keybinding in your Neovim configuration for faster access.

Navigate:

j or <Down>: Move down.

k or <Up>: Move up.

gg: Go to the top.

G: Go to the bottom.

<PageDown>: Page down.

<PageUp>: Page up.

Select a Macro:

Press <Enter> on the desired macro.

Execute:

The selected macro (prefixed with :) will appear on your Neovim command line.

Review it, then press <Enter> to execute it.

Close:

Press q or <Esc> to close the MacroVault window without selecting a macro.

Contributing
Contributions, issues, and feature requests are welcome. Please feel free to check the issues page. (Update with your actual issues link).

License
This project is licensed under the Apache License 2.0. (Ensure you have a LICENSE.md file in your repository containing the full text of the Apache License 2.0).
