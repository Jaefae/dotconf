return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  -- Must load at startup so `nvim <dir>` opens oil instead of netrw
  lazy = false,
  keys = {
    { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
  },
  opts = {
    default_file_explorer = true,
    view_options = {
      show_hidden = true,
    },
  },
}
