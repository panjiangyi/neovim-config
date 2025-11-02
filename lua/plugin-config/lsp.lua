local lspconfig = require('lspconfig')
local cmp_nvim_lsp = require('cmp_nvim_lsp')

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
          textDocument = vim.lsp.util.make_text_document_params(),
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
lspconfig.lua_ls.setup({
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

lspconfig.eslint.setup({
  capabilities = capabilities,
  -- 递归向上查找配置文件，而不是只从当前目录查找
  root_dir = function(fname)
    local startpath = vim.fn.fnamemodify(fname, ':p:h')
    return find_eslint_root(startpath)
  end,
  on_attach = function(client, bufnr)
    -- 禁用格式化功能，使用 conform 处理格式化
    client.server_capabilities.documentFormattingProvider = false
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
  lspconfig[server].setup({ capabilities = capabilities })
end
