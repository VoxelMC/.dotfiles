-- [[
-- Voxel's Neovim Configuration
--
-- To define custom keybinds, search for "Custom Keybinds" in this file.
-- ]]
-- print('Welcome! :)')

--  NOTE: This must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "
local setopt = vim.opt

-- Default Cursor Options (see :h guicursor):
-- vim.o.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"
vim.opt.guicursor = "n-v-c-sm-i-ci-ve:block,r-cr-o:hor20"

-- Cast a magic spell to add relative line numbers to Netrw, not that it matters anymore...
vim.cmd([[let g:netrw_bufsettings="noma nomod nu nobl nowrap ro rnu"]])
vim.o.foldmethod = 'indent'
vim.o.foldlevel = 99
vim.o.foldenable = true
-- vim.o.foldcolumn = '1'
vim.diagnostic.config({ virtual_text = false })

local transparent = false;

vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", {
    underdouble = true
})

if transparent then
    vim.api.nvim_create_autocmd({ "VimEnter" }, {
        command = "highlight Normal guibg=NONE ctermbg=NONE"
    })
    vim.api.nvim_create_autocmd({ "VimEnter" }, {
        command = "highlight SignColumn guibg=NONE ctermbg=NONE"
    })
    -- Do the above green and below red!!
    -- vim.api.nvim_create_autocmd({ "VimEnter" }, {
    --     -- command = "highlight LineNr guifg=#CCCCCC ctermfg=#FFFFFF"
    --     -- command = "highlight LineNr guifg=#CCCCCC"
    -- })
end


vim.api.nvim_create_autocmd({ "VimLeave" }, {
    command = "silent !wezterm cli set-tab-title $(basename \"$PWD\")"
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
    pattern = "*.mdx",
    callback = function()
        vim.cmd("set filetype=mdx")
        vim.cmd("setlocal commentstring={/*\\ %s\\ */}")
    end
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

-- Add line-moving to Shift-J and Shift-K during VISUAL mode
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line down 1" })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line up 1" })

-- Previous attempts: kept here for old times sake ;)
-- vim.keymap.set("n", "<C-K>", ":m+ <CR>==", { desc = "Move line up 1" })
-- vim.keymap.set("n", "<C-J>", ":m- <CR>==", { desc = "Move line down 1" })
-- vim.keymap.set("v", "<A-j>", ":m '>-1<CR>gv=gv", { desc = "Move line(s) down 1" })
-- vim.keymap.set("v", "<A-k>", ":m '>+1<CR>gv=gv", { desc = "Move line(s) up 1" })

-- Toggle Trouble
vim.keymap.set("n", "<C-p>", ":TroubleToggle<CR>", { desc = "Toggle Trouble" })

-- Custom backspace bind to delete whole words.
vim.keymap.set("i", "<S-BS>", "<C-w>", { desc = "Delete previous word" })

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

local center_disabled = false
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    pattern = { "*" },
    callback = function()
        -- vim.keymap.set("n", "-", "<CMD>File<CR>", { desc = "Open parent directory" })
        -- I want everyone to know that I did this because i don't know how to do inequality in Lua.
        local is_dashboard = vim.bo.filetype == ""
        local is_noice = vim.bo.filetype == "noice"
        local is_oil = vim.bo.filetype == "oil"
        local go = not center_disabled and not is_dashboard and not is_noice and not is_oil
        if go then
            vim.cmd [[:CenterOn]]
        end
    end,
})

-- No longer needed, but will keep in case I go back to Netrw from Oil (AS IF, LOL)
-- if vim.fn.exists(":Rex") > 0 then
--     -- Open netrw in pane
--     vim.keymap.set("n", "<leader>fs", vim.cmd.Rex, { desc = "Open File System (netrw)" })
--     vim.keymap.set("n", "-", vim.cmd.Rex, { desc = "Open file system (netrw)" })
-- else
--     vim.keymap.set("n", "<leader>fs", vim.cmd.Ex, { desc = "Open File System (netrw)" })
--     vim.keymap.set("n", "-", vim.cmd.Ex, { desc = "Open file system (netrw)" })
-- end
-- end,
-- })

vim.keymap.set("n", "q:", "<leader>q<CR>")
-- vim.keymap.set("n", "<leader>q", "bp<bar>sp<bar>bn<bar>bd<CR>", { desc = "Close buffer" })
-- vim.cmd [[map <CMD>q :bp<bar>sp<bar>bn<bar>bd<CR>]]
-- vim.cmd [[map :q :bp|sp|bn|bd]]

vim.api.nvim_create_user_command("Q",
    function()
        vim.cmd [[<CMD>q<CR>]]
    end,
    { desc = "Close buffer" })

-- Command to turn on or off centering to the cursor.
vim.api.nvim_create_user_command("CenterOn", function()
        center_disabled = false
        -- vim.cmd([[:setlocal scrolloff=999]])
        vim.cmd([[nnoremap k kzz]])
        vim.cmd([[nnoremap j jzz]])
        vim.cmd([[vnoremap k kzz]])
        vim.cmd([[vnoremap j jzz]])

        -- also remap <C-u> and <C-d> to scroll without moving the cursor
        vim.cmd([[nnoremap <C-u> <C-u>zz]])
        vim.cmd([[nnoremap <C-d> <C-d>zz]])
        -- also for visual mode
        vim.cmd([[vnoremap <C-u> <C-u>zz]])
        vim.cmd([[vnoremap <C-d> <C-d>zz]])
        -- also for finding next/previous
        vim.cmd([[nnoremap n nzz]])
        vim.cmd([[nnoremap N Nzz]])
    end,
    { desc = "Enable cursor center on screen" }
)

