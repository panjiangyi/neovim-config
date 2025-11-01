local map = vim.keymap.set

local function opts(desc)
  return { noremap = true, silent = true, desc = desc }
end

-- Telescope keymaps
map("n", "<C-p>", "<Cmd>Telescope find_files<CR>", opts("Find files"))
map("n", "<C-f>", "<Cmd>Telescope live_grep<CR>", opts("Live grep"))

local pluginKeys = {}

pluginKeys.telescopeList = {
  i = {
    ["<C-j>"] = "move_selection_next",
    ["<C-k>"] = "move_selection_previous",
    ["<Down>"] = "move_selection_next",
    ["<Up>"] = "move_selection_previous",
    ["<C-n>"] = "cycle_history_next",
    ["<C-p>"] = "cycle_history_prev",
    ["<C-c>"] = "close",
    ["<C-u>"] = "preview_scrolling_up",
    ["<C-d>"] = "preview_scrolling_down",
  },
}

return pluginKeys

