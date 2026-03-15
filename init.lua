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

Plug('nvim-lua/plenary.nvim')    -- utilities functions for LUA projects
Plug('lambdalisue/nerdfont.vim') -- additional icons in fonts
Plug('itchyny/vim-gitbranch')    -- function to get current git branch

-- +---------------------------------
-- | indentLine - indentation lines
-- +---------------------------------
Plug('Yggdroot/indentLine')

vim.g.vim_json_conceal = 0 -- disable conceal for JSON files

-- +---------------------------------
-- | Projects - project view
-- +---------------------------------
-- Plug 'amiorin/vim-project'
Plug('luinnar/vim-project')

vim.g.project_enable_welcome = 1
vim.g.project_use_neotree = 1

-- +---------------------------------
-- | Neo-tree - file browser
-- +---------------------------------
Plug('MunifTanjim/nui.nvim')
Plug('nvim-neo-tree/neo-tree.nvim')

add_init(function()
    require('neo-tree').setup({
        enable_diagnostics = false,
        use_popups_for_input = false,
        default_component_configs = {
            name = {
                trailing_slash = true,
                use_git_status_colors = false,
            },
            git_status = {
                symbols = {
                    untracked = '',
                    ignored   = '󰄱',
                    unstaged  = '',
                    staged    = '',
                    conflict  = '󰈅',
                }
            }
        },
        window = {
            width = 45,
        },
        filesystem = {
            filtered_items = {
                visible = true,
                hide_dotfiles = false,
                hide_gitignored = false,
                never_show = {
                    '.git',
                    '__pycache__',
                },
                never_show_by_pattern = {
                    '*.pyc',
                },
            },
            follow_current_file = {
                enabled = true,
                leave_dirs_open = false,
            },
            use_libuv_file_watcher = true,
        },
    })
end)

-- +---------------------------------
-- | telescope.nvim - search everywhere
-- +---------------------------------
Plug('nvim-telescope/telescope.nvim', { tag = '*' })
Plug('nvim-telescope/telescope-fzf-native.nvim', { ['do'] = 'make' })

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
                    ['<esc>'] = actions.close
                }
            },
        },
        extensions = {
            fzf = {
                fuzzy = true,                   -- false will only do exact matching
                override_generic_sorter = true, -- override the generic sorter
                override_file_sorter = true,    -- override the file sorter
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
-- Plug('junegunn/fzf', { ['do'] = vim.fn['fzf#install'] })
-- Plug('junegunn/fzf.vim')
--
-- vim.env.FZF_DEFAULT_COMMAND = 'rg --files'
-- vim.env.FZF_DEFAULT_OPTS = '--ansi --layout reverse'

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
            { 'mode',     'paste' },
            { 'readonly', 'filename', 'modified' },
        },
        right = {
            { 'lineinfo' },
            { 'percent' },
            { 'fileformat', 'fileencoding', 'filetype' },
            { 'gitbranch' }
        }
    },
    tabline = {
        left = {
            { 'buffers' }
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
    separator = { left = "\u{e0b8}", right = "\u{e0ba}" },
    subseparator = { left = "\u{e0b9}", right = "\u{e0bd}" }
}

vim.g['lightline#bufferline#enable_nerdfont'] = 1
vim.g['lightline#bufferline#modified'] = ' \u{f111}'
vim.g['lightline#bufferline#show_number'] = 2

-- +---------------------------------
-- | BuffKill - handle buffers without changes in layout
-- +---------------------------------
Plug('qpkorr/vim-bufkill')

-- +---------------------------------
-- | conform.nvim - code formatting
-- +---------------------------------
Plug('stevearc/conform.nvim')

add_init(function()
    require('conform').setup({
        formatters_by_ft = {
            lua = {},
            python = { 'isort', 'ruff_format' },
            zig = { 'zigfmt' },
        },
    })
end)

-- +---------------------------------
-- | nvim-lspconfig
-- +---------------------------------
Plug('neovim/nvim-lspconfig')

-- +---------------------------------
-- | blink.cmp
-- +---------------------------------
Plug('saghen/blink.cmp', { ['tag'] = 'v1.*' })

add_init(function ()
    require('blink.cmp').setup({
        appearance = {
            nerd_font_variant = 'mono',
        },
        completion = {
            documentation = { auto_show = true },
        },
        fuzzy = {
            implementation = 'prefer_rust_with_warning',
        },
        signature = {
            enabled = true,
        },
        sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer' },
        },
        keymap = {
            preset = 'none',

            ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
            ['<C-e>'] = { 'hide', 'fallback' },
            ['<CR>'] = { 'accept', 'fallback' },

            ['<C-j>'] = { 'snippet_forward', 'fallback' },
            ['<C-k>'] = { 'snippet_backward', 'fallback' },

            ['<Tab>'] =   { 'select_next', 'fallback' },
            ['<S-Tab>'] = { 'select_prev', 'fallback' },
            ['<Down>'] =  { 'select_next', 'fallback' },
            ['<Up>'] =    { 'select_prev', 'fallback' },

            ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
            ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
        }
    })
end)