vim.api.nvim_create_user_command("CenterOff", function()
        center_disabled = true

        -- vim.cmd([[:setlocal scrolloff=-1]])
        vim.cmd([[nnoremap k k]])
        vim.cmd([[nnoremap j j]])
        vim.cmd([[vnoremap k k]])
        vim.cmd([[vnoremap j j]])

        -- cancel the <C-u> and <C-d> remaps
        vim.cmd([[nnoremap <C-u> <C-u>]])
        vim.cmd([[nnoremap <C-d> <C-d>]])
        -- also for visual mode
        vim.cmd([[vnoremap <C-u> <C-u>]])
        vim.cmd([[vnoremap <C-d> <C-d>]])
        -- also for finding next/previous
        vim.cmd([[nnoremap n n]])
        vim.cmd([[nnoremap N N]])
    end,
    { desc = "Disable cursor center on screen" }
)


-- 'test'
-- vim.keymap.set("n", "<C-'>", "cs'`", { desc = "Cycle through quotation types." })
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
    {
        "andweeb/presence.nvim",
        opts = {
            -- General options
            auto_update       = true,
            neovim_image_text = "nvim",
            main_image        = "neovim",
            -- A list of strings or Lua patterns that disable Rich Presence if the current file name, path, or workspace matches
            blacklist         = {},
            -- Configure Rich Presence button(s), either a boolean to enable/disable, a static table
            -- (`{{ label = "<label>", url = "<url>" }, ...}`, or a function(buffer: string, repo_url: string|nil): table)
            buttons           = true,
            -- Show the timer
            show_time         = true,


            -- Rich Presence text options
            editing_text        = "Editing %s",
            -- Format string rendered when an editable file is loaded in the buffer
            -- (either string or function(filename: string): string)
            file_explorer_text  = "Reading %s",
            -- Format string rendered when browsing a file explorer (either string or function(file_explorer_name: string): string)
            git_commit_text     = "Committing changes",
            -- Format string rendered when committing changes in git (either string or function(filename: string): string)
            plugin_manager_text = "Managing plugins",
            -- Format string rendered when managing plugins
            -- (either string or function(plugin_manager_name: string): string)
            reading_text        = "Reading %s",
            -- Format string rendered when a read-only or unmodifiable file is loaded in the buffer
            -- (either string or function(filename: string): string)
            workspace_text      = "Working on %s",
            -- Format string rendered when in a git repository
            -- (either string or function(project_name: string|nil, filename: string): string)
            line_number_text    = "Line %s out of %s",
            -- Format string rendered when `enable_line_number` is set to true
            -- (either string or function(line_number: number, line_count: number): string)

        }
    },
    {
        'rachartier/tiny-inline-diagnostic.nvim',
        event = "VeryLazy",
        priority = 1000,
        config = function()
            require('tiny-inline-diagnostic').setup({
                -- preset = "classic",
                preset = "powerline",
                -- options = {
                --     throttle = 0,
                -- }
            })
        end
    },

    -- I do not remember what this is...
    -- {
    --     'wuelnerdotexe/vim-astro',
    --     config = function()
    --         -- vim.cmd([[let g:astro_typescript = 'enable']])
    --         -- vim.cmd([[let g:astro_stylus = 'enable']])
    --     end
    -- },

    {
        "nvim-tree/nvim-web-devicons",
        opts = {
            strict = true,
            config = function()
                -- require "nvim-web-devicons".set_icon { astro = { icon = "", color = "#f1502f", name = "astro", } }
            end,
            override_by_extension = {
                -- ["astro"] = { icon = "", color = "#f1502f", name = "Astro", },
                -- ["gleam"] = { icon = "", color = "#ffaef3", name = "Gleam", },
                ["typ"] = {
                    icon = "t",
                    color = "#239dad",
                    name = "Typst",
                },
            },
        }
    },
    {
        'marcussimonsen/let-it-snow.nvim',
        cmd = "LetItSnow",
        opts = {
            delay = 200
        }
    },
    {
        'stevearc/oil.nvim',
        opts = {
            skip_confirm_for_simple_edits = true,
            -- columns = {
            --     "icon",
            --     "size",
            -- },
            keymaps = {
                ["g?"] = "actions.show_help",
                ["<CR>"] = "actions.select",
                ["<C-s>"] = { "actions.select", opts = { vertical = true }, desc = "Open the entry in a vertical split" },
                ["<C-h>"] = { "actions.select", opts = { horizontal = true }, desc = "Open the entry in a horizontal split" },
                ["<C-t>"] = { "actions.select", opts = { tab = true }, desc = "Open the entry in new tab" },
                ["<S-p>"] = "actions.preview",
                ["<C-p>"] = false,
                ["<C-c>"] = "actions.close",
                ["<C-l>"] = "actions.refresh",
                ["-"] = "actions.parent",
                ["_"] = "actions.open_cwd",
                ["`"] = "actions.cd",
                ["~"] = { "actions.cd", opts = { scope = "tab" }, desc = ":tcd to the current oil directory", mode = "n" },
                ["gs"] = "actions.change_sort",
                ["gx"] = "actions.open_external",
                ["g."] = "actions.toggle_hidden",
                ["g\\"] = "actions.toggle_trash",
            },
            view_options = {
                -- Show files and directories that start with "."
                show_hidden = true,
                -- This function defines what is considered a "hidden" file
                is_hidden_file = function(name)
                    return vim.startswith(name, ".") or vim.startswith(name, 'node_modules')
                end,
            },
        },
        -- Optional dependencies
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    {
        'echasnovski/mini.nvim',
        version = false,
        config = function()
            require('mini.sessions').setup()
            -- MiniSessions.setup()
            require("mini.files").setup {
                mappings = {
                    close       = '<ESC>',
                    go_in       = '<CR>',
                    go_in_plus  = 'l',
                    go_out      = '-',
                    go_out_plus = 'h',
                    reset       = 'X',
                    reveal_cwd  = '@',
                    show_help   = 'g?',
                    synchronize = 'w',
                    trim_left   = '<',
                    trim_right  = '>',
                },
                windows = {
                    preview = true
                }
            }
            vim.api.nvim_create_user_command("File", function()
                vim.cmd([[lua MiniFiles.open()]])
            end, { desc = "Open Mini.Files" })

            require('mini.cursorword').setup {
                delay = 1
            }
            require('mini.jump').setup()
            local hipatterns = require('mini.hipatterns')
            hipatterns.setup({
                highlighters = {
                    -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
                    todo      = { pattern = '%f[%w]()todo!()()%f[%W]', group = 'MiniHipatternsTodo' },
                    hex_color = hipatterns.gen_highlighter.hex_color(),
                },
            })
        end
    },

    {
        'NTBBloodbath/color-converter.nvim',
        config = function()
            vim.api.nvim_create_user_command("ToRgb", function()
                require 'color-converter'.to_rgb()
            end, { desc = "Convert a colour value to css RGB format." })
            vim.api.nvim_create_user_command("ToHex", function()
                require 'color-converter'.to_hex()
            end, { desc = "Convert a colour value to css HEX format." })
            vim.api.nvim_create_user_command("ToHsl", function()
                require 'color-converter'.to_hsl()
            end, { desc = "Convert a colour value to css HSL format." })
        end -- Highlight hex color strings (`#rrggbb`) using that color
    },

    -- Git related plugins
    "tpope/vim-fugitive",
    "tpope/vim-rhubarb",
    "tpope/vim-commentary",
    "tpope/vim-surround",
    -- Eh...
    -- 'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

    -- Pretty registers window instead of boring other one.
    {
        "tversteeg/registers.nvim",
        cmd = "Registers",
        config = true,
        keys = {
            { "\"",    mode = { "n", "v" } },
            { "<C-R>", mode = "i" }
        },
        name = "registers",
    },

    -- Idek if this works, but there are probably commands to test this.
    {
        "barrett-ruth/import-cost.nvim",
        build = "sh install.sh npm",
        config = true,
    },

    -- Idk what this is but it seems important for later...
    -- 'sheerun/vim-polyglot',
    "prettier/vim-prettier",

    -- Enables a command to show all colour strings like this #42069F with a colour hint
    -- :ColorToggle
    "chrisbra/Colorizer",

    {
        "michaelrommel/nvim-silicon",
        lazy = true,
        cmd = "Silicon",
        init = function()
            local wk = require("which-key")
            wk.add({
                { "<leader>cts", ":Silicon<CR>", desc = "[C]ode: [T]ake [S]napshot", mode = "v" },
            })
        end,
        config = function()
            require("nvim-silicon").setup({
                font = "JetBrains Mono NL=34;Noto Color Emoji=34",
                to_clipboard = true,
                theme = "Coldark-Dark",
                background = "#8dd9d5",
                window_title = function()
                    return vim.fn.fnamemodify(
                        vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), ":t"
                    )
                end
            })
        end
    },
    {
        "mistricky/codesnap.nvim",
        build = "make",
        opts = {
            save_path = "~/Pictures/CodeSnap",
            -- has_breadcrumbs = true,
            bg_theme = "sea",
            watermark = "blog.trevfox.dev",
            code_font_family = "JetBrains Mono NL",
            -- breadcrumbs_separator = " -> ",
        }
    },

    -- NOTE: COPILOT DISABLED UNTIL I GET MY SUBSCRIPTION AGAIN...
    -- {
    --     "github/copilot.vim",
    --     config = function()
    --         vim.keymap.set("i", "<C-G>", 'copilot#Accept("<CR>")', {
    --             expr = true,
    --             replace_keycodes = false,
    --         })
    --         vim.g.copilot_no_tab_map = true
    --     end,
    -- },

    -- NOTE: This is where your plugins related to LSP can be installed.
    --  The configuration is done below. Search for lspconfig to find it below.
    {
        -- LSP Configuration & Plugins
        "neovim/nvim-lspconfig",
        ---@class PluginLspOpts
        opts = {
            servers = {
                gleam = { mason = false },
            }
        },
        config = function()
            -- local util = require 'lspconfig.util'
            -- local function get_typescript_server_path(root_dir)
            --     local project_root = util.find_node_modules_ancestor(root_dir)
            --     return project_root and (util.path.join(project_root, 'node_modules', 'typescript', 'lib')) or
            --         ''
            -- end

            require("lspconfig").rust_analyzer.setup({})
            require("lspconfig").pyright.setup({})
            require("lspconfig").astro.setup({})

            require("lspconfig").grammarly.setup {
                -- on_attach = on_attach,
                filetypes = { "txt", "typ", "typst" },
                init_options = { clientId = "client_BaDkMgx4X19X9UxxYRCXZo" }
            }
            require("lspconfig").tailwindcss.setup {
                settings = {
                    tailwindCSS = {
                        classAttributes = { "class", "className", "ngClass", "class:list", "hoverClass", "bgClass" }
                    }
                }
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
            -- NOTE: Maybe check this out a bit more...
            -- TODO: Use lazydev instead.
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
                snippet = {
                    expand = function(args)
                        require 'snippy'.expand_snippet(args.body)
                    end
                },
                sources = {
                    { name = 'snippy' }
                }
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
            -- 'dcampos/cmp-snippy',
            -- 'dcampos/nvim-snippy'
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

    'NoahTheDuke/vim-just',

    -- Formatter
    {
        "stevearc/conform.nvim",
        opts = {
            format_on_save = {
                -- These options will be passed to conform.format()
                timeout_ms = 1500,
                lsp_fallback = true,
            },
            formatters_by_ft = {
                css = { "prettier" },
                lua = { "stylua" },
                typst = { "typstfmt" },
                -- Conform will run multiple formatters sequentially
                python = { "isort", "black" },
                -- Use a sub-list to run only the first available formatter
                javascript = { "prettier" },
                json = { "prettier" },
                typescript = { "prettier" },
                mdx = { "prettier" },
                markdown = { "prettier" },
            },
        },
    },

    -- Gleam support
    'gleam-lang/gleam.vim',

    -- Typst support
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

    -- Useful plugin to show you pending keybinds.
    -- FOLKE
    {
        "folke/which-key.nvim",
        opts = {}
    },

    -- Zen
    {
        "folke/zen-mode.nvim",
        config = function()
            vim.api.nvim_create_user_command("Zen", function()
                require 'zen-mode'.toggle { window = { width = 0.55 } }
            end, { desc = "Activate Zen Mode with a wider screen" })
            vim.api.nvim_create_user_command("ZenWide", function()
                require 'zen-mode'.toggle { window = { width = 0.85 } }
            end, { desc = "Activate Zen Mode with a wider screen" })
            vim.api.nvim_create_user_command("ZenFull", function()
                require 'zen-mode'.toggle { window = { width = 1 } }
            end, { desc = "Activate Zen Mode with a wider screen" })
        end,
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

    -- {
    --     "EggbertFluffle/beepboop.nvim",
    --     opts = {
    --         audio_player = "ffplay",
    --         max_sounds = 20,
    --         sound_directory = "~/.sounds",
    --         sound_map = {
    --             {
    --                 auto_command = "InsertCharPre",
    --                 sounds = {
    --                     -- SOUND MAP DEFENITIONS HERE
    --                     "banana-l-1.wav",
    --                     "banana-l-2.wav",
    --                     "banana-l-3.wav",
    --                     "banana-l-4.wav",
    --                     "banana-l-5.wav",
    --                     "banana-l-6.wav",
    --                     "banana-l-7.wav",
    --                 }
    --             }
    --         }
    --     }
    -- },

    -- {
    --     'joshuadanpeterson/typewriter',
    --     dependencies = {
    --         'nvim-treesitter/nvim-treesitter',
    --     },
    --     config = function()
    --         require('typewriter').setup()
    --     end,
    --     opts = {}
    -- },
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
            scratch = {
                enabled = true,
                -- style = {
                --     minimal = false,
                --     border = 'rounded',
                --     title_pos = 'center',
                --     footer_pos = 'center',
                --     bo = { buftype = "", buflisted = false, "bufhidden = hide", swapfile = false },
                -- }
            },
            bigfile = { enabled = true },
            notifier = { enabled = true },
            quickfile = { enabled = true },
            statuscolumn = { enabled = true },
            words = { enabled = true },
            lazygit = { configure = true },
            dashboard = {
                enabled = true,
                preset = {
                    keys = {
                        { icon = " ", key = "o", desc = "Open Oil", action = ":Oil" },
                        { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
                        { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                        { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
                        { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
                        -- { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
                        -- { icon = " ", key = "s", desc = "Restore Session", section = "session" },
                        { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy },
                        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                    },
                },
                sections = {
                    { section = "keys", gap = 1, padding = 1 },
                    { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
                    { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
                    {
                        pane = 2,
                        icon = " ",
                        title = "Git Status",
                        section = "terminal",
                        enabled = vim.fn.isdirectory(".git") == 1,
                        cmd = "git status --short --branch --renames",
                        height = 5,
                        padding = 1,
                        ttl = 5 * 60,
                        indent = 3,
                    },
                    { section = "startup" },
                }
            }
        },
        keys = {
            -- { "<leader>", function() end, desc = ""},
            { "<leader>.",  function() Snacks.scratch() end,          desc = "Toggle Scratch Buffer" },
            { "<leader>S",  function() Snacks.scratch.select() end,   desc = "Select Scratch Buffer" },
            { "<leader>un", function() Snacks.notifier.hide() end,    desc = "Dismiss All Notifications" },
            { "<leader>bd", function() Snacks.bufdelete() end,        desc = "Delete Buffer" },
            { "<leader>gg", function() Snacks.lazygit() end,          desc = "Lazygit" },
            { "<leader>gb", function() Snacks.git.blame_line() end,   desc = "Git Blame Line" },
            { "<leader>gB", function() Snacks.gitbrowse() end,        desc = "Git Browse" },
            { "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "Lazygit Current File History" },
            { "<leader>gl", function() Snacks.lazygit.log() end,      desc = "Lazygit Log (cwd)" },
            { "<leader>od", function() Snacks.dashboard.open() end,   desc = "Dashboard" },
        }
    },
    {
        'folke/noice.nvim',
        event = "VeryLazy",
        -- config = function()
        --     vim.keymap.set("c", "<S-Enter>", function()
        --         require("noice").redirect(vim.fn.getcmdline())
        --     end, { desc = "Redirect Cmdline" })
        --     -- require("telescope").load_extension("noice")
        -- end,
        opts = {
            lsp = {
                -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
                },
            },
            messages = {
                enabled = false,
                view = "notify",
                view_error = "notify",
                view_search = false
            },
            -- you can enable a preset for easier configuration
            presets = {
                bottom_search = false,        -- use a classic bottom cmdline for search
                command_palette = true,       -- position the cmdline and popupmenu together
                long_message_to_split = true, -- long messages will be sent to a split
                inc_rename = true,            -- enables an input dialog for inc-rename.nvim
                lsp_doc_border = true,        -- add a border to hover docs and signature help
            },
        },
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        }
    },
    -- {
    --     'sethen/line-number-change-mode.nvim',
    --     config = function()
    --         local palette = {
    --             normal = "#00BFFF",
    --             insert = "#70CF67",
    --             visual = "#AD6FF7",
    --             command = "#EB788B",
    --             operator = "#FF8F40",
    --             replace = "#E66767",
    --             select = "#AD6FF7",
    --             terminal = "#4CD4BD",
    --             terminal_n = "#00BBCC",
    --             none = "#00000000"
    --         }
    --
    --         require("line-number-change-mode").setup({
    --             mode = {
    --                 i = {
    --                     fg = palette.insert,
    --                     bold = true,
    --                 },
    --                 n = {
    --                     fg = palette.normal,
    --                     bold = true,
    --                 },
    --                 R = {
    --                     fg = palette.replace,
    --                     bold = true,
    --                 },
    --                 v = {
    --                     fg = palette.select,
    --                     bold = true,
    --                 },
    --                 V = {
    --                     bg = palette.select,
    --                     bold = true,
    --                 },
    --             }
    --         })
    --     end
    -- },
    -- {
    -- "svampkorg/moody.nvim",
    -- enabled = true,
    -- event = { "ModeChanged", "BufWinEnter", "WinEnter" },
    -- opts = {
    --     -- you can set different blend values for your different modes.
    --     -- Some colours might look better more dark, so set a higher value
    --     -- will result in a darker shade.
    --     blends = {
    --         normal = 0.2,
    --         insert = 0.2,
    --         visual = 0.25,
    --         command = 0.2,
    --         operator = 0.2,
    --         replace = 0.2,
    --         select = 0.2,
    --         terminal = 0.2,
    --         terminal_n = 0.2,
    --     },
    --     -- there are two ways to define colours for the different modes.
    --     -- one way is to define theme here in colors. Another way is to
    --     -- set them up with highlight groups. Any highlight group set takes
    --     -- precedence over any colours defined here.
    --     colors = {
    --         normal = "#00BFFF",
    --         insert = "#70CF67",
    --         visual = "#AD6FF7",
    --         command = "#EB788B",
    --         operator = "#FF8F40",
    --         replace = "#E66767",
    --         select = "#AD6FF7",
    --         terminal = "#4CD4BD",
    --         terminal_n = "#00BBCC",
    --     },
    --     -- disable filetypes here. Add for example "TelescopePrompt" to
    --     -- not have any coloured cursorline for the telescope prompt.
    --     disabled_filetypes = { "TelescopePrompt" },
    --     -- you can turn on or off bold characters for the line numbers
    --     bold_nr = true,
    --     -- you can turn on and off a feature which shows a little icon and
    --     -- registry number at the end of the CursorLine, for when you are
    --     -- recording a macro! Default is false.
    --     recording = {
    --         enabled = true,
    --         -- icon = "󰑋",
    --         icon = "q",
    --         -- you can set some text to surround the recording registry char with
    --         -- or just set one to empty to maybe have just one letter, an arrow
    --         -- perhaps! For example recording to q, you could have! "󰑋    q" :D
    --         pre_registry_text = "[",
    --         post_registry_text = "]",
    --     },
    -- },
    -- },

    -- Error list
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cmd = "Trouble",
        -- opts = {
        --     -- your configuration comes here
        --     -- or leave it empty to use the default settings
        --     -- refer to the configuration section below
        -- },
        config = function()
            vim.keymap.set("n", "<leader>lp", "<cmd>Trouble workspace_diagnostics<cr>", { desc = "[L]ist [P]roblems" })
        end,
    },

    -- Todo comment highlights
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
            local harpoon = require("harpoon")
            harpoon:setup()

            vim.keymap.set("n", "<leader>fa", function() harpoon:list():add() end, { desc = "Add [A] file to Harpoon" })

            local toggle_menu = function()
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end

            -- vim.keymap.set("n", "<C-e>", toggle_menu, { desc = "Toggle Harpoon [E]xplorer" })
            vim.keymap.set("n", "<leader>fl", toggle_menu, { desc = "Toggle Harpoon [L]ist" })

            vim.keymap.set("n", "<C-1>", function()
                harpoon:list():select(1)
            end, { desc = "Open First Harpooned File" })
            vim.keymap.set("n", "<C-2>", function()
                harpoon:list():select(2)
            end, { desc = "Open Second Harpooned File" })
            vim.keymap.set("n", "<C-3>", function()
                harpoon:list():select(3)
            end, { desc = "Open Third Harpooned File" })
            vim.keymap.set("n", "<C-4>", function()
                harpoon:list():select(4)
            end, { desc = "Open Fourth Harpooned File" })

            vim.keymap.set("n", "<C-h>", function()
                harpoon:list():select(1)
            end, { desc = "Open First Harpooned File" })
            vim.keymap.set("n", "<C-j>", function()
                harpoon:list():select(2)
            end, { desc = "Open Second Harpooned File" })
            vim.keymap.set("n", "<C-k>", function()
                harpoon:list():select(3)
            end, { desc = "Open Third Harpooned File" })
            vim.keymap.set("n", "<C-l>", function()
                harpoon:list():select(4)
            end, { desc = "Open Fourth Harpooned File" })
            -- vim.keymap.set("n", "<C-`>", function()
            --     harpoon:list():select(5)
            -- end, { desc = "Open Fifth Harpooned File" })

            vim.keymap.set("n", "<leader>o1", function()
                harpoon:list():select(1)
            end, { desc = "Open First Harpooned File" })
            vim.keymap.set("n", "<leader>o2", function()
                harpoon:list():select(2)
            end, { desc = "Open Second Harpooned File" })
            vim.keymap.set("n", "<leader>o3", function()
                harpoon:list():select(3)
            end, { desc = "Open Third Harpooned File" })
            vim.keymap.set("n", "<leader>o4", function()
                harpoon:list():select(4)
            end, { desc = "Open Fourth Harpooned File" })

            vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end, { desc = "Previous Harpooned File" })
            vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end, { desc = "Next Harpooned File" })

            local conf = require("telescope.config").values
            local function toggle_telescope(harpoon_files)
                local file_paths = {}
                for _, item in ipairs(harpoon_files.items) do
                    table.insert(file_paths, item.value)
                end

                require("telescope.pickers").new({}, {
                    prompt_title = "Harpoon",
                    finder = require("telescope.finders").new_table({
                        results = file_paths,
                    }),
                    previewer = conf.file_previewer({}),
                    sorter = conf.generic_sorter({}),
                }):find()
            end

            vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end,
                { desc = "Open harpoon window" })
        end,
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim", }
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
                -- vim.keymap.set(
                --     "n",
                --     "<leader>hp",
                --     require("gitsigns").preview_hunk,
                --     { buffer = bufnr, desc = "Preview git hunk" }
                -- )
                --
                -- -- don't override the built-in and fugitive keymaps
                -- local gs = package.loaded.gitsigns
                -- vim.keymap.set({ "n", "v" }, "]c", function()
                --     if vim.wo.diff then
                --         return "]c"
                --     end
                --     vim.schedule(function()
                --         gs.next_hunk()
                --     end)
                --     return "<Ignore>"
                -- end, { expr = true, buffer = bufnr, desc = "Jump to next hunk" })
                -- vim.keymap.set({ "n", "v" }, "[c", function()
                --     if vim.wo.diff then
                --         return "[c"
                --     end
                --     vim.schedule(function()
                --         gs.prev_hunk()
                --     end)
                --     return "<Ignore>"
                -- end, { expr = true, buffer = bufnr, desc = "Jump to previous hunk" })
            end,
        },
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000
    },
    {
        "cocopon/iceberg.vim",
        name = "iceberg",
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
        "Alexis12119/nightly.nvim",
        lazy = false,
        priority = 1000,
    },
    {
        'space-chalk/spacechalk.nvim',
        lazy = false,    -- loaded during startup since it's the main colorscheme
        priority = 1000, -- load this before all other start plugins
    },

    {
        'olivercederborg/poimandres.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            -- require('poimandres').setup {
            --     bold_vert_split = false,          -- use bold vertical separators
            --     dim_nc_background = false,        -- dim 'non-current' window backgrounds
            --     disable_background = false,       -- disable background
            --     disable_float_background = false, -- disable background for floats
            --     disable_italics = false,          -- disable italics
            -- }
        end,
    },

    { "fffnite/gleam-theme-nvim" },
    'Yazeed1s/oh-lucy.nvim',

    {
        "shatur/neovim-ayu",
        priority = 1001,
        lazy = false,
        config = function()
            local ayucolors = require('ayu.colors')
            ayucolors.generate()

            require('ayu').setup({
                overrides = {
                    -- LineNr = { fg = ayucolors.keyword },
                    LineNrAbove = { fg = ayucolors.comment },
                    LineNrBelow = { fg = ayucolors.comment },
                    LineNr = { fg = ayucolors.accent }
                }
            })
        end,
    },
    { "kartikp10/noctis.nvim" },
    { "biscuit-colorscheme/nvim" },
    -- { "rktjmp/lush.nvim" },
    -- use later to make a scheme
    { "fafa-a/anoukis" },
    { 'nyoom-engineering/oxocarbon.nvim' },
    {
        'datsfilipe/min-theme.nvim',
        config = function()
            require('min-theme').setup({
                -- (note: if your configuration sets vim.o.background the following option will do nothing!)
                theme = 'dark',       -- String: 'dark' or 'light', determines the colorscheme used
                transparent = false,  -- Boolean: Sets the background to transparent
                italics = {
                    comments = true,  -- Boolean: Italicizes comments
                    keywords = true,  -- Boolean: Italicizes keywords
                    functions = true, -- Boolean: Italicizes functions
                    strings = true,   -- Boolean: Italicizes strings
                    variables = true, -- Boolean: Italicizes variables
                },
                overrides = {},       -- A dictionary of group names, can be a function returning a dictionary or a table.
            })
        end
    },
    {
        "https://gitlab.com/bartekjaszczak/distinct-nvim",
        priority = 1000,
        config = function()
            require("distinct").setup({
                doc_comments_different_color = true, -- Use different colour for documentation comments
            })
        end
    },
    {
        'stevearc/dressing.nvim',
        opts = {},
    },
    {
        "timofurrer/edelweiss",
        lazy = false,    -- make sure we load this during startup, because it's the main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function(plugin)
            vim.opt.rtp:append(plugin.dir .. "/nvim")
        end
    },
    {
        'AlexvZyl/nordic.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            -- require 'nordic'.load()
        end
    },
    {
        'rakr/vim-one',
        lazy = false,
        priority = 1000,
    },
    {
        "ficcdaf/ashen.nvim",
        lazy = false,
        priority = 1000,
        -- configuration is optional!
        opts = {
            -- your settings here
        },
    },
    {
        "zaldih/themery.nvim",
        opts = {
            themes = {
                "ayu-dark",
                "ayu-mirage",
                "ashen",
                "biscuit",
                "catppuccin-frappe",
                "catppuccin-macchiato",
                "catppuccin-mocha",
                "distinct",
                "flexoki-dark",
                "gleam",
                "iceberg",
                "kanagawa-dragon",
                "kanagawa-wave",
                "min-theme-dark",
                "nightly",
                "noctis",
                "nordic",
                "oh-lucy",
                "oh-lucy-evening",
                "onedark",
                "oxocarbon",
                "poimandres",
                "spacechalk",
                "tokyonight-moon",
                "tokyonight-night",
                "tokyonight-storm",
                "ayu-light",
                "catppuccin-latte",
                "everforest",
                "edelweiss",
                "paper",
                "flexoki-light",
                "kanagawa-lotus",
                "one"
            },
            -- Your list of installed colorschemes
            -- Described below
            livePreview = true,
            -- Apply theme while browsing. Default to true.
        }
    },
    {
        "sainnhe/everforest",
        priority = 1000,
        config = function()
            vim.g.everforest_background = "medium"
            -- vim.cmd.colorscheme 'tokyonight-moon'
            -- vim.cmd([[:colorscheme tokyonight-moon]])
            -- vim.cmd([[:colorscheme flexoki-dark]])
        end,
    },
    {
        -- Theme inspired by Atom
        "folke/tokyonight.nvim",
        priority = 1000,
        config = function()
            -- vim.cmd.colorscheme 'tokyonight-moon'
            -- vim.cmd([[:colorscheme tokyonight-moon]])
            -- vim.cmd([[:colorscheme flexoki-dark]])
        end,
    },
    "yorickpeterse/vim-paper",
    {
        "navarasu/onedark.nvim",
        opts = {
            -- style = "deep",
            transparent = true,
            code_style = {
                keywords = "bold,italic",
                -- functions = "bold",
            },
            lualine = {
                transparent = true
            },
            highlights = {
                ["@keyword.import"] = { fmt = "italic,bold" },
                ["@keyword.function"] = { fmt = "bold" },
                ["@module"] = { fmt = "italic" }
            }
        }
    },
    {
        -- Set lualine as statusline
        "nvim-lualine/lualine.nvim",
        -- See `:help lualine.txt`
        opts = {
            options = {
                icons_enabled = false,
                -- theme = "tokyonight",
                -- theme = "ayu",
                -- theme = "ayu-light",
                theme = "onedark",
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
    -- { "numToStr/Comment.nvim", opts = {} },

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
            { "nushell/tree-sitter-nu", build = ":TSUpdate nu" },
        },
        build = ":TSUpdate",
    },

    -- {
    --     'windwp/nvim-ts-autotag',
    --     config = function()
    --         require('nvim-ts-autotag').setup()
    --     end
    -- },

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

-- require 'custom.lualine-custom'



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

-- -- Configure oil.nvim
-- require("oil").setup({
--     skip_confirm_for_simple_edits = false,
--     -- columns = {
--     --     "icon",
--     --     "size",
--     -- },
--     view_options = {
--         -- Show files and directories that start with "."
--         show_hidden = true,
--         -- This function defines what is considered a "hidden" file
--         is_hidden_file = function(name)
--             return vim.startswith(name, ".") or vim.startswith(name, 'node_modules')
--         end,
--     },
-- })

-- require("nvim-web-devicons").setup {
--     strict = true,
--     override_by_extension = {
--         ["astro"] = {
--             icon = "",
--             color = "#f1502f",
--             name = "Astro",
--         },
--         ["gleam"] = {
--             icon = "",
--             color = "#ffaef3",
--             name = "Gleam",
--         },
--         ["typ"] = {
--             icon = "t",
--             color = "#239dad",
--             name = "Typst",
--         },
--     },
-- }

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.relativenumber = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = "unnamed"

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

-- Exit with capical 'Q'
vim.keymap.set("n", "<CMD>Q", "<CMD>q", { desc = "Quit" })

-- 'asd'
-- Cycle quotes
vim.keymap.set("n", "<C-'>", [[cs`"cs'`cs"']], { desc = "Cycle quotes", remap = true })

-- Dupe the current line, comment it out, and paste it
-- vim.keymap.set("n", "cl", [["fyygcc"fp]], { desc = "Copy line down and comment out the old one", remap = true })
vim.keymap.set("n", "cl", [["fyygcc"fp]], { desc = "Copy line down and comment out the old one", remap = true })



-- Primeagen magic keybinds here:::::
-- Join lines keeping cursor position
vim.keymap.set("n", "J", "mzJ`z")
-- Page up/down PLUS center screen
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

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
bind("n", "<C-p>", require("telescope.builtin").git_files, { desc = "Search Git Files" })
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
            "markdown",
            "gleam"
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
    nmap("<leader>c.", vim.lsp.buf.code_action, "[C]ode [A]ction")

    nmap("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
    nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
    nmap("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
    nmap("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
    nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
    nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

    -- See `:help K` for why this keymap
    nmap("K", vim.lsp.buf.hover, "Hover Documentation")
    nmap("<C-K>", vim.lsp.buf.signature_help, "Signature Documentation")

    -- Lesser used LSP functionality
    nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
    nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
    nmap("<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "[W]orkspace [L]ist Folders")

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, "Format", function(args)
        -- vim.lsp.buf.format()
        require("conform").format({ bufnr = args.buf })
    end, { desc = "Format current buffer with LSP" })
end

-- document existing key chains
require("which-key").add({

    { "<leader>c",  group = "[C]ode" },
    { "<leader>c_", hidden = true },
    { "<leader>d",  group = "[D]ocument" },
    { "<leader>d_", hidden = true },
    { "<leader>F",  group = "[F]ile Management" },
    { "<leader>F_", hidden = true },
    { "<leader>f",  group = "[F]ile Management" },
    { "<leader>f_", hidden = true },
    { "<leader>g",  group = "[G]it" },
    { "<leader>g_", hidden = true },
    { "<leader>l",  group = "[L]ook" },
    { "<leader>l_", hidden = true },
    { "<leader>o",  group = "[O]pen" },
    { "<leader>o_", hidden = true },
    { "<leader>r",  group = "[R]ename" },
    { "<leader>r_", hidden = true },
    { "<leader>s",  group = "[S]earch" },
    { "<leader>s_", hidden = true },
    { "<leader>w",  group = "[W]orkspace" },
    { "<leader>w_", hidden = true },

    -- ["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
    -- ["<leader>d"] = { name = "[D]ocument", _ = "which_key_ignore" },
    -- ["<leader>g"] = { name = "[G]it", _ = "which_key_ignore" },
    -- ['<leader>h'] = { name = 'More git', _ = 'which_key_ignore' },
    -- ["<leader>r"] = { name = "[R]ename", _ = "which_key_ignore" },
    -- ["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
    -- ["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
    -- ["<leader>f"] = { name = "[F]ile Management", _ = "which_key_ignore" },
    -- ["<leader>o"] = { name = "[O]pen", _ = "which_key_ignore" },
    -- ["<leader>l"] = { name = "[L]ook", _ = "which_key_ignore" },
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

require("lspconfig").gleam.setup({
    on_attach = on_attach
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
        -- ["<C-N>"] = cmp.mapping.select_next_item(),
        -- ["<C-P>"] = cmp.mapping.select_prev_item(),
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

vim.keymap.set("i", "<C-.>", "|>")

-- vim.notify("test")

-- local oti = require 'notify'.setup({
--     -- Animation style (see below for details)
--     stages = "fade_in_slide_out",
--     -- Default timeout for notifications
--     timeout = 3000,
--     -- For stages that change opacity this is treated as the highlight behind the window
--     background_highlight = "NormalFloat",
--     -- Icons for the different levels
--     icons = {
--         ERROR = "",
--         WARN = "",
--         INFO = "",
--         DEBUG = "",
--         TRACE = "✎",
--     },
-- })

-- Diagnostic Notification Commands
local diagTimeout = 4000
vim.keymap.set("n", "?", function()
    local diag = vim.lsp.diagnostic.get_line_diagnostics()
    local len = #diag
    local msg = ""
    local level = vim.log.levels.INFO

    if len < 1 then
        msg = " All Good!"
    else
        msg = " " .. diag[1].message
        level = vim.log.levels.WARN
    end
    vim.notify(msg, level,
        { title = "Line Diagnostics", render = "simple", timeout = diagTimeout, hide_from_history = true, animate = false })
end, { desc = "Get diagnostics in current line" })
-- make the same command as above but for all diagnostics in a file
vim.keymap.set("n", "<C-?>", function()
    local diag = vim.diagnostic.get()
    local len = #diag
    local msg = ""
    local level = vim.log.levels.INFO

    if len < 1 then
        msg = " All Good!"
    else
        -- make `msg` a string with all diagnostic messages in the table concatenated
        msg = ""
        for i, d in ipairs(diag) do
            msg = msg .. " Line " .. d.lnum .. " -> " .. d.message
            if i < len then
                msg = msg .. "\n\n"
            end
        end
        level = vim.log.levels.WARN
    end
    vim.notify(msg, level,
        { title = "File Diagnostics", render = "simple", timeout = diagTimeout, hide_from_history = true, animate = false })
end, { desc = "Get all diagnostics in current file" })

require 'lualine'.setup { options = { theme = 'everforest' } }

-- require("settings.theme")

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=4 sts=4 sw=4 et
