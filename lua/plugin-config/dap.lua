local dap = require("dap")
local dapUtils = require("dap.utils")
local map = vim.keymap.set

-- 配置 Node.js 调试适配器
-- 直接使用 js-debug-adapter 命令（Mason 会自动将其添加到 PATH）
dap.adapters["pwa-node"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = "js-debug-adapter",
    args = { "${port}" },
  },
  skipFiles = {
    "<node_internals>/**",
    "**/node_modules/**/*",
  },
}

-- Node.js 调试配置
dap.configurations.javascript = {
  {
    type = "pwa-node",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    cwd = "${workspaceFolder}",
    sourceMaps = true,
    protocol = "inspector",
    skipFiles = {
      "<node_internals>/**",
      "node_modules/**",
    },
  },
  {
    type = "pwa-node",
    request = "attach",
    name = "Attach to Process",
    processId = dapUtils.pick_process,
    cwd = "${workspaceFolder}",
    sourceMaps = true,
  },
}

-- TypeScript 也使用相同的配置
dap.configurations.typescript = dap.configurations.javascript
dap.configurations.javascriptreact = dap.configurations.javascript
dap.configurations.typescriptreact = dap.configurations.javascript

-- 辅助函数：从指定目录向上查找虚拟环境中的 Python 路径
-- 优先检查 .venv (uv 默认), 然后 venv, 最后使用系统 Python
local function find_python_path(start_path)
  start_path = start_path or vim.fn.getcwd()
  
  -- 从起始路径向上查找，直到找到虚拟环境或到达根目录
  local current = vim.fn.fnamemodify(start_path, ":p")
  
  while current and current ~= "/" do
    -- uv 通常使用 .venv，优先检查
    local venv_paths = {
      current .. "/.venv/bin/python",
      current .. "/venv/bin/python",
    }
    
    for _, path in ipairs(venv_paths) do
      if vim.fn.executable(path) == 1 then
        return path
      end
    end
    
    -- 向上查找父目录
    local parent = vim.fn.fnamemodify(current, ":h")
    if parent == current then
      break
    end
    current = parent
  end
  
  -- 如果没有找到虚拟环境，使用系统 Python
  return "python"
end

-- 辅助函数：从当前上下文查找 Python 路径
-- 优先从当前文件所在目录向上查找，然后从工作目录查找
local function get_python_for_config()
  -- 尝试从当前缓冲区获取文件路径
  local current_file = vim.api.nvim_buf_get_name(0)
  if current_file and current_file ~= "" then
    local file_dir = vim.fn.fnamemodify(current_file, ":p:h")
    local python_path = find_python_path(file_dir)
    if python_path ~= "python" then
      return python_path
    end
  end
  
  -- 从当前工作目录查找
  return find_python_path(vim.fn.getcwd())
end

-- 配置 Python 调试适配器 (debugpy)
-- 由于适配器配置在模块加载时确定，我们需要一个能在运行时查找 Python 的方法
-- 我们会在启动调试时重新设置适配器，确保使用虚拟环境中的 Python
dap.adapters.debugpy = {
  type = "executable",
  -- 初始化时使用当前工作目录查找（会在启动调试时更新）
  command = find_python_path(vim.fn.getcwd()),
  args = { "-m", "debugpy.adapter" },
}

