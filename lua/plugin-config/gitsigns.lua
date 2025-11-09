local gitsigns = require("gitsigns")

gitsigns.setup({
  -- 启用行号高亮（类似 VSCode 的行号颜色）
  numhl = true,
  
  -- 启用 signcolumn（行号左边的列）
  signcolumn = true,
  
  -- 配置符号和颜色
  signs = {
    add          = { text = '│', numhl = 'GitSignsAdd', linehl = '', show_count = false },
    change       = { text = '│', numhl = 'GitSignsChange', linehl = '', show_count = false },
    delete       = { text = '_', numhl = 'GitSignsDelete', linehl = '', show_count = false },
    topdelete    = { text = '‾', numhl = 'GitSignsDelete', linehl = '', show_count = false },
    changedelete = { text = '~', numhl = 'GitSignsChange', linehl = '', show_count = false },
    untracked    = { text = '┆', numhl = 'GitSignsAdd', linehl = '', show_count = false },
  },
  
  -- 当前行的变更高亮
  current_line_blame = false, -- 不在当前行显示 blame
  
  -- 预览 hunk 的选项
  preview_config = {
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },
  
  -- 性能优化
  update_debounce = 100,
  
  -- 显示差异时跳过的行数
  max_file_length = 40000,
  
  -- 在保存时自动暂存（可选，默认关闭）
  auto_attach = true,
  
  -- 附加到缓冲区时的配置
  on_attach = function(bufnr)
    -- 从 keybindings.lua 中加载快捷键配置
    local pluginKeys = require("keybindings")
    if pluginKeys.setup_gitsigns_keymaps then
      pluginKeys.setup_gitsigns_keymaps(bufnr)
    end
  end,
})

-- 自定义高亮颜色（适配 catppuccin mocha 主题）
-- 新增行的颜色（绿色）
vim.api.nvim_set_hl(0, 'GitSignsAdd', {
  fg = '#a6e3a1',  -- catppuccin green
  bg = 'NONE',
  bold = false,
})

-- 修改行的颜色（黄色）
vim.api.nvim_set_hl(0, 'GitSignsChange', {
  fg = '#f9e2af',  -- catppuccin yellow
  bg = 'NONE',
  bold = false,
})

-- 删除行的颜色（红色）
vim.api.nvim_set_hl(0, 'GitSignsDelete', {
  fg = '#f38ba8',  -- catppuccin red
  bg = 'NONE',
  bold = false,
})

-- 行号背景高亮（可选，如果需要行号背景色变化）
-- 这些颜色会根据主题自动调整
vim.api.nvim_set_hl(0, 'GitSignsAddNr', {
  fg = '#a6e3a1',
  bg = 'NONE',
})

vim.api.nvim_set_hl(0, 'GitSignsChangeNr', {
  fg = '#f9e2af',
  bg = 'NONE',
})

vim.api.nvim_set_hl(0, 'GitSignsDeleteNr', {
  fg = '#f38ba8',
  bg = 'NONE',
})

-- 如果使用 signcolumn，可以设置符号列的背景色
vim.api.nvim_set_hl(0, 'GitSignsAddInline', {
  bg = '#1e3a2e',  -- 深绿色背景（可选）
  bold = false,
})

vim.api.nvim_set_hl(0, 'GitSignsChangeInline', {
  bg = '#3a3021',  -- 深黄色背景（可选）
  bold = false,
})

vim.api.nvim_set_hl(0, 'GitSignsDeleteInline', {
  bg = '#3a2024',  -- 深红色背景（可选）
  bold = false,
})

