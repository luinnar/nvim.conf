-- +=================================
-- | HELPERS
-- +=================================
local PluginConfig = require("plugins")

-- +=================================
-- | PLUGINS
-- +=================================
local plugin_config = PluginConfig.New()

:add("https://github.com/nvim-lua/plenary.nvim")    -- utilities functions for LUA projects
:add("https://github.com/lambdalisue/nerdfont.vim") -- additional icons in fonts
:add("https://github.com/itchyny/vim-gitbranch")    -- function to get current git branch

-- +---------------------------------
-- | indentLine - indentation lines
-- +---------------------------------
:add(
    "https://github.com/Yggdroot/indentLine",
    function ()
        vim.g.vim_json_conceal = 0 -- disable conceal for JSON files
    end
)

-- +---------------------------------
-- | Projects - project view
-- +---------------------------------
-- Plug 'amiorin/vim-project'
:add(
    "https://github.com/luinnar/vim-project",
    function ()
        vim.g.project_enable_welcome = 1
        vim.g.project_use_neotree = 1
    end
)

-- +---------------------------------
-- | Neo-tree - file browser
-- +---------------------------------
:add(
    "https://github.com/nvim-neo-tree/neo-tree.nvim",
    function ()
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
    end,
    nil,
    {
        "https://github.com/MunifTanjim/nui.nvim" -- UI library
    }
)

-- +---------------------------------
-- | telescope.nvim - search everywhere
-- +---------------------------------
:add(
    "https://github.com/nvim-telescope/telescope.nvim",
    function ()
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

        vim.keymap.set('n', '<leader>fb', builtin.buffers)
        vim.keymap.set('n', '<leader>ff', builtin.find_files)
        vim.keymap.set('n', '<leader>fg', builtin.live_grep)
    end
)
:add(
    "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
    function ()
        if pcall(require, 'fzf_lib') then
            require('telescope').load_extension('fzf')
        end
    end,
    function (event)
        vim.system({ 'make' }, { cwd = event.data.path }):wait()
    end
)

-- +---------------------------------
-- | LightLine - status & tab lines on steroids
-- +---------------------------------
:add(
    "https://github.com/itchyny/lightline.vim",
    function ()
        vim.g.lightline = {
            active = {
                left = {
                    { "mode",     "paste" },
                    { "readonly", "filename", "modified" },
                },
                right = {
                    { "lineinfo" },
                    { "percent" },
                    { "fileformat", "fileencoding", "filetype" },
                    { "gitbranch" }
                }
            },
            tabline = {
                left = {
                    { "buffers" }
                },
            },
            component_expand = {
                buffers = "lightline#bufferline#buffers"
            },
            component_function = {
                gitbranch = "gitbranch#name"
            },
            component_type = {
                buffers = "tabsel"
            },
            separator = { left = "\u{e0b8}", right = "\u{e0ba}" },
            subseparator = { left = "\u{e0b9}", right = "\u{e0bd}" }
        }

        vim.g["lightline#bufferline#enable_nerdfont"] = 1
        vim.g["lightline#bufferline#modified"] = " \u{f111}"
        vim.g["lightline#bufferline#show_number"] = 2
    end,
    nil,
    {
        "https://github.com/mengelbrecht/lightline-bufferline" -- buffer line support
    }
)
-- +---------------------------------
-- | BuffKill - handle buffers without changes in layout
-- +---------------------------------
:add("https://github.com/qpkorr/vim-bufkill")

-- +---------------------------------
-- | conform.nvim - code formatting
-- +---------------------------------
:add(
    "https://github.com/stevearc/conform.nvim",
    function()
        require("conform").setup({
            formatters_by_ft = {
                lua = {},
                python = { "isort", "ruff_format" },
                zig = { "zigfmt" },
            },
        })
    end
)

-- +---------------------------------
-- | nvim-lspconfig
-- +---------------------------------
:add("https://github.com/neovim/nvim-lspconfig")

-- +---------------------------------
-- | blink.cmp
-- +---------------------------------
:add(
    { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("v1") },
    function ()
        require("blink.cmp").setup({
            appearance = {
                nerd_font_variant = "mono",
            },
            completion = {
                documentation = { auto_show = true },
            },
            fuzzy = {
                implementation = "prefer_rust_with_warning",
            },
            signature = {
                enabled = true,
            },
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },
            keymap = {
                preset = "none",

                ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
                ["<C-e>"] = { "hide", "fallback" },
                ["<CR>"] = { "accept", "fallback" },

                ["<C-j>"] = { "snippet_forward", "fallback" },
                ["<C-k>"] = { "snippet_backward", "fallback" },

                ["<Tab>"] =   { "select_next", "fallback" },
                ["<S-Tab>"] = { "select_prev", "fallback" },
                ["<Down>"] =  { "select_next", "fallback" },
                ["<Up>"] =    { "select_prev", "fallback" },

                ["<C-b>"] = { "scroll_documentation_up", "fallback" },
                ["<C-f>"] = { "scroll_documentation_down", "fallback" },
            }
        })
    end,
    nil,
    {
        "https://github.com/rafamadriz/friendly-snippets" -- snippets
    }
)

