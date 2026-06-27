return {
  "mrcjkb/rustaceanvim",
  version = "^6", -- pin to the current major to avoid surprise breaking changes
  lazy = false,   -- the plugin lazy-loads itself on Rust files; don't lazy-load it manually
  -- rustaceanvim configures and starts rust-analyzer on its own.
  -- It does NOT use the `vim.lsp.config`/`vim.lsp.enable` flow in lsp.lua, so
  -- the existing LspAttach autocmd there still provides all the usual keymaps
  -- (gd, gr, K, <leader>rn, inlay-hint toggle, etc.) for Rust buffers too.
}
