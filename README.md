# nvim-light

Lightweight configuration focused on providing "basic features" with little boilerplate. It includes better syntax highlight, a fuzzy finder and a ready made LSP setup with autocompletion.

## Requirements

* Neovim v0.8 or greater.
* git.
* A `C` compiler. Can be `gcc`, `tcc` or `zig`.
* [make](https://www.gnu.org/software/make/), the build tool.
* (optional) [ripgrep](https://github.com/BurntSushi/ripgrep). Improves project wide search speed.
* (optional) [fd](https://github.com/sharkdp/fd). Improves file search speed.

### Note for windows users

If you need a `C` compiler then `zig` is the easiest to install. It's available on `winget`, `scoop` and `chocolatey`. You can also find some links in their [download page](https://ziglang.org/download/). 

If you experience performance issues with the plugin `Telescope` then you might want to try an alternative like [fzf.lua](https://github.com/ibhagwan/fzf-lua).

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

* Copy the content of `init.lua` in this repository into your own `init.lua`.

* Open Neovim, use the command `nvim` in your terminal. When Neovim starts all plugins will be downloaded automatically.

## Learn how to use Neovim as a text editor

Neovim comes with an interactive tutorial that teaches the basics of the editor. It will show how to navigate in the code, how to execute commands and of course how to quit Neovim. You can access this tutorial by executing this command in your terminal.

```sh
nvim +Tutor
```

This video series by ThePrimeagen is also a good resource.

* [Vim As Your Editor - Introduction](https://www.youtube.com/watch?v=X6AR2RMB5tE) 
* [Vim As Your Editor - Horizontal Movements](https://youtu.be/5JGVtttuDQA) 
* [Vim As Your Editor - Vertical Movements](https://www.youtube.com/watch?v=KfENDDEpCsI)

> Note: if you see a video from ThePrimeagen called "0 to LSP" ignore the part were he configures the plugin called `lsp-zero`. That plugin has changed a lot since the video was released. And also, the plugin manager he uses is no longer mantained.

## Learn the basics of lua and Neovim's api

This configuration was created using a scripting language called `lua`, I highly recommend that you learn the syntax of this language. Learn just enough to know what is valid. Here are a couple resources:

* [Learn lua in Y minutes](https://learnxinyminutes.com/docs/lua/) 
* [Lua crash course (video)](https://www.youtube.com/watch?v=NneB6GX1Els)

Next step is to get familiar with Neovim's lua api, so you can create your own keybindings and commands. Here are a couple of guides you can read:

* [Build your first Neovim configuration in lua](https://vonheikemen.github.io/devlog/tools/build-your-first-lua-config-for-neovim/) 
* [Neovim's official lua guide](https://neovim.io/doc/user/lua-guide.html)

## About LSP servers

They are external programs that provide IDE-like features to Neovim. You need to install them manually. Go to nvim-lspconfig's documentation, in [server_configuration.md](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md) you'll find links and instruction on how to install all the supported LSP servers.

Once the LSP server is available in your system you need to add the setup function to your config.

For example, if you installed the typescript language server you need to add this.

```lua
require('lspconfig').tsserver.setup({})
```

## About syntax highlight

To get a more accurate syntax highlight for your favorite language you need to download something called a "treesitter parser".  Use the command `TSInstall` plus the name of a supported language to download and install its parser.

For example if you wanted to install a parser for javascript, you need to execute this command.

```vim
:TSInstall javascript
```

You can also instruct Neovim to download the parser you need by adding a name to the property `ensure_installed` located in the setup function of `nvim-treesitter.configs`.

## Learn more about lazy.nvim

So, `lazy.nvim` is the plugin manager used in this configuration. Here are a few resources that will help you understand some of it's features:

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
| Normal   | `gD`              | Jump to declaration.                                                    |
| Normal   | `gi`              | Lists all the implementations for the symbol under the cursor.          |
| Normal   | `go`              | Jumps to the definition of the type symbol                              |
| Normal   | `gr`              | Lists all the references.                                               |
| Normal   | `gs`              | Displays a function's signature information.                            |
| Normal   | `<F2>`            | Renames all references to the symbol under the cursor.                  |
| Normal   | `<F3>`            | Format code in current buffer.                                          |
| Normal   | `<F4>`            | Selects a code action available at the current cursor position.         |
| Normal   | `gl`              | Show diagnostics in a floating window.                                  |
| Normal   | `[d`              | Move to the previous diagnostic.                                        |
| Normal   | `]d`              | Move to the next diagnostic.                                            |
| Normal   | `gcc`             | Toggle comment in current line.                                         |
| Operator | `gc`              | Toggle comment in text.                                                 |
| Operator | `sa`              | Add surrounding.                                                        |
| Normal   | `sd`              | Delete surrounding.                                                     |
| Normal   | `sr`              | Surround replace.                                                       |
| Normal   | `sf`              | Find surrounding.                                                       |
| Normal   | `<leader>e`       | Toggle file explorer.                                                   |
| Normal   | `<leader>E`       | Open file explorer in current folder.                                   |
| Normal   | `<leader>bc`      | Close current buffer and preserve window layout.                        |
| Normal   | `<leader>?`       | Search oldfiles history.                                                |
| Normal   | `<leader><space>` | Search open buffers.                                                    |
| Normal   | `<leader>ff`      | Find file in current working directory.                                 |
| Normal   | `<leader>fg`      | Search pattern in current working directory. Interactive "grep search". |
| Normal   | `<leader>fd`      | Search diagnostics in current file.                                     |
| Normal   | `<leader>fs`      | Search pattern in current file.                                         |

### Autocomplete keybindings

| Mode   | Key            | Action                                    |
| ---    | ---            | ---                                       |
| Insert | `<Ctrl-y>`     | Confirm completion.                       |
| Insert | `<Enter>`      | Confirm completion.                       |
| Insert | `<Ctrl-e>`     | Cancel completion.                        |
| Insert | `<Ctrl-p>`     | Move to previous item.                    |
| Insert | `<Ctrl-n>`     | Move to next item.                        |
| Insert | `<Ctrl-u>`     | Scroll up in documentation window.        |
| Insert | `<Ctrl-d>`     | Scroll down in documentation window.      |
| Insert | `<Ctrl-b>`     | Jump to the previous snippet placeholder. |
| Insert | `<Ctrl-f>`     | Jump to the next snippet placeholder.     |
| Insert | `<Ctrl-Space>` | Trigger completion.                       |

## Plugin list

| Name                                                                                     | Description                                                               |
| ---                                                                                      | ---                                                                       |
| [lazy.nvim](https://github.com/folke/lazy.nvim)                                          | Plugin manager.                                                           |
| [tokyonight.nvim](https://github.com/folke/tokyonight.nvim)                              | Collection of colorscheme for Neovim.                                     |
| [which-key.nvim](https://github.com/folke/which-key.nvim)                                | Provide clues for keymaps.                                                |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)                             | Pretty statusline.                                                        |
| [mini.nvim](https://github.com/echasnovski/mini.nvim)                                    | Collection of independent lua modules that enhance Neovim's features.     |
| [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)                                 | Collection of lua modules. It helps plugin authors solve common problems. |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)                       | Fuzzy finder.                                                             |
| [telescope-fzf-native.nvim](https://github.com/nvim-telescope/telescope-fzf-native.nvim) | Extension for telescope. Allows fzf-like syntax in search queries.        |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)                    | Configures treesitter parsers. Provides modules to manipulate code.       |
| [lsp-zero.nvim](https://github.com/VonHeikemen/lsp-zero.nvim)                            | Bundles the boilerplate code needed to configure lspconfig and nvim-cmp.  |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)                               | Quickstart configs for Neovim's LSP client.                               |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)                                          | Autocompletion engine.                                                    |
| [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp)                                  | nvim-cmp source. Show suggestions based on LSP servers queries.           |
| [cmp-buffer](https://github.com/hrsh7th/cmp-buffer)                                      | nvim-cmp source. Suggest words in the current buffer.                     |
| [LuaSnip](https://github.com/L3MON4D3/LuaSnip)                                           | Snippet engine.                                                           |
