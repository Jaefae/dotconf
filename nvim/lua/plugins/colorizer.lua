return {
  "catgoose/nvim-colorizer.lua",
  -- Scoped to filetypes that actually contain colour literals. The previous
  -- `"*"` attached a highlighter to every buffer, which is pure overhead on
  -- source files that never contain a hex code.
  ft = { "css", "scss", "html", "lua", "toml", "yaml", "json", "conf" },
  opts = {
    filetypes = { "css", "scss", "html", "lua", "toml", "yaml", "json", "conf" },
    user_default_options = {
      css = true,
      css_fn = true,
      mode = "background",
    },
  },
}
