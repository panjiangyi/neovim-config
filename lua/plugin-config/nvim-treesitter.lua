return {
  ensure_installed = { "json", "html", "css", "vim", "lua", "javascript", "typescript", "tsx", "python", "go", "rust", "java", "c", "cpp" },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-space>",
      node_incremental = "<C-space>",
      node_decremental = "<bs>",
      scope_incremental = "<C-s>",
    },
  },
  indent = {
    enable = true,
  },
}