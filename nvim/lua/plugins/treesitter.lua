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
    -- af/if/ac/ic textobjects and ]m/[m/]]/[[ jumps, scoped to actual
    -- function/class nodes instead of blank-line heuristics.
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main", -- tracks nvim-treesitter's main branch above
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move = { set_jumps = true },
      })

      local select = require("nvim-treesitter-textobjects.select")
      vim.keymap.set({ "x", "o" }, "af", function() select.select_textobject("@function.outer", "textobjects") end)
      vim.keymap.set({ "x", "o" }, "if", function() select.select_textobject("@function.inner", "textobjects") end)
      vim.keymap.set({ "x", "o" }, "ac", function() select.select_textobject("@class.outer", "textobjects") end)
      vim.keymap.set({ "x", "o" }, "ic", function() select.select_textobject("@class.inner", "textobjects") end)

      local move = require("nvim-treesitter-textobjects.move")
      vim.keymap.set({ "n", "x", "o" }, "]m", function() move.goto_next_start("@function.outer", "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "]]", function() move.goto_next_start("@class.outer", "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "[m", function() move.goto_previous_start("@function.outer", "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "[[", function() move.goto_previous_start("@class.outer", "textobjects") end)
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
