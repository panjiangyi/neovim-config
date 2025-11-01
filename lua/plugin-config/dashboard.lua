local ok, dashboard = pcall(require, "dashboard")
if not ok then
  vim.notify("没有找到 dashboard-nvim", vim.log.levels.WARN)
  return
end

local header = {
  "",
  "          .-''''-.          ",
  "       .-'  _    _'-.       ",
  "     .'    (o)--(o)  '.     ",
  "    /    .-'      '-.  \\    ",
  "   ;    /            \\  ;   ",
  "   |   ;              ; |   ",
  "   ;   |              | ;   ",
  "    \\  ;              ; /   ",
  "     '.;              ;.'   ",
  "       '-.          .-'     ",
  "          '-......-'        ",
  "",
  "    Wake up. Open vim. Shape reality.  ",
  "",
}

local center = {
  {
    icon = "  ",
    desc = "Projects",
    key = "p",
    action = "Telescope projects",
  },
  {
    icon = "  ",
    desc = "Recent files",
    key = "r",
    action = "Telescope oldfiles",
  },
  {
    icon = "  ",
    desc = "Bookmarks",
    key = "m",
    action = "Telescope marks",
  },
  {
    icon = "  ",
    desc = "Edit keybindings",
    key = "k",
    action = "edit ~/.config/nvim/lua/keybindings.lua",
  },
  {
    icon = "  ",
    desc = "Open config",
    key = "c",
    action = "edit ~/.config/nvim/init.lua",
  },
  {
    icon = "  ",
    desc = "Colorschemes",
    key = "t",
    action = "Telescope colorscheme",
  },
  {
    icon = "  ",
    desc = "Find files",
    key = "f",
    action = "Telescope find_files",
  },
}

local stats = require("lazy").stats()
local ms = math.floor(stats.startuptime * 100 + 0.5) / 100

local footer = {
  string.format("⚡ Loaded %d plugins in %sms", stats.loaded, ms),
  "  Follow your curiosity.",
  "  " .. os.date("%Y-%m-%d %H:%M"),
}

dashboard.setup({
  theme = "doom",
  hide = {
    statusline = false,
    tabline = false,
    winbar = true,
  },
  config = {
    header = header,
    center = center,
    footer = footer,
  },
})

