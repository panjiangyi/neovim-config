-- ============================================================================
-- Neovim 快捷键配置文件
-- ============================================================================
-- 说明：
-- 1. 取消注释（删除 --）来启用快捷键
-- 2. <leader> 键已在 config/lazy.lua 中设置为空格键 " "
-- 3. 修改后保存，运行 :source % 或重启 Neovim 生效
-- 4. 查看所有快捷键：:Telescope keymaps
-- ============================================================================

local map = vim.keymap.set

local function opts(desc)
  return { noremap = true, silent = true, desc = desc }
end

-- 插件快捷键表（用于导出给其他插件使用）
local pluginKeys = {}

-- Leader 键已在 config/lazy.lua 中设置为空格键
-- 如需修改，请在 config/lazy.lua 中修改，而不是在这里

-- ============================================================================
-- 基本编辑快捷键
-- ============================================================================

-- 保存和退出
-- map("n", "<C-s>", ":w<CR>", opts("Save file"))
-- map("i", "<C-s>", "<Esc>:w<CR>a", opts("Save file in insert mode"))
map("n", "<leader>w", ":w<CR>", opts("Save"))
-- map("n", "<leader>q", ":q<CR>", opts("Quit"))
-- map("n", "<leader>x", ":x<CR>", opts("Save and quit"))

-- 取消搜索高亮
map("n", "<leader>nh", ":noh<CR>", opts("Clear search highlight"))

-- 窗口分屏
-- map("n", "<leader>sv", ":vsplit<CR>", opts("Split vertically"))
-- map("n", "<leader>sh", ":split<CR>", opts("Split horizontally"))
-- map("n", "<leader>sc", ":close<CR>", opts("Close window"))

-- 窗口导航
-- map("n", "<C-h>", "<C-w>h", opts("Go to left window"))
-- map("n", "<C-j>", "<C-w>j", opts("Go to bottom window"))
-- map("n", "<C-k>", "<C-w>k", opts("Go to top window"))
-- map("n", "<C-l>", "<C-w>l", opts("Go to right window"))

-- 缩进（保持选择）
-- map("v", "<", "<gv", opts("Indent left"))
-- map("v", ">", ">gv", opts("Indent right"))

-- 移动行
-- map("n", "<A-j>", ":m .+1<CR>==", opts("Move line down"))
-- map("n", "<A-k>", ":m .-2<CR>==", opts("Move line up"))
-- map("v", "<A-j>", ":m '>+1<CR>gv=gv", opts("Move selection down"))
-- map("v", "<A-k>", ":m '<-2<CR>gv=gv", opts("Move selection up"))

-- 复制粘贴增强
-- map("n", "<leader>y", '"+y', opts("Copy to system clipboard"))
-- map("v", "<leader>y", '"+y', opts("Copy to system clipboard"))
-- map("n", "<leader>p", '"+p', opts("Paste from system clipboard"))

-- 快速跳转（滚动后居中）
-- map("n", "<C-d>", "<C-d>zz", opts("Half page down and center"))
-- map("n", "<C-u>", "<C-u>zz", opts("Half page up and center"))
-- map("n", "n", "nzzzv", opts("Next search result and center"))
-- map("n", "N", "Nzzzv", opts("Previous search result and center"))

-- ============================================================================
-- Telescope 模糊查找（已启用）
-- ============================================================================

map("n", "<C-p>", "<Cmd>Telescope find_files<CR>", opts("Find files"))
map("n", "<C-f>", "<Cmd>Telescope live_grep<CR>", opts("Live grep"))

-- 其他 Telescope 功能
-- map("n", "<leader>fb", "<Cmd>Telescope buffers<CR>", opts("Find buffers"))
-- map("n", "<leader>fh", "<Cmd>Telescope help_tags<CR>", opts("Find help"))
-- map("n", "<leader>fo", "<Cmd>Telescope oldfiles<CR>", opts("Find recent files"))
-- map("n", "<leader>fk", "<Cmd>Telescope keymaps<CR>", opts("Find keymaps"))
-- map("n", "<leader>fd", "<Cmd>Telescope diagnostics<CR>", opts("Find diagnostics"))

-- ============================================================================
-- Buffer 缓冲区管理
-- ============================================================================

-- BufferLine 快捷键已在 plugins.lua 中配置：
-- <leader>bn  - 下一个缓冲区
-- <leader>bp  - 上一个缓冲区
-- <leader>bc  - 关闭当前缓冲区

