# React Hook ESLint 规则不显示的原因和解决方案

## 🔍 问题分析

你遇到的 `react-hooks/exhaustive-deps` 规则不显示错误，主要有以下几个原因：

### 原因 1：ESLint LSP 服务器配置问题

**之前的配置**：
```lua
local servers = { "ts_ls", "eslint", "jsonls", "html", "cssls" }
```

**问题**：
- ESLint LSP 服务器配置不完整，无法正确读取项目配置
- 缺少 `root_dir` 配置，无法自动检测项目根目录

**已修复**：
- 将 ESLint 单独配置，确保能正确读取项目配置文件
- 设置 `root_dir` 自动检测项目根目录（查找 `.eslintrc.*`、`eslint.config.js`、`package.json`）
- 配置 `workingDirectory` 为自动模式，确保 ESLint 在正确的目录运行
- 使用 `eslint` 作为服务器名称（正确名称）

### 原因 2：项目缺少 ESLint 配置文件 ⚠️ **最重要**

**这是最关键的！** ESLint LSP 需要在**项目根目录**有 ESLint 配置文件才能读取规则。

React Hook 规则必须在**项目的 ESLint 配置文件**中启用，Neovim 配置本身无法启用这些规则。

---

## ✅ 解决方案

### 步骤 1：确保 Mason 安装了正确的 ESLint LSP 服务器

1. 打开 Neovim
2. 运行 `:Mason`
3. 搜索并安装：
   - `eslint-lsp` 或 `eslint_d`（取决于你的系统）

### 步骤 2：在项目根目录创建 ESLint 配置文件

**选项 A：使用 `.eslintrc.js`（推荐）**

在你的 React 项目根目录创建 `.eslintrc.js`：

```javascript
module.exports = {
  env: {
    browser: true,
    es2021: true,
    node: true,
  },
  extends: [
    'eslint:recommended',
    'plugin:react/recommended',
    'plugin:react-hooks/recommended', // 启用 React Hooks 规则
    'plugin:@typescript-eslint/recommended', // 如果使用 TypeScript
  ],
  parser: '@typescript-eslint/parser', // 如果使用 TypeScript
  parserOptions: {
    ecmaFeatures: {
      jsx: true,
    },
    ecmaVersion: 'latest',
    sourceType: 'module',
  },
  plugins: [
    'react',
    'react-hooks', // 必须安装这个插件
    '@typescript-eslint', // 如果使用 TypeScript
  ],
  rules: {
    'react-hooks/rules-of-hooks': 'error', // 检查 Hook 的规则
    'react-hooks/exhaustive-deps': 'warn', // 检查 effect 的依赖 - 这就是你需要的规则！
    'react/react-in-jsx-scope': 'off', // React 17+ 不需要导入 React
  },
  settings: {
    react: {
      version: 'detect', // 自动检测 React 版本
    },
  },
};
```

**选项 B：使用 `eslint.config.js`（ESLint 9+ 新格式）**

```javascript
import js from '@eslint/js';
import react from 'eslint-plugin-react';
import reactHooks from 'eslint-plugin-react-hooks';

export default [
  js.configs.recommended,
  {
    files: ['**/*.{js,jsx,ts,tsx}'],
    plugins: {
      react,
      'react-hooks': reactHooks,
    },
    rules: {
      ...react.configs.recommended.rules,
      ...reactHooks.configs.recommended.rules,
      'react-hooks/exhaustive-deps': 'warn', // 检查 effect 的依赖
      'react/react-in-jsx-scope': 'off',
    },
    settings: {
      react: {
        version: 'detect',
      },
    },
  },
];
```

**选项 C：在 `package.json` 中配置**

```json
{
  "eslintConfig": {
    "extends": [
      "eslint:recommended",
      "plugin:react/recommended",
      "plugin:react-hooks/recommended"
    ],
    "plugins": ["react", "react-hooks"],
    "rules": {
      "react-hooks/rules-of-hooks": "error",
      "react-hooks/exhaustive-deps": "warn"
    },
    "settings": {
      "react": {
        "version": "detect"
      }
    }
  }
}
```

