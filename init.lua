-- +=================================
-- | HELPERS
-- +=================================

local Plug = vim.fn['plug#']

local init_functions = {}

function add_init(fn)
    table.insert(init_functions, fn)
end

-- +=================================
-- | PLUGINS
-- +=================================
vim.call('plug#begin', '~/.local/share/nvim/plugged')

Plug('nvim-lua/plenary.nvim')       -- utilities functions for LUA projects
Plug('lambdalisue/nerdfont.vim')    -- additional icons in fonts
Plug('itchyny/vim-gitbranch')       -- function to get current git branch

-- +---------------------------------
-- | indentLine - indentation lines
-- +---------------------------------
Plug('Yggdroot/indentLine')

vim.g.vim_json_conceal = 0        -- disable conceal for JSON files

-- +---------------------------------
-- | Projects - project view
-- +---------------------------------
-- Plug 'amiorin/vim-project'
Plug('luinnar/vim-project')

vim.g.project_enable_welcome = 1
vim.g.project_use_nerdtree = 1

-- +---------------------------------
-- | NERDTree - file browser
-- +---------------------------------
Plug('preservim/nerdtree')
Plug('Xuyuanp/nerdtree-git-plugin')

vim.g.NERDTreeCascadeSingleChildDir = 0
vim.g.NERDTreeGitStatusConcealBrackets = 1
vim.g.NERDTreeGitStatusUseNerdFonts = 1
vim.g.NERDTreeIgnore = {'^\\.git$', '^\\.idea$', '__pycache__'}
vim.g.NERDTreeWinSize = 45
vim.g.NERDTreeShowHidden = 1

--[[
-- If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 | 
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif
-- Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | 
    \ quit | endif
]]--

-- +---------------------------------
-- | telescope.nvim - search everywhere
-- +---------------------------------
Plug('nvim-telescope/telescope.nvim', {tag = '0.1.4'})
Plug('nvim-telescope/telescope-fzf-native.nvim', {['do'] = 'make'})

add_init(function()
    local actions = require('telescope.actions')
    local builtin = require('telescope.builtin')

    require('telescope').setup({
        defaults = {
            layout_config = {
                height = 0.6,
            },
            mappings = {
                i = {
                    --['<esc>'] = actions.close
                }
            },
        },
        extensions = {
            fzf = {
                fuzzy = true,                    -- false will only do exact matching
                override_generic_sorter = true,  -- override the generic sorter
                override_file_sorter = true,     -- override the file sorter
            },
        },
    })

    if pcall(require, 'fzf_lib') then
        require('telescope').load_extension('fzf')
    end

    vim.keymap.set('n', '<leader>ff', builtin.find_files)
    vim.keymap.set('n', '<leader>fg', builtin.live_grep)
end)

-- +---------------------------------
-- | FZF - fuzzy search
-- +---------------------------------
Plug('junegunn/fzf', {['do'] = vim.fn['fzf#install']})
Plug('junegunn/fzf.vim')

vim.env.FZF_DEFAULT_COMMAND = 'rg --files'
vim.env.FZF_DEFAULT_OPTS = '--ansi --layout reverse'

-- +---------------------------------
-- | Ferret - multi file search
-- +---------------------------------
Plug('wincent/ferret')

vim.g.FerretMap = 0

-- +---------------------------------
-- | LightLine - status & tab lines on steroids
-- +---------------------------------
Plug('itchyny/lightline.vim')
Plug('mengelbrecht/lightline-bufferline')

