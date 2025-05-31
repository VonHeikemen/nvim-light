-- ========================================================================== --
-- ==                           EDITOR SETTINGS                            == --
-- ========================================================================== --

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

-- Space as leader key
vim.g.mapleader = ' '

-- Basic clipboard interaction
vim.keymap.set({'n', 'x'}, 'gy', '"+y', {desc = 'Copy to clipboard'})
vim.keymap.set({'n', 'x'}, 'gp', '"+p', {desc = 'Paste clipboard content'})

-- ========================================================================== --
-- ==                               PLUGINS                                == --
-- ========================================================================== --

local lazy = {}

function lazy.install(path)
  local uv = vim.uv or vim.loop
  if not uv.fs_stat(path) then
    print('Installing lazy.nvim....')
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable', -- latest stable release
      path,
    })
  end
end

function lazy.setup(plugins)
  if vim.g.plugins_ready then
    return
  end

  -- You can "comment out" the line below after lazy.nvim is installed
  lazy.install(lazy.path)

  vim.opt.rtp:prepend(lazy.path)

  require('lazy').setup(plugins, lazy.opts)
  vim.g.plugins_ready = true
end

lazy.path = table.concat({
  vim.fn.stdpath('data') --[[@as string]],
  'lazy',
  'lazy.nvim'
}, '/')

lazy.opts = {}

-- Learn more about lazy.nvim
-- (plugin configuration, how to split your config in multiple files)
-- https://dev.to/vonheikemen/lazynvim-plugin-configuration-3opi
lazy.plugins = {
  {'folke/tokyonight.nvim'},
  {'folke/which-key.nvim'},
  {'neovim/nvim-lspconfig'},
  {'echasnovski/mini.nvim', branch = 'main'},
  {'nvim-treesitter/nvim-treesitter', build = ':TSUpdate', branch = 'main'},
}

-- The following plugins no longer support Neovim v0.10 or lower.
-- They need to be pinned to a version that is compatible.
if vim.fn.has('nvim-0.11') == 0 then
  vim.list_extend(lazy.plugins, {
    {'neovim/nvim-lspconfig', tag = 'v1.8.0', pin = true},
    {
      'nvim-treesitter/nvim-treesitter',
      tag = 'v0.10.0',
      pin = true,
      main = 'nvim-treesitter.configs',
      opts = {
        highlight = {enable = true},
        ensure_installed = {'lua', 'vim', 'vimdoc', 'c', 'query'},
      },
    },
  })
end

lazy.setup(lazy.plugins)

-- ========================================================================== --
-- ==                         PLUGIN CONFIGURATION                         == --
-- ========================================================================== --

vim.cmd.colorscheme('tokyonight')

-- Newer versions of nvim-treesitter no longer provide
-- fancy modules that enable features for us.
-- On Neovim v0.11 we need to enable each feature manually.
-- See :help nvim-treesitter-quickstart
if vim.fn.has('nvim-0.11') == 1 then
  local filetypes = {'lua'}

  vim.api.nvim_create_autocmd('FileType', {
    pattern = filetypes,
    callback = function()
      -- enable syntax highlight
      vim.treesitter.start()
    end,
  })
end

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

-- See :help MiniIcons.config
-- Change style to 'glyph' if you have a font with fancy icons
require('mini.icons').setup({style = 'ascii'})

-- See :help MiniAi-textobject-builtin
require('mini.ai').setup({n_lines = 500})

-- See :help MiniComment.config
require('mini.comment').setup({})

-- See :help MiniSurround.config
require('mini.surround').setup({})

-- See :help MiniNotify.config
require('mini.notify').setup({
  lsp_progress = {enable = false},
})

-- See :help MiniNotify.make_notify()
vim.notify = require('mini.notify').make_notify({})

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

-- See :help MiniStatusline-example-content
local mini_statusline = require('mini.statusline')

local function statusline()
  local mode, mode_hl = mini_statusline.section_mode({trunc_width = 120})
  local diagnostics = mini_statusline.section_diagnostics({trunc_width = 75})
  local lsp = mini_statusline.section_lsp({icon = 'LSP', trunc_width = 75})
  local filename = mini_statusline.section_filename({trunc_width = 140})
  local percent = '%2p%%'
  local location = '%3l:%-2c'

  return mini_statusline.combine_groups({
    {hl = mode_hl,                  strings = {mode}},
    {hl = 'MiniStatuslineDevinfo',  strings = {diagnostics, lsp}},
    '%<', -- Mark general truncate point
    {hl = 'MiniStatuslineFilename', strings = {filename}},
    '%=', -- End left alignment
    {hl = 'MiniStatuslineFilename', strings = {'%{&filetype}'}},
    {hl = 'MiniStatuslineFileinfo', strings = {percent}},
    {hl = mode_hl,                  strings = {location}},
  })
end

-- See :help MiniStatusline.config
mini_statusline.setup({
  content = {active = statusline},
})

-- See :help MiniExtra
require('mini.extra').setup({})

-- See :help MiniSnippets.config
require('mini.snippets').setup({})

-- See :help MiniCompletion.config
require('mini.completion').setup({})

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = {buffer = event.buf}

    -- These keymaps will become defaults after Neovim v0.11
    -- I've added them here for backwards compatibility
    vim.keymap.set('n', 'grr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', 'gri', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    vim.keymap.set('n', 'grn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set('n', 'gra', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
    vim.keymap.set('n', 'gO', '<cmd>lua vim.lsp.buf.document_symbol()<cr>', opts)
    vim.keymap.set({'i', 's'}, '<C-s>', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)

    -- These are custom keymaps
    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'grt', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', 'grd', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set({'n', 'x'}, 'gq', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
  end,
})

