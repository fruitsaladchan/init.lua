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
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        run = ":TSUpdate",
        branch = 'master',
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
            })
        end,
    },
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
            })
        end,
    },
    {
        "windwp/nvim-autopairs",
        event = { "InsertEnter" },
        config = true
    },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local lspconfig = require("lspconfig")
            local mason_lspconfig = require("mason-lspconfig")
            local capabilities = require('blink.cmp').get_lsp_capabilities()
            local keymap = vim.keymap -- for conciseness
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                callback = function(ev)
                    local opts = { buffer = ev.buf, silent = true }

                    -- set keybinds
                    keymap.set("n", "gR", "cmdTelescope lsp_references<CR>", opts) -- show definition, references

                    keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

                    keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

                    keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

                    keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

                    keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

                    keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

                    keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show diagnostics for file

                    keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

                    keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

                    keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

                    keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

                    keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
                end,
            })

            vim.diagnostic.config({
                virtual_text = true,
                virtual_lines = false,
                underline = true
            })

            mason_lspconfig.setup({
                handlers = {
                    function(server_name)
                        lspconfig[server_name].setup({
                            capabilities = capabilities,
                        })
                    end,
                },
            })
        end,
    },
    {
        'saghen/blink.cmp',
        dependencies = { 'rafamadriz/friendly-snippets' },
        version = '1.*',
        opts = {
            keymap = {
                preset = "none",
                ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
                ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },

                ["<Up>"] = { "select_prev", "fallback" },
                ["<Down>"] = { "select_next", "fallback" },

                ["<C-u>"] = { "scroll_documentation_up", "fallback" },
                ["<C-d>"] = { "scroll_documentation_down", "fallback" },

                ["<C-e>"] = { "hide", "fallback" },
                ["<CR>"] = { "accept", "fallback" },
            },
            appearance = {
                nerd_font_variant = 'normal'
            },
            completion = {
                keyword = { range = "full" },
                trigger = { show_on_backspace = false },
                list = {
                    selection = {
                        preselect = false,
                        auto_insert = false,
                    },
                },
                documentation = { auto_show = true, auto_show_delay_ms = 0 },
                menu = {
                    auto_show = true,
                    draw = {
                        columns = {
                            { "label", "label_description", gap = 1 },
                            { "kind_icon", "kind" }
                        },
                    }
                },
            },
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },
            cmdline = {
                completion = {
                    menu = {
                        auto_show = true,
                    },
                    list = {
                        selection = {
                            preselect = false,
                            auto_insert = false,
                        },
                    },
                },
                keymap = { preset = "inherit" },
            },
            fuzzy = { implementation = "prefer_rust_with_warning" },
        },
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
                            ["<Esc>"] = require('telescope.actions').close
                        },
                        n = {
                            ["<Esc>"] = require('telescope.actions').close
                        }
                    },
                    pickers = {
                        find_files = {
                            hidden = true,
                            previewer = false,
                            theme = "dropdown",
                        },
                    }
                },
            })
        end,
    },
    {
        "kylechui/nvim-surround",
        keys = {
            { "ys", desc = "Add surround" },
            { "ds", desc = "Delete surround" },
            { "rs", desc = "Replace surround" },
        },
        opts = { move_cursor = true },
    },
})
-- General Neovim settings
vim.opt.number = true         -- Show line numbers
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.undofile = true       -- enable undofile
vim.opt.swapfile = false      -- Don't create swap files
vim.opt.splitright = true     -- Vertical splits open on the right
vim.opt.splitbelow = true     -- Horizontal splits open below
vim.opt.mouse = "a"           -- Enable mouse support
vim.opt.clipboard = "unnamedplus" --use system clipboard
vim.opt.title = true
vim.opt.hidden = true
vim.opt.errorbells = false
vim.opt.backspace = "indent,eol,start"
vim.opt.iskeyword:append("-", "_")  -- Treat dash and underscore as part of word
vim.opt.path:append("**")      -- include subdirectories in search
vim.opt.modifiable = true      --buffer modifications
vim.opt.encoding = "UTF-8"     --encoding
vim.cmd.set("wildmenu")
vim.opt.wrap = false      --disable text wrapping
vim.opt.scrolloff = 10    -- Keep 10 lines above/below cursor