vim.g.lightline = {
    active = {
        left = { 
            {'mode', 'paste'},
            {'readonly', 'filename', 'modified'},
        },
        right = {
            {'lineinfo'},
            {'percent'},
            {'fileformat', 'fileencoding', 'filetype'},
            {'gitbranch'}
        }
    },
    bufferline = {
        enable_nerdfont = 1,
        modified = " \u{f111}",
        show_number = 2
    },
    tabline = {
        left = {
            {'buffers'}
        },
    },
    component_expand = {
        buffers = 'lightline#bufferline#buffers'
    },
    component_function = {
        gitbranch = 'gitbranch#name'
    },
    component_type = {
        buffers = 'tabsel'
    },
    separator = {left = "\u{e0b8}", right = "\u{e0ba}"},
    subseparator = {left = "\u{e0b9}", right = "\u{e0bd}"}
}

-- +---------------------------------
-- | BuffKill - handle buffers without changes in layout
-- +---------------------------------
Plug('qpkorr/vim-bufkill')

-- +---------------------------------
-- | CoC - autocompletion
-- +---------------------------------
Plug('neoclide/coc.nvim', {branch = 'release'})

vim.g.coc_global_extensions = {
   'coc-json',
   'coc-phpls',
   'coc-pyright',
   'coc-snippets'
}

-- Show signature help on placeholder jump
--autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')

-- snippets
Plug('honza/vim-snippets')
Plug('sniphpets/sniphpets')
Plug('sniphpets/sniphpets-common')

-- +---------------------------------
-- | CoC FZF
-- +---------------------------------
Plug('antoinemadec/coc-fzf')

vim.g.coc_fzf_preview='right:50%'

-- +---------------------------------
-- | ALE - syntax checking
-- +---------------------------------
Plug('dense-analysis/ale')

vim.g.ale_sign_column_always = 1
vim.g.ale_linters_explicit = 1
vim.g.ale_linters = {
    php = {'php', 'phpstan'},
    python = {'flake8'}
}
--    \   'python': ['ruff']
vim.g.ale_echo_msg_format = '[%linter%][%severity%]%[code]% %s'
vim.g.ale_virtualtext_cursor = 0

-- +---------------------------------
-- | delimitMate - insert brackets
-- +---------------------------------
Plug('Raimondi/delimitMate')

vim.g.delimitMate_expand_cr = 1

-- +---------------------------------
-- | CamelCaseMotion - text objects for camel case
-- +---------------------------------
Plug('bkad/CamelCaseMotion')

-- +---------------------------------
-- | Spelunker.vim - better spellchecks
-- +---------------------------------
Plug('kamykn/spelunker.vim')

vim.g.spelunker_check_type = 2
vim.g.spelunker_spell_bad_group = 'SpellBad'
vim.g.spelunker_target_min_char_len = 3

-- +=================================
-- | LANGUAGE SPECIFIC
-- +---------------------------------
-- | GODOT
-- +---------------------------------
Plug('habamax/vim-godot')

-- +---------------------------------
-- | MARKDOWN extended support 
-- +---------------------------------
Plug('plasticboy/vim-markdown')

vim.g.vim_markdown_conceal = 0                  -- disable hiding MD syntax
vim.g.vim_markdown_conceal_code_blocks = 0      -- disable hiding code syntax
vim.g.vim_markdown_folding_disabled = 1         -- disable folding
vim.g.vim_markdown_no_default_key_mappings = 1  -- no key mapping
vim.g.vim_markdown_fenced_languages = {'yml=yaml', 'viml=vim', 'bash=sh', 'ini=dosini'}

-- +=================================
-- | OPENSCAD
-- +---------------------------------
-- | Syntax highlight
-- +---------------------------------
Plug('sirtaj/vim-openscad')

-- +=================================
-- | PYTHON
-- +---------------------------------
-- | better syntax highlighting for python
-- +---------------------------------
Plug('vim-python/python-syntax')

vim.g.python_highlight_all = 1

-- +---------------------------------
-- | PyDocString - doc-string generator 
-- +---------------------------------
Plug('heavenshell/vim-pydocstring', {['do'] = 'make install', ['for'] = 'python' })

vim.g.pydocstring_templates_path = vim.fn.stdpath('config') .. '/pydocstring'

