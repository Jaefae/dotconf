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

opt.hlsearch = true

opt.undofile = true
opt.updatetime = 250
opt.timeoutlen = 300

opt.scrolloff = 10
opt.cursorline = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.numberwidth = 3

vim.g.mapleader = " "
opt.clipboard = "unnamedplus"

vim.keymap.set("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- C/C++ uses 2-space indent to match clang-format (.clang-format IndentWidth: 2)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
  end,
})

-- Re-fire BufReadPre/BufReadPost as User events that skip directory buffers,
-- so opening a dir with oil doesn't eagerly load LSP/git/treesitter plugins
-- that lazy-load on those events (oil still triggers the raw Buf* events).
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  pattern = "*",
  callback = function(args)
    if vim.fn.isdirectory(args.file) == 1 then return end
    vim.api.nvim_exec_autocmds("User", { pattern = "FilePre" })
  end,
})
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  pattern = "*",
  callback = function(args)
    if vim.bo[args.buf].filetype == "oil" then return end
    vim.api.nvim_exec_autocmds("User", { pattern = "FilePost" })
  end,
})
