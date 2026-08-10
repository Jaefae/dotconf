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
			-- rustaceanvim owns rust-analyzer; stop mason-lspconfig from
			-- auto-enabling a second instance for it.
			automatic_enable = { exclude = { "rust_analyzer" } },
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

			-- [d / ]d are built in as of 0.11 and are not deprecated; the old
			-- vim.diagnostic.goto_prev/goto_next they were remapped to are.
			vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Line diagnostics" })

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local function map(keys, fn, desc, mode)
						vim.keymap.set(mode or "n", keys, fn, { buffer = args.buf, desc = desc })
					end

					-- Neovim 0.11+ already ships grn (rename), gra (code action),
					-- grr (references), gri (implementation), grt (type definition)
					-- and K (hover). Those are deliberately NOT redefined here:
					-- binding plain `gr` made every one of them ambiguous, so each
					-- grr/grn/gra press stalled for timeoutlen (300ms) waiting to
					-- see whether it was really a bare `gr`.
					--
					-- What's left is what the defaults don't cover: a definition
					-- jump, and symbol pickers.
					map("gd", function() Snacks.picker.lsp_definitions() end, "Go to definition")
					map("<leader>fs", function() Snacks.picker.lsp_symbols() end, "Document symbols")
					map("<leader>fS", function() Snacks.picker.lsp_workspace_symbols() end, "Workspace symbols")

					-- Signature help. The 0.11 default for this is <C-s>, left
					-- unused here because <C-s> is XOFF under terminal flow control.
					map("<C-k>", function()
						vim.lsp.buf.signature_help({ border = "rounded" })
					end, "Signature help", "i")

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
