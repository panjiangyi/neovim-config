return {
  ensure_installed = { "json", "html", "css", "vim", "lua", "javascript", "typescript", "tsx", "python", "go", "rust", "java", "c", "cpp" },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-space>",
      node_incremental = "<C-space>",
      node_decremental = "<bs>",
      scope_incremental = "<C-s>",
    },
  },
  indent = {
    enable = true,
  },
  -- Textobjects 配置
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- 自动跳转到下一个文本对象
      keymaps = {
        -- 函数相关
        ["af"] = "@function.outer", -- 选择整个函数（包括注释和签名）
        ["if"] = "@function.inner", -- 选择函数内部（不包括签名）
        
        -- 类相关
        ["ac"] = "@class.outer", -- 选择整个类
        ["ic"] = "@class.inner", -- 选择类内部
        
        -- 条件语句
        ["ai"] = "@conditional.outer", -- 选择整个条件语句
        ["ii"] = "@conditional.inner", -- 选择条件内部
        
        -- 循环
        ["al"] = "@loop.outer", -- 选择整个循环
        ["il"] = "@loop.inner", -- 选择循环内部
        
        -- 参数
        ["aa"] = "@parameter.outer", -- 选择参数（包括逗号）
        ["ia"] = "@parameter.inner", -- 选择参数（不包括逗号）
        
        -- 注释
        ["a/"] = "@comment.outer", -- 选择整个注释块

        -- 异常处理（try-catch/try-except）
        ["ae"] = "@exception.outer", -- 选择整个异常处理块
        ["ie"] = "@exception.inner", -- 选择异常处理内部（不包括异常类型声明）
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- 设置跳转点
      goto_next_start = {
        ["]f"] = "@function.outer", -- 跳转到下一个函数开始
        ["]c"] = "@class.outer", -- 跳转到下一个类开始
        ["]a"] = "@parameter.inner", -- 跳转到下一个参数
      },
      goto_next_end = {
        ["]F"] = "@function.outer", -- 跳转到下一个函数结束
        ["]C"] = "@class.outer", -- 跳转到下一个类结束
      },
      goto_previous_start = {
        ["[f"] = "@function.outer", -- 跳转到上一个函数开始
        ["[c"] = "@class.outer", -- 跳转到上一个类开始
        ["[a"] = "@parameter.inner", -- 跳转到上一个参数
      },
      goto_previous_end = {
        ["[F"] = "@function.outer", -- 跳转到上一个函数结束
        ["[C"] = "@class.outer", -- 跳转到上一个类结束
      },
    },
  },
}