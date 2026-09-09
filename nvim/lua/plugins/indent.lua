return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = "User FilePost",
  opts = {
    indent = { char = "│" },
    scope = { enabled = true, show_start = false, show_end = false },
  },
}
