local lspconfig = require('lspconfig')
local cmp_nvim_lsp = require('cmp_nvim_lsp')

-- 基础快捷键（最常用的）
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local opts = { buffer = event.buf, silent = true }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
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
lspconfig.eslint.setup({
  capabilities = capabilities,
  -- 确保 ESLint 从项目根目录读取配置文件
  root_dir = lspconfig.util.root_pattern('.eslintrc', '.eslintrc.js', '.eslintrc.json', '.eslintrc.yaml', '.eslintrc.yml', 'eslint.config.js', 'package.json'),
  on_attach = function(client, bufnr)
    -- 禁用格式化功能，使用 null-ls 处理格式化
    client.server_capabilities.documentFormattingProvider = false
  end,
  settings = {
    -- 让 ESLint 读取项目配置文件
    format = false, -- 禁用格式化，使用 null-ls
    -- 确保 ESLint 在项目根目录查找配置文件
    workingDirectory = { mode = 'auto' }, -- 自动检测工作目录
  },
})

-- 其他 LSP 服务器使用默认配置
local servers = { "ts_ls", "jsonls", "html", "cssls" }
for _, server in ipairs(servers) do
  lspconfig[server].setup({ capabilities = capabilities })
end