-- Python 调试配置
-- 使用函数动态查找虚拟环境中的 Python（支持 uv 的 .venv）
dap.configurations.python = {
  {
    type = "debugpy",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    python = function()
      -- 从当前文件和工作目录向上查找虚拟环境（优先 .venv，uv 的默认路径）
      -- 首先尝试从当前缓冲区获取文件路径
      local current_file = vim.api.nvim_buf_get_name(0)
      if current_file and current_file ~= "" then
        local file_dir = vim.fn.fnamemodify(current_file, ":p:h")
        local python_path = find_python_path(file_dir)
        if python_path ~= "python" then
          return python_path
        end
      end
      -- 从工作目录查找
      return find_python_path(vim.fn.getcwd())
    end,
    cwd = "${workspaceFolder}",
    console = "integratedTerminal",
  },
  {
    type = "debugpy",
    request = "launch",
    name = "Launch file with arguments",
    program = "${file}",
    args = function()
      local args_string = vim.fn.input("Arguments: ")
      return vim.split(args_string, " +")
    end,
    python = function()
      local current_file = vim.api.nvim_buf_get_name(0)
      if current_file and current_file ~= "" then
        local file_dir = vim.fn.fnamemodify(current_file, ":p:h")
        local python_path = find_python_path(file_dir)
        if python_path ~= "python" then
          return python_path
        end
      end
      return find_python_path(vim.fn.getcwd())
    end,
    cwd = "${workspaceFolder}",
    console = "integratedTerminal",
  },
  {
    type = "debugpy",
    request = "attach",
    name = "Attach to Process",
    processId = dapUtils.pick_process,
    python = function()
      -- attach 时从工作目录向上查找虚拟环境
      return find_python_path(vim.fn.getcwd())
    end,
    cwd = "${workspaceFolder}",
  },
}

-- 包装函数：在启动调试前更新适配器配置
-- 这确保适配器使用虚拟环境中的 Python（debugpy 安装在虚拟环境中）
local function update_debugpy_adapter()
  local python_path = get_python_for_config()
  dap.adapters.debugpy = {
    type = "executable",
    command = python_path,
    args = { "-m", "debugpy.adapter" },
  }
end

-- 包装的 continue 函数：在启动调试前更新适配器
local function dap_continue_with_update()
  update_debugpy_adapter()
  dap.continue()
end

-- 基本键位映射
local opts = { noremap = true, silent = true }

-- 切换断点
map("n", "<leader>db", dap.toggle_breakpoint, vim.tbl_extend("force", opts, { desc = "Toggle breakpoint" }))

-- 开始/继续调试（使用包装函数以确保适配器使用正确的 Python）
map("n", "<leader>dc", dap_continue_with_update, vim.tbl_extend("force", opts, { desc = "Continue" }))

-- 单步调试
map("n", "<leader>di", dap.step_into, vim.tbl_extend("force", opts, { desc = "Step into" }))
map("n", "<leader>do", dap.step_over, vim.tbl_extend("force", opts, { desc = "Step over" }))
map("n", "<leader>du", dap.step_out, vim.tbl_extend("force", opts, { desc = "Step out" }))

-- 停止调试
map("n", "<leader>ds", dap.stop, vim.tbl_extend("force", opts, { desc = "Stop" }))

-- 重启调试
map("n", "<leader>dr", dap.restart, vim.tbl_extend("force", opts, { desc = "Restart" }))

-- 打开 REPL
map("n", "<leader>de", dap.repl.open, vim.tbl_extend("force", opts, { desc = "Open REPL" }))

-- 运行到光标处
map("n", "<leader>dg", dap.run_to_cursor, vim.tbl_extend("force", opts, { desc = "Run to cursor" }))

-- 显示调试信息
map("n", "<leader>dh", function()
  require("dap.ui.widgets").hover()
end, vim.tbl_extend("force", opts, { desc = "Hover variables" }))

-- 设置断点条件
map("n", "<leader>dB", function()
  dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, vim.tbl_extend("force", opts, { desc = "Set conditional breakpoint" }))

-- 美化调试界面
-- 高亮调试停止的行
vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "DiffChange" })

-- 定义调试符号
vim.fn.sign_define("DapStopped", {
  text = "󰁕 ",
  texthl = "DiagnosticSignWarn",
  linehl = "DapStoppedLine",
  numhl = "DapStoppedLine",
})

vim.fn.sign_define("DapBreakpoint", {
  text = " ",
  texthl = "DiagnosticSignInfo",
})

vim.fn.sign_define("DapBreakpointCondition", {
  text = " ",
  texthl = "DiagnosticSignInfo",
})

vim.fn.sign_define("DapBreakpointRejected", {
  text = " ",
  texthl = "DiagnosticSignError",
})

vim.fn.sign_define("DapLogPoint", {
  text = "󰯑 ",
  texthl = "DiagnosticSignInfo",
})

