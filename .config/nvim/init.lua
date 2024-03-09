-- [[
-- Voxel's Neovim Configuration
--
-- To define custom keybinds, search for "Custom Keybinds" in this file.
--]]

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
--
-- todo( asd

function split(pString, pPattern)
    local Table = {} -- NOTE: use {n = 0} in Lua-5.0
    local fpat = "(.-)" .. pPattern
    local last_end = 1
    local s, e, cap = pString:find(fpat, 1)
    while s do
        if s ~= 1 or cap ~= "" then
            table.insert(Table, cap)
        end
        last_end = e + 1
        s, e, cap = pString:find(fpat, last_end)
    end
    if last_end <= #pString then
        cap = pString:sub(last_end)
        table.insert(Table, cap)
    end
    return Table
end

vim.g.mapleader = " "
vim.g.maplocalleader = " "
local setopt = vim.opt

-- Cast a magic spell to add relative line numbers to Netrw
vim.cmd([[let g:netrw_bufsettings="noma nomod nu nobl nowrap ro rnu"]])

vim.api.nvim_create_autocmd({ "VimEnter" }, {
    command = "highlight Normal guibg=NONE ctermbg=NONE"
})
vim.api.nvim_create_autocmd({ "VimEnter" }, {
    command = "highlight SignColumn guibg=NONE ctermbg=NONE"
})
-- Do the above green and below red!!
vim.api.nvim_create_autocmd({ "VimEnter" }, {
    -- command = "highlight LineNr guifg=#CCCCCC ctermfg=#FFFFFF"
    command = "highlight LineNr guifg=#CCCCCC"
})

vim.api.nvim_create_autocmd({ "VimLeave" }, {
    command = "silent !wezterm cli set-tab-title $(basename \"$PWD\")"
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
    pattern = "*.*",
    callback = function()
        local split = {}
        for segment in string.gmatch(vim.api.nvim_buf_get_name(0), "[^/]+") do
            table.insert(split, segment)
        end

        local last = "/" .. split[#split - 1] .. "/" .. split[#split]

        vim.cmd("silent !wezterm cli set-tab-title " .. last)
    end
})

-- Tab settings?
setopt.tabstop = 4
setopt.softtabstop = 4
setopt.shiftwidth = 4

-- Editor relative line numbers
vim.wo.number = true
vim.wo.relativenumber = true

-- Add line-moving to Ctrl-J and Ctrl-K
vim.keymap.set("n", "<C-j>", ":m- <CR>==", { desc = "Move line down 1" })
vim.keymap.set("n", "<C-k>", ":m+ <CR>==", { desc = "Move line up 1" })
vim.keymap.set("v", "<A-j>", ":m '>-1<CR>gv=gv", { desc = "Move line(s) down 1" })
vim.keymap.set("v", "<A-k>", ":m '>+1<CR>gv=gv", { desc = "Move line(s) up 1" })

-- Toggle Trouble
vim.keymap.set("n", "<C-p>", ":TroubleToggle<CR>", { desc = "Toggle Trouble" })
vim.keymap.set("i", "<S-BS>", "<C-w>", { desc = "Delete previous word" })

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    pattern = { "*" },
    callback = function()
        vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
        -- if vim.fn.exists(":Rex") > 0 then
        --     -- Open netrw in pane
        --     vim.keymap.set("n", "<leader>fs", vim.cmd.Rex, { desc = "Open File System (netrw)" })
        --     vim.keymap.set("n", "-", vim.cmd.Rex, { desc = "Open file system (netrw)" })
        -- else
        --     vim.keymap.set("n", "<leader>fs", vim.cmd.Ex, { desc = "Open File System (netrw)" })
        --     vim.keymap.set("n", "-", vim.cmd.Ex, { desc = "Open file system (netrw)" })
        -- end
    end,
})

vim.keymap.set("n", "q:", ":q<CR>")

vim.api.nvim_create_user_command("CenterOn", function() vim.cmd([[:setlocal scrolloff=999]]) end,
    { desc = "Enable cursor center on screen" })
vim.api.nvim_create_user_command("CenterOff", function() vim.cmd([[:setlocal scrolloff=-1]]) end,
    { desc = "Disable cursor center on screen" })
-- Other Misc Keymaps

