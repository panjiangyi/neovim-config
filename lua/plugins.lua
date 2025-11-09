return {
  -- You can add your plugins here
  -- Example:
  -- {
  --   "nvim-telescope/telescope.nvim",
  --   tag = "0.1.5",
  --   dependencies = { "nvim-lua/plenary.nvim" }
  -- },

  -- Colorscheme: Tokyo Night (supports Tree-sitter)
{
  'catppuccin/nvim',
  name = 'catppuccin',
  lazy = false,
  priority = 1000,
  config = function()
    require('catppuccin').setup({
      flavour = 'mocha', -- latte, frappe, macchiato, mocha
    })
    vim.cmd([[colorscheme catppuccin]])
  end,
},

  -- Neo-tree.nvim
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    }
  },

  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("plugin-config.dashboard")
    end,
  },

  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      vim.opt.termguicolors = true

      require("bufferline").setup({
        options = {
          diagnostics = "nvim_lsp",
          separator_style = "slant",
          offsets = {
            {
              filetype = "neo-tree",
              text = "Explorer",
              text_align = "left",
              separator = true,
            },
          },
        },
      })

      local map = vim.keymap.set
      map("n", "<leader>bn", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
      map("n", "<leader>bp", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer" })
      map("n", "<leader>bc", "<Cmd>bdelete<CR>", { desc = "Close buffer" })
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "LinArcX/telescope-env.nvim",
    },
    config = function()
      require("plugin-config.telescope")
    end,
  },

  {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy",
    config = function()
      require("plugin-config.project")
    end,
  },

  -- nvim-treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      require("nvim-treesitter.configs").setup(require("plugin-config.nvim-treesitter"))

      -- 开启 Folding 模块
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
      vim.opt.foldlevel = 99
    end,
  },

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      require("plugin-config.lsp")
    end,
  },

  -- Mason for managing LSP servers
  {
    "mason-org/mason.nvim",
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })
    end,
  },

  -- Bridge between mason.nvim and lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "eslint", "ts_ls", "jsonls", "html", "cssls" },
        automatic_installation = true,
      })
    end,
  },

  -- Bridge between mason.nvim and dap
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    config = function()
      require("mason-nvim-dap").setup({
        ensure_installed = { "js-debug-adapter" },
        automatic_installation = true,
      })
    end,
  },

  -- Completion system
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      require("plugin-config.cmp")
    end,
  },

  -- LuaSnip for snippets
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      require("plugin-config.luasnip")
    end,
  },

  -- Linting
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("plugin-config.nvim-lint")
    end,
  },

  -- Formatting
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("plugin-config.conform")
    end,
  },

  -- Debug Adapter Protocol
  {
    "mfussenegger/nvim-dap",
    config = function()
      require("plugin-config.dap")
    end,
  },

  -- Git signs (显示 git 状态，类似 VSCode)
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("plugin-config.gitsigns")
    end,
  },

  -- Trouble.nvim: 类似 VSCode 的问题面板
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("plugin-config.trouble")
    end,
  },

}