-- +---------------------------------
-- | nvim-lint - lightweight linters
-- +---------------------------------
:add(
    "https://github.com/mfussenegger/nvim-lint",
    function ()
        require('lint').linters_by_ft = {
            php = { 'php', 'phpstan' },
            python = { 'flake8' }
        }

        vim.api.nvim_create_autocmd(
            {'BufWritePost', 'InsertLeave', 'TextChanged'},
            { callback = function() require('lint').try_lint() end }
        )
    end
)

-- +---------------------------------
-- | tiny-inline-diagnostic.nvim - nicer diagnostics
-- +---------------------------------
:add(
    "https://github.com/rachartier/tiny-inline-diagnostic.nvim",
    function()
        require("tiny-inline-diagnostic").setup({
            preset = "powerline",
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
    end
)

-- +---------------------------------
-- | delimitMate - insert brackets
-- +---------------------------------
:add(
    "https://github.com/Raimondi/delimitMate",
    function ()
        vim.g.delimitMate_expand_cr = 1
    end
)

-- +---------------------------------
-- | CamelCaseMotion - text objects for camel case
-- +---------------------------------
:add("https://github.com/bkad/CamelCaseMotion")

-- +---------------------------------
-- | Spelunker.vim - better spellchecks
-- +---------------------------------
:add(
    "https://github.com/kamykn/spelunker.vim",
    function ()
        vim.g.spelunker_check_type = 2
        vim.g.spelunker_spell_bad_group = "SpellBad"
        vim.g.spelunker_target_min_char_len = 3
    end
)

-- +=================================
-- | LANGUAGE SPECIFIC
-- +---------------------------------
-- | Elixir
-- +---------------------------------
:add("https://github.com/elixir-editors/vim-elixir")

-- +---------------------------------
-- | GLSL
-- +---------------------------------
:add("https://github.com/tikhomirov/vim-glsl")

-- +---------------------------------
-- | GODOT
-- +---------------------------------
:add("https://github.com/habamax/vim-godot")

-- +---------------------------------
-- | MARKDOWN extended support
-- +---------------------------------
:add(
    "https://github.com/plasticboy/vim-markdown",
    function ()
        vim.g.vim_markdown_conceal = 0                 -- disable hiding MD syntax
        vim.g.vim_markdown_conceal_code_blocks = 0     -- disable hiding code syntax
        vim.g.vim_markdown_folding_disabled = 1        -- disable folding
        vim.g.vim_markdown_no_default_key_mappings = 1 -- no key mapping
        vim.g.vim_markdown_fenced_languages = { "yml=yaml", "viml=vim", "bash=sh", "ini=dosini" }
    end
)

-- +=================================
-- | OPENSCAD
-- +---------------------------------
-- | Syntax highlight
-- +---------------------------------
:add("https://github.com/sirtaj/vim-openscad")

-- +=================================
-- | PYTHON
-- +---------------------------------
-- | better syntax highlighting for python
-- +---------------------------------
:add(
    "https://github.com/vim-python/python-syntax",
    function ()
        vim.g.python_highlight_all = 1
    end
)

-- +---------------------------------
-- | PyDocString - doc-string generator
-- +---------------------------------
:add(
    "https://github.com/heavenshell/vim-pydocstring",
    function ()
        vim.g.pydocstring_templates_path = vim.fn.stdpath("config") .. "/pydocstring"
    end,
    function (event)
        vim.system({ 'make install' }, { cwd = event.data.path }):wait()
    end
)

-- +=================================
-- | Zig
-- +---------------------------------
-- | syntax highlighting for Zig
-- +---------------------------------
:add(
    "https://github.com/ziglang/zig.vim",
    function ()
        vim.g.zig_fmt_parse_errors = 0
        vim.g.zig_fmt_autosave = 0
    end
)

-- +---------------------------------
-- | SKINS
-- +---------------------------------
:add("https://github.com/morhetz/gruvbox")
:add("https://github.com/luinnar/vim-neo-spider")

:apply()

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

-- code actions:
-- * display documentation
vim.keymap.set('n', '<leader>cd', function() vim.lsp.buf.hover() end, { silent = true })
-- * format current buffer
vim.keymap.set('n', '<leader>cf', function()
    if not require('conform').format() then
        vim.lsp.buf.format()
    end
end, { silent = true })
-- * jump to definition
vim.keymap.set('n', '<leader>cj', require('telescope.builtin').lsp_definitions)
-- * rename item
vim.keymap.set('n', '<leader>cr', '<cmd>lua vim.lsp.buf.rename()<CR>') -- function() vim.lsp.buf.rename() end)
-- * show usage
vim.keymap.set('n', '<leader>cu', require('telescope.builtin').lsp_references)

-- * PYTHON add docstring
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'python',
    callback = function()
        vim.keymap.set('n', '<leader>cc', ':Pydocstring<CR>')
    end
})

-- Neotree actions
vim.keymap.set('n', '<leader>tt', ':Neotree focus<CR>')

vim.lsp.enable({
    'glsl_analyzer',
    'lua_ls',
    'ty',
    'zls',
})

-- +=================================
-- | Auto commands
-- +=================================

-- remove tailing whitespaces in code
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
