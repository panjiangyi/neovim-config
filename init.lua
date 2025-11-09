require('config.lazy')
require('config.neotree')
require('keybindings')
require('plugin-config.telescope')
-- Basic settings from init.vim
vim.opt.relativenumber = true  -- 显示相对行号（可选）
vim.opt.number = true  -- 显示行号
vim.opt.clipboard = "unnamedplus"

-- Git signs 配置：始终显示 signcolumn（避免布局抖动）
vim.opt.signcolumn = "yes"  -- 显示符号列，用于显示 git 状态


