local cmp_nvim_lsp = require('cmp_nvim_lsp')

-- 配置诊断显示（VSCode 风格：只显示符号和下划线，不显示虚拟文本）
vim.diagnostic.config({
  -- 禁用虚拟文本（不在代码行后显示错误信息，类似 VSCode）
  virtual_text = false,
  -- 启用符号列（左侧显示错误符号，类似 VSCode）
  signs = true,
  -- 启用下划线（在错误位置显示下划线）
  underline = true,
  -- 插入模式下不更新诊断（性能优化）
  update_in_insert = false,
  -- 按严重程度排序
  severity_sort = true,
  -- 浮动窗口配置（光标悬停时显示完整信息）
  float = {
    -- 显示完整消息
    source = "always",
    -- 边框样式
    border = "rounded",
    -- 焦点时关闭
    focusable = false,
    -- 格式化函数：显示完整信息
    format = function(diagnostic)
      local code = diagnostic.code or (diagnostic.user_data and diagnostic.user_data.lsp.code)
      if code then
        return string.format("%s [%s]\n%s", diagnostic.source or "LSP", code, diagnostic.message)
      end
      return string.format("%s\n%s", diagnostic.source or "LSP", diagnostic.message)
    end,
  },
})

-- 全局诊断刷新组
local diagnostic_refresh_group = vim.api.nvim_create_augroup('LspDiagnosticRefresh', { clear = true })

-- 存储每个 buffer 的刷新定时器
local refresh_timers = {}

-- 刷新诊断的通用函数
local function refresh_diagnostics(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  -- 清除之前的定时器
  if refresh_timers[bufnr] then
    vim.fn.timer_stop(refresh_timers[bufnr])
    refresh_timers[bufnr] = nil
  end

  -- 设置新的定时器，延迟 500ms 刷新
  refresh_timers[bufnr] = vim.fn.timer_start(500, function()
    refresh_timers[bufnr] = nil
    -- 通知 LSP 客户端文档已更改，触发重新诊断
    local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
    for _, client in ipairs(clients) do
      if client.name == 'eslint' then
        -- 发送文档变化通知，触发重新诊断
        client.notify('textDocument/didChange', {
          textDocument = vim.lsp.util.make_text_document_params(bufnr),
          contentChanges = { {
            text = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), '\n'),
          } },
        })
      end
    end
  end)
end

-- 代码修改后自动刷新诊断
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local opts = { buffer = event.buf, silent = true }
    local bufnr = event.buf
    
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    
    -- Code Actions（包括 ESLint 自动修复）
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('v', '<leader>ca', vim.lsp.buf.code_action, opts)
    
    -- Trouble.nvim 快捷键（类似 VSCode 的 Problems 面板）
    -- 打开/切换工作区诊断（所有文件的诊断）
    vim.keymap.set('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', 
      vim.tbl_extend('force', opts, { desc = 'Toggle workspace diagnostics' }))
    -- 打开/切换当前文件的诊断
    vim.keymap.set('n', '<leader>xw', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', 
      vim.tbl_extend('force', opts, { desc = 'Toggle document diagnostics' }))
    -- 只显示错误（过滤警告和信息）
    vim.keymap.set('n', '<leader>xd', '<cmd>Trouble diagnostics toggle filter.severity=vim.diagnostic.severity.ERROR<cr>', 
      vim.tbl_extend('force', opts, { desc = 'Toggle workspace errors' }))
    -- 显示当前行的诊断（浮动窗口）
    vim.keymap.set('n', '<leader>xe', function()
      vim.diagnostic.open_float(nil, {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        border = "rounded",
        source = "always",
        prefix = " ",
      })
    end, vim.tbl_extend('force', opts, { desc = 'Show line diagnostic' }))
    
    -- 手动刷新诊断的快捷键
    vim.keymap.set('n', '<leader>dr', function()
      refresh_diagnostics(bufnr)
    end, vim.tbl_extend('force', opts, { desc = 'Refresh diagnostics' }))
    
    -- 监听文本变化事件
    vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI' }, {
      group = diagnostic_refresh_group,
      buffer = bufnr,
      callback = function()
        refresh_diagnostics(bufnr)
      end,
    })
    
    -- 插入模式退出时也刷新
    vim.api.nvim_create_autocmd('InsertLeave', {
      group = diagnostic_refresh_group,
      buffer = bufnr,
      callback = function()
        refresh_diagnostics(bufnr)
      end,
    })
  end,
})

-- LSP 服务器配置
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Lua 语言服务器需要特殊配置（识别 vim 全局变量）
vim.lsp.config('lua_ls', {
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = { globals = { 'vim' } },
      workspace = { library = vim.api.nvim_get_runtime_file("", true) },
    },
  },
})

-- ESLint 需要特殊配置（确保能读取项目配置文件）
-- 递归向上查找配置文件的函数
local function find_eslint_root(startpath)
  local config_files = {
    '.eslintrc',
    '.eslintrc.js',
    '.eslintrc.json',
    '.eslintrc.yaml',
    '.eslintrc.yml',
    'eslint.config.js',
    'package.json',
  }

  local current = startpath
  while current and current ~= '/' do
    for _, file in ipairs(config_files) do
      local config_path = current .. '/' .. file
      if vim.fn.filereadable(config_path) == 1 then
        return current
      end
    end
    -- 向上查找父目录
    local parent = vim.fn.fnamemodify(current, ':h')
    if parent == current then
      break
    end
    current = parent
  end
  return nil
end

vim.lsp.config('eslint', {
  capabilities = capabilities,
  -- 递归向上查找配置文件，而不是只从当前目录查找
  root_dir = function(fname)
    local startpath = vim.fn.fnamemodify(fname, ':p:h')
    return find_eslint_root(startpath)
  end,
  on_attach = function(client, bufnr)
    -- 禁用格式化功能，使用 conform 处理格式化
    if client.server_capabilities then
      client.server_capabilities.documentFormattingProvider = false
    end
  end,
  settings = {
    -- 让 ESLint 读取项目配置文件
    format = false, -- 禁用格式化，使用 conform
    -- 确保 ESLint 在项目根目录查找配置文件
    workingDirectory = { mode = 'auto' }, -- 自动检测工作目录
  },
})

-- 其他 LSP 服务器使用默认配置
local servers = { "ts_ls", "jsonls", "html", "cssls" }
for _, server in ipairs(servers) do
  vim.lsp.config(server, {
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      -- 确保兼容性
      if client.server_capabilities then
        -- 可以在这里添加通用的 on_attach 逻辑
      end
    end,
  })
end

-- 启用所有配置的 LSP 服务器
vim.lsp.enable('lua_ls')
vim.lsp.enable('eslint')
for _, server in ipairs(servers) do
  vim.lsp.enable(server)
end
