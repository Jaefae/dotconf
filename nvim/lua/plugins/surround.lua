return {
  "kylechui/nvim-surround",
  version = "*",
  event = "VeryLazy",
  init = function()
    -- Default visual-mode key is "S", which collides with flash.nvim's
    -- Flash Treesitter (flash.lua maps "S" in n/x/o). Move surround off it;
    -- "gS" (visual-line, add around each line) is untouched.
    --
    -- As of nvim-surround v4, keymaps are no longer configured via
    -- setup({ keymaps = ... }) (passing that now just errors); remapping is
    -- done by disabling the default and binding the <Plug> mapping instead.
    -- See :h nvim-surround.migrating.v3_to_v4
    vim.g.nvim_surround_no_visual_mappings = true
  end,
  keys = {
    { "gs", "<Plug>(nvim-surround-visual)", mode = "x" },
    { "gS", "<Plug>(nvim-surround-visual-line)", mode = "x" },
  },
}
