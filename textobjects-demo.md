# Treesitter Textobjects 使用演示

## 已安装和配置

✅ `nvim-treesitter-textobjects` 已安装并配置完成
✅ 支持 TypeScript、Python 以及所有已安装的语言

## 快速开始

### 1. 选择整个函数

在 TypeScript 或 Python 文件中，将光标放在函数内的任意位置，然后：

- 按 `vaf` - 进入可视模式并选择整个函数（包括注释和签名）
- 按 `vif` - 选择函数内部代码（不包括函数签名）

### 2. 操作函数

你可以用这些文本对象执行各种操作：

- `daf` - 删除整个函数
- `yaf` - 复制整个函数
- `caf` - 修改整个函数
- `=af` - 格式化整个函数

### 3. 在函数之间跳转

- `]f` - 跳转到下一个函数开始
- `[f` - 跳转到上一个函数开始
- `]F` - 跳转到下一个函数结束
- `[F` - 跳转到上一个函数结束

## 测试代码示例

### TypeScript 示例

创建一个 test.ts 文件并测试：

```typescript
// 这是一个测试函数
function greet(name: string): string {
  if (name) {
    return `Hello, ${name}!`;
  }
  return "Hello!";
}

class Person {
  constructor(private name: string) {}
  
  sayHello(): void {
    console.log(this.greet(this.name));
  }
  
  private greet(name: string): string {
    return `Hi, ${name}`;
  }
}

const multiply = (a: number, b: number): number => {
  return a * b;
};
```

### Python 示例

创建一个 test.py 文件并测试：

```python
def calculate_sum(numbers):
    """计算数字列表的总和"""
    total = 0
    for num in numbers:
        total += num
    return total

class Calculator:
    def __init__(self, initial_value=0):
        self.value = initial_value
    
    def add(self, number):
        """添加数字"""
        self.value += number
        return self.value
    
    def multiply(self, number):
        """乘以数字"""
        self.value *= number
        return self.value

# Lambda 函数
square = lambda x: x ** 2
```

## 所有可用的文本对象

### 选择操作（配合 v、d、y、c 等使用）

- `af` / `if` - 函数（outer/inner）
- `ac` / `ic` - 类（outer/inner）
- `ai` / `ii` - 条件语句（outer/inner）
- `al` / `il` - 循环（outer/inner）
- `aa` / `ia` - 参数（outer/inner）
- `a/` - 注释块

### 跳转操作

- `]f` / `[f` - 下一个/上一个函数开始
- `]F` / `[F` - 下一个/上一个函数结束
- `]c` / `[c` - 下一个/上一个类开始
- `]C` / `[C` - 下一个/上一个类结束
- `]a` / `[a` - 下一个/上一个参数

## 实际使用场景

### 场景 1：重构函数

1. 用 `vaf` 选择整个函数
2. 用 `y` 复制
3. 跳到新位置，用 `p` 粘贴
4. 回到原函数，用 `daf` 删除

### 场景 2：快速浏览代码

1. 用 `]f` 跳到下一个函数
2. 用 `K` 查看文档
3. 用 `[f` 跳回上一个函数

### 场景 3：编辑参数

1. 光标在参数上，按 `via` 选择参数
2. 输入新参数
3. 按 `]a` 跳到下一个参数继续编辑

### 场景 4：选择类的所有方法

1. 用 `vac` 选择整个类
2. 用 `=` 格式化整个类

## 重启 Neovim 生效

保存所有更改后，请重启 Neovim 或运行：

```vim
:source ~/.config/nvim/init.lua
:TSUpdate
```

## 如果遇到问题

1. 确保 Treesitter 解析器已安装：
   ```vim
   :TSInstall typescript python
   ```

2. 检查 Treesitter 状态：
   ```vim
   :checkhealth nvim-treesitter
   ```

3. 查看已安装的模块：
   ```vim
   :TSModuleInfo
   ```

## 更多信息

完整的配置在：`lua/plugin-config/nvim-treesitter.lua`
所有快捷键说明在：`KEYBINDINGS.md`

