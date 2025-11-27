-- ========================================================================== --
-- ==                           EDITOR SETTINGS                            == --
-- ========================================================================== --

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
vim.o.complete = '.,w,b,u'
vim.o.completeopt = 'menuone,noselect'

vim.g.netrw_banner = 0
vim.g.netrw_winsize = 30
vim.g.netrw_liststyle = 0

-- Space as leader key
vim.g.mapleader = ' '

-- Basic clipboard interaction
vim.api.nvim_set_keymap('n', 'gy', '"+y', {noremap = true})
vim.api.nvim_set_keymap('x', 'gy', '"+y', {noremap = true})
vim.api.nvim_set_keymap('n', 'gp', '"+p', {noremap = true})
vim.api.nvim_set_keymap('x', 'gp', '"+p', {noremap = true})

-- Here we will store functions that we will use in commands and keymaps
_G.User = {}

-- ========================================================================== --
-- ==                               PLUGINS                                == --
-- ========================================================================== --

-- NOTE: In this configuration we don't have access to all modules in mini.nvim.
-- A few extra plugins are needed to fill the missing features.
--   * mini.deps is replaced by minpac (plugin manager)
--   * mini.pick is replaced by telescope (fuzzy finder)
--   * mini.files is replaced by netrw (file explorer)

local minpac = function(plug)
  local uv = vim.loop or vim.uv
  local packpath = vim.fn.stdpath('data') .. '/site'
  local path = packpath .. '/pack/minpac/opt/minpac'
  vim.g.minpac_ready = true

  if not uv.fs_stat(path) then
    print('Installing minpac....')
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/k-takata/minpac',
      path
    })

    vim.g.minpac_ready = false
    User.InstallPlugins = function()
      User.PackInit()
      vim.call('minpac#update', '', {['do'] = 'source $MYVIMRC'})
    end
    vim.cmd('autocmd VimEnter * lua User.InstallPlugins()')
  end

  vim.cmd([[
    command! PackUpdate lua User.PackInit(); vim.call('minpac#update', '')
    command! PackClean  lua User.PackInit(); vim.call('minpac#clean')
    command! PackStatus packadd minpac | call minpac#status()
  ]])

  User.PackInit = function()
    vim.cmd('packadd minpac')
    vim.call('minpac#init', {dir = packpath})
    plug(vim.fn['minpac#add'])
  end
end

minpac(function(add)
  add('folke/which-key.nvim', {
    rev = '4b7167f8fb2dba3d01980735e3509e172c024c29',
    frozen = true,
  })

  add('nvim-mini/mini.nvim', {
    rev = '3f2c7a2aee528309fb42091b723285fb7630a0c2',
    frozen = true,
  })

  add('nvim-treesitter/nvim-treesitter', {
    rev = '8a1acc00d2a768985a79358d1a6caa9f08a0eeea',
    frozen = true,
  })

  add('neovim/nvim-lspconfig', {
    rev = '99596a8cabb050c6eab2c049e9acde48f42aafa4',
    frozen = true,
  })

  add('nvim-lua/plenary.nvim', {
    rev = 'a672e11c816d4a91ef01253ba1a2567d20e08e55',
    frozen = true,
  })

  add('nvim-telescope/telescope.nvim', {
    rev = '80cdb00b221f69348afc4fb4b701f51eb8dd3120',
    frozen = true,
  })
end)

if not vim.g.minpac_ready then
  return
end

-- ========================================================================== --
-- ==                         PLUGIN CONFIGURATION                         == --
-- ========================================================================== --

vim.cmd('colorscheme minicyan')

-- See :help which-key.nvim-which-key-setup
local wk = require('which-key')
wk.setup({})
wk.register({
  f = 'Fuzzy Find',
  b = 'Buffers',
  e = 'Toggle file explorer',
}, {prefix = '<leader>'})
wk.register({
  gr = 'LSP Actions',
  gy = 'Copy to clipboard',
  gp = 'Paste clipboard content',
}, {mode = {'n', 'x'}})

-- See :help MiniComment.config
require('mini.comment').setup({})

-- See :help MiniSurround.config
require('mini.surround').setup({})

-- See :help MiniBufremove.config
require('mini.bufremove').setup({})

