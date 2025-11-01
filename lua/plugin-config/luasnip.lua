local luasnip = require('luasnip')

-- 加载 VSCode 风格的 snippets
require('luasnip.loaders.from_vscode').lazy_load()

-- 基础配置
luasnip.config.setup({
  history = true,
  update_events = { 'TextChanged', 'TextChangedI' },
})
