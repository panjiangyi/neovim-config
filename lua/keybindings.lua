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

-- Buffer 历史记录（用于恢复最近关闭的 buffer）
local buffer_history = {}
local max_history = 20 -- 最多保存 20 个历史记录

-- 记录关闭的 buffer
local function record_closed_buffer(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  local buftype = vim.api.nvim_buf_get_option(bufnr, "buftype")
  local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
  
  -- 只记录普通文件 buffer，排除插件窗口
  if buftype == "" and name ~= "" and 
     filetype ~= "neo-tree" and
     filetype ~= "Trouble" and
     filetype ~= "dashboard" and
     not name:match("neo%-tree") and
     not name:match("Trouble") then
    -- 检查是否已存在（避免重复）
    for i, entry in ipairs(buffer_history) do
      if entry.path == name then
        table.remove(buffer_history, i)
        break
      end
    end
    -- 添加到历史记录开头
    table.insert(buffer_history, 1, {
      path = name,
      bufnr = bufnr,
      filetype = filetype,
    })
    -- 限制历史记录数量
    if #buffer_history > max_history then
      table.remove(buffer_history)
    end
  end
end

-- 监听 buffer 关闭事件（使用多个事件确保捕获）
vim.api.nvim_create_autocmd("BufDelete", {
  callback = function(args)
    record_closed_buffer(args.buf)
  end,
})

vim.api.nvim_create_autocmd("BufWipeout", {
  callback = function(args)
    record_closed_buffer(args.buf)
  end,
})

-- 插件快捷键表（用于导出给其他插件使用）
local pluginKeys = {}

-- Leader 键已在 config/lazy.lua 中设置为空格键
-- 如需修改，请在 config/lazy.lua 中修改，而不是在这里

-- ============================================================================
-- 基本编辑快捷键
-- ============================================================================

-- 保存和退出
-- Ctrl+s: 保存所有文件（类似 VSCode 的 Save All）
map("n", "<C-s>", "<Cmd>wall<CR>", opts("Save all files"))
map("i", "<C-s>", "<Esc><Cmd>wall<CR>a", opts("Save all files in insert mode"))
map("v", "<C-s>", "<Esc><Cmd>wall<CR>", opts("Save all files in visual mode"))

map("n", "<leader>w", ":w<CR>", opts("Save current file"))
-- map("n", "<leader>q", ":q<CR>", opts("Quit"))
-- map("n", "<leader>x", ":x<CR>", opts("Save and quit"))

-- Ctrl+w: 关闭当前 buffer（类似 VSCode）
-- 注意：这会覆盖 Vim 默认的窗口操作前缀，窗口操作改用 <leader>w 开头
map("n", "<C-w>", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local buftype = vim.api.nvim_buf_get_option(bufnr, "buftype")
  
  -- 不关闭特殊 buffer（neo-tree、trouble 等）
  if buftype ~= "" then
    return
  end
  
  -- 检查 buffer 是否为空（无文件名或新建的空 buffer）
  local function is_empty_buffer(buf)
    local name = vim.api.nvim_buf_get_name(buf)
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    -- 空 buffer: 没有文件名 且 只有一行空内容
    return name == "" and #lines == 1 and lines[1] == ""
  end
  
  -- 获取所有普通 buffer
  local buffers = vim.tbl_filter(function(buf)
    return vim.api.nvim_buf_is_valid(buf) 
      and vim.api.nvim_buf_get_option(buf, "buflisted")
      and vim.api.nvim_buf_get_option(buf, "buftype") == ""
  end, vim.api.nvim_list_bufs())
  
  -- 如果只有一个 buffer，切换到空 buffer 而不是关闭
  if #buffers <= 1 then
    vim.cmd("enew")
  else
    -- 有多个 buffer，智能切换
    -- 先尝试切换到左边
    vim.cmd("BufferLineCyclePrev")
    local left_buf = vim.api.nvim_get_current_buf()
    
    -- 如果左边是空 buffer，尝试切换到右边
    if is_empty_buffer(left_buf) then
      -- 先回到原来的 buffer
      vim.cmd("BufferLineCycleNext")
      -- 再切换到右边
      vim.cmd("BufferLineCycleNext")
      local right_buf = vim.api.nvim_get_current_buf()
      
      -- 如果右边也是空 buffer，还是切回左边
      if is_empty_buffer(right_buf) then
        vim.cmd("BufferLineCyclePrev")
        vim.cmd("BufferLineCyclePrev")
      end
    end
  end
  
  -- 关闭之前的 buffer（如果它不是当前显示的）
  if vim.api.nvim_buf_is_valid(bufnr) and bufnr ~= vim.api.nvim_get_current_buf() then
    vim.api.nvim_buf_delete(bufnr, { force = false })
  end
end, opts("Close current buffer"))

-- 取消搜索高亮
map("n", "<leader>nh", ":noh<CR>", opts("Clear search highlight"))

-- 窗口分屏（由于 Ctrl+w 被重新映射为关闭 buffer，窗口操作改用 leader+w 开头）
map("n", "<leader>wv", ":vsplit<CR>", opts("Split vertically"))
map("n", "<leader>wh", ":split<CR>", opts("Split horizontally"))
map("n", "<leader>wc", ":close<CR>", opts("Close window"))
map("n", "<leader>wo", ":only<CR>", opts("Close other windows"))

-- 窗口导航（保持原有的 Ctrl+hjkl）
map("n", "<C-h>", "<C-w>h", opts("Go to left window"))
map("n", "<C-j>", "<C-w>j", opts("Go to bottom window"))
map("n", "<C-k>", "<C-w>k", opts("Go to top window"))
map("n", "<C-l>", "<C-w>l", opts("Go to right window"))

-- 窗口大小调整
map("n", "<leader>w=", "<C-w>=", opts("Equal window size"))
map("n", "<leader>w>", ":vertical resize +5<CR>", opts("Increase window width"))
map("n", "<leader>w<", ":vertical resize -5<CR>", opts("Decrease window width"))
map("n", "<leader>w+", ":resize +5<CR>", opts("Increase window height"))
map("n", "<leader>w-", ":resize -5<CR>", opts("Decrease window height"))

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
-- <S-A-t>     - 关闭除了当前 buffer 之外的所有 buffer（只关闭代码文件，不包括插件窗口）
-- Shift+Ctrl+t - 直接打开最近关闭的文件（类似 VSCode，不显示列表）
-- <C-e>       - 打开最近文件列表选择（显示列表）
-- <leader>br  - 打开最近文件列表选择（显示列表，备选）

-- 额外的 Buffer 快捷键
-- map("n", "<S-l>", ":bnext<CR>", opts("Next buffer"))
-- map("n", "<S-h>", ":bprevious<CR>", opts("Previous buffer"))

-- 快速切换 Buffer 标签（顶部栏）
map("n", "<A-.>", "<Cmd>BufferLineCycleNext<CR>", opts("Next buffer tab"))
map("n", "<A-,>", "<Cmd>BufferLineCyclePrev<CR>", opts("Previous buffer tab"))

-- 关闭除了当前 buffer 之外的所有 buffer（只关闭代码文件，不包括插件窗口）
-- 快捷键：Shift + Alt + t
map("n", "<S-A-t>", function()
  local current_buf = vim.api.nvim_get_current_buf()
  local buffers = vim.api.nvim_list_bufs()
  
  -- 先记录要关闭的 buffer（在关闭前记录）
  local buffers_to_close = {}
  for _, buf in ipairs(buffers) do
    if buf ~= current_buf then
      local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
      local filetype = vim.api.nvim_buf_get_option(buf, "filetype")
      local name = vim.api.nvim_buf_get_name(buf)
      
      -- 只关闭普通文件 buffer，排除插件窗口
      -- buftype 为空或 "" 表示普通文件
      -- 排除 neo-tree、trouble、dashboard 等插件的 buffer
      if buftype == "" and 
         filetype ~= "neo-tree" and
         filetype ~= "Trouble" and
         filetype ~= "dashboard" and
         not name:match("neo%-tree") and
         not name:match("Trouble") then
        -- 在关闭前记录
        record_closed_buffer(buf)
        table.insert(buffers_to_close, buf)
      end
    end
  end
  
  -- 关闭所有需要关闭的 buffer
  for _, buf in ipairs(buffers_to_close) do
    vim.api.nvim_buf_delete(buf, { force = false })
  end
end, opts("Close other buffers (keep current)"))

-- 恢复最近关闭的 buffer
-- Shift+Ctrl+t：直接打开最近关闭的文件（类似 VSCode）
-- Ctrl+e：打开文件列表选择
-- leader+br：打开文件列表选择（备选）
map("n", "<C-T>", function()
  -- 直接打开最近关闭的第一个文件
  local oldfiles = vim.v.oldfiles
  if not oldfiles or #oldfiles == 0 then
    vim.notify("没有最近打开的文件", vim.log.levels.WARN)
    return
  end
  
  -- 查找第一个存在且未打开的文件
  for _, file in ipairs(oldfiles) do
    if vim.fn.filereadable(file) == 1 then
      -- 检查是否已经在某个 buffer 中打开
      local is_open = false
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_get_name(buf) == file then
          is_open = true
          break
        end
      end
      -- 找到第一个未打开的文件，直接打开
      if not is_open then
        vim.cmd("edit " .. vim.fn.fnameescape(file))
        return
      end
    end
  end
  
  vim.notify("没有可恢复的文件", vim.log.levels.WARN)
end, opts("Reopen last closed file (Shift+Ctrl+t)"))

map("n", "<C-e>", "<Cmd>Telescope oldfiles<CR>", opts("Browse recent files (Ctrl+e)"))
map("n", "<leader>br", "<Cmd>Telescope oldfiles<CR>", opts("Browse recent files (leader+br)"))

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

