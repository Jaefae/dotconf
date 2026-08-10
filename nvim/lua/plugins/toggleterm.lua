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
      -- Match the shell the rest of this config sets up: pwsh on Windows,
      -- the login shell elsewhere. Without this Windows falls back to
      -- vim.o.shell, which is cmd.exe — no starship, none of the PATH fixes
      -- from Microsoft.PowerShell_profile.ps1.
      shell = vim.fn.has('win32') == 1 and 'pwsh' or vim.o.shell,
      winbar = {
        enabled = false,
        name_formatter = function(term) --  term: Terminal
          return term.name
        end
        },
    })
  end
}