-- snippets
Plug('rafamadriz/friendly-snippets')

-- +---------------------------------
-- | nvim-lint - lightweight linters
-- +---------------------------------
Plug('mfussenegger/nvim-lint')

add_init(function ()
    require('lint').linters_by_ft = {
        php = { 'php', 'phpstan' },
        python = { 'flake8' }
    }

    vim.api.nvim_create_autocmd(
        {'BufWritePost', 'InsertLeave', 'TextChanged'},
        {
            callback = function() require('lint').try_lint() end,
        }
    )
end)

-- +---------------------------------
-- | tiny-inline-diagnostic.nvim - nicer diagnostics
-- +---------------------------------
Plug('rachartier/tiny-inline-diagnostic.nvim')

add_init(function()
    require('tiny-inline-diagnostic').setup({
        preset = 'powerline',
        options = {
            show_source = {
                enabled = true,
            },
            show_code = true,
            show_all_diags_on_cursorline = true,
            break_line = {
                enabled = true,
                after = 100,
            }
        }
    })

    vim.diagnostic.config({ virtual_text = false }) -- Disable Neovim's default virtual text diagnostics
end)

-- +---------------------------------
-- | CoC - autocompletion
-- +---------------------------------
-- Plug('neoclide/coc.nvim', { branch = 'release' })
--
-- vim.g.coc_global_extensions = {
--     'coc-css',
--     'coc-elixir',
--     'coc-json',
--     'coc-lua',
--     'coc-phpls',
--     -- 'coc-pyright',
--     'coc-basedpyright',
--     'coc-snippets'
-- }
--
-- -- Show signature help on placeholder jump
-- vim.api.nvim_create_autocmd('User', {
--     pattern = 'CocJumpPlaceholder',
--     command = "call CocActionAsync('showSignatureHelp')"
-- })
--
-- -- snippets
-- Plug('honza/vim-snippets')
-- Plug('sniphpets/sniphpets')
-- Plug('sniphpets/sniphpets-common')

-- +---------------------------------
-- | CoC FZF
-- +---------------------------------
-- Plug('antoinemadec/coc-fzf')
--
-- vim.g.coc_fzf_preview = 'right:50%'

-- +---------------------------------
-- | ALE - syntax checking
-- +---------------------------------
-- Plug('dense-analysis/ale')
--
-- vim.g.ale_disable_lsp = 1
-- vim.g.ale_sign_column_always = 1
-- vim.g.ale_linters_explicit = 1
-- vim.g.ale_linters = {
--     php = { 'php', 'phpstan' },
--     python = { 'flake8' }
-- }
-- vim.g.ale_echo_msg_format = '[%linter%][%severity%]%[code]% %s'
-- vim.g.ale_virtualtext_cursor = 0

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

-- +---------------------------------
-- | auto.session - save sessions
-- +---------------------------------
-- Plug('rmagatti/auto-session')
--
-- add_init(function()
--     require("auto-session").setup({
--         auto_restore = false,
--         cwd_change_handling = true,
--         pre_save_cmds = { 'Neotree close' },
--         --post_restore_cmds = { 'Neotree focus' },
--     })
-- end)
--
-- vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- +=================================
-- | LANGUAGE SPECIFIC
-- +---------------------------------
-- | Elixir
-- +---------------------------------
Plug('elixir-editors/vim-elixir')

-- +---------------------------------
-- | GLSL
-- +---------------------------------
Plug 'tikhomirov/vim-glsl'

-- +---------------------------------
-- | GODOT
-- +---------------------------------
Plug('habamax/vim-godot')

-- +---------------------------------
-- | MARKDOWN extended support
-- +---------------------------------
Plug('plasticboy/vim-markdown')