-- 额外的 Buffer 快捷键
-- map("n", "<S-l>", ":bnext<CR>", opts("Next buffer"))
-- map("n", "<S-h>", ":bprevious<CR>", opts("Previous buffer"))

-- ============================================================================
-- LSP 快捷键（在 plugin-config/lsp.lua 中自动设置）
-- ============================================================================

-- 这些快捷键在 LSP attach 时自动生效：
-- gd           - 跳转到定义
-- K            - 显示悬停文档
-- <space>rn    - 重命名符号
-- gr           - 查找引用
-- [d           - 上一个诊断
-- ]d           - 下一个诊断
-- <leader>ca   - 代码操作（修复）
-- <leader>dr   - 刷新诊断
--
-- Trouble.nvim 诊断面板（类似 VSCode 的 Problems 面板）：
-- <leader>xx   - 打开/切换工作区诊断（所有文件的诊断）
-- <leader>xw   - 打开/切换当前文件的诊断
-- <leader>xd   - 只显示错误（过滤警告和信息）
-- <leader>xe   - 显示当前行的诊断（浮动窗口）

-- 额外的 LSP 快捷键
-- map("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))
-- map("n", "gi", vim.lsp.buf.implementation, opts("Go to implementation"))

-- ============================================================================
-- DAP 调试快捷键（在 plugin-config/dap.lua 中已配置）
-- ============================================================================

-- 这些快捷键已自动设置：
-- <leader>db   - 切换断点
-- <leader>dc   - 开始/继续调试
-- <leader>di   - 单步进入
-- <leader>do   - 单步跳过
-- <leader>du   - 单步跳出
-- <leader>ds   - 停止调试
-- <leader>dg   - 运行到光标处
-- <leader>dh   - 显示变量信息

-- ============================================================================
-- Neo-tree 文件树快捷键
-- ============================================================================

-- Neo-tree 快捷键
map("n", "<C-n>", ":Neotree filesystem reveal left<CR>", opts("Open file tree"))
map("n", "<leader>e", ":Neotree filesystem toggle<CR>", opts("Toggle file tree"))
map("n", "<leader>bf", ":Neotree buffers reveal float<CR>", opts("Show buffer tree"))
-- 注意：<leader>gs 被 gitsigns 使用（暂存 hunk），如果需要打开 Git 状态视图，可以使用其他快捷键
-- map("n", "<leader>gS", ":Neotree git_status reveal left<CR>", opts("Git status"))  -- 可选：使用 gS 代替

-- 临时关闭文件树的快捷键（仅用于特殊需求）
map("n", "<leader>ec", ":Neotree close<CR>", opts("Close file tree"))

-- Neo-tree 窗口内快捷键：
-- <CR>         - 打开文件/目录
-- <Space>      - 展开/折叠目录
-- a            - 新建文件
-- A            - 新建目录
-- d            - 删除
-- r            - 重命名
-- x            - 剪切
-- y            - 复制
-- p            - 粘贴
-- m            - 移动到指定路径
-- H            - 切换显示隐藏文件
-- q            - 关闭 Neo-tree (用 q 代替 ESC)

-- ============================================================================
-- 终端模式
-- ============================================================================

-- map("n", "<leader>tt", ":terminal<CR>", opts("Open terminal"))
-- map("t", "<Esc>", "<C-\\><C-n>", opts("Exit terminal mode"))

-- ============================================================================
-- 代码格式化
-- ============================================================================

-- map("n", "<leader>fm", function() require("conform").format({ async = true, lsp_fallback = true }) end, opts("Format file"))

-- ============================================================================
-- Git 操作（gitsigns.nvim）
-- ============================================================================

-- 设置 gitsigns 快捷键的函数
-- 这个函数会被 gitsigns.lua 的 on_attach 调用
function pluginKeys.setup_gitsigns_keymaps(bufnr)
  local gitsigns = require("gitsigns")
  local buffer_opts = { buffer = bufnr, noremap = true, silent = true }
  
  -- 导航到上一个/下一个 hunk
  map('n', ']g', function()
    if vim.wo.diff then return ']g' end
    vim.schedule(function() gitsigns.next_hunk() end)
    return '<Ignore>'
  end, vim.tbl_extend('force', buffer_opts, { expr = true, desc = 'Next hunk' }))
  
  map('n', '[g', function()
    if vim.wo.diff then return '[g' end
    vim.schedule(function() gitsigns.prev_hunk() end)
    return '<Ignore>'
  end, vim.tbl_extend('force', buffer_opts, { expr = true, desc = 'Previous hunk' }))
  
  -- 暂存/撤销暂存当前 hunk
  map('n', '<leader>gs', gitsigns.stage_hunk, vim.tbl_extend('force', buffer_opts, { desc = 'Stage hunk' }))
  map('v', '<leader>gs', function() gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, vim.tbl_extend('force', buffer_opts, { desc = 'Stage hunk' }))
  
  map('n', '<leader>gu', gitsigns.undo_stage_hunk, vim.tbl_extend('force', buffer_opts, { desc = 'Undo stage hunk' }))
  
  -- 重置当前 hunk
  map('n', '<leader>gr', gitsigns.reset_hunk, vim.tbl_extend('force', buffer_opts, { desc = 'Reset hunk' }))
  map('v', '<leader>gr', function() gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, vim.tbl_extend('force', buffer_opts, { desc = 'Reset hunk' }))
  
  -- 预览当前 hunk
  map('n', '<leader>gp', gitsigns.preview_hunk, vim.tbl_extend('force', buffer_opts, { desc = 'Preview hunk' }))
  
  -- 显示当前行的 blame
  map('n', '<leader>gb', function() gitsigns.blame_line({ full = true }) end, vim.tbl_extend('force', buffer_opts, { desc = 'Blame line' }))
  
  -- 显示差异
  map('n', '<leader>gd', gitsigns.diffthis, vim.tbl_extend('force', buffer_opts, { desc = 'Diff this' }))
  map('n', '<leader>gD', function() gitsigns.diffthis('~') end, vim.tbl_extend('force', buffer_opts, { desc = 'Diff this ~' }))
  
  -- 切换行内 blame 显示
  map('n', '<leader>gt', gitsigns.toggle_current_line_blame, vim.tbl_extend('force', buffer_opts, { desc = 'Toggle line blame' }))
  
  -- 切换删除的行显示
  map('n', '<leader>gtd', gitsigns.toggle_deleted, vim.tbl_extend('force', buffer_opts, { desc = 'Toggle deleted' }))
end

-- Git 快捷键说明（gitsigns.nvim）：
-- ]g            - 下一个 hunk
-- [g            - 上一个 hunk
-- <leader>gs    - 暂存当前 hunk（normal/visual 模式）
--                 ⚠️ 注意：此快捷键会覆盖 neo-tree 的 Git 状态视图快捷键
--                 在 Git 仓库的文件中，<leader>gs 用于暂存 hunk
-- <leader>gu    - 撤销暂存当前 hunk
-- <leader>gr    - 重置当前 hunk（normal/visual 模式）
-- <leader>gp    - 预览当前 hunk
-- <leader>gb    - 显示当前行的 blame
-- <leader>gd    - 显示差异
-- <leader>gD    - 显示差异（与 HEAD~1 对比）
-- <leader>gt    - 切换行内 blame 显示
-- <leader>gtd   - 切换删除的行显示

-- ============================================================================
-- 插件管理
-- ============================================================================

-- map("n", "<leader>l", ":Lazy<CR>", opts("Open Lazy"))
-- map("n", "<leader>m", ":Mason<CR>", opts("Open Mason"))

-- ============================================================================
-- 其他实用功能
-- ============================================================================

-- 快速编辑配置
-- map("n", "<leader>ev", ":edit $MYVIMRC<CR>", opts("Edit init.lua"))
-- map("n", "<leader>sv", ":source $MYVIMRC<CR>", opts("Reload init.lua"))

-- 显示/复制文件路径
-- map("n", "<leader>fp", ":echo expand('%:p')<CR>", opts("Show file path"))
-- map("n", "<leader>cp", ":let @+ = expand('%:p')<CR>", opts("Copy file path"))

-- ============================================================================
-- 自定义快捷键区域（在这里添加你的快捷键）
-- ============================================================================

-- 示例：
-- map("n", "<leader>h", ":echo 'Hello!'<CR>", opts("Say hello"))

-- ============================================================================

-- Telescope 配置（给 telescope.lua 使用）
pluginKeys.telescopeList = {
  i = {
    ["<C-j>"] = "move_selection_next",
    ["<C-k>"] = "move_selection_previous",
    ["<Down>"] = "move_selection_next",
    ["<Up>"] = "move_selection_previous",
    ["<C-n>"] = "cycle_history_next",
    ["<C-p>"] = "cycle_history_prev",
    ["<C-c>"] = "close",
    ["<C-u>"] = "preview_scrolling_up",
    ["<C-d>"] = "preview_scrolling_down",
  },
}

return pluginKeys

