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
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

  {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        highlight = { enable = true },
        indent = { enable = true },
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
        ensure_installed = { "bashls", "pyright" }, 
      })
    end,
  },
{
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("bufferline").setup{
        options = {
          diagnostics = "nvim_lsp",
          show_buffer_close_icons = true,
          show_close_icon = true,
          left_trunc_marker = "",
          right_trunc_marker = "",
        },
      }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("lspconfig").bashls.setup{}

      require("lspconfig").pyright.setup{}
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip", -- Snippet engine
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = {
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.scroll_docs(-4),
          ["<C-p>"] = cmp.mapping.scroll_docs(4),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        },
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
              ["<C-n>"] = require("telescope.actions").move_selection_next,
              ["<C-p>"] = require("telescope.actions").move_selection_previous,
            },
          },
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
    "tpope/vim-surround",
  },

  {
    "tpope/vim-commentary",
  },

  {
    "junegunn/vim-easy-align",
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("ibl").setup({
        scope = {
          show_start = true,
          show_end = true,
        },
      })
    end,
  },
})

-- General Neovim settings
vim.opt.number = true              -- Show line numbers
vim.opt.relativenumber = true      -- Relative line numbers
vim.opt.tabstop = 4                -- Number of spaces tabs count for
vim.opt.shiftwidth = 4             -- Number of spaces for auto-indents
vim.opt.expandtab = true           -- Use spaces instead of tabs
vim.opt.smartcase = true           -- Smart case when searching
vim.opt.ignorecase = true          -- Ignore case in search
vim.opt.splitright = true          -- Vertical splits open on the right
vim.opt.splitbelow = true          -- Horizontal splits open below
vim.opt.mouse = "a"                -- Enable mouse support

-- Set the Catppuccin colorscheme
vim.cmd.colorscheme("catppuccin")

-- Keybindings
vim.g.mapleader = " "
vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true }) -- Toggle file explorer
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { noremap = true }) -- Fuzzy find files
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>", { noremap = true }) -- Fuzzy grep search
vim.keymap.set('n', 'W', 'b', { noremap = true })
vim.keymap.set('n', ';', ':', { noremap = true })
vim.keymap.set('n', 'x', '"_x', { noremap = true })
vim.keymap.set('n', 'c', '"_c', { noremap = true })
vim.keymap.set('n', 'd', '"_d', { noremap = true })
vim.keymap.set('v', 'd', '"_d', { noremap = true })
vim.keymap.set('v', 'c', '"_c', { noremap = true })
vim.keymap.set("n", "<C-h>", "<C-w>h", { remap = true, desc = "Go to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { remap = true, desc = "Go to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { remap = true, desc = "Go to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { remap = true, desc = "Go to right window" })
vim.keymap.set("n", "zz", "<Cmd>q!<CR>", { desc = "Quit" })
vim.keymap.set("n", "Z", "<Cmd>wq!<CR>", { desc = "Quit" })
vim.keymap.set("n", "<leader>bp", ":BufferLinePick<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>bn", ":BufferLineCycleNext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>bp", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-h>", "<Cmd>BufferLineCyclePrev<CR>", { noremap = true, silent = true, desc = "Prev buffer" })
vim.keymap.set("n", "<S-l>", "<Cmd>BufferLineCycleNext<CR>", { noremap = true, silent = true, desc = "Next buffer" })
vim.keymap.set("n", "<leader>bd", "<Cmd>bd<CR>", { noremap = true, silent = true, desc = "Close buffer" })

keymap("n", "<A-Down>", "<Cmd>resize +2<CR>", { desc = "Increase window height" })
keymap("n", "<A-Up>", "<Cmd>resize -2<CR>", { desc = "Decrease window height" })
keymap("n", "<A-Left>", "<Cmd>vertical resize -2<CR>", { desc = "Increase window width" })
keymap("n", "<A-Right>", "<Cmd>vertical resize +2<CR>", { desc = "Decrease window width" })
  
vim.api.nvim_set_keymap('n', 'S', ':%s//g<left><left>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'p', ':set paste<CR>p:set nopaste<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'P', ':set paste<CR>P:set nopaste<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'yy', '^vg_y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'p', ':set paste<CR>p:set nopaste<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-S-v>', '<Esc>:set paste<CR>"+gP:set nopaste<CR>', { noremap = true, silent = true })
