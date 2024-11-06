local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
                "git",
                "clone",
                "--filter=blob:none",
                "https://github.com/folke/lazy.nvim.git",
                "--branch=stable",
                lazypath,
        })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
        {
                "catppuccin/nvim",
                name = "catppuccin",
                config = function()
                        require("catppuccin").setup({
                                flavour = "mocha",
                                transparent_background = true, 
                        })
                end,
        },
        {
                "nvim-treesitter/nvim-treesitter",
                event = { "BufReadPre", "BufNewFile" },
                build = ":TSUpdate",
                run = ":TSUpdate",
                dependencies = {
                        "windwp/nvim-ts-autotag",
                },
                config = function()
                        local treesitter = require("nvim-treesitter.configs")
                        treesitter.setup({
                                highlight = {
                                        enable = true,
                                },
                                indent = { enable = true },
                                autotag = {
                                        enable = true,
                                },
                                ensure_installed = {
                                        "json",
                                        "javascript",
                                        "typescript",
                                        "tsx",
                                        "yaml",
                                        "html",
                                        "css",
                                        "graphql",
                                        "bash",
                                        "lua",
                                        "vim",
                                        "dockerfile",
                                        "gitignore",
                                        "gitcommit",
                                        "query",
                                        "c",
                                },
                                incremental_selection = {
                                        enable = true,
                                        keymaps = {
                                                init_selection = "<C-space>",
                                                node_incremental = "<C-space>",
                                                scope_incremental = false,
                                                node_decremental = "<bs>",
                                        },
                                },
                        })
                end,
        },
        {
                "williamboman/mason.nvim",
                dependencies = {
                        "WhoIsSethDaniel/mason-tool-installer.nvim",
                },
                build = ":MasonUpdate",
                config = function()
                        require("mason").setup()
                        local mason_tool_installer = require("mason-tool-installer")

                        mason_tool_installer.setup({
                                ensure_installed = {
                                        "prettier",
                                        "stylua",
                                        "isort",
                                        "black",
                                },
                        })
                end,
        },
        {
                "Bekaboo/dropbar.nvim",
                dependencies = {
                        "nvim-telescope/telescope-fzf-native.nvim",
                },
        },
        {
                "williamboman/mason-lspconfig.nvim",
                config = function()
                        require("mason-lspconfig").setup({
                                ensure_installed = {
                                        "bashls",
                                        "lua_ls",
                                        "pyright",
                                        "ast_grep",
                                        "emmet_language_server",
                                        "graphql",
                                },
                        })
                end,
        },
        {
                "folke/noice.nvim",
                event = "VeryLazy",
                opts = {
                        presets = {
                                bottom_search = false,
                                command_palette = true,
                        },
                },
                dependencies = {
                        "MunifTanjim/nui.nvim",
                        "rcarriga/nvim-notify",
                },
        },
        {
                "akinsho/bufferline.nvim",
                dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin/nvim" },
                after = "catppuccin",
                config = function()
                        require("bufferline").setup({
                                highlights = require("catppuccin.groups.integrations.bufferline").get(),
                                options = {
                                        diagnostics = "nvim_lsp",
                                        show_buffer_close_icons = true,
                                        show_close_icon = true,
                                        color_icons = true,
                                        show_buffer_icons = true,
                                        left_trunc_marker = "",
                                        right_trunc_marker = "",
                                        show_tab_indicators = true,
                                        offsets = {
                                                {
                                                        filetype = "NvimTree",
                                                        text = "File Explorer",
                                                        text_align = "center",
                                                        padding = 0,
                                                },
                                        },
                                },
                        })
                end,
        },
        {
                "folke/which-key.nvim",
                event = "VeryLazy",
                init = function()
                        vim.o.timeout = false
                        vim.o.timeoutlen = 300
                end,
                opts = {},
        },
        {
                "windwp/nvim-autopairs",
                event = { "InsertEnter" },
                dependencies = {
                        "hrsh7th/nvim-cmp",
                },
                config = function()
                        local autopairs = require("nvim-autopairs")

                        autopairs.setup({
                                check_ts = true,
                                ts_config = {
                                        lua = { "string" },
                                        javascript = { "template_string" },
                                        java = false,
                                },
                        })
                        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
                        local cmp = require("cmp")
                        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
                end,
        },
        {
                "neovim/nvim-lspconfig",
                event = { "BufReadPre", "BufNewFile" },
                dependencies = {
                        "hrsh7th/cmp-nvim-lsp",
                        { "antosha417/nvim-lsp-file-operations", config = true },
                        { "folke/neodev.nvim", opts = {} },
                },
                config = function()
                        local lspconfig = require("lspconfig")
                        local mason_lspconfig = require("mason-lspconfig")
                        local cmp_nvim_lsp = require("cmp_nvim_lsp")
                        local capabilities = cmp_nvim_lsp.default_capabilities()
                        local keymap = vim.keymap -- for conciseness
                        vim.api.nvim_create_autocmd("LspAttach", {
                                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                                callback = function(ev)
                                        local opts = { buffer = ev.buf, silent = true }

                                        -- set keybinds
                                        opts.desc = "Show LSP references"
                                        keymap.set("n", "gR", "cmdTelescope lsp_references<CR>", opts) -- show definition, references

                                        opts.desc = "Go to declaration"
                                        keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

                                        opts.desc = "Show LSP definitions"
                                        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

                                        opts.desc = "Show LSP implementations"
                                        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

                                        opts.desc = "Show LSP type definitions"
                                        keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

                                        opts.desc = "See available code actions"
                                        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

                                        opts.desc = "Smart rename"
                                        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

                                        opts.desc = "Show buffer diagnostics"
                                        keymap.set("n", "<leader>D)", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

                                        opts.desc = "Show line diagnostics"
                                        keymap.set("n", "<leader>d)", vim.diagnostic.open_float, opts) -- show diagnostics for line

                                        opts.desc = "Go to previous diagnostic"
                                        keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

                                        opts.desc = "Go to next diagnostic"
                                        keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

                                        opts.desc = "Show documentation for what is under cursor"
                                        keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

                                        opts.desc = "Restart LSP"
                                        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
                                end,
                        })

                        local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
                        for type, icon in pairs(signs) do
                                local hl = "DiagnosticSign" .. type
                                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
                        end
                        mason_lspconfig.setup_handlers({
                                function(server_name)
                                        lspconfig[server_name].setup({
                                                capabilities = capabilities,
                                        })
                                end,
                                ["pyright"] = function()
                                        lspconfig["pyright"].setup({
                                                on_attach = function() end,
                                                capabilities = capabilities,
                                        })
                                end,
                                ["graphql"] = function()
                                        lspconfig["graphql"].setup({
                                                capabilities = capabilities,
                                                filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
                                        })
                                end,
                                ["bashls"] = function()
                                        lspconfig["bashls"].setup({
                                                capabilities = capabilities,
                                                on_attach = function() end,
                                                filetypes = { "sh" },
                                        })
                                end,
                                ["ast_grep"] = function()
                                        lspconfig["ast_grep"].setup({
                                                capabilities = capabilities,
                                                on_attach = function() end,
                                        })
                                end,
                                ["emmet_ls"] = function()
                                        lspconfig["emmet_ls"].setup({
                                                capabilities = capabilities,
                                                filetypes = {
                                                        "html",
                                                        "typescriptreact",
                                                        "javascriptreact",
                                                        "javascript",
                                                        "css",
                                                        "sass",
                                                        "scss",
                                                        "less",
                                                        "svelte",
                                                },
                                        })
                                end,
                                ["lua_ls"] = function()
                                        lspconfig["lua_ls"].setup({
                                                capabilities = capabilities,
                                                filetypes = { "lua" },
                                                settings = {
                                                        Lua = {
                                                                diagnostics = {
                                                                        globals = { "vim" },
                                                                },
                                                                completion = {
                                                                        callSnippet = "Replace",
                                                                },
                                                        },
                                                },
                                        })
                                end,
                        })
                end,
        },
        {
                "hrsh7th/nvim-cmp",
                event = { "InsertEnter", "CmdlineEnter" },
                dependencies = {
                        "hrsh7th/cmp-buffer",
                        "hrsh7th/cmp-nvim-lsp",
                        "hrsh7th/cmp-buffer",
                        "hrsh7th/cmp-path",
                        "hrsh7th/cmp-cmdline",
                        {
                                "L3MON4D3/LuaSnip",
                                version = "v2.*",
                                build = "make install_jsregexp",
                        },
                        "saadparwaiz1/cmp_luasnip",
                        "rafamadriz/friendly-snippets",
                        "onsails/lspkind.nvim",
                },
                config = function()
                        local cmp = require("cmp")
                        local luasnip = require("luasnip")
                        local lspkind = require("lspkind")
                        require("luasnip.loaders.from_vscode").lazy_load()
                        local function border(hl_name)
                                return {
                                        { "╭", hl_name },
                                        { "─", hl_name },
                                        { "╮", hl_name },
                                        { "│", hl_name },
                                        { "╯", hl_name },
                                        { "─", hl_name },
                                        { "╰", hl_name },
                                        { "│", hl_name },
                                }
                        end
                        cmp.setup({
                                completion = {
                                        completeopt = "menu,menuone,preview,noselect",
                                },
                                snippet = {
                                        expand = function(args)
                                                luasnip.lsp_expand(args.body)
                                        end,
                                },
                                mapping = {
                                        ["<Tab>"] = cmp.mapping.select_next_item(),
                                        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                                        ["<C-n>"] = cmp.mapping.scroll_docs(-4),
                                        ["<C-p>"] = cmp.mapping.scroll_docs(4),
                                        ["<CR>"] = cmp.mapping.confirm({ select = true }),
                                },
                                sources = cmp.config.sources({
                                        { name = "nvim_lsp", max_item_count = 10 },
                                        { name = "luasnip", max_item_count = 5 },
                                        { name = "buffer", max_item_count = 8 },
                                        { name = "path", max_item_count = 5 },
                                }),
                                formatting = {
                                        format = lspkind.cmp_format({
                                                maxwidth = 50,
                                                ellipsis_char = "...",
                                        }),
                                },
                                window = {
                                        completion = cmp.config.window.bordered(border("CmpBorder")),
                                        documentation = cmp.config.window.bordered(border("CmpDocBorder")),
                                },
                        })
                        cmp.setup.cmdline("/", {
                                mapping = cmp.mapping.preset.cmdline(),
                                sources = {
                                        { name = "buffer" },
                                },
                        })
                        cmp.setup.cmdline(":", {
                                mapping = cmp.mapping.preset.cmdline(),
                                sources = cmp.config.sources({
                                        { name = "path" },
                                }, {
                                        { name = "cmdline" },
                                }),
                        })
                end,
        },
        {
                "kyazdani42/nvim-tree.lua",
                dependencies = { "kyazdani42/nvim-web-devicons" },
                config = function()
                        require("nvim-tree").setup()
                end,
        },
        {
                "tpope/vim-fugitive",
        },
        {
                "nvim-telescope/telescope.nvim",
                dependencies = { "nvim-lua/plenary.nvim" },
                config = function()
                        require("telescope").setup({
                                defaults = {
                                        mappings = {
                                                i = {
                                                        ["<C-j>"] = require("telescope.actions").move_selection_next,
                                                        ["<C-k>"] = require("telescope.actions").move_selection_previous,
                                                },
                                        },
                                },
                        })
                end,
        },
        {
                "stevearc/conform.nvim",
                config = function()
                        require("conform").setup({
                                format_on_save = {
                                        timeout_ms = 500,
                                        lsp_format = "fallback",
                                },
                                formatters_by_ft = {
                                        lua = { "stylua" },
                                        javascript = { "prettier" },
                                        typescript = { "prettier" },
                                        css = { "prettier" },
                                        javascriptreact = { "prettier" },
                                        typescriptreact = { "prettier" },
                                        python = { "isort", "black" },
                                        json = { "prettier" },
                                        yaml = { "prettier" },
                                        html = { "prettier" },
                                        sh = { "shfmt" },
                                },
                        })
                end,
        },
        {
                "nvim-lualine/lualine.nvim",
                dependencies = { "kyazdani42/nvim-web-devicons", opt = true },
                config = function()
                        require("lualine").setup({
                                options = { theme = "catppuccin" },
                        })
                end,
        },
        {
                "kylechui/nvim-surround",
                version = "*",
                event = "VeryLazy",
                config = function()
                        require("nvim-surround").setup({})
                end,
        },
        {
                "tpope/vim-commentary",
        },
        {
                "romainl/vim-cool",
        },
        {
                "stevearc/dressing.nvim",
                event = "VeryLazy",
        },
        {
                "junegunn/vim-easy-align",
        },
        {
                "lukas-reineke/indent-blankline.nvim",
                event = { "BufReadPre", "BufNewFile" },
                main = "ibl",
                opts = {
                        indent = {
                                char = "┊",
                                tab_char = "┊",
                        },
                        scope = { enabled = false },
                        exclude = {
                                filetypes = { "help", "neo-tree", "lazy", "mason" },
                        },
                },
        },
})
-- General Neovim settings
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.tabstop = 4 -- Number of spaces tabs count for
vim.opt.shiftwidth = 4 -- Number of spaces for auto-indents
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.smartcase = true -- Smart case when searching
vim.opt.ignorecase = true -- Ignore case in search
vim.opt.undofile = true -- enable undofile
vim.opt.splitright = true -- Vertical splits open on the right
vim.opt.splitbelow = true -- Horizontal splits open below
vim.opt.mouse = "a" -- Enable mouse support
vim.opt.cmdheight = 0 --hide cmd bar
vim.opt.termguicolors = true --use termguicolors
vim.opt.wrap = false --disable text wrapping
vim.opt.smartcase = true --use smartcase
vim.opt.ignorecase = true --ignorecase
vim.opt.clipboard = "unnamedplus"

