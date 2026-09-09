return {
  "nvim-tree/nvim-tree.lua",
  -- Must load at startup so `nvim <dir>` opens the tree instead of netrw
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<leader>tt", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file tree" },
    { "<leader>tf", "<cmd>NvimTreeFindFile<cr>", desc = "Find current file in tree" },
  },
  opts = {
    disable_netrw = true,
    hijack_netrw = true,
    hijack_directories = { enable = true, auto_open = true },
    -- Keep the tree's cursor on whatever file is open in the other window.
    update_focused_file = { enable = true },
    view = { width = 30 },
    renderer = { group_empty = true },
    -- share/ and cache/ are stale, gitignored XDG dirs with 10k+ leftover
    -- files (see .gitignore) -- keep them out of the tree and git-status scan.
    filters = { dotfiles = false, git_ignored = true },
    git = { enable = true },
    actions = {
      open_file = { quit_on_open = false },
    },
  },
}
