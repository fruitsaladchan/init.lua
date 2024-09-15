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
  dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin/nvim" },
  after = "catppuccin",  -- Ensure it loads after Catppuccin
  config = function()
    require("bufferline").setup {
      highlights = require("catppuccin.groups.integrations.bufferline").get(),  -- Use Catppuccin colors for bufferline
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
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {
  },
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
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-buffer", -- source for text in buffer
    "hrsh7th/cmp-path", -- source for file system paths
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    {
      "L3MON4D3/LuaSnip",
      version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
      build = "make install_jsregexp",
    },
    "saadparwaiz1/cmp_luasnip", -- for autocompletion
    "rafamadriz/friendly-snippets", -- useful snippets
    "onsails/lspkind.nvim", -- vs-code like pictograms
  },
  config = function()
    local cmp = require("cmp")

    local luasnip = require("luasnip")

    local lspkind = require("lspkind")

    -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
    require("luasnip.loaders.from_vscode").lazy_load()

    cmp.setup({
      completion = {
        completeopt = "menu,menuone,preview,noselect",
      },
      snippet = { -- configure how nvim-cmp interacts with snippet engine
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
      -- sources for autocompletion
      sources = cmp.config.sources({
        { name = "luasnip" }, -- snippets
        { name = "buffer" }, -- text within current buffer
        { name = "path" }, -- file system paths
      }),

      -- configure lspkind for vs-code like pictograms in completion menu
      formatting = {
        format = lspkind.cmp_format({
          maxwidth = 50,
          ellipsis_char = "...",
        }),
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
        -- Add configuration options here if needed
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "black" },
          -- Add other filetypes and formatters as needed
        },
      })
    end,
  },

{
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  opts = function()
    local banner = [[
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣶⣶⣶⣶⣤⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣶⣶⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢈⣹⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⢀⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠊⣿⣿⣟⡿⣿⣿⣿⣿⡿⡁⣿⣿⣿⠀⠀⠀⠀⣀⣤⡾⣦⣄⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⣀⣴⣾⠋⠉⣻⡷⢦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠃⢽⣿⣿⠿⢻⠏⠑⢀⣿⣿⣿⣀⣠⡶⠋⢹⣷⣄⢠⣿⣿⡶⣤⡀⠀⠀⠀
⠀⠀⣀⣴⣾⢫⣿⡿⠀⣾⣿⠇⠀⣼⡟⠛⠛⣻⣿⣧⣀⣴⣶⣾⣿⣿⣷⣶⣄⣰⡟⣻⣿⡟⠉⣿⣷⡀⠘⣿⣿⠀⠙⢿⣇⢼⣿⣷⢦⣄
⣴⡞⢹⣿⡿⣸⠟⠀⠀⣿⠏⠀⢸⣿⡟⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣿⣿⡇⠀⠻⣿⡇⠀⠈⢻⠀⠀⠀⠛⠌⠻⣿⡠⣿
⣿⡏⡿⠏⠀⠁⠀⠀⠀⠃⠀⠀⠸⡿⠀⠀⢸⣿⣻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣙⣿⠁⠀⠀⠹⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠃⠙
⠋⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠀⠀⢘⠃⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡆⠸⠀⠀⠀⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⠛⣿⣿⣿⣿⣿⣿⣿⣿⡿⣿⣿⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⣰⡀⢀⡀⣻⣄⡀⢀⣠⣴⣿⣿⣿⠃⢠⣿⣿⣿⣿⣿⣿⣿⣿⡆⠹⣿⣿⣿⣶⣄⡀⢀⣰⣏⣀⣀⣠⣇⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠙⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠋⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣇⠀⠀⠙⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⠏⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠈⠁⠈⠉⠛⠋⠁⠀⠀⠀⠀⢰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⠀⠀⠀⠀⠈⠙⠛⠛⠉⠉⠛⠀⠀⠀⠀⠀⠀⠀⠀

   ]]
    banner = string.rep("\n", 7) .. banner .. "\n"
    local opts = {
      theme = "doom",
      hide = {
        statusline = false,
        tabline = false,
        winbar = false,
      },
      config = {
        header = vim.split(banner, "\n"),
        center = {
          { action = "ene | startinsert",     desc = " New file",     icon = " ", key = "n", icon_hl = "Character" },
          { action = "Telescope find_files",  desc = " Find file",    icon = " ", key = "f", icon_hl = "Label" },
          { action = "Telescope live_grep",   desc = " Find text",    icon = " ", key = "g", icon_hl = "Special" },
          { action = "Telescope oldfiles",    desc = " Recent files", icon = " ", key = "r", icon_hl = "Macro" },
          { action = "qa",                    desc = " Quit",         icon = " ", key = "q", icon_hl = "Error" },
        },
        footer = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)

          local version = vim.version()

          return {
            string.format(
              " Neovim v%d.%d.%d%s",
              version.major,
              version.minor,
              version.patch,
              version.prerelease and "(nightly)" or ""
            ) .. " loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms",
          }
        end,
      },
    }

    for _, button in ipairs(opts.config.center) do
      button.key_format = "%s"
      button.key_hl = "Constant"
      button.desc_hl = "CursorLineNr"
      button.desc = button.desc .. string.rep(" ", 50 - #button.desc)
    end

    if vim.o.filetype == "lazy" then
      vim.api.nvim_create_autocmd("WinClosed", {
        pattern = tostring(vim.api.nvim_get_current_win()),
        once = true,
        callback = function()
          vim.schedule(function()
            vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
          end)
        end,
      })
    end

    return opts
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

--nvim-tree
vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true }) -- Toggle file explorer

