local ok, project = pcall(require, "project_nvim")
if not ok then
  vim.notify("没有找到 project_nvim", vim.log.levels.WARN)
  return
end

project.setup({
  detection_methods = { "pattern", "lsp" },
  patterns = {
    "package.json",
    "pyproject.toml",
    "poetry.lock",
    "Cargo.toml",
    "go.mod",
    "composer.json",
    "pnpm-workspace.yaml",
    "Makefile",
    ".git",
    ".hg",
    ".bzr",
    ".svn",
  },
  exclude_dirs = { "~/.local/share" },
  show_hidden = true,
  silent_chdir = false,
  scope_chdir = "global",
})

local telescope_ok, telescope = pcall(require, "telescope")
if telescope_ok then
  telescope.load_extension("projects")
end

