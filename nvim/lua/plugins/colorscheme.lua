return {
  "sainnhe/everforest",
  priority = 1000,
  config = function()
    -- These must be set before the colorscheme command.
    vim.opt.background = "dark" -- "light" for the light variant
    vim.g.everforest_background = "medium" -- hard | medium | soft
    vim.g.everforest_better_performance = 1 -- recommended upstream
    -- Let the wezterm backdrop show through. 2 also clears the statusline and
    -- other UI components.
    vim.g.everforest_transparent_background = 1
    vim.cmd("colorscheme everforest")
  end,
}