-- +---------------------------------
-- | SKINS
-- +---------------------------------
Plug('morhetz/gruvbox')
Plug('luinnar/vim-neo-spider')

vim.call('plug#end')

-- +=================================
-- | VIM settings
-- +=================================
vim.api.nvim_exec('language en_US.UTF-8', true)

vim.opt.backspace = 'indent,eol,start'  -- backspace works like most other programs
vim.opt.clipboard = 'unnamedplus'       -- use OS clipboard instead of VIM one
vim.opt.encoding = 'utf-8'
vim.opt.backup = false

vim.opt.mouse = ''

vim.opt.conceallevel = 0    -- don't hide anything

vim.opt.spell = false       -- spelling check by spelunker
vim.opt.spelllang = 'en_us,en_gb,pl'
vim.opt.spelloptions = 'camel'  -- enable camel case spelling (nvim 0.5+)

vim.opt.hidden = true
vim.opt.updatetime = 250  -- frequency (in ms) of saving recovery files

vim.opt.colorcolumn = '120' -- show right margin
vim.opt.cursorline = true   -- highlight current line
vim.opt.number = true       -- show line numbers
vim.opt.signcolumn = 'yes'  -- always show sign column
vim.opt.showtabline = 2     -- always show tabline

vim.opt.wrap = false        -- disable code wrapping
vim.opt.whichwrap = '<,>,[,]'   -- move left/right arrows to prev/next line
vim.opt.scrolloff = 10      -- Set X lines to the cursor - when moving vertically
vim.opt.sidescrolloff = 10  -- Same horizontally (when :set nowrap)

vim.opt.expandtab = true    -- tabs: spaces instead of tabs
vim.opt.shiftwidth = 4      -- tabs: use 4 spaces instead tab
vim.opt.tabstop = 4         -- tabs: displayed tab size
vim.opt.smarttab = true     -- smarter tab placement

--filetype indent on
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.shiftround = true     -- indentation rounded to tab size

vim.opt.termguicolors = true
vim.opt.background = 'dark'

vim.cmd('colorscheme neospider')

-- +=================================
-- | Custom key bindings
-- +=================================

-- set leader to space
vim.g.mapleader = " "

vim.keymap.set('n', '<Home>', '^')
vim.keymap.set('i', '<Home>', '<C-o>^')
-- indentation with tab
vim.keymap.set('v', '<TAB>', '>gv')
vim.keymap.set('v', '<S-TAB>', '<gv')
-- paste in visual shortcut
vim.keymap.set('i', '<C-p>', '<C-r>+')

-- close buffer without changing layout
vim.keymap.set('n', 'bd', ':BD<CR>')

-- switch to buffer by its ordinal ID
vim.keymap.set('n', 'b1', ':call lightline#bufferline#go(1)<CR>', {silent = true})
vim.keymap.set('n', 'b2', ':call lightline#bufferline#go(2)<CR>', {silent = true})
vim.keymap.set('n', 'b3', ':call lightline#bufferline#go(3)<CR>', {silent = true})
vim.keymap.set('n', 'b4', ':call lightline#bufferline#go(4)<CR>', {silent = true})
vim.keymap.set('n', 'b5', ':call lightline#bufferline#go(5)<CR>', {silent = true})
vim.keymap.set('n', 'b6', ':call lightline#bufferline#go(6)<CR>', {silent = true})
vim.keymap.set('n', 'b7', ':call lightline#bufferline#go(7)<CR>', {silent = true})
vim.keymap.set('n', 'b8', ':call lightline#bufferline#go(8)<CR>', {silent = true})
vim.keymap.set('n', 'b9', ':call lightline#bufferline#go(9)<CR>', {silent = true})
vim.keymap.set('n', 'b0', ':call lightline#bufferline#go(10)<CR>', {silent = true})
-- jump to previous buffer
vim.keymap.set('n', 'bp', ':b#<CR>', {silent = true})

