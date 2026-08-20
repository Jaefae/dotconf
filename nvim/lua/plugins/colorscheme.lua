return {
  "EdenEast/nightfox.nvim",
  priority = 1000,
  config = function()
    vim.opt.background = "dark"
    require("nightfox").setup({
      options = {
        -- Let the wezterm backdrop show through, matching the old Everforest setup.
        transparent = true,
        dim_inactive = true,
      },
    })
    vim.cmd("colorscheme carbonfox")
  end,
}