vim.cmd.colorscheme("catppuccin")

-- Keybindings
vim.g.mapleader = " "

--nvim-tree
vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true }) -- Toggle file explorer

--telescope
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { noremap = true, silent = true }) -- Fuzzy find files
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>", { noremap = true, silent = true }) -- Fuzzy grep search
vim.keymap.set("n", "<leader>fr", ":Telescope oldfiles<CR>", { noremap = true, silent = true }) -- Fuzzy recent files
vim.keymap.set("n", "<leader>fc", ":Telescope grep_string<CR>", { noremap = true, silent = true }) -- Fuzzy string under cursor in cwd

--custom
vim.keymap.set("n", "W", "b", { noremap = true })
vim.keymap.set("n", ";", ":", { noremap = true })
vim.keymap.set("n", "x", '"_x', { noremap = true })
vim.keymap.set("n", "c", '"_c', { noremap = true })
vim.keymap.set("n", "d", '"_d', { noremap = true })
vim.keymap.set("v", "d", '"_d', { noremap = true })
vim.keymap.set("v", "c", '"_c', { noremap = true })
vim.keymap.set("n", "zz", "<Cmd>q!<CR>", { desc = "Write Quit" })
vim.keymap.set("n", "Z", "<Cmd>wq!<CR>", { desc = "Quit" })
vim.keymap.set("n", "J", "mzJ`Z")
vim.keymap.set(
        "n",
        "<leader>s",
        [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
        { desc = "replace under cursor" }
)
vim.api.nvim_set_keymap("n", "S", ":%s//g<left><left>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "p", ":set paste<CR>p:set nopaste<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "P", ":set paste<CR>P:set nopaste<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "yy", "^vg_y", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "p", ":set paste<CR>p:set nopaste<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-S-v>", '<Esc>:set paste<CR>"+gP:set nopaste<CR>', { noremap = true, silent = true })
vim.keymap.set("n", "<A-h>", "^", { desc = "To the first non-blank char of the line" })
vim.keymap.set("n", "<A-l>", "$", { desc = "To the end of the line" })

--better up/down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

--beter up/down page
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

--changing windows
vim.keymap.set("n", "<C-h>", "<C-w>h", { remap = true, desc = "Go to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { remap = true, desc = "Go to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { remap = true, desc = "Go to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { remap = true, desc = "Go to right window" })

--buffer
vim.keymap.set("n", "<leader>bp", ":BufferLinePick<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>bn", ":BufferLineCycleNext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>bp", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-h>", "<Cmd>BufferLineCyclePrev<CR>", { noremap = true, silent = true, desc = "Prev buffer" })
vim.keymap.set("n", "<S-l>", "<Cmd>BufferLineCycleNext<CR>", { noremap = true, silent = true, desc = "Next buffer" })
vim.keymap.set("n", "<leader>bd", "<Cmd>bd<CR>", { noremap = true, silent = true, desc = "Close buffer" })

--window size
vim.keymap.set("n", "<A-Down>", "<Cmd>resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<A-Up>", "<Cmd>resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<A-Right>", "<Cmd>vertical resize -2<CR>", { desc = "Increase window width" })
vim.keymap.set("n", "<A-Left>", "<Cmd>vertical resize +2<CR>", { desc = "Decrease window width" })

--splits
vim.keymap.set("n", "<leader>-", "<C-w>s", { desc = "Split below" })
vim.keymap.set("n", "<leader>|", "<C-w>v", { desc = "Split right" })

--package manager
vim.keymap.set("n", "<leader>pl", "<CMD>Lazy<CR>", { desc = "Lazy" })
vim.keymap.set("n", "<leader>pm", "<CMD>Mason<CR>", { desc = "Mason " })

--dismiss notifications
vim.keymap.set("n", "<leader>nd", "<cmd>NoiceDismiss<CR>", { desc = "Dissmiss Notifications" })

--:q uses force quit
vim.api.nvim_command("command! -bang Q q!")
vim.cmd("cabbrev q q!")
