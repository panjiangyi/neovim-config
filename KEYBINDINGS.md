# 快捷键配置说明

所有快捷键配置都在 `lua/keybindings.lua` 文件中。

## 当前已启用的快捷键

### 基本编辑
- `\w` - 保存文件
- `\nh` - 取消搜索高亮

### 文件查找（Telescope）
- `Ctrl+p` - 查找文件
- `Ctrl+f` - 全局搜索文本

### 文件树（Neo-tree）
- `Ctrl+n` - 打开文件树
- `\e` - 切换文件树
- `\bf` - 显示缓冲区树
- `\gs` - Git 状态

### 缓冲区切换（Buffer）
- `\bn` - 下一个缓冲区
- `\bp` - 上一个缓冲区
- `\bc` - 关闭当前缓冲区

### LSP（代码智能）
- `gd` - 跳转到定义
- `K` - 显示文档
- `Space+rn` - 重命名
- `gr` - 查找引用
- `[d` - 上一个错误
- `]d` - 下一个错误
- `\ca` - 代码修复

### 调试（DAP）
- `\db` - 切换断点
- `\dc` - 开始/继续调试
- `\di` - 单步进入
- `\do` - 单步跳过
- `\ds` - 停止调试

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

## 修改 Leader 键

默认 leader 键是 `\`，如果想改成空格：

在 `lua/keybindings.lua` 的顶部取消注释：
```lua
vim.g.mapleader = " "
```

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

