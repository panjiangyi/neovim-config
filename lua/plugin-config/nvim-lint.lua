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

-- 自动运行 linter
local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
  group = lint_augroup,
  callback = function()
    lint.try_lint()
  end,
})