-- [[ Install `lazy.nvim` plugin manager ]]
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure plugins ]]
require("lazy").setup({
    "virchau13/tree-sitter-astro",
    {
        "alvan/vim-closetag",
        config = function()
            vim.cmd("let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.astro'")
        end,
    },
    -- {
    --     'wuelnerdotexe/vim-astro',
    --     config = function()
    --         -- vim.cmd([[let g:astro_typescript = 'enable']])
    --         -- vim.cmd([[let g:astro_stylus = 'enable']])
    --     end
    -- },

    {
        'stevearc/oil.nvim',
        opts = {},
        -- Optional dependencies
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },

    -- Git related plugins
    "tpope/vim-fugitive",
    "tpope/vim-rhubarb",
    -- {
    "tpope/vim-commentary",
    "tpope/vim-surround",
    --     config = function()
    --     end,
    -- },

    -- Detect tabstop and shiftwidth automatically
    -- 'tpope/vim-sleuth',
    -- {
    --     'yardnsm/vim-import-cost',
    --     build = "pnpm install",
    -- },
    {
        "barrett-ruth/import-cost.nvim",
        build = "sh install.sh npm",
        -- if on windows
        -- build = 'pwsh install.ps1 yarn',
        config = true,
    },

    -- 'sheerun/vim-polyglot',
    "prettier/vim-prettier",
    "chrisbra/Colorizer",
    {
        "github/copilot.vim",
        config = function()
            vim.keymap.set("i", "<C-G>", 'copilot#Accept("<CR>")', {
                expr = true,
                replace_keycodes = false,
            })
            vim.g.copilot_no_tab_map = true
        end,
    },
    -- NOTE: This is where your plugins related to LSP can be installed.
    --  The configuration is done below. Search for lspconfig to find it below.
    {
        -- LSP Configuration & Plugins
        "neovim/nvim-lspconfig",
        config = function()
            local util = require 'lspconfig.util'
            local function get_typescript_server_path(root_dir)
                local project_root = util.find_node_modules_ancestor(root_dir)
                return project_root and (util.path.join(project_root, 'node_modules', 'typescript', 'lib')) or
                    ''
            end
            require("lspconfig").rust_analyzer.setup({})
            require("lspconfig").pyright.setup({})
            require("lspconfig").astro.setup({})

            require("lspconfig").grammarly.setup {
                -- on_attach = on_attach,
                filetypes = { "txt" },
                init_options = { clientId = "client_BaDkMgx4X19X9UxxYRCXZo" }
            }
        end,
        dependencies = {
            -- Automatically install LSPs to stdpath for neovim
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",

            -- Useful status updates for LSP
            -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
            { "j-hui/fidget.nvim", tag = "legacy", opts = {} },

            -- Additional lua configuration, makes nvim stuff amazing!
            "folke/neodev.nvim",
        },
    },

    {
        -- Autocompletion
        "hrsh7th/nvim-cmp",
        config = function()
            vim.o.completeopt = "menuone,noselect,preview"

            local cmp = require("cmp")
            cmp.setup({
                mapping = cmp.mapping.preset.insert({
                    ["<Tab>"] = cmp.mapping.confirm({ select = true }),
                }),
            })
        end,
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            -- Adds LSP completion capabilities
            "hrsh7th/cmp-nvim-lsp",
            -- Adds a number of user-friendly snippets
            "rafamadriz/friendly-snippets",
        },
    },

    -- Hover Tooltip Plugin
    {
        "lewis6991/hover.nvim",
        config = function()
            require("hover").setup({
                init = function()
                    -- Require providers
                    require("hover.providers.lsp")
                    -- require('hover.providers.gh') require('hover.providers.gh_user') require('hover.providers.jira') require('hover.providers.man') require('hover.providers.dictionary')
                end,
                preview_opts = {
                    border = "single",
                },
                -- Whether the contents of a currently open hover window should be moved to a :h preview-window when pressing the hover keymap.
                preview_window = false,
                title = true,
                mouse_providers = {
                    "LSP",
                },
                mouse_delay = 1000,
            })
            -- vim.keymap.del("n", "H")
            -- Setup keymaps
            vim.keymap.set("n", "H", require("hover").hover, { desc = "hover.nvim" })
            vim.keymap.set("n", "gH", require("hover").hover_select, { desc = "hover.nvim (select)" })

            -- Mouse support
            -- vim.keymap.set('n', '<MouseMove>', require('hover').hover_mouse, { desc = "hover.nvim (mouse)" })
            -- vim.o.mousemoveevent = true
        end,
    },

    -- Autoclose Plugin
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {},
        dependencies = {
            "hrsh7th/nvim-cmp",
        },
    },

    -- {
    --     'kaarmu/typst.vim',
    --     ft = 'typst',
    --     lazy = false,
    -- },
    'NoahTheDuke/vim-just',
    {
        "stevearc/conform.nvim",
        opts = {
            format_on_save = {
                -- These options will be passed to conform.format()
                timeout_ms = 500,
                lsp_fallback = true,
            },
            formatters_by_ft = {
                lua = { "stylua" },
                typst = { "typstfmt" },
                -- Conform will run multiple formatters sequentially
                python = { "isort", "black" },
                -- Use a sub-list to run only the first available formatter
                javascript = { { "prettierd", "prettier" } },
                astro = { "prettier" },
                typescript = { "prettier" },
            },
        },
        -- config = function()
        --     require("conform").setup({
        --     })
        -- end,
    },
    {
        "chomosuke/typst-preview.nvim",
        lazy = true,
        ft = "typst",
        opts = {
            get_root = function(bufnr)
                return vim.api.nvim_buf_get_name(bufnr):match("(.*/)")
            end,
        },
        build = function()
            require("typst-preview").update()
        end,
    },
    -- Use this when IT WORKS
    -- {
    --     'chomosuke/typst-preview.nvim',
    --     ft = 'typst',
    --     lazy = false,
    --     version = '0.1.*',
    --     build = function()
    --         require 'typst-preview'.update()
    --     end,
    -- },

    -- Useful plugin to show you pending keybinds.
    -- FOLKE
    { "folke/which-key.nvim",  opts = {} },
    {
        "folke/zen-mode.nvim",
        opts = {
            window = {
                width = .60
            },
            plugins = {
                gitsigns = { enabled = true },
                wezterm = {
                    enable = true,
                    font = "+2"
                }
            }
        }
    },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        -- opts = {
        --     --
        --     -- your configuration comes here
        --     -- or leave it empty to use the default settings
        --     -- refer to the configuration section below
        -- },
        config = function()
            vim.keymap.set("n", "<leader>lp", "<cmd>Trouble workspace_diagnostics<cr>", { desc = "[L]ist [P]roblems" })
        end,
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "folke/trouble.nvim" },
        config = function()
            require("todo-comments").setup({
                keywords = {
                    FIX = {
                        icon = " ", -- icon used for the sign, and in search results
                        color = "error", -- can be a hex color, or a named color (see below)
                        alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
                        -- signs = false, -- configure signs for some keywords individually
                    },
                    TODO = { icon = " ", color = "info", alt = { "todo", "!todo" } },
                    HACK = { icon = " ", color = "warning" },
                    WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
                    PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
                    NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
                    TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
                },
                search = {
                    -- todo asd
                    pattern = [[\b(KEYWORDS)]]
                }
            })

            vim.keymap.set("n", "]t", function()
                require("todo-comments").jump_next()
            end, { desc = "Next todo comment" })

            vim.keymap.set("n", "[t", function()
                require("todo-comments").jump_prev()
            end, { desc = "Previous todo comment" })

            vim.keymap.set("n", "<leader>lt", "<cmd>TodoTrouble<cr>", { desc = "[L]ook at [t]odos" })
            vim.keymap.set("n", "<leader>lT", "<cmd>TodoTelescope<cr>", { desc = "[L]ook at todos using [T]elescope" })
        end,
    },
    {
        "theprimeagen/harpoon",
        config = function()
            local mark = require("harpoon.mark")
            local ui = require("harpoon.ui")
            vim.keymap.set("n", "<leader>fa", mark.add_file, { desc = "Add [A] file to Harpoon" })
            vim.keymap.set("n", "<C-a>", mark.add_file, { desc = "Add [A] file to Harpoon" })
            vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu, { desc = "Toggle Harpoon [E]xplorer" })
            vim.keymap.set("n", "<leader>fl", ui.toggle_quick_menu, { desc = "Toggle Harpoon [L]ist" })

            vim.keymap.set("n", "<C-1>", function()
                ui.nav_file(1)
            end, { desc = "Open First Harpooned File" })
            vim.keymap.set("n", "<C-2>", function()
                ui.nav_file(2)
            end, { desc = "Open Second Harpooned File" })
            vim.keymap.set("n", "<C-3>", function()
                ui.nav_file(3)
            end, { desc = "Open Third Harpooned File" })
            vim.keymap.set("n", "<C-4>", function()
                ui.nav_file(4)
            end, { desc = "Open Fourth Harpooned File" })

            -- vim.keymap.set("n", "<C-a>", function() ui.nav_file(1) end, { desc = "Open First Harpooned File" })
            -- vim.keymap.set("n", "<C-d>", function() ui.nav_file(3) end, { desc = "Open Third Harpooned File" })
            -- vim.keymap.set("n", "<C-f>", function() ui.nav_file(4) end, { desc = "Open Fourth Harpooned File" })
            vim.keymap.set("n", "<leader>o1", function()
                ui.nav_file(1)
            end, { desc = "Open First Harpooned File" })
            vim.keymap.set("n", "<leader>o2", function()
                ui.nav_file(2)
            end, { desc = "Open Second Harpooned File" })
            vim.keymap.set("n", "<leader>o3", function()
                ui.nav_file(3)
            end, { desc = "Open Third Harpooned File" })
            vim.keymap.set("n", "<leader>o4", function()
                ui.nav_file(4)
            end, { desc = "Open Fourth Harpooned File" })
        end,
    },
    {
        -- Adds git related signs to the gutter, as well as utilities for managing changes
        "lewis6991/gitsigns.nvim",
        opts = {
            -- See `:help gitsigns.txt`
            signs = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "^" },
                changedelete = { text = "~" },
            },
            on_attach = function(bufnr)
                vim.keymap.set(
                    "n",
                    "<leader>hp",
                    require("gitsigns").preview_hunk,
                    { buffer = bufnr, desc = "Preview git hunk" }
                )

                -- don't override the built-in and fugitive keymaps
                local gs = package.loaded.gitsigns
                vim.keymap.set({ "n", "v" }, "]c", function()
                    if vim.wo.diff then
                        return "]c"
                    end
                    vim.schedule(function()
                        gs.next_hunk()
                    end)
                    return "<Ignore>"
                end, { expr = true, buffer = bufnr, desc = "Jump to next hunk" })
                vim.keymap.set({ "n", "v" }, "[c", function()
                    if vim.wo.diff then
                        return "[c"
                    end
                    vim.schedule(function()
                        gs.prev_hunk()
                    end)
                    return "<Ignore>"
                end, { expr = true, buffer = bufnr, desc = "Jump to previous hunk" })
            end,
        },
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000
    },
    {
        "rebelot/kanagawa.nvim",
        name = "kanagawa",
        priority = 1000
    },
    {
        'kepano/flexoki-neovim',
        name = 'flexoki',
        priority = 1001
    },
    {
        -- Theme inspired by Atom
        "folke/tokyonight.nvim",
        priority = 1000,
        config = function()
            -- vim.cmd.colorscheme 'tokyonight-moon'
            vim.cmd([[:colorscheme tokyonight-moon]])
        end,
    },
    "yorickpeterse/vim-paper",
    "navarasu/onedark.nvim",
    {
        -- Set lualine as statusline
        "nvim-lualine/lualine.nvim",
        -- See `:help lualine.txt`
        opts = {
            options = {
                icons_enabled = false,
                theme = "tokyonight",
                component_separators = "|",
                section_separators = "",
            },
        },
    },

    {
        -- Add indentation guides even on blank lines
        "lukas-reineke/indent-blankline.nvim",
        -- Enable `lukas-reineke/indent-blankline.nvim`
        -- See `:help ibl`
        main = "ibl",
        opts = {},
    },

    -- "gc" to comment visual regions/lines
    { "numToStr/Comment.nvim", opts = {} },

    -- Fuzzy Finder (files, lsp, etc)
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            -- Fuzzy Finder Algorithm which requires local dependencies to be built.
            -- Only load if `make` is available. Make sure you have the system
            -- requirements installed.
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                -- NOTE: If you are having trouble with this installation,
                --       refer to the README for telescope-fzf-native for more instructions.
                build = "make",
                cond = function()
                    return vim.fn.executable("make") == 1
                end,
            },
        },
    },

    {
        -- Highlight, edit, and navigate code
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        build = ":TSUpdate",
    },

    --  {
    --      'windwp/nvim-ts-autotag',
    --      config = {
    --          require('nvim-ts-autotag').setup()
    --      },
    --  },

    -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
    --       These are some example plugins that I've included in the kickstart repository.
    --       Uncomment any of the lines below to enable them.
    -- require 'kickstart.plugins.autoformat',
    -- require 'kickstart.plugins.debug',

    -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
    --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
    --    up-to-date with whatever is in the kickstart repo.
    --    Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
    --
    --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
    -- { import = 'custom.plugins' },
}, {})

