local conform = require('conform')

-- 查找项目根目录的函数（查找包含 .prettierrc, prettier.config.js, package.json 等的目录）
local function find_project_root(filename)
  local config_files = {
    '.prettierrc',
    '.prettierrc.json',
    '.prettierrc.js',
    '.prettierrc.cjs',
    '.prettierrc.yaml',
    '.prettierrc.yml',
    'prettier.config.js',
    'prettier.config.cjs',
  }

  local current = vim.fn.fnamemodify(filename, ':p:h')
  while current and current ~= '/' do
    for _, file in ipairs(config_files) do
      local config_path = current .. '/' .. file
      if vim.fn.filereadable(config_path) == 1 or vim.fn.isdirectory(config_path) == 1 then
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
  -- 如果找不到，返回文件所在目录
  return vim.fn.fnamemodify(filename, ':p:h')
end

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
      -- 动态设置 cwd，确保 prettier 从项目根目录运行，能找到配置文件
      cwd = function(ctx)
        return find_project_root(ctx.filename)
      end,
    },
  },
})

-- 设置格式化快捷键
vim.keymap.set({ 'n', 'v' }, '<leader>f', function()
  conform.format({ async = true, lsp_fallback = true })
end, { desc = 'Format code' })


