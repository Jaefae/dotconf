return {
  "rebelot/kanagawa.nvim",
  priority = 1000,
  config = function()
    vim.opt.background = "dark"
    require("kanagawa").setup({
      background = { dark = "dragon" },
      -- Let the wezterm backdrop show through, matching the old Everforest setup.
      transparent = true,
      dimInactive = true,
    })
    vim.cmd("colorscheme kanagawa-dragon")
  end,
}
