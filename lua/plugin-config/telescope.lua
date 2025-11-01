local ok, telescope = pcall(require, "telescope")
if not ok then
  return
end

telescope.setup({
  defaults = {
    initial_mode = "insert",
    mappings = require("keybindings").telescopeList,
  },
  pickers = {
    find_files = {
      -- theme = "dropdown",
    },
  },
  extensions = {},
})

pcall(telescope.load_extension, "env")

