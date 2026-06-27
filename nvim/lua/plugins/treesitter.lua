return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main", -- requires Neovim 0.12+ and the tree-sitter CLI
    build = ":TSUpdate",
    config = function()
      local langs = {
        "cpp", "c", "lua", "markdown", "markdown_inline",
        "vimdoc", "bash", "python", "rust",
      }
      require("nvim-treesitter").install(langs)

      -- The main branch does not auto-enable highlighting; start it per buffer.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = langs,
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },
  {
    -- Keeps the enclosing function/class header pinned at the top of the window
    "nvim-treesitter/nvim-treesitter-context",
    main = "treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      { "<leader>tc", function() require("treesitter-context").toggle() end, desc = "Toggle context" },
    },
    opts = {
      max_lines = 5,            -- cap total context lines (room for nested scope + multiline sig)
      multiline_threshold = 5,  -- show up to 5 lines of a single context (full multi-line signatures)
    },
  },
}