-- Close buffer and preserve window layout
vim.api.nvim_set_keymap('n', '<leader>bc', '<cmd>lua pcall(MiniBufremove.delete)<cr>', {noremap = true})

-- See :help MiniStatusline.config
require('mini.statusline').setup({})

-- See :help MiniCompletion.config
require('mini.completion').setup({
  lsp_completion = {
    source_func = 'omnifunc',
    auto_setup = false,
  },
})

-- Toggle file explorer
User.ToggleExplorer = function()
  local keycode = vim.api.nvim_replace_termcodes

  if vim.bo.filetype == 'netrw' then
    return keycode('<cmd>close<cr>', true, true, true)
  end

  if vim.t.netrw_lexbufnr then
    return keycode('<cmd>Lexplore<cr>', true, true, true)
  end

  return keycode('<cmd>Lexplore %:p:h<cr>', true, true, true)
end

vim.api.nvim_set_keymap('n', '<leader>e', 'v:lua.User.ToggleExplorer()', {noremap = true, expr = true})

-- See :help telescope.builtin
vim.api.nvim_set_keymap('n', '<leader>?', '<cmd>Telescope oldfiles<cr>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader><space>', '<cmd>Telescope buffers<cr>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files<cr>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fd', '<cmd>Telescope diagnostics<cr>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fs', '<cmd>Telescope current_buffer_fuzzy_find<cr>', {noremap = true})

-- Treesitter setup
-- NOTE: the list of supported parsers is in the documentation:
-- https://github.com/nvim-treesitter/nvim-treesitter/tree/8a1acc00d2a768985a79358d1a6caa9f08a0eeea#supported-languages
local ts_parsers = {'lua', 'vim', 'help', 'c', 'query'}
require('nvim-treesitter.configs').setup({
  highlight = {enable = true},
  ensure_installed = ts_parsers,
})

-- LSP setup
local lspconfig = require('lspconfig')
local lsp_defaults = lspconfig.util.default_config
local nvim_08 = vim.fn.has('nvim-0.8') == 1

if vim.fn.has('nvim-0.6') == 0 then
  vim.api.nvim_set_keymap('n', '<C-w>d', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>', {noremap = true})
  vim.api.nvim_set_keymap('n', '<C-w><C-d>', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>', {noremap = true})
  vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>', {noremap = true})
  vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<cr>', {noremap = true})
else
  vim.api.nvim_set_keymap('n', '<C-w>d', '<cmd>lua vim.diagnostic.open_float()<cr>', {noremap = true})
  vim.api.nvim_set_keymap('n', '<C-w><C-d>', '<cmd>lua vim.diagnostic.open_float()<cr>', {noremap = true})
  vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', {noremap = true})
  vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', {noremap = true})
end

lsp_defaults.on_attach = function(client, bufnr)
  local opts = {noremap = true}
  local buf_keymap = vim.api.nvim_buf_set_keymap

  if client.supports_method('textDocument/completion') then
    vim.bo[bufnr].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
  end

  -- These keymaps will become defaults after Neovim v0.11
  buf_keymap(bufnr, 'n', 'grr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
  buf_keymap(bufnr, 'n', 'gri', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
  buf_keymap(bufnr, 'n', 'grt', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
  buf_keymap(bufnr, 'n', 'grn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
  buf_keymap(bufnr, 'n', 'gra', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  buf_keymap(bufnr, 'n', 'gO', '<cmd>lua vim.lsp.buf.document_symbol()<cr>', opts)
  buf_keymap(bufnr, 'i', '<C-s>', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
  buf_keymap(bufnr, 's', '<C-s>', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)

  -- These are custom keymaps
  buf_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
  buf_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
  buf_keymap(bufnr, 'n', 'grd', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)

  if nvim_08 then
    buf_keymap(bufnr, 'n', 'gq', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    buf_keymap(bufnr, 'x', 'gq', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
  else
    buf_keymap(bufnr, 'n', 'gq', '<cmd>lua vim.lsp.buf.formatting()<cr>', opts)
    buf_keymap(bufnr, 'x', 'gq', '<Esc><cmd>lua vim.lsp.buf.range_formatting()<cr>', opts)
  end
end

