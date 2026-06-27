return {
  'akinsho/toggleterm.nvim',
  version = "*",
  -- Rarely used (wezterm splits handle most terminal needs), so keep it off
  -- the startup path: load only when the toggle key or a command is used.
  keys = { [[<C-\>]] },
  cmd = { "ToggleTerm", "TermExec", "ToggleTermToggleAll", "TermSelect" },
  config = function()
    require("toggleterm").setup({
      size = 80,
      open_mapping = [[<C-\>]], -- This is the magic key to show/hide it
      direction = 'vertical',  
      shade_terminals = false,
      -- Use nushell if available, otherwise the OS default shell
      shell = vim.fn.executable('nu') == 1 and 'nu' or vim.o.shell,
      winbar = {
        enabled = false,
        name_formatter = function(term) --  term: Terminal
          return term.name
        end
        },
    })
  end
}
