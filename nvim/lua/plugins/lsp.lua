return {
	{
		"williamboman/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonUninstall", "MasonLog" },
		config = true,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			ensure_installed = { "clangd", "lua_ls" },
		},
	},
	{
		-- Installs non-LSP tools (formatters, debuggers) through Mason
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			ensure_installed = { "stylua" },
		},
	},
	{
		"neovim/nvim-lspconfig",
		-- blink.cmp is a dependency so it loads first and registers its
		-- completion capabilities before any server is enabled below.
		dependencies = { "saghen/blink.cmp" },
		event = { "BufReadPre", "BufNewFile" },
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
			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						hint = { enable = true }, -- inlay hints
					},
				},
			})

			-- Start the servers for the current buffer
			-- (rust-analyzer is managed separately by rustaceanvim — see rust.lua)
			vim.lsp.enable({ "clangd", "lua_ls" })

			-- Neovim 0.11 disables inline diagnostic text by default
			vim.diagnostic.config({ virtual_text = true })

			-- Global Diagnostic Mappings
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
			vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Line diagnostics" })

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local function map(keys, fn, desc, mode)
						vim.keymap.set(mode or "n", keys, fn, { buffer = args.buf, desc = desc })
					end

					-- Navigation (Telescope pickers, falling back to raw LSP if unavailable)
					local ok, builtin = pcall(require, "telescope.builtin")
					map("gd", ok and builtin.lsp_definitions or vim.lsp.buf.definition, "Go to definition")
					map("gr", ok and builtin.lsp_references or vim.lsp.buf.references, "References")
					map("gi", ok and builtin.lsp_implementations or vim.lsp.buf.implementation, "Implementation")
					map("gy", ok and builtin.lsp_type_definitions or vim.lsp.buf.type_definition, "Type definition")
					map("<leader>fs", ok and builtin.lsp_document_symbols or vim.lsp.buf.document_symbol, "Document symbols")
					map(
						"<leader>fS",
						ok and builtin.lsp_dynamic_workspace_symbols or vim.lsp.buf.workspace_symbol,
						"Workspace symbols"
					)

					-- Documentation & signature help
					map("K", vim.lsp.buf.hover, "Hover documentation")
					map("<C-k>", vim.lsp.buf.signature_help, "Signature help", "i")

					-- Refactoring
					map("<leader>rn", vim.lsp.buf.rename, "Rename")
					map("<leader>ca", vim.lsp.buf.code_action, "Code action", { "n", "v" })

					-- Inlay hints (param names, inferred types) with a toggle
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client and client:supports_method("textDocument/inlayHint") then
						vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(
								not vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf }),
								{ bufnr = args.buf }
							)
						end, "Toggle inlay hints")
					end
				end,
			})
		end,
	},
}
