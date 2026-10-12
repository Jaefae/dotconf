return {
  "Mofiqul/dracula.nvim",
  priority = 1000,
  config = function()
    vim.opt.background = "dark"
    require("dracula").setup({
      -- Let the wezterm backdrop show through, matching the old gruvbox setup.
      transparent_bg = true,
    })
    vim.cmd("colorscheme dracula")
  end,
}
