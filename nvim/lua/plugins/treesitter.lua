return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install({
        "cpp", "c", "lua", "markdown", "markdown_inline",
        "vimdoc", "bash", "python"
      })
    end,
  },
  { "nvim-treesitter/nvim-treesitter-context" },
}
