require("trouble").setup({
  -- 自动打开（不自动打开，手动控制）
  auto_open = false,
  -- 自动关闭（当没有诊断时）
  auto_close = false,
  -- 自动预览（在代码中高亮对应的位置）
  auto_preview = true,
  -- 自动折叠（折叠已解决的问题）
  auto_fold = false,
  -- 使用诊断符号
  use_diagnostic_signs = true,
  -- 分组诊断（按文件分组）
  group = true,
  -- 填充
  padding = false,
  -- 模式（默认显示工作区诊断）
  mode = "workspace_diagnostics", -- workspace_diagnostics | document_diagnostics | quickfix | loclist
  -- 严重程度过滤（nil = 显示所有）
  severity = nil, -- nil = 所有, vim.diagnostic.severity.ERROR = 只有错误
  -- 高度
  height = 10,
  -- 宽度
  width = 50,
  -- 位置
  position = "bottom", -- bottom | top | left | right
  -- 动作键配置
  action_keys = {
    -- 关闭
    close = "q",
    -- 取消
    cancel = "<esc>",
    -- 刷新
    refresh = "r",
    -- 跳转
    jump = { "<cr>", "<tab>", "<2-leftmouse>" },
    -- 跳转并打开
    jump_open = { "o", "<cr>" },
    -- 跳转并分割
    jump_split = { "s" },
    -- 跳转并垂直分割
    jump_vsplit = { "v" },
    -- 跳转并标签页
    jump_tab = { "t" },
    -- 跳转到上一个
    jump_close = { "q" },
    -- 跳转到下一个并关闭折叠
    jump_close_folds = { "zc" },
    -- 切换模式
    toggle_mode = "m",
    -- 切换预览
    toggle_preview = "P",
    -- 悬停
    hover = "K",
    -- 预览
    preview = "p",
    -- 关闭折叠
    close_folds = { "zM", "zm" },
    -- 打开折叠
    open_folds = { "zR", "zr" },
    -- 切换折叠
    toggle_fold = { "za", "zA" },
    -- 上一个
    previous = "k",
    -- 下一个
    next = "j",
    -- 帮助
    help = "?",
  },
})

