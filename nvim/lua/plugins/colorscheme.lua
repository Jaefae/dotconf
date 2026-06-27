return {
  "folke/tokyonight.nvim",
  priority = 1000,
  opts = {
    style = "storm", -- night | storm | moon | day; "storm" matches wezterm "Tokyo Night Storm"
  },
  config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd("colorscheme tokyonight")
  end,
}
