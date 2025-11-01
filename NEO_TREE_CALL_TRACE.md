# Neo-tree 调用追踪

## 📍 调用位置总览

neo-tree 在你的配置中被调用的位置和时机：

---

## 1. 插件声明（插件加载入口）

**文件**：`lua/plugins.lua` (第 11-20 行)

```lua
{
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  }
}
```

**作用**：
- 告诉 lazy.nvim 需要安装和加载这个插件
- **注意**：由于没有延迟加载配置（`cmd`、`keys`、`event` 等），neo-tree 会在 Neovim 启动时**立即加载**

---

## 2. 配置文件的加载（配置入口）

**文件**：`init.lua` (第 2 行)

```lua
require('config.neotree')
```

**执行时机**：
- Neovim 启动时，在 `require('config.lazy')` 之后执行
- 此时 lazy.nvim 已经加载了 neo-tree 插件（因为 plugins.lua 中没有延迟加载配置）

---

## 3. 实际调用位置（核心调用）

**文件**：`lua/config/neotree.lua`

### 3.1 初始化配置（第 15 行）

```lua
require('neo-tree').setup({
  -- 配置选项...
})
```

**作用**：
- 初始化 neo-tree 插件
- 设置插件的默认行为和选项
- **执行时机**：Neovim 启动时，立即执行

### 3.2 快捷键映射（第 2-5 行）

```lua
vim.keymap.set('n', '<C-n>', ':Neotree filesystem reveal left<CR>')
vim.keymap.set('n', '<leader>e', ':Neotree filesystem reveal left<CR>')
vim.keymap.set('n', '<leader>bf', ':Neotree buffers reveal float<CR>')
vim.keymap.set('n', '<leader>gs', ':Neotree git_status reveal left<CR>')
```

**作用**：
- 定义快捷键来调用 neo-tree 的命令
- **执行时机**：Neovim 启动时，立即设置这些映射
- **实际调用时机**：用户按下这些快捷键时

### 3.3 关闭功能（第 8-12 行）

```lua
vim.keymap.set('n', '<Esc>', function()
  if vim.bo.filetype == 'neo-tree' then
    vim.cmd('Neotree close')
  end
end, { buffer = true })
```

**作用**：
- 在 neo-tree 窗口中按 `Esc` 关闭它
- **执行时机**：用户按下 `Esc` 且当前 buffer 的 filetype 是 `neo-tree` 时

---

## 📊 完整调用流程图

```
Neovim 启动
    │
    ├─ 1. 加载 init.lua
    │      │
    │      ├─ require('config.lazy')
    │      │      │
    │      │      ├─ Bootstrap lazy.nvim（如果不存在）
    │      │      │
    │      │      ├─ 解析 plugins.lua
    │      │      │      │
    │      │      │      └─ 发现 "nvim-neo-tree/neo-tree.nvim"
    │      │      │             │
    │      │      │             └─ 立即加载（无延迟配置）
    │      │      │                    │
    │      │      │                    ├─ 加载依赖：plenary.nvim
    │      │      │                    ├─ 加载依赖：nvim-web-devicons
    │      │      │                    └─ 加载依赖：nui.nvim
    │      │      │
    │      │      └─ lazy.nvim 将插件添加到 rtp
    │      │
    │      └─ require('config.neotree')  ← 第2步
    │             │
    │             ├─ 设置快捷键映射（第 2-5 行）
    │             │   ├─ <C-n> → :Neotree filesystem reveal left
    │             │   ├─ <leader>e → :Neotree filesystem reveal left
    │             │   ├─ <leader>bf → :Neotree buffers reveal float
    │             │   └─ <leader>gs → :Neotree git_status reveal left
    │             │
    │             ├─ 设置关闭映射（第 8-12 行）
    │             │   └─ <Esc> → :Neotree close（仅在 neo-tree buffer 中）
    │             │
    │             └─ require('neo-tree').setup({...})  ← 第3步：初始化配置
    │
    └─ Neovim 启动完成
         │
         └─ 用户交互
              │
              ├─ 用户按下 <C-n> 或 <leader>e
              │      │
              │      └─ 执行 :Neotree filesystem reveal left
              │             │
              │             └─ neo-tree 显示文件树
              │
              ├─ 用户按下 <leader>bf
              │      │
              │      └─ 执行 :Neotree buffers reveal float
              │             │
              │             └─ neo-tree 显示缓冲区列表（浮动窗口）
              │
              ├─ 用户按下 <leader>gs
              │      │
              │      └─ 执行 :Neotree git_status reveal left
              │             │
              │             └─ neo-tree 显示 Git 状态
              │
              └─ 用户在 neo-tree 窗口中按下 <Esc>
                     │
                     └─ 执行 :Neotree close
                            │
                            └─ 关闭 neo-tree
```

