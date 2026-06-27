-- Vim settings
local opt = vim.opt

opt.number = true
opt.relativenumber = true

opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true

opt.undofile = true
opt.updatetime = 250
opt.timeoutlen = 300

opt.scrolloff = 10
opt.cursorline = true
opt.termguicolors = true
opt.signcolumn = "yes"

vim.g.mapleader = " "
opt.clipboard = "unnamedplus"

-- C/C++ uses 2-space indent to match clang-format (.clang-format IndentWidth: 2)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
  end,
})
