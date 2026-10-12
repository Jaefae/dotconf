local wezterm = require("wezterm")
local config = wezterm.config_builder()
local tab_style = "square"
local is_windows = wezterm.target_triple:find("windows") ~= nil

config.font_size = 13
-- Dracula, matching the nvim colorscheme (Mofiqul/dracula.nvim). Inlined
-- rather than by name: naming a scheme the running build doesn't have falls
-- back to a black default rather than erroring.
config.color_schemes = {
	["Dracula"] = {
		ansi = { "#21222c", "#ff5555", "#50fa7b", "#f1fa8c", "#bd93f9", "#ff79c6", "#8be9fd", "#f8f8f2" },
		brights = { "#6272a4", "#ff6e6e", "#69ff94", "#ffffa5", "#d6acff", "#ff92df", "#a4ffff", "#ffffff" },
		foreground = "#f8f8f2",
		background = "#282a36",
		cursor_fg = "#282a36",
		cursor_bg = "#f8f8f2",
		cursor_border = "#f8f8f2",
		selection_fg = "#f8f8f2",
		selection_bg = "#44475a",
	},
}
config.color_scheme = "Dracula"

-- Flat solid background (Dracula bg, #282a36) instead of a photo backdrop. The
-- previous blurred-photo backdrop (backgrounds/forest.png, pre-processed into
-- wezterm/backgrounds/outputblur.jpg) had Everforest's bg0 baked directly
-- into the image pixels at 55% opacity, so it can't be reused as-is under a
-- different theme; regenerating it for Dracula needs ImageMagick
-- (`brew install imagemagick`), which isn't installed here. Flat also avoids
-- the per-frame image compositing that was a measurable source of typing
-- latency, so config.background is left unset and WezTerm just paints
-- `background` above.
config.font = wezterm.font_with_fallback({
	"FiraCode Nerd Font Mono",
	"FiraCode Nerd Font",
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
-- 2. Force a strict line height (prevents rounding errors that cut off character glyphs)
config.line_height = 1.0

-- 3. Prevent the terminal from "snapping" to bottom on input
config.scroll_to_bottom_on_input = false

config.window_padding = {
	left = 2,
	right = 2,
	top = 2,
	bottom = 2,
}

-- Fixed-step font sizing (see keybinds below): WezTerm's built-in
-- IncreaseFontSize/DecreaseFontSize scale by 10% of the current size, which
-- overshoots at this base size. Step by a flat 1pt instead, tracked via a
-- per-window override so each window can size independently.
local FONT_SIZE_STEP = 1
local FONT_SIZE_MIN = 6
wezterm.on("bump-font-size-increase", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	local current = overrides.font_size or config.font_size
	overrides.font_size = current + FONT_SIZE_STEP
	window:set_config_overrides(overrides)
end)
wezterm.on("bump-font-size-decrease", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	local current = overrides.font_size or config.font_size
	overrides.font_size = math.max(current - FONT_SIZE_STEP, FONT_SIZE_MIN)
	window:set_config_overrides(overrides)
end)

-- Leader is CTRL+b (tmux's default), not CTRL+Space. CTRL+Space was intercepted
-- by WezTerm before nvim or PSReadLine ever saw it, and the 2s timeout meant a
-- stray press swallowed the next keystroke for two full seconds. 1s is enough
-- for a deliberate chord. CTRL+b is unbound in PSReadLine's Windows edit mode.
config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	{
		mods = "LEADER",
		key = ".",
		action = wezterm.action.ToggleFullScreen,
	},
	-- Step by a fixed 1pt instead of WezTerm's default IncreaseFontSize/
	-- DecreaseFontSize, which jump in 10% multiplicative increments (too
	-- coarse at this base size).
	{
		key = "=",
		mods = "CTRL",
		action = wezterm.action.EmitEvent("bump-font-size-increase"),
	},
	{
		key = "-",
		mods = "CTRL",
		action = wezterm.action.EmitEvent("bump-font-size-decrease"),
	},
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
	-- Tab bar drawn from Dracula's dark scale. The active tab sits at the
	-- editor background so it reads as continuous with the pane; the bar
	-- itself recedes to Dracula's darker "background 2" tone.
	tab_bar = {
		background = "#191a21",
		active_tab = {
			bg_color = "#282a36",
			fg_color = "#f8f8f2",
			intensity = "Normal",
			underline = "None",
			italic = false,
			strikethrough = false,
		},
		inactive_tab = {
			bg_color = "#191a21",
			fg_color = "#6272a4",
		},
		inactive_tab_hover = {
			bg_color = "#44475a",
			fg_color = "#8be9fd",
		},
		new_tab = {
			bg_color = "#191a21",
			fg_color = "#6272a4",
		},
		new_tab_hover = {
			bg_color = "#44475a",
			fg_color = "#8be9fd",
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
			-- Vim treats <A-x> and <M-x> as the same modifier, so forwarding
			-- ALT here still lands on nvim's smart-splits.lua `<A-h>` maps.
			win:perform_action({ SendKey = { key = key, mods = "ALT" } }, pane)
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

-- CTRL+SHIFT+h/j/k/l: resize panes (pass through to nvim). Was META (the
-- physical Super/Cmd key), but that's not reliably cross-platform: Win+L
-- locks the screen on Windows before WezTerm ever sees the keypress, and
-- Cmd+H is reserved by macOS to hide the app. CTRL+SHIFT isn't claimed by
-- either OS.
table.insert(config.keys, { key = "h", mods = "CTRL|SHIFT", action = resize("Left", "h") })
table.insert(config.keys, { key = "j", mods = "CTRL|SHIFT", action = resize("Down", "j") })
table.insert(config.keys, { key = "k", mods = "CTRL|SHIFT", action = resize("Up", "k") })
table.insert(config.keys, { key = "l", mods = "CTRL|SHIFT", action = resize("Right", "l") })

return config
