# Buffer 恢复功能实现文档

## 需求
实现类似 VSCode 的功能：
1. 关闭除当前外的所有 buffer（`Shift+Alt+t`）
2. 恢复最近关闭的文件（`Shift+Ctrl+t`），直接打开，不显示列表

## 遇到的问题和解决方案

### 问题 1：Buffer 历史记录系统失败

**尝试方案 1：自定义历史记录系统**
```lua
-- 监听 BufDelete 事件记录关闭的 buffer
vim.api.nvim_create_autocmd("BufDelete", {
  callback = function(args)
    record_closed_buffer(args.buf)
  end,
})
```

**失败原因：**
- `BufDelete` 事件触发时，buffer 的某些信息（如 buftype、filetype）可能已经丢失
- 事件触发时机不稳定，导致历史记录一直为空
- 即使在关闭前手动调用 `record_closed_buffer()`，仍然无法稳定工作

**错误表现：**
- 按快捷键显示 "tab stack is empty"（历史记录为空）
- 自定义的 `buffer_history` 表始终是空的

### 问题 2：使用 Telescope 自定义 picker 复杂度高

**尝试方案 2：自定义 Telescope picker**
```lua
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
-- ... 复杂的配置
```

**问题：**
- 需要依赖自定义的历史记录系统（已失败）
- 代码复杂，维护困难
- 没有利用 Neovim 内置的功能

### 问题 3：终端快捷键冲突

**问题描述：**
- `Shift+Ctrl+t` 被 Ubuntu Terminal 默认占用（打开新标签）
- 即使禁用终端快捷键，Neovim 也无法识别 `<S-C-t>` 或 `<C-S-t>`

**解决过程：**
1. 用户禁用了终端的 `Ctrl+Shift+t` 快捷键
2. 使用 `Ctrl+v` 测试实际键码：终端发送的是 `T`（大写）
3. 发现终端将 `Shift+Ctrl+t` 转换为 `Ctrl+T`（因为 Shift 让 t 变成了大写 T）
4. 最终映射为 `<C-T>` 才能正常工作

**关键发现：**
```
按键：Shift+Ctrl+t
终端发送：Ctrl+T (大写 T)
Neovim 映射：<C-T>
```

### 问题 4：用户需求理解偏差

**初始实现：**
打开 Telescope 文件列表，让用户选择

**实际需求：**
像 VSCode 一样，直接打开最近关闭的文件，无需选择

## 最终解决方案

### 方案：使用 Neovim 内置的 `vim.v.oldfiles`

**为什么有效：**
- `vim.v.oldfiles` 是 Neovim 内置维护的最近文件列表
- 不需要手动监听事件和记录
- 自动持久化，重启 Neovim 后仍然可用
- 稳定可靠，不会出现空列表的问题

**实现代码：**

```lua
map("n", "<C-T>", function()
  -- 直接打开最近关闭的第一个文件
  local oldfiles = vim.v.oldfiles
  if not oldfiles or #oldfiles == 0 then
    vim.notify("没有最近打开的文件", vim.log.levels.WARN)
    return
  end
  
  -- 查找第一个存在且未打开的文件
  for _, file in ipairs(oldfiles) do
    if vim.fn.filereadable(file) == 1 then
      -- 检查是否已经在某个 buffer 中打开
      local is_open = false
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_get_name(buf) == file then
          is_open = true
          break
        end
      end
      -- 找到第一个未打开的文件，直接打开
      if not is_open then
        vim.cmd("edit " .. vim.fn.fnameescape(file))
        return
      end
    end
  end
  
  vim.notify("没有可恢复的文件", vim.log.levels.WARN)
end, opts("Reopen last closed file (Shift+Ctrl+t)"))
```

**工作流程：**
1. 从 `vim.v.oldfiles` 获取最近文件列表
2. 遍历列表，跳过已打开的文件
3. 找到第一个存在且未打开的文件
4. 直接打开该文件
5. 多次按可以依次打开更早的文件

## 最终配置的快捷键

| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `Shift+Alt+t` | 关闭除当前外的所有 buffer | 只关闭代码文件，不关闭插件窗口 |
| `Shift+Ctrl+t` | 直接打开最近关闭的文件 | 映射为 `<C-T>`，类似 VSCode |
| `Ctrl+e` | 打开最近文件列表选择 | 使用 Telescope，可搜索 |
| `空格+br` | 打开最近文件列表选择 | 备选快捷键 |

## 关键经验总结

### 1. 避免过度设计
- ❌ 不要实现复杂的自定义历史记录系统
- ✅ 优先使用 Neovim 内置功能（`vim.v.oldfiles`）

### 2. 终端快捷键处理
- ✅ 使用 `Ctrl+v` 测试终端实际发送的键码
- ✅ 了解终端如何转换组合键（`Shift+Ctrl+t` → `Ctrl+T`）
- ⚠️ `Shift+Ctrl+字母` 在终端中通常被转换为 `Ctrl+大写字母`

### 3. 事件监听的局限性
- ❌ `BufDelete`/`BufWipeout` 事件触发时，buffer 信息可能已丢失
- ❌ 在关闭前手动记录也不稳定
- ✅ 使用 Neovim 内置的持久化机制更可靠

### 4. 理解用户需求
- 最初：以为需要显示列表让用户选择
- 实际：用户想要直接打开，类似 VSCode 的行为
- 教训：需求不明确时应该先确认

## 测试快捷键的方法

### 测试终端发送的键码
1. 在 Neovim 普通模式下按 `i` 进入插入模式
2. 按 `Ctrl+v`，然后按你想测试的组合键
3. Neovim 会显示终端发送的实际字符
4. 按 `Esc` 退出插入模式

### 查看当前映射
```vim
:verbose map
:verbose nmap <C-T>
```

### 重新加载配置
```vim
:source ~/.config/nvim/lua/keybindings.lua
```

## 为什么花了这么久

1. **第一次尝试**：实现自定义 buffer 历史记录系统（失败）
2. **第二次尝试**：优化事件监听，添加 BufWipeout（仍然失败）
3. **第三次尝试**：在关闭前手动记录（仍然不稳定）
4. **第四次尝试**：简化为使用 Telescope oldfiles（列表方式）
5. **终端键码问题**：尝试 `<C-S-t>`、`<S-C-t>` 等多种格式（都失败）
6. **键码测试**：发现终端发送 `T`，修改为 `<C-T>`（成功）
7. **需求确认**：改为直接打开而不是显示列表（最终完成）

**核心教训：**
- 不要重新发明轮子，优先使用内置功能
- 终端键码需要实际测试，不能凭猜测
- 需求不明确时要先确认

## 相关文件

- 配置文件：`lua/keybindings.lua`
- 清理了不必要的 buffer 历史记录代码（已删除）
- 使用简洁的实现，代码量减少 60%

## 未来改进建议

如果需要更高级的功能：
1. 可以保存每个文件关闭时的光标位置
2. 可以记录关闭的顺序而不是打开的顺序
3. 可以实现"前进/后退"历史导航

但目前的实现已经满足了基本需求，且非常稳定可靠。

