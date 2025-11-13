-- ============================================================================
-- 主题自动切换配置
-- ============================================================================
-- 功能：
-- 1. 根据时间自动切换 light/dark 模式
-- 2. 提供手动切换快捷键
-- 3. 保存用户手动选择的主题偏好
-- ============================================================================

local M = {}

-- 配置项
M.config = {
  -- 白天模式的时间范围（24小时制）
  day_start_hour = 6,   -- 早上6点开始使用 light mode
  day_end_hour = 18,    -- 下午6点开始使用 dark mode
  
  -- Catppuccin 主题 flavour 设置
  light_theme = "latte",  -- 白天使用的主题
  dark_theme = "mocha",   -- 晚上使用的主题
  
  -- 是否启用自动切换
  auto_switch = true,
  
  -- 检查时间间隔（秒）
  check_interval = 60,  -- 每60秒检查一次
}

-- 获取当前应该使用的主题
local function get_theme_by_time()
  local hour = tonumber(os.date("%H"))
  if hour >= M.config.day_start_hour and hour < M.config.day_end_hour then
    return M.config.light_theme
  else
    return M.config.dark_theme
  end
end

-- 应用主题
local function apply_theme(flavour)
  -- 检查 catppuccin 是否已加载
  local ok, catppuccin = pcall(require, 'catppuccin')
  if not ok then
    vim.notify("Catppuccin 主题未安装", vim.log.levels.WARN)
    return
  end
  
  -- 设置主题
  catppuccin.setup({
    flavour = flavour,
  })
  
  -- 应用配色方案
  vim.cmd([[colorscheme catppuccin]])
  
  -- 保存当前主题到全局变量
  vim.g.current_catppuccin_flavour = flavour
  
  -- 显示通知
  local mode_name = flavour == M.config.light_theme and "Light Mode" or "Dark Mode"
  vim.notify("已切换到 " .. mode_name .. " (" .. flavour .. ")", vim.log.levels.INFO)
end

-- 切换主题（在 light 和 dark 之间）
function M.toggle_theme()
  local current = vim.g.current_catppuccin_flavour or M.config.dark_theme
  local new_flavour
  
  if current == M.config.light_theme then
    new_flavour = M.config.dark_theme
  else
    new_flavour = M.config.light_theme
  end
  
  apply_theme(new_flavour)
  
  -- 禁用自动切换（用户手动选择后）
  M.config.auto_switch = false
  vim.notify("已禁用自动切换，将保持当前主题", vim.log.levels.INFO)
end

-- 启用自动切换
function M.enable_auto_switch()
  M.config.auto_switch = true
  vim.notify("已启用主题自动切换", vim.log.levels.INFO)
  M.check_and_switch()
end

-- 检查并切换主题
function M.check_and_switch()
  if not M.config.auto_switch then
    return
  end
  
  local target_theme = get_theme_by_time()
  local current_theme = vim.g.current_catppuccin_flavour or M.config.dark_theme
  
  if target_theme ~= current_theme then
    apply_theme(target_theme)
  end
end

-- 初始化
function M.setup(opts)
  -- 合并用户配置
  if opts then
    M.config = vim.tbl_deep_extend("force", M.config, opts)
  end
  
  -- 应用初始主题
  local initial_theme = get_theme_by_time()
  apply_theme(initial_theme)
  
  -- 设置自动检查定时器
  if M.config.auto_switch then
    local timer = vim.loop.new_timer()
    if timer then
      timer:start(0, M.config.check_interval * 1000, vim.schedule_wrap(function()
        M.check_and_switch()
      end))
    end
  end
  
  -- 设置快捷键
  vim.keymap.set('n', '<leader>tt', M.toggle_theme, { 
    noremap = true, 
    silent = true, 
    desc = "Toggle light/dark theme" 
  })
  
  vim.keymap.set('n', '<leader>ta', M.enable_auto_switch, { 
    noremap = true, 
    silent = true, 
    desc = "Enable auto theme switching" 
  })
  
  -- 创建用户命令
  vim.api.nvim_create_user_command('ThemeToggle', M.toggle_theme, {
    desc = '切换 light/dark 主题'
  })
  
  vim.api.nvim_create_user_command('ThemeAutoEnable', M.enable_auto_switch, {
    desc = '启用主题自动切换'
  })
  
  vim.api.nvim_create_user_command('ThemeAutoDisable', function()
    M.config.auto_switch = false
    vim.notify("已禁用主题自动切换", vim.log.levels.INFO)
  end, {
    desc = '禁用主题自动切换'
  })
end

return M

