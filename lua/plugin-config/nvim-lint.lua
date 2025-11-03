local lint = require('lint')

-- 配置 linter
lint.linters_by_ft = {
  javascript = { 'eslint' },
  javascriptreact = { 'eslint' },
  typescript = { 'eslint' },
  typescriptreact = { 'eslint' },
  lua = { 'luacheck' },
}

-- 配置 ESLint 优先使用本地安装
lint.linters.eslint = lint.linters.eslint or {}
lint.linters.eslint.prefer_local = 'node_modules/.bin'
lint.linters.eslint.cmd = 'eslint'

-- 确保 lint 在适当的时机运行
local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })

-- 更稳定的触发事件
vim.api.nvim_create_autocmd({ 'BufWritePost', 'InsertLeave', 'BufEnter' }, {
  group = lint_augroup,
  callback = function(args)
    -- 只在支持的文件类型中运行 lint
    local ft = vim.api.nvim_buf_get_option(args.buf, 'filetype')
    if lint.linters_by_ft[ft] then
      lint.try_lint(nil, { bufnr = args.buf })
    end
  end,
})

-- 在 LSP attach 时也触发一次 lint，确保 ESLint 诊断及时更新
vim.api.nvim_create_autocmd('LspAttach', {
  group = lint_augroup,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == 'eslint' then
      -- 延迟一点时间让 LSP 完全初始化
      vim.defer_fn(function()
        lint.try_lint(nil, { bufnr = args.buf })
      end, 100)
    end
  end,
})

