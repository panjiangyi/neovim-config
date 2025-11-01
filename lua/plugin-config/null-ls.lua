local null_ls = require('null-ls')

local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
  sources = {
    formatting.prettier.with({ prefer_local = 'node_modules/.bin' }),
    formatting.stylua,
    diagnostics.eslint.with({ prefer_local = 'node_modules/.bin' }),
  },
  on_attach = function(client, bufnr)
    if client.supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })
    end
  end,
})
