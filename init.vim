call plug#begin('~/.local/share/nvim/plugged')

Plug 'preservim/nerdtree'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'qpkorr/vim-bufkill'
Plug 'itchyny/lightline.vim'
Plug 'ap/vim-buftabline'
"Plug 'mhinz/vim-startify'
Plug 'amiorin/vim-project'
Plug 'ludovicchabant/vim-gutentags'

"Plug 'phpactor/phpactor'        " code assist for PHP
"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"Plug 'kristijanhusak/deoplete-phpactor'
"Plug 'ncm2/ncm2'                " code autocompletion framework
"Plug 'roxma/nvim-yarp'
"Plug 'phpactor/ncm2-phpactor'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" skins 
"Plug 'sainnhe/gruvbox-material'
Plug 'dim13/smyck.vim'

call plug#end()

language en_US.UTF-8
syntax enable

set encoding=utf-8
set hidden

set number          " show line numbers
set cursorline      " highlight current line
set colorcolumn=120 " show right margin
set nowrap          " disable code wrapping
set whichwrap=<,>,[,]   " move left/right arrows to prev/next line

set expandtab       " tabs: spaces instead of tabs
set shiftwidth=4    " tabs: use 4 spaces instead tab
set tabstop=4       " tabs: displayed tab size
set smarttab        " smarter tab placement

filetype indent on
set autoindent
set smartindent

set showmatch       " highlight matching braces

set termguicolors
set background=dark
colorscheme smyck

" Projects configuration
let g:project_enable_welcome = 1
let g:project_use_nerdtree = 1

call project#rc("~/Projects")

Project '~/Projects/inelo/dev/omni-service', 'inelo-omni'

" NERDTree config
" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 | 
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif
" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | 
    \ quit | endif

" FZF config
let $FZF_DEFAULT_OPTS = '--reverse'
map <C-F> :GFiles<CR>

" gutentag config
let g:gutentags_cache_dir = expand('~/.local/share/nvim/tags')
let g:gutentags_ctags_extra_args = ['--tag-relative=yes', '--fields=+ailmnS']

set statusline+=%{gutentags#statusline('[',']')}

augroup MyGutentagsStatusLineRefresher
    autocmd!
    autocmd User GutentagsUpdating call lightline#update()
    autocmd User GutentagsUpdated call lightline#update()
augroup END

" COC configs
" autocpmplete menu fixes
" - escape closes menu
inoremap <expr> <Esc> pumvisible() ? "\<C-e>" : "\<Esc>"
" - enter and tab selects option
inoremap <expr> <CR>  pumvisible() ? "\<C-y>" : "\<CR>"
inoremap <expr> <TAB> pumvisible() ? "\<C-y>" : "\<TAB>"
" start autocompletion on ctrl-space
inoremap <silent><expr> <c-space> coc#refresh()

