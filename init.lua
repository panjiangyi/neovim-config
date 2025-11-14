-- 保存启动时的工作目录（防止 Telescope 搜索范围改变）
vim.g.initial_cwd = vim.fn.getcwd()

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

-- 减少按键延迟时间（解决 Ctrl+w 等组合键的延迟问题）
vim.opt.timeoutlen = 300-- 等待组合键的时间（毫秒），默认 1000ms


