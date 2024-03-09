-- ========================================================================== --
-- ==                           EDITOR SETTINGS                            == --
-- ========================================================================== --

vim.opt.number = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.showmode = false
vim.opt.termguicolors = true

-- Space as leader key
vim.g.mapleader = ' '

-- Basic clipboard interaction
vim.keymap.set({'n', 'x', 'o'}, 'gy', '"+y', {desc = 'Copy to clipboard'})
vim.keymap.set({'n', 'x', 'o'}, 'gp', '"+p', {desc = 'Paste clipboard content'})

-- ========================================================================== --
-- ==                               PLUGINS                                == --
-- ========================================================================== --

local lazy = {}

function lazy.install(path)
  if not vim.loop.fs_stat(path) then
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

lazy.path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
lazy.opts = {}

lazy.setup({
  {'folke/tokyonight.nvim'},
  {'nvim-lualine/lualine.nvim'},
  {'nvim-lua/plenary.nvim'},
  {'nvim-treesitter/nvim-treesitter'},
  {'nvim-telescope/telescope.nvim', branch = '0.1.x'},
  {'nvim-telescope/telescope-fzf-native.nvim', build = 'make'},
  {'echasnovski/mini.comment', branch = 'stable'},
  {'echasnovski/mini.surround', branch = 'stable'},
  {'echasnovski/mini.bufremove', branch = 'stable'},
  {'VonHeikemen/lsp-zero.nvim', branch = 'v3.x'},
  {'neovim/nvim-lspconfig'},
  {'hrsh7th/nvim-cmp'},
  {'hrsh7th/cmp-nvim-lsp'},
  {'hrsh7th/cmp-buffer'},
  {'L3MON4D3/LuaSnip'},
})


-- ========================================================================== --
-- ==                         PLUGIN CONFIGURATION                         == --
-- ========================================================================== --

vim.cmd.colorscheme('tokyonight')

vim.g.netrw_banner = 0
vim.g.netrw_winsize = 30

-- See :help netrw-browse-maps
vim.keymap.set('n', '<leader>e', '<cmd>Lexplore<cr>', {desc = 'Toggle file explorer'})
vim.keymap.set('n', '<leader>E', '<cmd>Lexplore %:p:h<cr>', {desc = 'Open file explorer in current file'})

-- See :help lualine.txt
require('lualine').setup({
  options = {
    theme = 'tokyonight',
    icons_enabled = false,
    component_separators = '|',
    section_separators = '',
  },
})

-- See :help nvim-treesitter-modules
require('nvim-treesitter.configs').setup({
  highlight = {
    enable = true,
  },
  ensure_installed = {'lua', 'vim', 'vimdoc', 'json'},
})

-- See :help MiniComment.config
require('mini.comment').setup({})

-- See :help MiniSurround.config
require('mini.surround').setup({})

-- See :help MiniBufremove.config
require('mini.bufremove').setup({})

vim.keymap.set('n', '<leader>bc', '<cmd>lua pcall(MiniBufremove.delete)<cr>')

-- See :help telescope.builtin
vim.keymap.set('n', '<leader>?', '<cmd>Telescope oldfiles<cr>', {desc = 'Search file history'})
vim.keymap.set('n', '<leader><space>', '<cmd>Telescope buffers<cr>', {desc = 'Search open files'})
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>', {desc = 'Search files in project'})
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', {desc = 'Search term in project'})
vim.keymap.set('n', '<leader>fd', '<cmd>Telescope diagnostics<cr>', {desc = 'Search diagnostics message'})
vim.keymap.set('n', '<leader>fs', '<cmd>Telescope current_buffer_fuzzy_find<cr>', {desc = 'Search term in current file'})

require('telescope').load_extension('fzf')

-- lsp-zero will integrate lspconfig and cmp for you
-- If you wish to do that manually, see the code here: 
-- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/lsp.md#how-does-it-work
local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  -- See :help lsp-zero-keybindings
  lsp_zero.default_keymaps({buffer = bufnr})
end)

-- See :help lspconfig-setup
-- require('lspconfig').tsserver.setup({})
-- require('lspconfig').eslint.setup({})
-- require('lspconfig').rust_analyzer.setup({})

local cmp = require('cmp')
local cmp_action = lsp_zero.cmp_action()

-- See :help cmp-config
cmp.setup({
  sources = {
    {name = 'nvim_lsp'},
    {name = 'buffer'},
  },
  formatting = lsp_zero.cmp_format(),
  mapping = cmp.mapping.preset.insert({
    ['<CR>'] = cmp.mapping.confirm({select = false}),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
    ['<C-b>'] = cmp_action.luasnip_jump_backward(),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
  })
})
