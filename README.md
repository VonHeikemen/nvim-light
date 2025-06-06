# nvim-light

Lightweight configuration focused on providing "basic features" with little boilerplate. It includes better syntax highlight, a fuzzy finder and IDE-like features powered by Neovim's LSP client.

## Requirements

* Neovim v0.9.5 or greater.
* git.
* [tree-sitter CLI](https://github.com/tree-sitter/tree-sitter).
* A `C` compiler. Can be `gcc`, `tcc` or `zig`.
* A [language server](#about-language-servers). Required to actually enable the "IDE-like" features.
* (optional) [ripgrep](https://github.com/BurntSushi/ripgrep). Improves project wide search speed.
* (optional) [fd](https://github.com/sharkdp/fd). Improves file search speed.

### Note for windows users

If you need a `C` compiler then `zig` is the easiest to install. It's available on `winget`, `scoop` and `chocolatey`. You can also find some links in the [zig download page](https://ziglang.org/download/). 

## Installation

* Backup your existing configuration if you have one.

* Create an `init.lua` file in your system. Use this command in your terminal if you don't know the specific location of Neovim's configuration folder.

  ```sh
  nvim --headless -c 'call mkdir(stdpath("config"), "p") | exe "edit" stdpath("config") . "/init.lua" | write | quit'
  ```

  To check the file was created you can use this command.

  ```sh
  nvim --headless -c 'echo $MYVIMRC' -c 'quit'
  ```

  This will show you the path of your `init.lua`

* Copy the content of [init.lua of this github repository](https://github.com/VonHeikemen/nvim-light/blob/main/init.lua) into your own `init.lua`.

* Open Neovim, use the command `nvim` in your terminal. When Neovim starts all plugins will be downloaded automatically.

## Learn how to use Neovim as a text editor

Neovim comes with an interactive tutorial that teaches the basics of the editor. The estimated time of this tutorial is around 45 minutes. It will show you how to move around text, how to execute commands and of course how to quit Neovim. You can access the tutorial by executing this command in your terminal.

```sh
nvim +Tutor
```

Note there is also a book inside Neovim's documentation, this is called the user manual. You can find it online here:

* [Neovim online docs: user manual](https://neovim.io/doc/user/usr_toc.html#user-manual) 
* [TJ DeVries reads Neovim's user manual (9h27min video)](https://www.youtube.com/watch?v=rT-fbLFOCy0)

## Learn the basics of lua and Neovim's api

This configuration was created using a scripting language called `lua`, I highly recommend that you learn the syntax of this language. Learn just enough to know what is valid. Here are a couple resources:

* [Learn X in Y minutes: Where X = lua](https://learnxinyminutes.com/docs/lua/) 
* [Lua crash course (12min video)](https://www.youtube.com/watch?v=NneB6GX1Els)

Next step is to get familiar with Neovim's lua api, so you can create your own keybindings and commands. Here are a couple of guides you can read:

* [Build your first Neovim configuration in lua](https://vonheikemen.github.io/devlog/tools/build-your-first-lua-config-for-neovim/) 
* [Neovim's official lua guide](https://neovim.io/doc/user/lua-guide.html)

## About language servers

They are external programs that provide IDE-like features to Neovim. If you want to know more about language servers watch this wonderful 5 minutes video: [LSP explained](https://www.youtube.com/watch?v=LaS32vctfOY).

To know what language servers are supported you need to go to nvim-lspconfig's documentation, in [configs.md](https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md) you'll find links and instruction on how to install them.

Once you have a language server available in your system you need to enable it.

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

In this example `lua_ls` is the language server we want to enable.

## About syntax highlight

To get a more accurate syntax highlight for your favorite language you need to download something called a "treesitter parser".

So inside Neovim execute the command `:TSInstall` and provide a list of parsers. For example:

```vim
:TSInstall lua gleam vimdoc
```

On **Neovim v0.10** or lower the syntax highlight will be enabled automatically by the plugin `nvim-treesitter`.

On **Neovim v0.11** or greater we must enable the syntax highlight ourselves. On this configuration on the [line 111](https://github.com/VonHeikemen/nvim-light/blob/main/init.lua#L111) there is a variable called `filetypes`, that's the list of languages where the syntax highlight will be enabled.

```lua
local filetypes = {'lua', 'gleam', 'help'}
```

Notice that sometimes the parser and the filetype name don't match. In this example the parser `vimdoc` is for the filetype `help`.

## Learn more about the plugin manager

`lazy.nvim` is the plugin manager used in this configuration. Here are a few resources that will help you understand some of it's features:

* [Lazy.nvim: plugin configuration](https://dev.to/vonheikemen/lazynvim-plugin-configuration-3opi). Here you'll learn about the "plugin spec" and how to split your plugin setup into multiple files.

* [Lazy.nvim: how to revert a plugin back to a previous version](https://dev.to/vonheikemen/lazynvim-how-to-revert-a-plugin-back-to-a-previous-version-1pdp). Learn how to recover from a bad plugin update.

### Plugins directory

Your plugins will be installed in a separate directory from your configuration. The location of this directory depends on your operating system and environment variables, so you'll need to execute this command to know where that is.

```sh
nvim --headless -c 'echo stdpath("data") . "/lazy/lazy.nvim" | quit'
```

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
| [lazy.nvim](https://github.com/folke/lazy.nvim)                                          | Plugin manager.                                                           |
| [tokyonight.nvim](https://github.com/folke/tokyonight.nvim)                              | Collection of colorscheme for Neovim.                                     |
| [which-key.nvim](https://github.com/folke/which-key.nvim)                                | Provide clues for keymaps.                                                |
| [mini.nvim](https://github.com/echasnovski/mini.nvim)                                    | Collection of independent lua modules that enhance Neovim's features.     |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)                    | Configures treesitter parsers.                                            |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)                               | Quickstart configs for Neovim's LSP client.                               |

