require('config.lazy')
require('config.neotree')

-- Basic settings from init.vim
vim.opt.number = true          -- 显示绝对行号
vim.opt.relativenumber = true  -- 显示相对行号（可选）
vim.opt.clipboard = "unnamedplus"

-- FZF mapping (you'll need to install fzf.vim plugin for this to work)
vim.keymap.set('n', '<C-p>', ':FZF<CR')


