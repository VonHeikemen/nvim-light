# nvim-light

Lightweight configuration focused on providing "basic features" with little boilerplate. It includes better syntax highlight, a fuzzy finder and IDE-like features powered by Neovim's LSP client.

## Requirements

* Neovim v0.7.2 or greater.
* git.
* [tree-sitter CLI](https://github.com/tree-sitter/tree-sitter).
* A `C` compiler. Can be `gcc`, `tcc` or `zig`.
* A [language server](#about-language-servers). Required to actually enable the "IDE-like" features.
* (optional) [ripgrep](https://github.com/BurntSushi/ripgrep). Improves project wide search speed.
* (optional) [fd](https://github.com/sharkdp/fd). Improves file search speed.

### Note for windows users

If you need a `C` compiler then `zig` is the easiest to install. It's available on `winget`, `scoop` and `chocolatey`. You can also find some links in the [zig download page](https://ziglang.org/download/). 

## Installation

* I recommend installing Neovim's [latest stable version](https://vonheikemen.github.io/learn-nvim/101/installation.html). Or at least Neovim v0.9.

* Backup your existing configuration if you have one.

* Create an `init.lua` file in your system.

  If you don't know the location of Neovim's configuration file use this command.

  ```sh
  nvim --headless -c 'echo stdpath("config") . "/init.lua" . "\n"' -c 'quit'
  ```

  Use whatever method you want to create the config folder and also an empty `init.lua` file.

* Choose a configuration file from the [configs directory](https://github.com/VonHeikemen/nvim-light/tree/main/configs) and copy its content to your own `init.lua`.

  - [configs/stable.lua](https://github.com/VonHeikemen/nvim-light/blob/main/configs/stable.lua) requires NVIM v0.11 or greater
  - [configs/nightly.lua](https://github.com/VonHeikemen/nvim-light/blob/main/configs/nightly.lua) targets NVIM v0.12, the current nightly version

  You can check Neovim's version using this command.

  ```sh
  nvim --version
  ```

  If you need support for older Neovim versions:

  - [configs/v0-7.lua](https://github.com/VonHeikemen/nvim-light/blob/main/configs/v0-7.lua) targets NVIM v0.7 and v0.8
  - [configs/v0-9.lua](https://github.com/VonHeikemen/nvim-light/blob/main/configs/v0-9.lua) requires NVIM v0.9 or greater
  - [configs/v0-10.lua](https://github.com/VonHeikemen/nvim-light/blob/main/configs/v0-10.lua) requires NVIM v0.10 or greater

* Open Neovim, use the command `nvim` in your terminal. When Neovim starts all plugins will be downloaded automatically.

## Learn how to use Neovim as a text editor

Neovim comes with an interactive tutorial that teaches the basics of the editor. The estimated time of this tutorial is around 45 minutes. It will show you how to move around text, how to execute commands and of course how to quit Neovim. You can access the tutorial by executing this command in your terminal.

```sh
nvim +Tutor
```

I've also created a documentation site aimed at teaching the basic features of Neovim. Note that it is mostly about how to use Neovim as a text editor without plugins, but there is still some valuable information there:

* [The nvim command](https://vonheikemen.github.io/learn-nvim/101/the-nvim-command.html)
* [Basic editing](https://vonheikemen.github.io/learn-nvim/101/basic-editing.html)
* [Edit multiple files](https://vonheikemen.github.io/learn-nvim/101/edit-multiple-files.html)
* [The help page](https://vonheikemen.github.io/learn-nvim/101/the-help-page.html)

## Learn the basics of lua and Neovim's api

This configuration was created using a scripting language called `lua`, I highly recommend that you learn the syntax of this language. Learn just enough to know what is valid. Here are a couple resources:

* [An Introduction to lua](https://vonheikemen.github.io/learn-nvim/101/lua-intro.html)
* [Learn X in Y minutes: Where X = lua](https://learnxinyminutes.com/docs/lua/) 
* [Lua crash course (12min video)](https://www.youtube.com/watch?v=NneB6GX1Els)

Next step is to get familiar with Neovim's lua api, so you can create your own keybindings and commands. Here are a couple of guides you can read:

* [Build your first Neovim configuration in lua](https://vonheikemen.github.io/devlog/tools/build-your-first-lua-config-for-neovim/) 
* [Neovim's official lua guide](https://neovim.io/doc/user/lua-guide.html)

## About language servers

They are external programs that provide IDE-like features to Neovim. If you want to know more about language servers watch this wonderful 5 minutes video: [LSP explained](https://www.youtube.com/watch?v=LaS32vctfOY).

To know what language servers are supported you need to go to nvim-lspconfig's documentation, in [configs.md](https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md) you'll find links and instruction on how to install them.

Once you have a language server available in your system you need to enable it. Here's an example using the language server for lua, `lua_ls`.

On **Neovim v0.10** or lower you must use the "legacy setup" function.

```lua
require('lspconfig').lua_ls.setup({})
```

On **Neovim v0.11** or greater you can use the function `vim.lsp.enable()`.

```lua
vim.lsp.enable('lua_ls')
```

> [!TIP]
> Copy the content of [.luarc.json of this github repository](https://github.com/VonHeikemen/nvim-light/blob/main/.luarc.json) into your own `.luarc.json`. This file should be located next to your `init.lua`. With it the language server for lua will provide basic support for Neovim's lua api.

## About syntax highlight

To get a more accurate syntax highlight for your favorite language you need to download something called a "treesitter parser".

So inside this configuration there is a variable called `ts_parsers`, and initially it looks like this. 

```lua
local ts_parsers = {'lua', 'vim', 'vimdoc', 'c', 'query'}
```
That will be a list of parsers, and they will be installed automatically. You can add more languages to this list, but make sure is supported by the plugin `nvim-treesitter`.

Is important to note `nvim-treesitter` no longer supports Neovim versions below **v0.11**. So on older versions of Neovim `nvim-treesitter` will be pinned to version from the [master branch](https://github.com/nvim-treesitter/nvim-treesitter/tree/master). In this case you'll find the list of supported languages here: [supported languages](https://github.com/nvim-treesitter/nvim-treesitter/tree/master?tab=readme-ov-file#supported-languages).

New versions of `nvim-treesitter` are under the [main branch](https://github.com/nvim-treesitter/nvim-treesitter/tree/main). The list of supported is located here: [SUPPORTED_LANGUAGES.md](https://github.com/nvim-treesitter/nvim-treesitter/blob/main/SUPPORTED_LANGUAGES.md).

## About the plugin manager

Neovim versions below **v0.11** will use `mini.deps` as the plugin manager. Make sure to read the documentation to learn how to add more plugins:

* [mini.deps overview](https://nvim-mini.org/mini.nvim/doc/mini-deps.html#minideps-overview)

Neovim **v0.12** and greater will use `vim.pack`, a builtin plugin manager currently under development.

* [vim.pack official documentation](https://neovim.io/doc/user/pack.html#vim.pack).

## Keybindings

Leader key: `Space`.

| Mode     | Key               | Action                                                                  |
| ---      | ---               | ---                                                                     |
| Normal   | `gy`              | Copy text to clipboard.                                                 |
| Normal   | `gp`              | Paste text from clipboard.                                              |
| Normal   | `K`               | Displays hover information about the symbol under the cursor.           |
| Normal   | `gd`              | Jump to the definition.                                                 |
| Normal   | `gq`              | Format code in current buffer.                                          |
| Normal   | `gO`              | Lists symbols in the current buffer.                                    |
| Normal   | `<C-s>`           | Displays a function's signature information.                            |
| Normal   | `gri`             | Lists all the implementations for the symbol under the cursor.          |
| Normal   | `grr`             | Lists all the references.                                               |
| Normal   | `grn`             | Renames all references to the symbol under the cursor.                  |
| Normal   | `gra`             | Selects a code action available at the current cursor position.         |
| Normal   | `grd`             | Jump to declaration.                                                    |
| Normal   | `grt`             | Jumps to the definition of the type symbol                              |
| Normal   | `<Ctrl-w>d`       | Show diagnostics in a floating window.                                  |
| Normal   | `[d`              | Move to the previous diagnostic.                                        |
| Normal   | `]d`              | Move to the next diagnostic.                                            |
| Normal   | `gcc`             | Toggle comment in current line.                                         |
| Operator | `gc`              | Toggle comment in text.                                                 |
| Operator | `sa`              | Add surrounding.                                                        |
| Normal   | `sd`              | Delete surrounding.                                                     |
| Normal   | `sr`              | Surround replace.                                                       |
| Normal   | `sf`              | Find surrounding.                                                       |
| Normal   | `<leader>e`       | Toggle file explorer.                                                   |
| Normal   | `<leader>bc`      | Close current buffer and preserve window layout.                        |
| Normal   | `<leader>?`       | Search oldfiles history.                                                |
| Normal   | `<leader><space>` | Search open buffers.                                                    |
| Normal   | `<leader>ff`      | Find file in current working directory.                                 |
| Normal   | `<leader>fg`      | Search pattern in current working directory. Interactive "grep search". |
| Normal   | `<leader>fd`      | Search diagnostics in current file.                                     |
| Normal   | `<leader>fs`      | Search pattern in current file.                                         |

### Autocomplete keybindings

| Mode   | Key            | Action                                                          |
| ---    | ---            | ---                                                             |
| Insert | `<Up>`         | Move to previous item.                                          |
| Insert | `<Down>`       | Move to next item.                                              |
| Insert | `<Ctrl-p>`     | Move to previous item and insert content.                       |
| Insert | `<Ctrl-n>`     | Move to next item and insert content.                           |
| Insert | `<Ctrl-y>`     | Confirm completion.                                             |
| Insert | `<Enter>`      | Confirm completion if item was selected with Up or Down arrows. |
| Insert | `<Ctrl-e>`     | Cancel completion.                                              |

## Plugin list

| Name                                                                                     | Description                                                               |
| ---                                                                                      | ---                                                                       |
| [tokyonight.nvim](https://github.com/folke/tokyonight.nvim)                              | Collection of colorscheme for Neovim.                                     |
| [which-key.nvim](https://github.com/folke/which-key.nvim)                                | Provide clues for keymaps.                                                |
| [mini.nvim](https://github.com/nvim-mini/mini.nvim)                                      | Collection of independent lua modules that enhance Neovim's features.     |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)                    | Configures treesitter parsers.                                            |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)                               | Quickstart configs for Neovim's LSP client.                               |

