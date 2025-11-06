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

-- 基本键位映射
local opts = { noremap = true, silent = true }

-- 切换断点
map("n", "<leader>db", dap.toggle_breakpoint, vim.tbl_extend("force", opts, { desc = "Toggle breakpoint" }))

-- 开始/继续调试
map("n", "<leader>dc", dap.continue, vim.tbl_extend("force", opts, { desc = "Continue" }))

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

