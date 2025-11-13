-- ============================================================================
-- 主题切换器测试脚本
-- ============================================================================
-- 使用方法：在 Neovim 中运行 :luafile test-theme-switcher.lua
-- ============================================================================

print("========================================")
print("主题切换器测试")
print("========================================")

-- 测试 1: 检查 theme-switcher 模块是否可加载
print("\n[测试 1] 检查 theme-switcher 模块...")
local ok, switcher = pcall(require, 'plugin-config.theme-switcher')
if ok then
  print("✓ theme-switcher 模块加载成功")
else
  print("✗ theme-switcher 模块加载失败: " .. tostring(switcher))
  return
end

-- 测试 2: 检查配置
print("\n[测试 2] 检查配置...")
print("  白天开始时间: " .. switcher.config.day_start_hour .. ":00")
print("  夜间开始时间: " .. switcher.config.day_end_hour .. ":00")
print("  白天主题: " .. switcher.config.light_theme)
print("  夜间主题: " .. switcher.config.dark_theme)
print("  自动切换: " .. (switcher.config.auto_switch and "启用" or "禁用"))
print("  检查间隔: " .. switcher.config.check_interval .. " 秒")

-- 测试 3: 检查当前时间和应该使用的主题
print("\n[测试 3] 检查当前时间...")
local hour = tonumber(os.date("%H"))
local minute = tonumber(os.date("%M"))
print("  当前时间: " .. hour .. ":" .. string.format("%02d", minute))

local should_be_light = (hour >= switcher.config.day_start_hour and hour < switcher.config.day_end_hour)
local expected_theme = should_be_light and switcher.config.light_theme or switcher.config.dark_theme
print("  预期主题: " .. expected_theme .. " (" .. (should_be_light and "light mode" or "dark mode") .. ")")

-- 测试 4: 检查当前主题
print("\n[测试 4] 检查当前主题...")
local current = vim.g.current_catppuccin_flavour
if current then
  print("  当前主题: " .. current)
  if current == expected_theme then
    print("✓ 当前主题与预期一致")
  else
    print("⚠ 当前主题与预期不一致（可能是手动切换的）")
  end
else
  print("⚠ 无法获取当前主题信息")
end

-- 测试 5: 检查快捷键
print("\n[测试 5] 检查快捷键...")
local keymaps_ok = true
local keymaps = vim.api.nvim_get_keymap('n')
local has_toggle = false
local has_auto = false

for _, map in ipairs(keymaps) do
  if map.lhs == '<Space>tt' or map.lhs == ' tt' then
    has_toggle = true
  end
  if map.lhs == '<Space>ta' or map.lhs == ' ta' then
    has_auto = true
  end
end

if has_toggle then
  print("✓ <leader>tt (切换主题) 已设置")
else
  print("✗ <leader>tt (切换主题) 未找到")
  keymaps_ok = false
end

if has_auto then
  print("✓ <leader>ta (启用自动切换) 已设置")
else
  print("✗ <leader>ta (启用自动切换) 未找到")
  keymaps_ok = false
end

-- 测试 6: 检查用户命令
print("\n[测试 6] 检查用户命令...")
local commands_ok = true
local commands = vim.api.nvim_get_commands({})

if commands.ThemeToggle then
  print("✓ :ThemeToggle 命令已注册")
else
  print("✗ :ThemeToggle 命令未找到")
  commands_ok = false
end

if commands.ThemeAutoEnable then
  print("✓ :ThemeAutoEnable 命令已注册")
else
  print("✗ :ThemeAutoEnable 命令未找到")
  commands_ok = false
end

if commands.ThemeAutoDisable then
  print("✓ :ThemeAutoDisable 命令已注册")
else
  print("✗ :ThemeAutoDisable 命令未找到")
  commands_ok = false
end

-- 总结
print("\n========================================")
print("测试总结")
print("========================================")
if keymaps_ok and commands_ok then
  print("✓ 所有测试通过！主题切换器已正确配置")
  print("\n你可以尝试：")
  print("  1. 按 <Space>tt 手动切换主题")
  print("  2. 运行 :ThemeToggle 切换主题")
  print("  3. 等待自动切换（每60秒检查一次）")
else
  print("⚠ 部分测试失败，请检查配置")
end
print("========================================")

