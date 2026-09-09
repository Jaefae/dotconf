return {
  "ellisonleao/gruvbox.nvim",
  priority = 1000,
  config = function()
    vim.opt.background = "dark"
    require("gruvbox").setup({
      -- Let the wezterm backdrop show through, matching the old carbonfox setup.
      transparent_mode = true,
      dim_inactive = true,
    })
    vim.cmd("colorscheme gruvbox")
  end,
}
