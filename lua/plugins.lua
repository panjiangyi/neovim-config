
local packer = require("packer")
packer.startup({
  function(use)
   -- Packer 可以管理自己本身
    use 'wbthomason/packer.nvim'
    -- 你的插件列表...
    use "folke/tokyonight.nvim"
    use "mhartington/oceanic-next"
    -- nvim-tree (新增)
    use({ "kyazdani42/nvim-tree.lua", requires = "kyazdani42/nvim-web-devicons" })
    use({ "akinsho/bufferline.nvim", requires = { "kyazdani42/nvim-web-devicons", "moll/vim-bbye" }})
    use({ "nvim-lualine/lualine.nvim", requires = { "kyazdani42/nvim-web-devicons" } })
    use("arkav/lualine-lsp-progress")
    use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
    --------------------- LSP --------------------
    use({ "williamboman/mason.nvim" })
    use({ "williamboman/mason-lspconfig.nvim" })
    -- Lspconfig
    use({ "neovim/nvim-lspconfig" })
    use({"glepnir/dashboard-nvim", requires = {'nvim-tree/nvim-web-devicons'}})
    use("ahmedkhalf/project.nvim")
    use { 'nvim-telescope/telescope.nvim', requires = { "nvim-lua/plenary.nvim" } }
  end,
  config = {
    display = {
        open_fn = function()
          return require("packer.util").float({ border = "single" })
        end,
    },
  },
})
-- 每次保存 plugins.lua 自动安装插件
pcall(
  vim.cmd,
  [[
    augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
    augroup end
  ]]
)