--visual
vim.opt.termguicolors = true  --use termguicolors
vim.opt.signcolumn = "yes"
vim.opt.cmdheight = 1         -- cmd bar height
-- vim.opt.colorcolumn = "150"   -- Show column at 100 characters
vim.opt.winborder = "rounded"
vim.opt.showmatch = true      -- Highlight matching brackets
vim.o.showtabline = 2 --awlays show tab line

--indentation
vim.opt.tabstop = 4           -- Number of spaces tabs count for
vim.opt.shiftwidth = 4        -- Number of spaces for auto-indents
vim.opt.expandtab = true      -- Use spaces instead of tabs
vim.opt.smartindent = true    -- Smart auto-indenting
vim.opt.autoindent = true     -- Copy indent from current line

-- Performance changes
vim.opt.redrawtime = 10000
vim.opt.maxmempattern = 20000

--netrw
vim.g.loaded_netrwPlugin = 1
vim.g.netrw_browse_split = 4
vim.g.netrw_altv = 1
vim.g.netrw_keepdir = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 4
vim.keymap.set("n", "<C-n>", ":15Lex<CR>", { noremap = true, silent = true })
vim.g.netrw_hide = '' --show dotfiles

--search settings
vim.opt.incsearch = true  --show matches at typs
vim.opt.cursorline = true -- Highlight current line
vim.opt.hlsearch = true   -- highlight search results
vim.opt.smartcase = true  --use smartcase
vim.opt.ignorecase = true --ignorecase

--set theme 
vim.cmd.colorscheme("gruvbox-material")
--transparency
-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
-- vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
-- vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })

-- Keybindings
vim.g.mapleader = " " --space key

--telescope
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { noremap = true, silent = true })  -- Fuzzy find files
vim.keymap.set("n", "<leader>fw", ":Telescope current_buffer_fuzzy_find<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>", { noremap = true, silent = true })   -- Fuzzy grep search
vim.keymap.set("n", "<leader>fr", ":Telescope oldfiles<CR>", { noremap = true, silent = true })    -- Fuzzy recent files
vim.keymap.set("n", "<leader>fc", ":Telescope grep_string<CR>", { noremap = true, silent = true }) -- Fuzzy string under cursor in cwd
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>", { noremap = true, silent = true })     -- Fuzzy find buffers
vim.keymap.set("n", "<leader>ft", ":Telescope colorscheme<CR>", { noremap = true, silent = true }) -- Fuzzy find buffers
local nvim_config_path = vim.fn.stdpath('config') --Fuzzy find config files
vim.keymap.set('n', '<leader>fn', function()
  require('telescope.builtin').find_files({
    prompt_title = 'Neovim Config Files',
    cwd = nvim_config_path,
    hidden = true,
  })
end, { noremap = true, silent = true })

--custom
vim.keymap.set("n", "<C-c>", ":nohlsearch<CR>", { desc = "Clear search highlights" })
vim.keymap.set("n", "W", "b", { noremap = true })
vim.keymap.set("n", "<A-h>", "^", { desc = "To the first non-blank char of the line" })
vim.keymap.set("n", "<A-l>", "$", { desc = "To the end of the line" })
vim.keymap.set("n", ";", ":", { noremap = true })
vim.keymap.set('n', '\\', ';', { noremap = true })
vim.keymap.set("n", "x", '"_x', { noremap = true }) -------
vim.keymap.set("n", "c", '"_c', { noremap = true }) --
vim.keymap.set("n", "d", '"_d', { noremap = true }) -- stop from copying to clipboard
vim.keymap.set("v", "d", '"_d', { noremap = true }) --
vim.keymap.set("v", "c", '"_c', { noremap = true }) -------
vim.keymap.set("n", "qq", "<Cmd>q!<CR>", { desc = "Write Quit" })
vim.keymap.set("n", "<leader>w", "<Cmd>w<CR>", { desc = "Write" })
vim.keymap.set("n", "J", "mzJ`z")

vim.api.nvim_set_keymap("n", "<leader>s", ":%s//g<left><left>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "yy", "^vg_y", { noremap = true, silent = true })

--better up/down
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")

--beter up/down page
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

--changing windows
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true, remap = true, desc = "Go to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true, remap = true, desc = "Go to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true, remap = true, desc = "Go to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true, remap = true, desc = "Go to right window" })

--buffers
vim.keymap.set("n", "H", ":bprevious<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "L", ":bnext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { noremap = true, silent = true })

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

-- user group
local augroup = vim.api.nvim_create_augroup("UserConfig", {})

-- highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup,
    callback = function()
        vim.highlight.on_yank()
    end,
})

