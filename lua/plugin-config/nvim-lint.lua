local lint = require('lint')

lint.linters_by_ft = {
  javascript = { 'eslint' },
  javascriptreact = { 'eslint' },
  typescript = { 'eslint' },
  typescriptreact = { 'eslint' },
  lua = { 'luacheck' },
}

-- 向上查找 eslint 配置文件
local function has_eslint_config()
  local config_files = {
    '.eslintrc',
    '.eslintrc.js',
    '.eslintrc.cjs',
    '.eslintrc.json',
    '.eslintrc.yaml',
    '.eslintrc.yml',
    'eslint.config.js',
    'eslint.config.mjs',
    'eslint.config.cjs',
  }
  
  local current_file = vim.fn.expand('%:p')
  local current_dir = vim.fn.fnamemodify(current_file, ':h')
  
  -- 向上查找项目根目录
  while current_dir and current_dir ~= '/' do
    -- 检查是否存在 eslint 配置文件
    for _, config_file in ipairs(config_files) do
      if vim.fn.filereadable(current_dir .. '/' .. config_file) == 1 then
        return true
      end
    end
    
    -- 检查 package.json 中是否有 eslintConfig 字段
    local package_json = current_dir .. '/package.json'
    if vim.fn.filereadable(package_json) == 1 then
      local content = vim.fn.readfile(package_json)
      local json_str = table.concat(content, '\n')
      if json_str:match('"eslintConfig"') then
        return true
      end
    end
    
    current_dir = vim.fn.fnamemodify(current_dir, ':h')
  end
  
  return false
end

-- 确保 lint 在适当的时机运行
local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })

vim.api.nvim_create_autocmd({ 'BufWritePost', 'InsertLeave' }, {
  group = lint_augroup,
  callback = function()
    local ft = vim.bo.filetype
    local linters = lint.linters_by_ft[ft]
    
    if not linters then
      return
    end
    
    -- 如果是 JS/TS 文件，检查是否有 eslint 配置
    if vim.tbl_contains({ 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' }, ft) then
      if not has_eslint_config() then
        return
      end
    end
    
    lint.try_lint()
  end,
})