--telescope
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { noremap = true }) -- Fuzzy find files
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>", { noremap = true }) -- Fuzzy grep search
vim.keymap.set("n", "<leader>fr", ":Telescope oldfiles<CR>", { noremap = true }) -- Fuzzy recent files
vim.keymap.set("n", "<leader>fc", ":Telescope grep_string<CR>", { noremap = true }) -- Fuzzy string under cursor in cwd

--custom
vim.keymap.set('n', 'W', 'b', { noremap = true })
vim.keymap.set('n', ';', ':', { noremap = true })
vim.keymap.set('n', 'x', '"_x', { noremap = true })
vim.keymap.set('n', 'c', '"_c', { noremap = true })
vim.keymap.set('n', 'd', '"_d', { noremap = true })
vim.keymap.set('v', 'd', '"_d', { noremap = true })
vim.keymap.set('v', 'c', '"_c', { noremap = true })
vim.keymap.set("n", "zz", "<Cmd>q!<CR>", { desc = "Quit" })
vim.keymap.set("n", "Z", "<Cmd>wq!<CR>", { desc = "Quit" })
vim.api.nvim_set_keymap('n', 'S', ':%s//g<left><left>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'p', ':set paste<CR>p:set nopaste<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'P', ':set paste<CR>P:set nopaste<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'yy', '^vg_y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'p', ':set paste<CR>p:set nopaste<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-S-v>', '<Esc>:set paste<CR>"+gP:set nopaste<CR>', { noremap = true, silent = true })
vim.keymap.set("n", "<A-h>", "^", { desc = "To the first non-blank char of the line" })
vim.keymap.set("n", "<A-l>", "$", { desc = "To the end of the line" })

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

--window height
vim.keymap.set("n", "<A-Down>", "<Cmd>resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<A-Up>", "<Cmd>resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<A-Left>", "<Cmd>vertical resize -2<CR>", { desc = "Increase window width" })
vim.keymap.set("n", "<A-Right>", "<Cmd>vertical resize +2<CR>", { desc = "Decrease window width" })

--splits
vim.keymap.set("n", "<leader>-", "<C-w>s", { desc = "Split below" })
vim.keymap.set("n", "<leader>|", "<C-w>v", { desc = "Split right" })
