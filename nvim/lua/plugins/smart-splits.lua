-- Tell WezTerm this pane is nvim via OSC 1337 user variable (more reliable than process-name detection)
if vim.env.WEZTERM_PANE or vim.env.TERM_PROGRAM == 'WezTerm' then
  local function set_wezterm_user_var(name, value)
    io.write(('\027]1337;SetUserVar=%s=%s\007'):format(name, value))
    io.flush()
  end
  vim.api.nvim_create_autocmd({ 'VimEnter', 'VimResume' }, {
    callback = function() set_wezterm_user_var('IS_NVIM', 'MQ==') end, -- MQ== is base64('1')
  })
  vim.api.nvim_create_autocmd({ 'VimLeave', 'VimSuspend' }, {
    callback = function() set_wezterm_user_var('IS_NVIM', '') end,
  })
end

-- Navigate nvim splits, falling through to WezTerm panes at boundaries
local wezterm_dir = { h = 'Left', j = 'Down', k = 'Up', l = 'Right' }
local function navigate(dir)
  local cur = vim.api.nvim_get_current_win()
  vim.cmd('wincmd ' .. dir)
  if vim.api.nvim_get_current_win() == cur then
    vim.fn.jobstart({ 'wezterm', 'cli', 'activate-pane-direction', wezterm_dir[dir] })
  end
end

-- Normal and terminal mode. WezTerm forwards CTRL+h/j/k/l to this pane whenever
-- IS_NVIM is set, so without the terminal-mode maps the keys were simply swallowed
-- inside :terminal and toggleterm buffers instead of moving between splits.
for key, dir in pairs({ h = 'h', j = 'j', k = 'k', l = 'l' }) do
  vim.keymap.set('n', '<C-' .. key .. '>', function() navigate(dir) end)
  vim.keymap.set('t', '<C-' .. key .. '>', function()
    vim.cmd('stopinsert')
    navigate(dir)
  end)
end

-- Resize splits
vim.keymap.set('n', '<A-h>', '<C-w><')
vim.keymap.set('n', '<A-j>', '<C-w>-')
vim.keymap.set('n', '<A-k>', '<C-w>+')
vim.keymap.set('n', '<A-l>', '<C-w>>')

return {}
