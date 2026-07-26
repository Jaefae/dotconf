local wezterm = require("wezterm")
local config = wezterm.config_builder()
local tab_style = "square"
local is_windows = wezterm.target_triple:find("windows") ~= nil

config.font_size = 13
-- Everforest ships no terminal theme of its own, so this follows the community
-- mapping: background and normal colors are the upstream dark/medium palette;
-- the brights are Everforest's light-palette accents, which are more saturated
-- and so read correctly as "bright".
--
-- Defined inline rather than by name: WezTerm only bundles the "Dark Medium"
-- scheme on nightly, and naming a scheme the running build doesn't have falls
-- back to a black default rather than erroring.
config.color_schemes = {
	["Everforest Dark Medium"] = {
		ansi = { "#343f44", "#e67e80", "#a7c080", "#dbbc7f", "#7fbbb3", "#d699b6", "#83c092", "#d3c6aa" },
		brights = { "#5c6a72", "#f85552", "#8da101", "#dfa000", "#3a94c5", "#df69ba", "#35a77c", "#dfddc8" },
		foreground = "#d3c6aa",
		background = "#2d353b",
		cursor_fg = "#2d353b",
		cursor_bg = "#d3c6aa",
		cursor_border = "#d3c6aa",
		selection_fg = "#d3c6aa",
		selection_bg = "#543a48", -- bg_visual
	},
}
config.color_scheme = "Everforest Dark Medium"

-- Blurred/dimmed backdrop. The image is fully pre-processed with ImageMagick —
-- including the bg0 (#2d353b) overlay baked in at 55% — so at runtime it's a
-- single opaque layer with no per-frame alpha blending (that compositing was a
-- measurable source of typing latency):
--   magick output.png -resize 2560x1440^ -gravity center -extent 2560x1440 \
--     -blur 0x20 -modulate 45 -fill "#2d353b" -colorize 55 \
--     -strip -quality 85 backgrounds/outputblur.jpg
-- To shift the balance: raise the -colorize value toward a flatter background,
-- lower it to let more of the image through. config_dir resolves on both
-- platforms because link.ps1/link.sh symlink the whole wezterm/ directory. Uses
-- the layered `background` API; the older window_background_image is deprecated.
config.background = {
	{
		source = { File = wezterm.config_dir .. "/backgrounds/outputblur.jpg" },
		width = "100%",
		height = "100%",
	},
}
config.font = wezterm.font_with_fallback({
	"0xProto Nerd Font Mono",
	"0xProto Nerd Font",
	"0xProto NF",
	is_windows and "Cascadia Code" or "Menlo",
})

config.tab_and_split_indices_are_zero_based = false
config.window_decorations = "RESIZE"
config.term = "xterm-256color"
config.front_end = is_windows and "WebGpu" or "OpenGL"

-- Latency: cap presents high (bump to your monitor's refresh) and force the
-- discrete GPU so WebGpu doesn't silently land on the integrated one.
config.max_fps = 120
config.webgpu_power_preference = "HighPerformance"
-- Stop the blinking cursor from forcing a full-window repaint while idle.
config.cursor_blink_rate = 0

-- Windows: use PowerShell 7 (pwsh). macOS/Linux: inherit the login shell.
if is_windows then
	config.default_prog = { "pwsh", "-NoLogo" }
end

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
	{ key = "=", mods = "CTRL", action = wezterm.action.IncreaseFontSize },
	{ key = "-", mods = "CTRL", action = wezterm.action.DecreaseFontSize },
	{
		mods = "LEADER",
		key = "c",
		action = wezterm.action.SpawnTab("CurrentPaneDomain"),
	},
	{
		mods = "LEADER",
		key = "x",
		action = wezterm.action.CloseCurrentPane({ confirm = false }),
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
		action = wezterm.action.CloseCurrentPane({ confirm = false }),
	},
}

for i = 0, 9 do
	-- alt + number to activate that tab
	table.insert(config.keys, {
		key = tostring(i),
		mods = "ALT",
		action = wezterm.action.ActivateTab(i - 1),
	})
end

--[[
============================
Tab Bar
============================
]]
--

-- Retro (non-fancy) tab bar, pinned to the top, hidden when only one tab is open.
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = true

config.colors = {
	-- Tab bar drawn from Everforest's dark/medium background scale. The active
	-- tab sits at bg0 so it reads as continuous with the pane; the bar itself
	-- recedes to bg_dim.
	tab_bar = {
		background = "#232a2e",
		active_tab = {
			bg_color = "#2d353b",
			fg_color = "#d3c6aa",
			intensity = "Normal",
			underline = "None",
			italic = false,
			strikethrough = false,
		},
		inactive_tab = {
			bg_color = "#232a2e",
			fg_color = "#7a8478",
		},
		inactive_tab_hover = {
			bg_color = "#343f44",
			fg_color = "#9da9a0",
		},
		new_tab = {
			bg_color = "#232a2e",
			fg_color = "#7a8478",
		},
		new_tab_hover = {
			bg_color = "#343f44",
			fg_color = "#9da9a0",
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
	return pane:get_user_vars().IS_NVIM == "1"
end

local function nav(dir, key)
	return wezterm.action_callback(function(win, pane)
		if is_vim(pane) then
			win:perform_action({ SendKey = { key = key, mods = "CTRL" } }, pane)
		else
			win:perform_action({ ActivatePaneDirection = dir }, pane)
		end
	end)
end

local function resize(dir, key)
	return wezterm.action_callback(function(win, pane)
		if is_vim(pane) then
			win:perform_action({ SendKey = { key = key, mods = "META" } }, pane)
		else
			win:perform_action({ AdjustPaneSize = { dir, 3 } }, pane)
		end
	end)
end

-- CTRL+h/j/k/l: navigate panes (pass through to nvim)
table.insert(config.keys, { key = "h", mods = "CTRL", action = nav("Left", "h") })
table.insert(config.keys, { key = "j", mods = "CTRL", action = nav("Down", "j") })
table.insert(config.keys, { key = "k", mods = "CTRL", action = nav("Up", "k") })
table.insert(config.keys, { key = "l", mods = "CTRL", action = nav("Right", "l") })

-- META+h/j/k/l: resize panes (pass through to nvim)
table.insert(config.keys, { key = "h", mods = "META", action = resize("Left", "h") })
table.insert(config.keys, { key = "j", mods = "META", action = resize("Down", "j") })
table.insert(config.keys, { key = "k", mods = "META", action = resize("Up", "k") })
table.insert(config.keys, { key = "l", mods = "META", action = resize("Right", "l") })

return config