---

## 🔍 关键调用点详解

### 调用点 1：`require('neo-tree').setup()`

**位置**：`lua/config/neotree.lua:15`

**时机**：
- 启动时立即执行
- 因为 plugins.lua 中没有延迟加载配置

**作用**：
- 初始化插件
- 配置插件行为（窗口位置、边框样式、Git 状态等）

**代码路径**：
```
init.lua:2
  → require('config.neotree')
    → lua/config/neotree.lua:15
      → require('neo-tree').setup()
        → ~/.local/share/nvim/lazy/neo-tree.nvim/lua/neo-tree/init.lua
```

### 调用点 2：`:Neotree` 命令

**触发方式**：
1. 快捷键映射触发（`<C-n>`, `<leader>e`, `<leader>bf`, `<leader>gs`）
2. 手动输入命令（`:Neotree filesystem reveal left`）

**命令定义位置**：
- 插件内部：`~/.local/share/nvim/lazy/neo-tree.nvim/lua/neo-tree/commands.lua`（或类似位置）
- 这些命令由 neo-tree 插件在加载时自动注册

**命令列表**：
- `:Neotree filesystem reveal left` - 显示文件系统树（左侧）
- `:Neotree buffers reveal float` - 显示缓冲区列表（浮动窗口）
- `:Neotree git_status reveal left` - 显示 Git 状态（左侧）
- `:Neotree close` - 关闭 neo-tree

---

## ⚠️ 当前配置的问题

### 问题：没有延迟加载

**当前行为**：
- neo-tree 在启动时立即加载
- 即使不使用也会占用内存和启动时间

**影响**：
- 启动时间变慢
- 内存占用增加

### 解决方案

如果你想实现延迟加载，可以修改 `lua/plugins.lua`：

```lua
{
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  cmd = "Neotree",  -- 按命令延迟加载
  keys = {          -- 按快捷键延迟加载
    { "<C-n>", ":Neotree filesystem reveal left<CR>", desc = "Explorer" },
    { "<leader>e", ":Neotree filesystem reveal left<CR>", desc = "Explorer" },
    { "<leader>bf", ":Neotree buffers reveal float<CR>", desc = "Buffers" },
    { "<leader>gs", ":Neotree git_status reveal left<CR>", desc = "Git Status" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    -- 将 config/neotree.lua 中的配置移到这里
    require('neo-tree').setup({
      -- 你的配置...
    })
  end,
}
```

**优化后的行为**：
- 启动时不加载 neo-tree
- 只有执行 `:Neotree` 命令或按下配置的快捷键时才加载
- 启动速度更快，内存占用更少

---

## 📝 总结

neo-tree 的调用位置：

1. **声明位置**：`lua/plugins.lua` - 告诉 lazy.nvim 需要这个插件
2. **加载入口**：`init.lua:2` - 加载配置文件
3. **初始化调用**：`lua/config/neotree.lua:15` - `require('neo-tree').setup()`
4. **运行时调用**：通过快捷键或命令 `:Neotree` 触发

**当前状态**：启动时立即加载（无延迟）
**建议**：添加延迟加载配置以优化启动性能

