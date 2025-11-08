# 快捷键配置说明

所有快捷键配置都在 `lua/keybindings.lua` 文件中。

## 当前已启用的快捷键

**注意**：Leader 键已设置为**空格键** `Space`，所以下面的快捷键都是 `Space + 字母` 的组合。

### 基本编辑
- `Space + w` - 保存文件
- `Space + nh` - 取消搜索高亮

### 文件查找（Telescope）
- `Ctrl+p` - 查找文件
- `Ctrl+f` - 全局搜索文本

### 文件树（Neo-tree）
- `Ctrl+n` - 打开文件树
- `Space + e` - 切换文件树
- `Space + bf` - 显示缓冲区树
- `Space + gs` - Git 状态

### 缓冲区切换（Buffer）
- `Space + bn` - 下一个缓冲区
- `Space + bp` - 上一个缓冲区
- `Space + bc` - 关闭当前缓冲区

### LSP（代码智能）
- `gd` - 跳转到定义
- `K` - 显示文档
- `Space + rn` - 重命名
- `gr` - 查找引用
- `[d` - 上一个错误
- `]d` - 下一个错误
- `Space + ca` - 代码修复

### 调试（DAP）
- `Space + db` - 切换断点
- `Space + dc` - 开始/继续调试
- `Space + di` - 单步进入
- `Space + do` - 单步跳过
- `Space + ds` - 停止调试

## 如何启用更多快捷键

1. 打开 `lua/keybindings.lua`
2. 找到你需要的快捷键（以 `--` 开头的行）
3. 删除行首的 `--` 来启用
4. 保存后运行 `:source %` 或重启 Neovim

## 查看所有快捷键

在 Neovim 中运行：
```
:Telescope keymaps
```

## Leader 键设置

当前 Leader 键已设置为**空格键** `Space`，设置在 `lua/config/lazy.lua` 中。

如需修改，请编辑 `lua/config/lazy.lua` 文件：
```lua
vim.g.mapleader = " "  -- 改为你想要的键
vim.g.maplocalleader = "\\"  -- 本地 leader 键
```

⚠️ **重要**：Leader 键必须在加载插件之前设置，所以要在 `lazy.lua` 中设置。

## 常用技巧

### Neo-tree 文件树内的操作：
- `a` - 新建文件
- `A` - 新建目录
- `d` - 删除
- `r` - 重命名
- `x` - 剪切
- `p` - 粘贴
- `m` - 移动

### Telescope 搜索窗口内：
- `Ctrl+j/k` 或 `↑/↓` - 上下选择
- `Enter` - 打开文件
- `Ctrl+c` - 关闭窗口

