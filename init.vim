" +=================================
" | HELPERS
" +=================================
function! VimRcGetConfigDir()
    return fnamemodify(expand($MYVIMRC), ":p:h")
endfunction

" +=================================
" | PLUGINS
" +=================================
call plug#begin('~/.local/share/nvim/plugged')

Plug 'lambdalisue/nerdfont.vim' " additional icons in fonts
Plug 'Yggdroot/indentLine'      " indentation lines
Plug 'itchyny/vim-gitbranch'    " function to get current git branch

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
Plug 'Xuyuanp/nerdtree-git-plugin'

let g:NERDTreeCascadeSingleChildDir = 0
let g:NERDTreeGitStatusConcealBrackets = 1
let g:NERDTreeGitStatusUseNerdFonts = 1
let g:NERDTreeIgnore = ['^\.git$', '^\.idea$']
let g:NERDTreeWinSize=45
let g:NERDTreeShowHidden=1

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
let $FZF_DEFAULT_OPTS = '--ansi --layout reverse'

map <C-F> :Files<CR>

" +---------------------------------
" | Ferret - multi file search
" +---------------------------------
Plug 'wincent/ferret'

let g:FerretMap = 0

nmap <S-F> <Plug>(FerretAck)

" +---------------------------------
" | LightLine - status & tab lines on steroids
" +---------------------------------
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'

