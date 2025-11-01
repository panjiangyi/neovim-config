-- Neo-tree configuration
vim.keymap.set('n', '<C-n>', ':Neotree filesystem reveal left<CR>')
vim.keymap.set('n', '<leader>e', ':Neotree filesystem reveal left<CR>')
vim.keymap.set('n', '<leader>bf', ':Neotree buffers reveal float<CR>')
vim.keymap.set('n', '<leader>gs', ':Neotree git_status reveal left<CR>')

-- Close neo-tree with Escape when it has focus
vim.keymap.set('n', '<Esc>', function()
  if vim.bo.filetype == 'neo-tree' then
    vim.cmd('Neotree close')
  end
end, { buffer = true })

local devicons_ok, devicons = pcall(require, 'nvim-web-devicons')
if devicons_ok then
  devicons.set_icon({
    ts = { icon = "📘", color = "#3178c6", cterm_color = "33", name = "TypeScript" },
    js = { icon = "📒", color = "#f7df1e", cterm_color = "220", name = "JavaScript" },
    py = { icon = "🐍", color = "#ffbc03", cterm_color = "214", name = "Python" },
    json = { icon = "🧾", color = "#cbcb41", cterm_color = "185", name = "Json" },
    md = { icon = "📝", color = "#519aba", cterm_color = "67", name = "Markdown" },
    markdown = { icon = "📝", color = "#519aba", cterm_color = "67", name = "Markdown" },
    yml = { icon = "📄", color = "#ffbc03", cterm_color = "214", name = "Yaml" },
    yaml = { icon = "📄", color = "#ffbc03", cterm_color = "214", name = "Yaml" },
    [".gitignore"] = { icon = "🚫", color = "#f14c28", cterm_color = "196", name = "GitIgnore" },
  })
end

