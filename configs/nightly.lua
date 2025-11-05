-- ========================================================================== --
-- ==                           EDITOR SETTINGS                            == --
-- ========================================================================== --

-- IMPORTANT: nvim v0.12 is under active development.
-- Breaking changes can happen at any point in time

-- Learn more about Neovim lua api
-- https://neovim.io/doc/user/lua-guide.html
-- https://vonheikemen.github.io/devlog/tools/build-your-first-lua-config-for-neovim/

vim.o.number = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = false
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.showmode = false
vim.o.termguicolors = true
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.signcolumn = 'yes'
vim.o.winborder = 'rounded'

-- Space as leader key
vim.g.mapleader = vim.keycode('<Space>')

-- Basic clipboard interaction
vim.keymap.set({'n', 'x'}, 'gy', '"+y', {desc = 'Copy to clipboard'})
vim.keymap.set({'n', 'x'}, 'gp', '"+p', {desc = 'Paste clipboard content'})

-- ========================================================================== --
-- ==                               PLUGINS                                == --
-- ========================================================================== --

-- NOTE: `vim.pack` is an experimental feature.
-- see :help vim.pack
vim.pack.add({
  {src = 'https://github.com/folke/tokyonight.nvim'},
  {src = 'https://github.com/folke/which-key.nvim'},
  {src = 'https://github.com/neovim/nvim-lspconfig'},
  {src = 'https://github.com/nvim-mini/mini.nvim', version = 'main'},
  {src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main'},
})

-- ========================================================================== --
-- ==                         PLUGIN CONFIGURATION                         == --
-- ========================================================================== --

vim.cmd.colorscheme('tokyonight')

-- See :help MiniIcons.config
-- Change style to 'glyph' if you have a font with fancy icons
require('mini.icons').setup({style = 'ascii'})

-- See :help MiniSurround.config
require('mini.surround').setup({})

-- See :help MiniNotify.config
require('mini.notify').setup({
  lsp_progress = {enable = false},
})

-- See :help MiniBufremove.config
require('mini.bufremove').setup({})

-- Close buffer and preserve window layout
vim.keymap.set('n', '<leader>bc', '<cmd>lua pcall(MiniBufremove.delete)<cr>', {desc = 'Close buffer'})

-- See :help MiniFiles.config
local mini_files = require('mini.files')
mini_files.setup({})

-- Toggle file explorer
-- See :help MiniFiles-navigation
vim.keymap.set('n', '<leader>e', function()
  if mini_files.close() then
    return
  end

  mini_files.open()
end, {desc = 'File explorer'})

-- See :help MiniPick.config
require('mini.pick').setup({})

-- See available pickers
-- :help MiniPick.builtin
-- :help MiniExtra.pickers
vim.keymap.set('n', '<leader>?', '<cmd>Pick oldfiles<cr>', {desc = 'Search file history'})
vim.keymap.set('n', '<leader><space>', '<cmd>Pick buffers<cr>', {desc = 'Search open files'})
vim.keymap.set('n', '<leader>ff', '<cmd>Pick files<cr>', {desc = 'Search all files'})
vim.keymap.set('n', '<leader>fg', '<cmd>Pick grep_live<cr>', {desc = 'Search in project'})
vim.keymap.set('n', '<leader>fd', '<cmd>Pick diagnostic<cr>', {desc = 'Search diagnostics'})
vim.keymap.set('n', '<leader>fs', '<cmd>Pick buf_lines<cr>', {desc = 'Buffer local search'})

-- See :help MiniStatusline.config
require('mini.statusline').setup({})

-- See :help MiniExtra
require('mini.extra').setup({})

-- See :help MiniSnippets.config
require('mini.snippets').setup({})

-- See :help MiniCompletion.config
require('mini.completion').setup({})

-- See :help which-key.nvim-which-key-setup
require('which-key').setup({
  icons = {
    mappings = false,
    keys = {
      Space = 'Space',
      Esc = 'Esc',
      BS = 'Backspace',
      C = 'Ctrl-',
    },
  },
})

require('which-key').add({
  {'<leader>f', group = 'Fuzzy Find'},
  {'<leader>b', group = 'Buffer'},
})

-- Treesitter setup
local ts_parsers = {'lua', 'vim', 'vimdoc', 'c', 'query'}

local ts = vim.treesitter
local ts_installed = require('nvim-treesitter').get_installed()

local ts_filetypes = vim.iter(ts_parsers)
  :map(ts.language.get_filetypes)
  :flatten()
  :fold({}, function(tbl, v)
    tbl[v] = vim.tbl_contains(ts_installed, v)
    return tbl
  end)

local ts_enable = function(buffer, lang)
  local ok, hl = pcall(ts.query.get, lang, 'highlights')
  if ok and hl then
    ts.start(buffer, lang)
  end
end

vim.api.nvim_create_autocmd('FileType', {
  desc = 'enable treesitter',
  callback = function(event)
    local ft = event.match
    local available = ts_filetypes[ft]
    if available == nil then
      return
    end

    local lang = ts.language.get_lang(ft)
    local buffer = event.buf

    if available then
      ts_enable(buffer, lang)
      return
    end

    require('nvim-treesitter').install(lang):await(function()
      ts_filetypes[ft] = true
      ts_enable(buffer, lang)
    end)
  end,
})

vim.api.nvim_create_autocmd('PackChanged', {
  desc = 'auto-update treesitter parsers',
  callback = function(event)
    local args = event.data
    if args.spec.name == 'nvim-treesitter' and args.kind == 'update' then
      vim.cmd.TSUpdate()
    end
  end,
})

-- LSP setup
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = {buffer = event.buf}
    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'grd', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set({'n', 'x'}, 'gq', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
  end,
})

