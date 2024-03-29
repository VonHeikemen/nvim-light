-- ========================================================================== --
-- ==                           EDITOR SETTINGS                            == --
-- ========================================================================== --

-- Learn more about Neovim lua api
-- https://neovim.io/doc/user/lua-guide.html
-- https://vonheikemen.github.io/devlog/tools/build-your-first-lua-config-for-neovim/

vim.opt.number = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.showmode = false
vim.opt.termguicolors = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.signcolumn = 'yes'

-- Space as leader key
vim.g.mapleader = ' '

-- Basic clipboard interaction
vim.keymap.set({'n', 'x', 'o'}, 'gy', '"+y', {desc = 'Copy to clipboard'})
vim.keymap.set({'n', 'x', 'o'}, 'gp', '"+p', {desc = 'Paste clipboard content'})

local is_unix = vim.fn.has('unix') == 1 or vim.fn.has('mac') == 1

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

-- Learn more about lazy.nvim
-- https://dev.to/vonheikemen/lazynvim-plugin-configuration-3opi
lazy.setup({
  {'folke/tokyonight.nvim'},
  {'folke/which-key.nvim'},
  {'nvim-lualine/lualine.nvim'},
  {'nvim-lua/plenary.nvim'},
  {'nvim-treesitter/nvim-treesitter'},
  {'nvim-telescope/telescope.nvim', branch = '0.1.x'},
  {'nvim-telescope/telescope-fzf-native.nvim', build = 'make', enabled = is_unix},
  {'echasnovski/mini.nvim', branch = 'stable'},
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
  highlight = { enable = true, },
  auto_install = true,
  ensure_installed = {'lua', 'vim', 'vimdoc', 'json'},
})

-- See :help which-key.nvim-which-key-configuration
require('which-key').setup({})
require('which-key').register({
  ['<leader>f'] = {name = 'Fuzzy Find', _ = 'which_key_ignore'},
  ['<leader>b'] = {name = 'Buffer', _ = 'which_key_ignore'},
})

-- See :help MiniAi-textobject-builtin
require('mini.ai').setup({n_lines = 500})

-- See :help MiniComment.config
require('mini.comment').setup({})

-- See :help MiniSurround.config
require('mini.surround').setup({})

-- See :help MiniBufremove.config
require('mini.bufremove').setup({})

-- Close buffer and preserve window layout
vim.keymap.set('n', '<leader>bc', '<cmd>lua pcall(MiniBufremove.delete)<cr>', {desc = 'Close buffer'})

-- See :help telescope.builtin
vim.keymap.set('n', '<leader>?', '<cmd>Telescope oldfiles<cr>', {desc = 'Search file history'})
vim.keymap.set('n', '<leader><space>', '<cmd>Telescope buffers<cr>', {desc = 'Search open files'})
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>', {desc = 'Search all files'})
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', {desc = 'Search in project'})
vim.keymap.set('n', '<leader>fd', '<cmd>Telescope diagnostics<cr>', {desc = 'Search diagnostics'})
vim.keymap.set('n', '<leader>fs', '<cmd>Telescope current_buffer_fuzzy_find<cr>', {desc = 'Buffer local search'})

if is_unix then
  require('telescope').load_extension('fzf')
end

-- lsp-zero will integrate lspconfig and cmp for you
-- If you wish to do that manually, see the code here: 
-- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/lsp.md#how-does-it-work
local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  -- See :help lsp-zero-keybindings
  lsp_zero.default_keymaps({buffer = bufnr, preserve_mappings = false})
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
  formatting = lsp_zero.cmp_format({details = true}),
  mapping = cmp.mapping.preset.insert({
    ['<CR>'] = cmp.mapping.confirm({select = false}),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
    ['<C-b>'] = cmp_action.luasnip_jump_backward(),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
  })
})
