# LSP 和 Snippet 配置测试

## 测试步骤

1. 启动 Neovim 并检查插件是否正确加载：
   ```bash
   nvim --checkhealth
   ```

2. 检查 Mason 是否正确安装了 LSP 服务器：
   ```vim
   :Mason
   ```

3. 检查 LSP 服务器状态：
   ```vim
   :LspInfo
   ```

4. 测试 TypeScript/JavaScript 自动补全：
   - 创建一个 `.ts` 文件
   - 输入 `cl` + Tab 应该展开为 `console.log()`
   - 输入 `fc` + Tab 应该展开为 React 函数组件模板

5. 测试 LSP 功能：
   - 将鼠标悬停在函数/变量上应该显示类型信息
   - 使用 `gd` 应该跳转到定义
   - 使用 `K` 应该显示文档

## 快捷键总结

### LSP 导航
- `gd` - 跳转到定义
- `gD` - 跳转到声明
- `gi` - 跳转到实现
- `gr` - 查找引用
- `K` - 显示悬停信息
- `<C-k>` - 显示签名帮助

### 代码操作
- `<space>rn` - 重命名
- `<space>ca` - 代码操作
- `<space>f` - 格式化代码

### 补全导航
- `<Tab>` / `<S-Tab>` - 在补全项之间导航
- `<C-j>` / `<C-k>` - 在补全项之间导航（替代方案）
- `<A-.>` - 触发补全
- `<A-,>` - 取消补全

### Snippet 导航
- `<C-l>` - 跳转到下一个 snippet 节点
- `<C-h>` - 跳转到上一个 snippet 节点
- `<C-j>` - 选择下一个选择项
- `<C-k>` - 选择上一个选择项
- `<C-u>` - 取消当前 snippet

### 诊断导航
- `[d` / `]d` - 跳转到上一个/下一个诊断
- `<space>e` - 显示悬浮诊断信息
- `<space>q` - 设置位置列表

## 自定义 Snippets

### JavaScript/TypeScript
- `cl` → `console.log()`
- `af` → arrow function
- `async` → async arrow function

### TypeScript
- `interface` → interface 定义
- `type` → type 定义
- `fc` → React 函数组件
- `ue` → useEffect hook
- `us` → useState hook

### Lua
- `lf` → local function
- `req` → require statement