require 'custom.lualine-custom'

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp = require("cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

require("nvim-treesitter.configs").setup({
    autotag = {
        enable = true,
    },
})

-- Configure oil.nvim
require("oil").setup({
    skip_confirm_for_simple_edits = false,
    view_options = {
        -- Show files and directories that start with "."
        show_hidden = true,
        -- This function defines what is considered a "hidden" file
        is_hidden_file = function(name, bufnr)
            return vim.startswith(name, ".") or vim.startswith(name, 'node_modules')
        end,
    },
})
require("nvim-web-devicons").setup {
    strict = true,
    override_by_extension = {
        ["astro"] = {
            icon = "",
            color = "#f1502f",
            name = "Astro",
        },
    },
}

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.relativenumber = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = "unnamedplus"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- [[ Basic Keymaps ]]
-- CUSTOM KEYMAPS
-- CUSTOM COMMANDS TOO
vim.keymap.set("n", "<leader>/", "<cmd>Commentary<CR>", { desc = "[/] comment out current line" })
vim.keymap.set("v", "<leader>/", ":Commentary<CR>", { desc = "[/] Comment Out Current Selection" })
vim.keymap.set("n", "<C-/>", "<cmd>Commentary<CR>", { desc = "[/] comment out current line" })
vim.keymap.set("v", "<C-/>", ":Commentary<CR>", { desc = "[/] Comment Out Current Selection" })

local paper_is_active = false
vim.api.nvim_create_user_command("TogglePaper", function(_)
    paper_is_active = not paper_is_active
    if paper_is_active then
        vim.cmd([[colorscheme paper]])
    else
        vim.cmd([[colorscheme tokyonight-night]])
    end
end, {})

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = "*",
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require("telescope").setup({
    defaults = {
        mappings = {
            i = {
                ["<C-u>"] = false,
                ["<C-d>"] = false,
            },
        },
    },
})

-- Enable telescope fzf native, if installed
pcall(require("telescope").load_extension, "fzf")

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
    -- Use the current buffer's path as the starting point for the git search
    local current_file = vim.api.nvim_buf_get_name(0)
    local current_dir
    local cwd = vim.fn.getcwd()
    -- If the buffer is not associated with a file, return nil
    if current_file == "" then
        current_dir = cwd
    else
        -- Extract the directory from the current file's path
        current_dir = vim.fn.fnamemodify(current_file, ":h")
    end

    -- Find the Git root directory from the current file's path
    local git_root = vim.fn.systemlist("git -C " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")[1]
    if vim.v.shell_error ~= 0 then
        print("Not a git repository. Searching on current working directory")
        return cwd
    end
    return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
    local git_root = find_git_root()
    if git_root then
        require("telescope.builtin").live_grep({
            search_dirs = { git_root },
        })
    end
end

vim.api.nvim_create_user_command("LiveGrepGitRoot", live_grep_git_root, {})

-- Custom Keymaps
-- See `:help telescope.builtin`
vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>\\", function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = false,
    }))