-- additional motions
-- - shift arrow in insert moves with CamelCase
vim.keymap.set('i', '<S-Left>', '<C-o><Plug>CamelCaseMotion_b', {silent = true})
vim.keymap.set('i', '<S-Right>', '<C-o><Plug>CamelCaseMotion_w', {silent = true})
-- - operations in camel word
vim.keymap.set('o', 'cw', '<Plug>CamelCaseMotion_w', {silent = true})
vim.keymap.set('x', 'cw', '<Plug>CamelCaseMotion_w', {silent = true})
vim.keymap.set('o', 'icw', '<Plug>CamelCaseMotion_iw', {silent = true})
vim.keymap.set('x', 'icw', '<Plug>CamelCaseMotion_iw', {silent = true})
vim.keymap.set('o', 'icb', '<Plug>CamelCaseMotion_ib', {silent = true})
vim.keymap.set('x', 'icb', '<Plug>CamelCaseMotion_ibu', {silent = true})

-- autocomplete menu fixes:
-- * escape closes menu
vim.keymap.set('i', '<Esc>', function()
    if vim.fn.pumvisible() == 1 then
        return '<C-e>'
    end
    return '<Esc>'
end, {expr = true})

-- CocNvim - use tab & enter to navigate
vim.keymap.set('i', '<TAB>', function()
    if vim.fn['coc#pum#visible']() == 1 then
        return vim.fn['coc#pum#next'](1)
    end
    return '<TAB>'
end, {expr = true, silent = true})

vim.keymap.set('i', '<CR>', function()
    if vim.fn['coc#pum#visible']() == 1 then
        return vim.fn['coc#pum#confirm']()
    end
    return '<CR>'
end, {expr = true, silent = true})

-- * start autocompletion on ctrl-space
vim.keymap.set('i', '<C-space>', function()
    return vim.fn['coc#refresh']()
end, {expr = true, silent = true})

-- code actions:
-- * display available actions
vim.keymap.set('n', '<leader>ca', '<Plug>(coc-codeaction-cursor)', {silent = true})
-- * display documentation
vim.keymap.set('n', '<leader>cd', ':call CocAction("doHover")<CR>', {silent = true})
-- * jump to definition
vim.keymap.set('n', '<leader>cj', '<Plug>(coc-definition)')
-- * refactor/move item
vim.keymap.set('n', '<leader>cm', '<Plug>(coc-refactor)')
-- * rename item
vim.keymap.set('n', '<leader>cr', '<Plug>(coc-rename)')
-- * show usage
vim.keymap.set('n', '<leader>cu', '<Plug>(coc-references)')
-- * PYTHON add docstring
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'python',
    callback = function()
        vim.keymap.set('n', '<leader>cc', ':Pydocstring<CR>')
    end
})

-- NERDTree actions
vim.keymap.set('n', '<leader>tc', ':NERDTreeFocus<CR>PX<C-w>w<leader>tf')
vim.keymap.set('n', '<leader>tf', ':NERDTreeFind<CR><C-w>w')
vim.keymap.set('n', '<leader>tr', ':NERDTreeRefreshRoot<CR>')
vim.keymap.set('n', '<leader>tt', ':NERDTreeFocus<CR>')

-- find operations
vim.keymap.set('n', '<leader><S-F>', '<Plug>(FerretAck)')
vim.keymap.set('n', '<C-F>', ':Files<CR>')


-- run all initializers
for i, init_fn in ipairs(init_functions) do
    init_fn()
end

-- +=================================
-- | External files
-- +=================================

-- intelephense key
vim.cmd('source ' .. vim.fn.stdpath('config') .. '/coc-intelephense-key.vim')
-- projects functions
vim.cmd('source ' .. vim.fn.stdpath('config') .. '/projects-functions.vim')
-- projects definitions
vim.cmd('source ' .. vim.fn.stdpath('config') .. '/projects.vim')
