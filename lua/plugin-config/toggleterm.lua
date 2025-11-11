return function()
  require("toggleterm").setup({
    size = 12,
    open_mapping = [[<leader>t]],
    shade_terminals = false,
    direction = "horizontal", -- 'vertical' | 'float' | 'tab'
    close_on_exit = true,
    start_in_insert = true,
    insert_mappings = true,
    terminal_mappings = true,
    persist_size = true,
  })

  -- Better escape from terminal to normal mode
  vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { desc = 'Terminal -> Normal' })
end


