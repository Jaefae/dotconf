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

vim.g.mapleader = " "
opt.clipboard = "unnamedplus"
