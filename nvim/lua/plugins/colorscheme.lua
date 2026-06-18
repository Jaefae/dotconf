return {
  "joshdick/onedark.vim",
  priority = 1000,
  config = function()
    vim.cmd("colorscheme onedark")
    local function set_gutter_highlights()
      vim.api.nvim_set_hl(0, "LineNr",       { fg = "#4b5263", bg = "#21252b" })
      vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#e5c07b", bg = "#21252b", bold = true })
      vim.api.nvim_set_hl(0, "SignColumn",   { bg = "#21252b" })
      vim.api.nvim_set_hl(0, "FoldColumn",   { bg = "#21252b" })
      vim.api.nvim_set_hl(0, "CursorLine",   { bg = "#2c313a" })
    end
    set_gutter_highlights()
    vim.api.nvim_create_autocmd("ColorScheme", { callback = set_gutter_highlights })
  end,
}
