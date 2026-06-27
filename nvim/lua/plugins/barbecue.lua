return {
  "utilyre/barbecue.nvim",
  name = "barbecue",
  version = "*",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "SmiteshP/nvim-navic", -- provides the symbol path from the LSP
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    -- navic attaches itself via barbecue; silence its own attach warning
    attach_navic = true,
  },
}
