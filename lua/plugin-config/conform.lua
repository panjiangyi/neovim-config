local conform = require('conform')

conform.setup({
  formatters_by_ft = {
    javascript = { 'prettier' },
    javascriptreact = { 'prettier' },
    typescript = { 'prettier' },
    typescriptreact = { 'prettier' },
    json = { 'prettier' },
    html = { 'prettier' },
    css = { 'prettier' },
    scss = { 'prettier' },
    markdown = { 'prettier' },
    lua = { 'stylua' },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
  formatters = {
    prettier = {
      prefer_local = 'node_modules/.bin',
    },
  },
})

-- 设置格式化快捷键
vim.keymap.set({ 'n', 'v' }, '<leader>f', function()
  conform.format({ async = true, lsp_fallback = true })
end, { desc = 'Format code' })

