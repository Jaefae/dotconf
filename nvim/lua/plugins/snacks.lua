-- Replaces telescope.nvim. Telescope's sorter is pure Lua (no fzf-native
-- built here, and no C toolchain guaranteed on every machine), which is the
-- slow path on Windows where each candidate batch also costs a process spawn.
-- snacks.picker does its matching in a single async pass and reuses one rg
-- invocation, so it stays responsive on large trees.
return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		picker = {
			enabled = true,
			sources = {
				-- Glob semantics, not Lua patterns. The old telescope config
				-- used `file_ignore_patterns = { "build", ... }`, and a bare
				-- "build" matched any path *containing* the substring —
				-- hiding rebuild.c, src/builder.rs, buildings/. Anchoring to
				-- a directory segment is what was actually meant.
				files = { exclude = { "build/", ".git/" } },
				grep = { exclude = { "build/", ".git/" } },
			},
		},
	},
	keys = {
		{ "<leader>ff", function() Snacks.picker.files() end, desc = "Find File" },
		{ "<leader>fg", function() Snacks.picker.grep() end, desc = "Search Text" },
		{ "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
		{ "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent Files" },
		{ "<leader>fh", function() Snacks.picker.help() end, desc = "Help Tags" },
		{ "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
		{ "<leader>fk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
		{ "<leader>fR", function() Snacks.picker.resume() end, desc = "Resume Last Picker" },
	},
}
