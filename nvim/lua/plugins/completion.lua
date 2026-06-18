return {
  'saghen/blink.cmp',
  version = '*', -- Use a release tag to keep it stable
  opts = {
    keymap = { preset = 'super-tab' }, -- Familiar feel for most devs
    appearance = {
      use_nvim_cmp_as_default = true, -- Smooth transition if you're used to cmp
      nerd_font_variant = 'mono'
    },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
  },
}
