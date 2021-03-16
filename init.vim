call plug#begin('~/.local/share/nvim/plugged')

" +=================================
" | PLUGINS
" +=================================
Plug 'lambdalisue/nerdfont.vim' " additional icons in fonts
Plug 'jiangmiao/auto-pairs'     " insert brackets

" skins 
"Plug 'sainnhe/gruvbox-material'
Plug 'dim13/smyck.vim'
Plug 'morhetz/gruvbox'

" +---------------------------------
" | Projects - project view
" +---------------------------------
Plug 'amiorin/vim-project'

let g:project_enable_welcome = 1
let g:project_use_nerdtree = 1

" +---------------------------------
" | NERDTree - file browser
" +---------------------------------
Plug 'preservim/nerdtree'

" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 | 
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif
" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | 
    \ quit | endif

" +---------------------------------
" | FZF - fuzzy search
" +---------------------------------
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

let $FZF_DEFAULT_COMMAND = 'rg --files'
let $FZF_DEFAULT_OPTS = '--reverse'

"map <C-F> :GFiles --cached --others --exclude-standard<CR>
map <C-F> :Files<CR>

" +---------------------------------
" | Ferret - multi file search
" +---------------------------------
Plug 'wincent/ferret'

let g:FerretMap = 0

"nnoremap <S-F> <Plug>(FerretAck)

" +---------------------------------
" | LightLine - status & tab lines on steroids
" +---------------------------------
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'

let g:lightline = {
    \   'tabline': {
    \       'left': [ ['buffers'] ],
    \   },
    \   'component_expand': {
    \       'buffers': 'lightline#bufferline#buffers'
    \   },
    \   'component_type': {
    \       'buffers': 'tabsel'
    \   },
	\   'separator': { 'left': "\ue0b8", 'right': "\ue0ba" },
	\   'subseparator': { 'left': "\ue0b9", 'right': "\ue0bd" }
    \ }

let g:lightline#bufferline#enable_nerdfont = 1
let g:lightline#bufferline#modified = " \uf111"
let g:lightline#bufferline#show_number = 2

" switch to buffer by its ordinal ID
nnoremap b1 :call lightline#bufferline#go(1)<CR>
nnoremap b2 :call lightline#bufferline#go(2)<CR>
nnoremap b3 :call lightline#bufferline#go(3)<CR>
nnoremap b4 :call lightline#bufferline#go(4)<CR>
nnoremap b5 :call lightline#bufferline#go(5)<CR>
nnoremap b6 :call lightline#bufferline#go(6)<CR>
nnoremap b7 :call lightline#bufferline#go(7)<CR>
nnoremap b8 :call lightline#bufferline#go(8)<CR>
nnoremap b9 :call lightline#bufferline#go(9)<CR>
nnoremap b0 :call lightline#bufferline#go(10)<CR>

" +---------------------------------
" | BuffKill - handle buffers without changes in layout
" +---------------------------------
Plug 'qpkorr/vim-bufkill'

nnoremap bd :BD<CR>

" +---------------------------------
" | Gutentags - ctag generator
" +---------------------------------
Plug 'ludovicchabant/vim-gutentags'

let g:gutentags_cache_dir = expand('~/.local/share/nvim/tags')
let g:gutentags_ctags_extra_args = ['--tag-relative=yes', '--fields=+ailmnS']

set statusline+=%{gutentags#statusline('[',']')}

augroup MyGutentagsStatusLineRefresher
    autocmd!
    autocmd User GutentagsUpdating call lightline#update()
    autocmd User GutentagsUpdated call lightline#update()
augroup END

" +---------------------------------
" | CoC - autocompletion
" +---------------------------------
Plug 'neoclide/coc.nvim', {'branch': 'release'}

let g:coc_global_extensions = [
    \   'coc-json',
    \   'coc-phpls',
    \   'coc-snippets'
    \]

" autocomplete menu fixes
" - escape closes menu
inoremap <expr> <Esc> pumvisible() ? "\<C-e>" : "\<Esc>"
" - enter and tab selects option
inoremap <expr> <CR>  pumvisible() ? "\<C-y>" : "\<CR>"
inoremap <expr> <TAB> pumvisible() ? "\<C-y>" : "\<TAB>"
" start autocompletion on ctrl-space
inoremap <silent><expr> <c-space> coc#refresh()

" snippets
Plug 'honza/vim-snippets'
Plug 'sniphpets/sniphpets'
Plug 'sniphpets/sniphpets-common'

" +---------------------------------
" | ALE - syntax checking
" +---------------------------------
Plug 'dense-analysis/ale'

let g:ale_sign_column_always = 1
let g:ale_linters_explicit = 1
let g:ale_linters = {
    \   'php': ['php', 'intelephense', 'phpstan']
    \ }

" +---------------------------------
" | MARKDOWN extended support 
" +---------------------------------
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'

let g:vim_markdown_folding_disabled = 1         " disable folding
let g:vim_markdown_no_default_key_mappings = 1  " no key mapping
let g:vim_markdown_fenced_languages = ['yml=yaml', 'viml=vim', 'bash=sh', 'ini=dosini']




call plug#end()

" +=================================
" | VIM settings
" +=================================
language en_US.UTF-8
syntax enable

set backspace=2             " backspace works like most other programs
set clipboard+=unnamedplus  " use OS clipboard instead of VIM one
set encoding=utf-8

set spell
set spelllang=en_us,pl

set hidden

set showtabline=2   " always show tabline
set number          " show line numbers
set cursorline      " highlight current line
set colorcolumn=120 " show right margin

set nowrap          " disable code wrapping
set whichwrap=<,>,[,]           " move left/right arrows to prev/next line
"set keymodel=startsel,stopsel   " <Shift>-<Arrow> starts selecting text
set scrolloff=10        " Set 7 lines to the cursor - when moving vertically
set sidescrolloff=10    " Same horizontally (when :set nowrap)

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

" +=================================
" | Custom key bindings
" +=================================

" indentation with tab
vnoremap <TAB> >gv
vnoremap <S-TAB> <gv
" paste in visual shortcut
inoremap <C-P> <C-R>+

" +=================================
" | Projects settings
" +=================================
call project#rc("~/Projects")

Project '~/Projects/inelo/dev/fhtagn',          'inelo-fhtagn'
Callback 'inelo-fhtagn', 'ProjectFindSkipVendor'

Project '~/Projects/inelo/dev/omni-service',    'inelo-omni'
Callback 'inelo-omni', ['ProjectAlePHPLinters', 'ProjectFindSkipVendor']

function! ProjectFindSkipVendor(...) abort
    let $FZF_DEFAULT_COMMAND = 'rg --files --no-ignore-vcs -g ''!vendor/**'' '
endfunction

function! ProjectAlePHPLinters(...) abort
    let g:ale_php_phpstan_executable = 'vendor/bin/phpstan'
    let g:ale_php_phpstan_level = 7
endfunction