-- Basic neo-tree setup
require('neo-tree').setup({
  close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
  popup_border_style = "rounded",
  enable_git_status = true,
  enable_diagnostics = true,
  enable_normal_mode_for_inputs = true,
  open_files_do_not_replace_types = { "terminal", "trouble", "qf" }, -- when opening files, do not use windows containing these filetypes or buftypes
  sort_case_insensitive = false, -- used when sorting files and directories in the tree
  sort_function = nil , -- use a custom function for sorting files and directories
  -- A list of functions, each representing a global custom command
  -- that will be available in all sources (if not overridden in `opts[source_name]`)
  commands = {}, -- get a list of commands by running `:NeotreeCommands`
  default_component_configs = {
    icon = {
      folder_closed = "📁",
      folder_open = "📂",
      folder_empty = "🗂️",
      default = "📄",
    },
    modified = {
      symbol = "[+]",
    },
    git_status = {
      symbols = {
        added     = "[A]",
        modified  = "[M]",
        deleted   = "[D]",
        renamed   = "[R]",
        untracked = "[U]",
        ignored   = "[I]",
        unstaged  = "[!]",
        staged    = "[S]",
        conflict  = "[C]",
      }
    },
  },

  filesystem = {
    bind_to_cwd = true,
    cwd_target = "global",
    follow_current_file = {
      enabled = true,
      leave_dirs_open = false,
    },
    hijack_netrw_behavior = "open_default",
    use_libuv_file_watcher = true,
    filtered_items = {
      visible = false,
      hide_dotfiles = false,
      hide_gitignored = true,
    },
  },

  buffers = {
    follow_current_file = {
      enabled = true,
      leave_dirs_open = false,
    },
  },

  git_status = {
    window = {
      position = "left",
    },
  },

  -- window = {
  --   width = 30,
  --   mappings = {
  --     ["<space>"] = "toggle_node",
  --     ["<2-LeftMouse>"] = "open",
  --     ["<cr>"] = "open",
  --     ["<esc>"] = "cancel",
  --     ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
  --     -- ["S"] = "open_split",
  --     -- ["s"] = "open_vsplit",
  --     -- ["t"] = "open_tabnew",
  --     -- ["w"] = "open_with_window_picker",
  --     -- ["C"] = "close_node",
  --     -- ["z"] = "close_all_nodes",
  --     --["R"] = "refresh",
  --     --["a"] = { "add", config = { show_path = "none" } },
  --     --["A"] = "add_directory", -- also accepts the optional config.show_path option like "add".
  --     --["d"] = "delete",
  --     --["r"] = "rename",
  --     --["y"] = "copy_to_clipboard",
  --     --["x"] = "cut_to_clipboard",
  --     --["p"] = "paste_from_clipboard",
  --     --["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
  --     --["c"] = { "copy", config = { show_path = "none" } },
  --     --["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
  --     --["m"] = { "move", config = { show_path = "none" } },
  --   },
  -- },
  -- nesting_rules = {},
  -- filesystem = {
  --   filtered_items = {
  --     visible = false, -- when true, they will just be displayed differently than normal items
  --     hide_dotfiles = true,
  --     hide_gitignored = true,
  --     hide_hidden = true,
  --     hide_by_name = {
  --       "node_modules",
  --       ".git",
  --     },
  --     hide_by_pattern = { -- uses glob style patterns
  --       --"*.meta",
  --       --"*/src/*/tsconfig.json",
  --     },
  --     always_show = { -- remains visible even if other settings would normally hide it
  --       --".gitignored",
  --     },
  --     never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
  --       --".DS_Store",
  --       --"thumbs.db"
  --     },
  --     never_show_by_pattern = { -- uses glob style patterns
  --       --".null-ls_*",
  --     },
  --   },
  --   follow_current_file = {
  --     enabled = false, -- This will find and focus the file in the active buffer every time
  --     --               -- the current file is changed while the tree is open.
  --     leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
  --   },
  --   group_empty_dirs = false, -- when true, empty folders will be grouped together
  --   hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
  --                           -- in whatever position is specified in window.position
  --                         -- "open_current",  -- netrw disabled, opening a directory opens within the
  --                           -- window like netrw would, regardless of window.position
  --                         -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
  --   use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
  --                                 -- instead of relying on nvim autocmd events.
  --   window = {
  --     mappings = {
  --       ["<bs>"] = "navigate_up",
  --       ["."] = "set_root",
  --       ["H"] = "toggle_hidden",
  --       ["/"] = "fuzzy_finder",
  --       ["D"] = "fuzzy_finder_directory",
  --       ["f"] = "filter_on_submit",
  --       ["<c-x>"] = "clear_filter",
  --       ["[g"] = "prev_git_modified",
  --       ["]g"] = "next_git_modified",
  --     },
  --     fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
  --       ["<down>"] = "move_cursor_down",
  --       ["<C-n>"] = "move_cursor_down",
  --       ["<up>"] = "move_cursor_up",
  --       ["<C-p>"] = "move_cursor_up",
  --     },
  --   },
  --   commands = {}, -- Add a custom command by overriding the global command table custom_commands.name
  -- },
  -- buffers = {
  --   follow_current_file = {
  --     enabled = true, -- This will find and focus the file in the active buffer every time
  --     --              -- the current file is changed while the tree is open.
  --     leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
  --   },
  --   group_empty_dirs = true, -- when true, empty folders will be grouped together
  --   show_unloaded = true,
  --   window = {
  --     mappings = {
  --       ["bd"] = "buffer_delete",
  --       ["<bs>"] = "navigate_up",
  --       ["."] = "set_root",
  --     },
  --   },
  -- },
  -- git_status = {
  --   window = {
  --     position = "float",
  --     mappings = {
  --       ["A"] = "git_add_all",
  --       ["gu"] = "git_unstage_file",
  --       ["ga"] = "git_add_file",
  --       ["gr"] = "git_revert_file",
  --       ["gc"] = "git_commit",
  --       ["gp"] = "git_push",
  --       ["gg"] = "git_commit_and_push",
  --     },
  --   },
  -- },
})