--create dir when saving a file if it dosent exit
vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("mvim_pde_auto_create_dir", { clear = true }),
    callback = function(event)
        local file = vim.uv.fs_realpath(event.match) or event.match
        if not event.match:match("^%w%w+:[\\/][\\/]") then
            vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
        end
    end,
})

--goto last edit position when opening file
vim.api.nvim_create_autocmd("BufReadPost", {
    group = augroup,
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- Auto-resize splits when window is resized
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup,
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

--terminal
local terminal_state = {
  buf = nil,
  win = nil,
  is_open = false
}

local function FloatingTerminal()
  -- If terminal is already open, close it (toggle behavior)
  if terminal_state.is_open and vim.api.nvim_win_is_valid(terminal_state.win) then
    vim.api.nvim_win_close(terminal_state.win, false)
    terminal_state.is_open = false
    return
  end

  -- Create buffer if it doesn't exist or is invalid
  if not terminal_state.buf or not vim.api.nvim_buf_is_valid(terminal_state.buf) then
    terminal_state.buf = vim.api.nvim_create_buf(false, true)
    -- Set buffer options for better terminal experience
    vim.api.nvim_buf_set_option(terminal_state.buf, 'bufhidden', 'hide')
  end

  -- Calculate window dimensions
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Create the floating window
  terminal_state.win = vim.api.nvim_open_win(terminal_state.buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
  })

  -- Set transparency for the floating window
  vim.api.nvim_win_set_option(terminal_state.win, 'winblend', 0)

  -- Set transparent background for the window
  vim.api.nvim_win_set_option(terminal_state.win, 'winhighlight',
    'Normal:FloatingTermNormal,FloatBorder:FloatingTermBorder')


  -- Start terminal if not already running
  local has_terminal = false
  local lines = vim.api.nvim_buf_get_lines(terminal_state.buf, 0, -1, false)
  for _, line in ipairs(lines) do
    if line ~= "" then
      has_terminal = true
      break
    end
  end

  if not has_terminal then
    vim.fn.termopen(os.getenv("SHELL"))
  end

  terminal_state.is_open = true

  vim.cmd("startinsert")

  -- Set up auto-close on buffer leave 
  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = terminal_state.buf,
    callback = function()
      if terminal_state.is_open and vim.api.nvim_win_is_valid(terminal_state.win) then
        vim.api.nvim_win_close(terminal_state.win, false)
        terminal_state.is_open = false
      end
    end,
    once = true
  })
end

-- Function to explicitly close the terminal
local function CloseFloatingTerminal()
  if terminal_state.is_open and vim.api.nvim_win_is_valid(terminal_state.win) then
    vim.api.nvim_win_close(terminal_state.win, false)
    terminal_state.is_open = false
  end
end

-- terminal mappings
vim.keymap.set("n", "<leader>t", FloatingTerminal, { noremap = true, silent = true, desc = "Toggle floating terminal" })
vim.keymap.set("t", "<Esc>", function()
  if terminal_state.is_open then
    vim.api.nvim_win_close(terminal_state.win, false)
    terminal_state.is_open = false
  end
end, { noremap = true, silent = true, desc = "Close floating terminal from terminal mode" })


-- custom tabline
vim.o.tabline = "%!v:lua.BufferLine()"

function _G.BufferLine()
  local s = ''
  local current = vim.fn.bufnr('%')
  local buffers = vim.fn.getbufinfo({ buflisted = 1 })

  for _, buf in ipairs(buffers) do
    local name = vim.fn.fnamemodify(buf.name, ':t')
    if name == '' then name = '[No Name]' end

    -- Add dot for unsaved buffers
    local modified = buf.changed == 1 and '  ' or ''

    -- Set highlight
    if buf.bufnr == current then
      s = s .. '%#TabLineSel#'
    else
      s = s .. '%#TabLine#'
    end

    s = s .. '%' .. buf.bufnr .. 'T' .. ' [' .. name .. modified .. '] '
  end

  s = s .. '%#TabLineFill#%='
  return s
end

