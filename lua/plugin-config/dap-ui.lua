local dapui = require("dapui")

-- 配置 dap-ui
dapui.setup({
  icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
  mappings = {
    -- 使用内置的展开/折叠
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  -- 使用内联表达式评估（在代码中显示变量值）
  expand_lines = vim.fn.has("nvim-0.7") == 1,
  -- 布局配置
  layouts = {
    {
      elements = {
        -- 元素可以按字符串或表来配置
        { id = "scopes", size = 0.25 },
        "breakpoints",
        "stacks",
        "watches",
      },
      size = 40,
      position = "left",
    },
    {
      elements = {
        "repl",
        "console",
      },
      size = 10,
      position = "bottom",
    },
  },
  controls = {
    -- 需要 Neovim 0.8+
    enabled = true,
    -- 显示控制按钮
    element = "repl",
    icons = {
      pause = "⏸",
      play = "▶",
      step_into = "⏬",
      step_over = "⏭",
      step_out = "⏫",
      step_back = "⏮",
      run_last = "▶▶",
      terminate = "⏹",
    },
  },
  floating = {
    max_height = nil, -- 这些可以是整数或浮点数
    max_width = nil,  -- 浮动窗口的最大尺寸
    border = "single", -- 边框样式
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
  render = {
    max_type_length = nil, -- 可以设置为数字来限制类型名称的长度
    max_value_lines = 100, -- 可以设置为数字来限制值显示的行数
  },
})

