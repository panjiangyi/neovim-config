local ok, auto_session = pcall(require, "auto-session")
if not ok then
  vim.notify("没有找到 auto-session", vim.log.levels.WARN)
  return
end

auto_session.setup({
  log_level = "error",
  auto_session_suppress_dirs = { "~/", "~/Downloads", "/tmp", "/" },
  
  pre_save_cmds = { "Neotree close" },
  post_restore_cmds = { "Neotree show" },
})