### 步骤 3：安装必要的 npm 包

在你的项目根目录运行：

```bash
# 基础 ESLint
npm install --save-dev eslint

# React 相关插件
npm install --save-dev eslint-plugin-react eslint-plugin-react-hooks

# 如果使用 TypeScript
npm install --save-dev @typescript-eslint/parser @typescript-eslint/eslint-plugin
```

### 步骤 4：验证配置

1. **重启 Neovim**（让配置生效）

2. **打开一个 React 文件**，例如：
   ```jsx
   import { useEffect } from 'react';
   import { useDispatch } from 'react-redux';
   
   function MyComponent() {
     const dispatch = useDispatch();
     
     useEffect(() => {
       dispatch(someAction());
     }, []); // ⚠️ 这里应该会显示警告：缺少 dispatch 依赖
     
     return <div>Hello</div>;
   }
   ```

3. **检查 LSP 状态**：
   - 运行 `:LspInfo` 查看 ESLint 是否连接
   - 运行 `:LspLog` 查看是否有错误

4. **查看诊断信息**：
   - 运行 `:lua vim.diagnostic.get(0)` 查看当前缓冲区的诊断
   - 或者使用 `[d` 和 `]d` 导航错误

---

## 🔧 故障排除

### 问题 1：ESLint LSP 没有启动

**检查方法**：
```vim
:LspInfo
```

**解决方法**：
1. 确保安装了 ESLint LSP：`:Mason`，搜索 `eslint-lsp`
2. 确保项目根目录有 ESLint 配置文件
3. 重启 Neovim

### 问题 2：ESLint 配置文件未被识别

**检查方法**：
```vim
:LspLog
```

**解决方法**：
1. 确保配置文件在项目根目录
2. 确保配置文件格式正确（JSON 或 JS）
3. 确保安装了 `eslint-plugin-react-hooks`

### 问题 3：规则不生效

**检查方法**：
```bash
# 在项目根目录运行
npx eslint your-file.jsx
```

**解决方法**：
1. 确保在 ESLint 配置中启用了 `react-hooks/exhaustive-deps` 规则
2. 确保规则级别设置为 `'warn'` 或 `'error'`
3. 确保安装了 `eslint-plugin-react-hooks`

### 问题 4：TypeScript 项目不显示错误

**解决方法**：
1. 确保安装了 `@typescript-eslint/parser` 和 `@typescript-eslint/eslint-plugin`
2. 在 ESLint 配置中添加 TypeScript 解析器：
   ```javascript
   parser: '@typescript-eslint/parser',
   parserOptions: {
     ecmaVersion: 'latest',
     sourceType: 'module',
     project: './tsconfig.json', // 如果使用项目类型检查
   },
   ```

---

## 📝 配置要点总结

### Neovim 配置（已修复）✅
- ✅ ESLint LSP 服务器正确配置（`eslint`）
- ✅ 配置了 `root_dir` 自动检测项目根目录
- ✅ 配置了 `workingDirectory` 自动模式，确保在项目目录运行
- ✅ ESLint 会自动从项目根目录读取配置文件（`.eslintrc.*`、`eslint.config.js`、`package.json` 中的配置）

### 项目配置（需要你完成）⚠️
1. **项目根目录必须有 ESLint 配置文件**（`.eslintrc.js` 或 `eslint.config.js`）
2. **必须安装 `eslint-plugin-react-hooks`**
3. **必须在配置中启用 `react-hooks/exhaustive-deps` 规则**

---

## 🎯 快速检查清单

- [ ] Mason 中安装了 `eslint-lsp`
- [ ] 项目根目录有 ESLint 配置文件
- [ ] 安装了 `eslint-plugin-react-hooks`
- [ ] ESLint 配置中启用了 `react-hooks/exhaustive-deps` 规则
- [ ] 重启了 Neovim
- [ ] 运行 `:LspInfo` 确认 ESLint 已连接

完成以上步骤后，React Hook 的依赖检查应该就能正常工作了！