vim.g.vim_markdown_conceal = 0                 -- disable hiding MD syntax
vim.g.vim_markdown_conceal_code_blocks = 0     -- disable hiding code syntax
vim.g.vim_markdown_folding_disabled = 1        -- disable folding
vim.g.vim_markdown_no_default_key_mappings = 1 -- no key mapping
vim.g.vim_markdown_fenced_languages = { 'yml=yaml', 'viml=vim', 'bash=sh', 'ini=dosini' }

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
Plug('heavenshell/vim-pydocstring', { ['do'] = 'make install', ['for'] = 'python' })

vim.g.pydocstring_templates_path = vim.fn.stdpath('config') .. '/pydocstring'

-- +=================================
-- | Zig
-- +---------------------------------
-- | syntax highlighting for Zig
-- +---------------------------------
Plug('ziglang/zig.vim')

vim.g.zig_fmt_parse_errors = 0
vim.g.zig_fmt_autosave = 0

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

vim.opt.backspace = 'indent,eol,start' -- backspace works like most other programs
vim.opt.clipboard = 'unnamedplus'      -- use OS clipboard instead of VIM one
vim.opt.encoding = 'utf-8'
vim.opt.backup = false

vim.opt.mouse = ''

vim.opt.conceallevel = 0       -- don't hide anything

vim.opt.spell = false          -- spelling check by spelunker
vim.opt.spelllang = 'en_us,en_gb,pl'
vim.opt.spelloptions = 'camel' -- enable camel case spelling (nvim 0.5+)

vim.opt.hidden = true
vim.opt.updatetime = 250      -- frequency (in ms) of saving recovery files

vim.opt.colorcolumn = '120'   -- show right margin
vim.opt.cursorline = true     -- highlight current line
vim.opt.number = true         -- show line numbers
vim.opt.relativenumber = true -- show relative line number and current line number
vim.opt.signcolumn = 'yes'    -- always show sign column
vim.opt.showtabline = 2       -- always show tabline

vim.opt.wrap = false          -- disable code wrapping
vim.opt.whichwrap = '<,>,[,]' -- move left/right arrows to prev/next line
vim.opt.scrolloff = 10        -- Set X lines to the cursor - when moving vertically
vim.opt.sidescrolloff = 10    -- Same horizontally (when :set nowrap)

vim.opt.expandtab = true      -- tabs: spaces instead of tabs
vim.opt.shiftwidth = 4        -- tabs: use 4 spaces instead tab
vim.opt.tabstop = 4           -- tabs: displayed tab size
vim.opt.smarttab = true       -- smarter tab placement

--filetype indent on
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.shiftround = true -- indentation rounded to tab size

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
vim.keymap.set('n', '<leader>bd', ':BD<CR>')

-- switch to buffer by its ordinal ID
vim.keymap.set('n', '<leader>b1', ':call lightline#bufferline#go(1)<CR>', { silent = true })
vim.keymap.set('n', '<leader>b2', ':call lightline#bufferline#go(2)<CR>', { silent = true })
vim.keymap.set('n', '<leader>b3', ':call lightline#bufferline#go(3)<CR>', { silent = true })
vim.keymap.set('n', '<leader>b4', ':call lightline#bufferline#go(4)<CR>', { silent = true })
vim.keymap.set('n', '<leader>b5', ':call lightline#bufferline#go(5)<CR>', { silent = true })
vim.keymap.set('n', '<leader>b6', ':call lightline#bufferline#go(6)<CR>', { silent = true })
vim.keymap.set('n', '<leader>b7', ':call lightline#bufferline#go(7)<CR>', { silent = true })
vim.keymap.set('n', '<leader>b8', ':call lightline#bufferline#go(8)<CR>', { silent = true })
vim.keymap.set('n', '<leader>b9', ':call lightline#bufferline#go(9)<CR>', { silent = true })
vim.keymap.set('n', '<leader>b0', ':call lightline#bufferline#go(10)<CR>', { silent = true })
-- jump to previous buffer
vim.keymap.set('n', '<leader>bp', ':b#<CR>', { silent = true })

