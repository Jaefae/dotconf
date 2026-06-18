return {
	{
		"williamboman/mason.nvim",
		config = true,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			ensure_installed = { "clangd", "lua_ls" },
		},
	},
	{
		-- Installs non-LSP tools (formatters, debuggers) through Mason
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = {
			ensure_installed = { "stylua" },
		},
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			-- The new Neovim 0.11+ way
			-- Instead of require('lspconfig').clangd.setup({})

			-- Setup C++ (clangd)
			vim.lsp.config("clangd", {
				capabilities = { offsetEncoding = { "utf-16" } },
				-- Optional: add your specific project arguments here
				cmd = { "clangd", "--background-index" },
			})

			-- Setup Lua
			vim.lsp.config("lua_ls", {})

			-- Start the servers for the current buffer
			vim.lsp.enable({ "clangd", "lua_ls" })

			-- Neovim 0.11 disables inline diagnostic text by default
			vim.diagnostic.config({ virtual_text = true })

			-- Global Diagnostic Mappings
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local opts = { buffer = args.buf }

					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts) -- Documentation
					opts.desc = "Go to definition"
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts) -- Go to definition
					opts.desc = "Refactor"
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- Refactor/Rename
					opts.desc = "Quick fix"
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts) -- Quick fixes
				end,
			})
		end,
	},
}
