return {
	"nvim-telescope/telescope.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File" },
		{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Search Text" },
		{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
	},
	opts = {
		defaults = {
			file_ignore_patterns = { "^build/", "/build/", "^build\\", "\\build\\", "build", ".git" },
		},
	},
}