end, { desc = "[\\] Fuzzily search in current buffer" })

local bind = vim.keymap.set
bind("n", "<leader>gf", require("telescope.builtin").git_files, { desc = "Search [G]it [F]iles" })
bind("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
bind("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
bind("n", "<leader>sw", require("telescope.builtin").grep_string, { desc = "[S]earch current [W]ord" })
bind("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
bind("n", "<leader>sG", ":LiveGrepGitRoot<cr>", { desc = "[S]earch by [G]rep on Git Root" })
bind("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })
bind("n", "<leader>sr", require("telescope.builtin").resume, { desc = "[S]earch [R]esume" })

bind("n", "<leader>v", '"+p', { desc = "Paste from clipboard" })

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
bind({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
bind("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
bind("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
bind("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
bind("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
bind("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
bind("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
    require("nvim-treesitter.configs").setup({
        -- Add languages to be installed here that you want installed for treesitter
        ensure_installed = {
            "c",
            "cpp",
            "go",
            "lua",
            "python",
            "rust",
            "tsx",
            "javascript",
            "typescript",
            "vimdoc",
            "vim",
            "bash",
            "markdown"
        },

        -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
        auto_install = true,

        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<c-space>",
                node_incremental = "<c-space>",
                scope_incremental = "<c-s>",
                node_decremental = "<M-space>",
            },
        },
        textobjects = {
            select = {
                enable = true,
                lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                keymaps = {
                    -- You can use the capture groups defined in textobjects.scm
                    ["aa"] = "@parameter.outer",
                    ["ia"] = "@parameter.inner",
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    ["ic"] = "@class.inner",
                },
            },
            move = {
                enable = true,
                set_jumps = true, -- whether to set jumps in the jumplist
                goto_next_start = {
                    ["]m"] = "@function.outer",
                    ["]]"] = "@class.outer",
                },
                goto_next_end = {
                    ["]M"] = "@function.outer",
                    ["]["] = "@class.outer",
                },
                goto_previous_start = {
                    ["[m"] = "@function.outer",
                    ["[["] = "@class.outer",
                },
                goto_previous_end = {
                    ["[M"] = "@function.outer",
                    ["[]"] = "@class.outer",
                },
            },
            swap = {
                enable = true,
                swap_next = {
                    ["<leader>a"] = "@parameter.inner",
                },
                swap_previous = {
                    ["<leader>A"] = "@parameter.inner",
                },
            },
        },
    })
end, 0)

-- NOTE: DEFINE NEW FILETYPES
-- extension = "lang"
-- e.g. js = "javascript"

vim.filetype.add({
    extension = {
        typ = "typst",
    },
})
vim.treesitter.language.register("markdown", "mdx")
vim.filetype.add({
    extension = {
        mdx = "mdx",
    },
})


-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
    -- NOTE: Remember that lua is a real programming language, and as such it is possible
    -- to define small helper and utility functions so you don't have to repeat yourself
    -- many times.
    --
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local nmap = function(keys, func, desc)
        if desc then
            desc = "LSP: " .. desc
        end

        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
    end

    nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

    nmap("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
    nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
    nmap("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
    nmap("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
    nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
    nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

    -- See `:help K` for why this keymap
    nmap("K", vim.lsp.buf.hover, "Hover Documentation")
    nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

    -- Lesser used LSP functionality
    nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
    nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
    nmap("<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "[W]orkspace [L]ist Folders")

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
        vim.lsp.buf.format()
    end, { desc = "Format current buffer with LSP" })
end

-- document existing key chains
require("which-key").register({
    ["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
    ["<leader>d"] = { name = "[D]ocument", _ = "which_key_ignore" },
    ["<leader>g"] = { name = "[G]it", _ = "which_key_ignore" },
    -- ['<leader>h'] = { name = 'More git', _ = 'which_key_ignore' },
    ["<leader>r"] = { name = "[R]ename", _ = "which_key_ignore" },
    ["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
    ["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
    ["<leader>f"] = { name = "[F]ile Management", _ = "which_key_ignore" },
    ["<leader>o"] = { name = "[O]pen", _ = "which_key_ignore" },
    ["<leader>l"] = { name = "[L]ook", _ = "which_key_ignore" },
})

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require("mason").setup()
require("mason-lspconfig").setup()

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
    -- clangd = {},
    -- gopls = {},
    -- pyright = {},
    -- rust_analyzer = {},
    -- tsserver = {},
    -- html = { filetypes = { 'html', 'twig', 'hbs'} },
    -- mdx_analyzer = { filetypes = { 'mdx', 'markdown' } },

    lua_ls = {
        Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
        },
    },
}

-- Setup neovim lua configuration
require("neodev").setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
    ensure_installed = vim.tbl_keys(servers),
})

mason_lspconfig.setup_handlers({
    function(server_name)
        require("lspconfig")[server_name].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name],
            filetypes = (servers[server_name] or {}).filetypes,
        })
    end,
})

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require("cmp")
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()
luasnip.config.setup({})

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        -- ['<CR>'] = cmp.mapping.complete {},
        ["<Tab>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        }),
        ["<C-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    }),
    sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
    },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=4 sts=4 sw=4 et
