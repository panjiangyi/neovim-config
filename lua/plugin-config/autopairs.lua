local autopairs = require('nvim-autopairs')

autopairs.setup({
  check_ts = true, -- 启用 treesitter 检查
  ts_config = {
    lua = { 'string' }, -- 在 lua 的字符串中不自动配对
    javascript = { 'template_string' }, -- 在 JS 模板字符串中不自动配对
  },
  disable_filetype = { "TelescopePrompt", "vim" },
  fast_wrap = {
    map = '<M-e>', -- Alt+e 快速包裹
    chars = { '{', '[', '(', '"', "'" },
    pattern = [=[[%'%"%>%]%)%}%,]]=],
    end_key = '$',
    keys = 'qwertyuiopzxcvbnmasdfghjkl',
    check_comma = true,
    highlight = 'Search',
    highlight_grey = 'Comment'
  },
})

-- 与 nvim-cmp 集成
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)