-- additional motions
-- - shift arrow in insert moves with CamelCase
vim.keymap.set('i', '<S-Left>', '<C-o><Plug>CamelCaseMotion_b', { silent = true })
vim.keymap.set('i', '<S-Right>', '<C-o><Plug>CamelCaseMotion_w', { silent = true })
-- - operations in camel word
vim.keymap.set('o', 'cw', '<Plug>CamelCaseMotion_w', { silent = true })
vim.keymap.set('x', 'cw', '<Plug>CamelCaseMotion_w', { silent = true })
vim.keymap.set('o', 'icw', '<Plug>CamelCaseMotion_iw', { silent = true })
vim.keymap.set('x', 'icw', '<Plug>CamelCaseMotion_iw', { silent = true })
vim.keymap.set('o', 'icb', '<Plug>CamelCaseMotion_ib', { silent = true })
vim.keymap.set('x', 'icb', '<Plug>CamelCaseMotion_ibu', { silent = true })

-- disable arrows
vim.keymap.set({'i', 'n', 'v'}, '<Up>', '<Nop>')
vim.keymap.set({'i', 'n', 'v'}, '<Down>', '<Nop>')
vim.keymap.set({'i', 'n', 'v'}, '<Left>', '<Nop>')
vim.keymap.set({'i', 'n', 'v'}, '<Right>', '<Nop>')

-- autocomplete menu fixes:
-- * escape closes menu
vim.keymap.set('i', '<Esc>', function()
    if vim.fn.pumvisible() == 1 then
        return '<C-e>'
    end
    return '<Esc>'
end, { expr = true })

-- CocNvim - use tab & enter to navigate
-- vim.keymap.set('i', '<TAB>', function()
--     if vim.fn['coc#pum#visible']() == 1 then
--         return vim.fn['coc#pum#next'](1)
--     end
--     return '<TAB>'
-- end, { expr = true, silent = true })
--
-- vim.keymap.set('i', '<CR>', function()
--     if vim.fn['coc#pum#visible']() == 1 then
--         return vim.fn['coc#pum#confirm']()
--     end
--     return '<CR>'
-- end, { expr = true, silent = true })

-- * start autocompletion on ctrl-space
-- vim.keymap.set('i', '<C-space>', function()
--     return vim.fn['coc#refresh']()
-- end, { expr = true, silent = true })

-- code actions:
-- * display available actions
vim.keymap.set('n', '<leader>ca', '<Plug>(coc-codeaction-cursor)', { silent = true })
-- * display documentation
vim.keymap.set('n', '<leader>cd', function() vim.lsp.buf.hover() end, { silent = true })
-- * format current buffer
vim.keymap.set('n', '<leader>cf', function()
    if not require('conform').format() then
        vim.lsp.buf.format()
    end
end, { silent = true })
-- * jump to definition
vim.keymap.set('n', '<leader>cj', function() vim.lsp.buf.definition() end)
-- * refactor/move item
--vim.keymap.set('n', '<leader>cm', '<Plug>(coc-refactor)')
-- * rename item
vim.keymap.set('n', '<leader>cr', '<cmd>lua vim.lsp.buf.rename()<CR>') -- function() vim.lsp.buf.rename() end)
-- * show usage
vim.keymap.set('n', '<leader>cu', ':Telescope lsp_references<CR>')

-- * PYTHON add docstring
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'python',
    callback = function()
        vim.keymap.set('n', '<leader>cc', ':Pydocstring<CR>')
    end
})

-- Neotree actions
vim.keymap.set('n', '<leader>tt', ':Neotree focus<CR>')

-- find operations
vim.keymap.set('n', '<leader><S-F>', '<Plug>(FerretAck)')


-- run all initializers
for i, init_fn in ipairs(init_functions) do
    init_fn()
end

vim.lsp.enable({
    -- 'basedpyright',
    'glsl_analyzer',
    'lua_ls',
    'ty',
})

-- +=================================
-- | Auto commands
-- +=================================

-- remove tailing whitespaces in PHP & python files
vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = { '*.lua', '*.php', '*.py' },
    callback = function()
        local view = vim.fn.winsaveview()
        vim.cmd('keeppatterns %s/\\s\\+$//e')
        vim.fn.winrestview(view)
    end
})

-- +=================================
-- | External files
-- +=================================

-- intelephense key
--vim.cmd('source ' .. vim.fn.stdpath('config') .. '/coc-intelephense-key.vim')
-- projects functions
vim.cmd('source ' .. vim.fn.stdpath('config') .. '/projects-functions.vim')
-- projects definitions
vim.cmd('source ' .. vim.fn.stdpath('config') .. '/projects.vim')



-- Nvim lag fix
vim.cmd('hi! link CurSearch Search')
