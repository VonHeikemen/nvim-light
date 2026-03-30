" NOTE: Neovim v0.12 or greater is needed
" NOTE: This file exists to demonstrate vimscript 
" is still a viable option to configure Neovim.
"

" ============================================================================ "
" ===                           EDITOR SETTINGS                            === "
" ============================================================================ "

set number
set ignorecase
set smartcase
set hlsearch
set tabstop=2
set shiftwidth=2
set noshowmode
set termguicolors
set updatetime=250
set timeoutlen=300
set signcolumn=yes
set winborder=rounded

" Space as leader key
let mapleader= "\<Space>"

" Basic clipboard interaction
" gy to copy; gp to paste
noremap gy "+y
noremap gp "+p

" ============================================================================ "
" ===                               PLUGINS                                === "
" ============================================================================ "

" NOTE: To install a plugin you just need to add the URL to the repository.
" But as soon as you need to add more information, like the git branch or 
" commit, use the "plugin spec" form. See :help vim.pack

call v:lua.vim.pack.add([
\  'https://github.com/folke/tokyonight.nvim',
\  'https://github.com/folke/which-key.nvim',
\  'https://github.com/VonHeikemen/ts-enable.nvim',
\  'https://github.com/neovim/nvim-lspconfig',
\  {'src': 'https://github.com/nvim-mini/mini.nvim', 'version': 'main'},
\  {'src': 'https://github.com/nvim-treesitter/nvim-treesitter', 'version': 'main'},
\])

" Define the function 'Safe' to catch lua runtime errors.
" Error messages will show up at the end of the startup process.
lua RE = {}; Safe = function(f) vim.list_extend(RE, {pcall(f)}, 2, 2) end
autocmd VimEnter * lua if RE[1] then vim.notify(table.concat(RE,'\n\n'),3) end

" Use 'setup' function of lua plugins in a safe way
let Setup = luaeval('function(m,c) Safe(function() require(m).setup(c) end) end')

" ============================================================================ "
" ===                            PLUGIN CONFIG                             === "
" ============================================================================ "

colorscheme tokyonight

" See :help MiniIcons.config
" Change style to 'glyph' if you have a font with fancy icons
call Setup('mini.icons', {'style': 'ascii'})

" See :help MiniSurround.config
call Setup('mini.surround', {})

" See :help MiniNotify.config
call Setup('mini.notify', {'lsp_progress': {'enable': v:false}})

" See :help MiniBufremove.config
call Setup('mini.bufremove', {})

" Close buffer and preserve window layout
nnoremap <leader>bc <cmd>lua pcall(MiniBufremove.delete)<cr>

" See :help MiniFiles.config
call Setup('mini.files', {})

function! ToggleExplorer() abort
  if v:lua.MiniFiles.close()
    return
  endif

  call v:lua.MiniFiles.open()
endfunction

nnoremap <leader>e <cmd>call ToggleExplorer()<cr>

" See :help MiniPick.config
call Setup('mini.pick', {})

" See available pickers
" :help MiniPick.builtin
" :help MiniExtra.pickers
nnoremap <leader>? <cmd>Pick oldfiles<cr>
nnoremap <leader><space> <cmd>Pick buffers<cr>
nnoremap <leader>ff <cmd>Pick files<cr>
nnoremap <leader>fg <cmd>Pick grep_live<cr>
nnoremap <leader>fd <cmd>Pick diagnostic<cr>
nnoremap <leader>fs <cmd>Pick buf_lines<cr>

" See :help MiniExtra.config
call Setup('mini.extra', {})

" See :help MiniStatusline.config
call Setup('mini.statusline', {})

" See :help MiniSnippets.config
call Setup('mini.snippets', {})

" See :help MiniCompletion.config
call Setup('mini.completion', {
\  'lsp_completion': {
\    'source_func': 'omnifunc',
\    'auto_setup': v:false,
\  },
\})

" See :help which-key.nvim-which-key-setup
call Setup('which-key', {
\  'preset': 'helix',
\  'icons': {
\    'mappings': v:false,
\    'keys': {
\      'Space': 'Space',
\      'Esc': 'Esc',
\      'BS': 'Backspace',
\      'C': 'Ctrl-'
\    },
\  }
\})

" Treesitter setup
" NOTE: the list of supported parsers is in the documentation:
" https://github.com/nvim-treesitter/nvim-treesitter/blob/main/SUPPORTED_LANGUAGES.md
let s:ts_parsers = ['lua', 'vim', 'vimdoc', 'c', 'query']

" See :help ts-enable-config
let g:ts_enable = {
\  'auto_install': v:true,
\  'highlights': v:true,
\  'parsers': s:ts_parsers
\}

" Try to update all parsers after a plugin update
autocmd PackChanged nvim-treesitter TSUpdate

" LSP setup
function! LspAttached() abort
  nnoremap <buffer> K <cmd>lua vim.lsp.buf.hover()<cr>
  nnoremap <buffer> gd <cmd>lua vim.lsp.buf.definition()<cr>
  nnoremap <buffer> gq <cmd>lua vim.lsp.buf.format({async = true})<cr>
  xnoremap <buffer> gq <cmd>lua vim.lsp.buf.format({async = true})<cr>
  setlocal omnifunc=v:lua.MiniCompletion.completefunc_lsp
endfunction

autocmd LspAttach * call LspAttached()

