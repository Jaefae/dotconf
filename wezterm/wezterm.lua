local wezterm = require("wezterm")

local config = wezterm.config_builder()
local tab_style = "square"

config.font_size = 13
config.color_scheme = 'One Dark (Gogh)'
config.font = wezterm.font("0xProto Nerd Font")
-- Disable IME to prevent Windows keystroke interception bugs
config.line_height = 1.0

config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_and_split_indices_are_zero_based = false
config.window_decorations = "RESIZE"
config.term = "xterm-256color"
config.default_prog = { 'nu' }
config.front_end = "OpenGL" -- If you were on WebGpu

config.animation_fps = 24
-- 1. Disable IME to stop the "per-character" shift
config.use_ime = false

-- 2. Force a strict line height (prevents rounding errors that move the buffer)
config.line_height = 1.0

-- 3. Prevent the terminal from "snapping" to bottom on input
config.scroll_to_bottom_on_input = false

config.window_padding = {
	left = 4,
	right = 4,
	top = 4,
	bottom = 4,
}

config.leader = { key = " ", mods = "CTRL", timeout_milliseconds = 2000 }
config.keys = {
	{
		mods = "LEADER",
		key = ".",
		action = wezterm.action.ToggleFullScreen,
	},
    { key = '=', mods = 'CTRL', action = wezterm.action.IncreaseFontSize },
    { key = '-', mods = 'CTRL', action = wezterm.action.DecreaseFontSize },
	{
		mods = "LEADER",
		key = "c",
		action = wezterm.action.SpawnTab("CurrentPaneDomain"),
	},
	{
		mods = "LEADER",
		key = "x",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	{
		mods = "ALT",
		key = "b",
		action = wezterm.action.ActivateTabRelative(-1),
	},
	{
		mods = "ALT",
		key = "n",
		action = wezterm.action.ActivateTabRelative(1),
	},
	{
		mods = "LEADER",
		key = "\\",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "LEADER",
		key = "-",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "LEADER",
		key = "LeftArrow",
		action = wezterm.action.AdjustPaneSize({ "Left", 5 }),
	},
	{
		mods = "LEADER",
		key = "RightArrow",
		action = wezterm.action.AdjustPaneSize({ "Right", 5 }),
	},
	{
		mods = "LEADER",
		key = "DownArrow",
		action = wezterm.action.AdjustPaneSize({ "Down", 5 }),
	},
	{
		mods = "LEADER",
		key = "UpArrow",
		action = wezterm.action.AdjustPaneSize({ "Up", 5 }),
	},
	{
		mods = "ALT",
		key = "x",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
}

for i = 0, 9 do
	-- alt + number to activate that tab
	table.insert(config.keys, {
		key = tostring(i),
		mods = "ALT",
		action = wezterm.action.ActivateTab(i-1),
	})
end

--[[
============================
Tab Bar
============================
]]
--

-- tab bar
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = false
config.use_fancy_tab_bar = false

config.colors = {
	tab_bar = {
		background = '#21252b',
		active_tab = {
			bg_color = '#282c34',
			fg_color = '#abb2bf',
			intensity = 'Normal',
			underline = 'None',
			italic = false,
			strikethrough = false,
		},
		inactive_tab = {
			bg_color = '#21252b',
			fg_color = '#5c6370',
		},
		inactive_tab_hover = {
			bg_color = '#3e4451',
			fg_color = '#abb2bf',
		},
		new_tab = {
			bg_color = '#21252b',
			fg_color = '#5c6370',
		},
		new_tab_hover = {
			bg_color = '#3e4451',
			fg_color = '#abb2bf',
		},
	},
}

local function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	return tab_info.active_pane.title
end

local function is_vim(pane)
	return pane:get_user_vars().IS_NVIM == '1'
end

local function nav(dir, key)
	return wezterm.action_callback(function(win, pane)
		if is_vim(pane) then
			win:perform_action({ SendKey = { key = key, mods = 'CTRL' } }, pane)
		else
			win:perform_action({ ActivatePaneDirection = dir }, pane)
		end
	end)
end

local function resize(dir, key)
	return wezterm.action_callback(function(win, pane)
		if is_vim(pane) then
			win:perform_action({ SendKey = { key = key, mods = 'META' } }, pane)
		else
			win:perform_action({ AdjustPaneSize = { dir, 3 } }, pane)
		end
	end)
end

-- CTRL+h/j/k/l: navigate panes (pass through to nvim)
table.insert(config.keys, { key = 'h', mods = 'CTRL', action = nav('Left',  'h') })
table.insert(config.keys, { key = 'j', mods = 'CTRL', action = nav('Down',  'j') })
table.insert(config.keys, { key = 'k', mods = 'CTRL', action = nav('Up',    'k') })
table.insert(config.keys, { key = 'l', mods = 'CTRL', action = nav('Right', 'l') })

-- META+h/j/k/l: resize panes (pass through to nvim)
table.insert(config.keys, { key = 'h', mods = 'META', action = resize('Left',  'h') })
table.insert(config.keys, { key = 'j', mods = 'META', action = resize('Down',  'j') })
table.insert(config.keys, { key = 'k', mods = 'META', action = resize('Up',    'k') })
table.insert(config.keys, { key = 'l', mods = 'META', action = resize('Right', 'l') })

return config