let g:lightline = {
    \   'active': {
    \       'left': [ 
    \           [ 'mode', 'paste' ],
    \           [ 'readonly', 'filename', 'modified' ],
    \       ],
    \       'right': [
    \           [ 'lineinfo' ],
    \           [ 'percent' ],
    \           [ 'fileformat', 'fileencoding', 'filetype' ],
    \           [ 'gitbranch' ]
    \       ]
    \    },
    \   'tabline': {
    \       'left': [ ['buffers'] ],
    \   },
    \   'component_expand': {
    \       'buffers': 'lightline#bufferline#buffers'
    \   },
    \   'component_function': {
    \       'gitbranch': 'gitbranch#name'
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
nnoremap <silent>b1 :call lightline#bufferline#go(1)<CR>
nnoremap <silent>b2 :call lightline#bufferline#go(2)<CR>
nnoremap <silent>b3 :call lightline#bufferline#go(3)<CR>
nnoremap <silent>b4 :call lightline#bufferline#go(4)<CR>
nnoremap <silent>b5 :call lightline#bufferline#go(5)<CR>
nnoremap <silent>b6 :call lightline#bufferline#go(6)<CR>
nnoremap <silent>b7 :call lightline#bufferline#go(7)<CR>
nnoremap <silent>b8 :call lightline#bufferline#go(8)<CR>
nnoremap <silent>b9 :call lightline#bufferline#go(9)<CR>
nnoremap <silent>b0 :call lightline#bufferline#go(10)<CR>

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
" | delimitMate - insert brackets
" +---------------------------------
Plug 'Raimondi/delimitMate'

let g:delimitMate_expand_cr = 1

" +---------------------------------
" | CamelCaseMotion - text objects for camel case
" +---------------------------------
Plug 'bkad/CamelCaseMotion'

" +---------------------------------
" | MARKDOWN extended support 
" +---------------------------------
Plug 'plasticboy/vim-markdown'

let g:vim_markdown_conceal = 0                  " disable hiding MD syntax
let g:vim_markdown_conceal_code_blocks = 0      " disable hiding code syntax
let g:vim_markdown_folding_disabled = 1         " disable folding
let g:vim_markdown_no_default_key_mappings = 1  " no key mapping
let g:vim_markdown_fenced_languages = ['yml=yaml', 'viml=vim', 'bash=sh', 'ini=dosini']

" +---------------------------------
" | PHPActor - boosted PHP support
" +---------------------------------
"Plug 'phpactor/phpactor', {'for': 'php', 'tag': '*', 'do': 'composer install --no-dev -o'}
"
"g:PhpactorRootDirectoryStrategy = function () { return getcwd() }

" +---------------------------------
" | SKINS
" +---------------------------------
Plug 'dim13/smyck.vim'
Plug 'morhetz/gruvbox'

call plug#end()

" +=================================
" | VIM settings
" +=================================
language en_US.UTF-8
syntax enable

set backspace=2             " backspace works like most other programs
set clipboard+=unnamedplus  " use OS clipboard instead of VIM one
set encoding=utf-8
set nobackup

set spell
set spelllang=en_us,en_gb,pl
set spelloptions=camel  " enable camel case spelling (nvim 0.5+)

set hidden
set updatetime=250  " frequency (in ms) of saving recovery files

set colorcolumn=120 " show right margin
set cursorline      " highlight current line
set number          " show line numbers
set signcolumn=yes  " always show sign column
set showtabline=2   " always show tabline

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
set shiftround      " indentation rounded to tab size

set termguicolors
set background=dark
colorscheme smyck

" +=================================
" | Custom key bindings
" +=================================

" set leader to space
let mapleader = " "

" indentation with tab
vnoremap <TAB> >gv
vnoremap <S-TAB> <gv
" paste in visual shortcut
inoremap <C-p> <C-r>+

" additional motions
" - shift arrow in insert moves with CamelCase
imap <silent> <S-Left> <C-o><Plug>CamelCaseMotion_b
imap <silent> <S-Right> <C-o><Plug>CamelCaseMotion_w
" - operations in camel word
omap <silent> cw <Plug>CamelCaseMotion_w
xmap <silent> cw <Plug>CamelCaseMotion_w
omap <silent> icw <Plug>CamelCaseMotion_iw
xmap <silent> icw <Plug>CamelCaseMotion_iw
omap <silent> icb <Plug>CamelCaseMotion_ib
xmap <silent> icb <Plug>CamelCaseMotion_ibu


" autocomplete menu fixes
" - escape closes menu
imap <expr> <Esc> pumvisible() ? "\<C-e>" : "\<Esc>"
" - enter and tab selects option & <CR> uses delimitMate expansion
imap <expr> <CR> pumvisible() ? "\<C-y>" : "\<Plug>delimitMateCR"
imap <expr> <TAB> pumvisible() ? "\<C-y>" : "\<TAB>"

" buffer operations
nnoremap <silent> bp :b#<CR>

" start autocompletion on ctrl-space
" start autocompletion on ctrl-space
inoremap <silent><expr> <C-space> coc#refresh()
" code actions
" - display available actions
nmap <silent> <leader>ca <Plug>(coc-codeaction-cursor)
" - display documentation
nmap <silent> <leader>cd :call CocAction('doHover')<CR>
" - jump to definition
nmap <leader>cj <Plug>(coc-definition)
" - rename item
nmap <leader>cr <Plug>(coc-rename)
" - show usage
nmap <leader>cu <Plug>(coc-references)

" NERDTree actions
nmap <leader>tf :NERDTreeFind<CR><C-w>w
nmap <leader>tr :NERDTreeRefreshRoot<CR>
nmap <leader>tt :NERDTreeFocus<CR>

" PHP actions
nnoremap <leader>pa :PhpactorContextMenu 

" +=================================
" | Auto commands
" +=================================

function! LocalVimrcTrimWhitespace()
    let l:view = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:view)
endfunction

" remove tailing whitespaces in PHP files
autocmd BufWritePre *.php :call LocalVimrcTrimWhitespace()

" +=================================
" | External files
" +=================================

" intelephense key
execute 'source ' . VimRcGetConfigDir() . '/coc-intelephense-key.vim'
" projects functions
execute 'source ' . VimRcGetConfigDir() . '/projects-functions.vim'
" projects definitions
execute 'source ' . VimRcGetConfigDir() . '/projects.vim'

