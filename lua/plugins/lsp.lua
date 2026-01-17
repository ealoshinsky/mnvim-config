-- lua/plugins/lsp.lua
return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},

	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = "williamboman/mason.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "gopls", "ts_ls", "html", "cssls", "jsonls" },
			})
		end,
	},

	{
		"b0o/schemastore.nvim",
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"b0o/schemastore.nvim",
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local on_attach = function(client, bufnr)
				local map = function(m, lhs, rhs, desc)
					vim.keymap.set(m, lhs, rhs, { buffer = bufnr, desc = desc })
				end

				map("n", "K", vim.lsp.buf.hover, "Hover")
				map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
				map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
				map("n", "gi", vim.lsp.buf.implementation, "Goto Implementation")
				map("n", "gr", vim.lsp.buf.references, "References")
				map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
				map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
				map("n", "<leader>f", function()
					vim.lsp.buf.format({ async = true })
				end, "Format")
				-- Go-specific
				if client.name == "gopls" then
					map("n", "<leader>gi", function()
						vim.ui.input({ prompt = "Import package: " }, function(input)
							if input then
								vim.cmd("GoImport " .. input)
							end
						end)
					end, "Go: Add import")
					map("n", "<leader>gt", "<cmd>GoTest -v<CR>", "Go: Run tests")
				end
			end

			-- Lua
			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						workspace = { library = vim.api.nvim_get_runtime_file("", true) },
						telemetry = { enable = false },
					},
				},
			})

			-- Go
			vim.lsp.config("gopls", {
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					gopls = {
						completeUnimported = true,
						usePlaceholders = true,
						-- Ключевые настройки для автоимпортов:
						experimentalPostfixCompletions = true,
						analyses = {
							unusedparams = true,
							shadow = true,
							nilness = true,
							unusedwrite = true,
							useany = true,
							unusedvariable = true,
							staticcheck = true,
						},
						hints = {
							assignVariableTypes = true,
							compositeLiteralFields = true,
							constantValues = true,
							functionTypeParameters = true,
							parameterNames = true,
							rangeVariableTypes = true,
						},
						staticcheck = true,
						gofumpt = true,
						directoryFilters = { "-node_modules", "-.git", "-.env", "-build" },
						codelenses = {
							generate = true,
							gc_details = true,
							test = true,
							tidy = true,
							upgrade_dependency = true,
							run_vulncheck_exp = true,
						},
						symbolMatcher = "fuzzy",
						semanticTokens = true,

						templateExtensions = { "gotmpl", "tmpl", "html" },
					},
				},
			})

			-- TypeScript/JavaScript
			vim.lsp.config("ts_ls", {
				capabilities = capabilities,
				on_attach = on_attach,
			})

			-- HTML
			vim.lsp.config("html", {
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "html", "javascriptreact", "typescriptreact" },
			})

			-- CSS
			vim.lsp.config("cssls", {
				capabilities = capabilities,
				on_attach = on_attach,
			})

			-- JSON
			vim.lsp.config("jsonls", {
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				},
			})

			-- Диагностика
			vim.diagnostic.config({
				virtual_text = { prefix = "●", spacing = 4 },
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				float = { border = "rounded", source = "always" },
			})

			-- Красивые hover и signature
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
				border = "rounded",
				focusable = false,
			})

			vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
				border = "rounded",
				focusable = false,
			})
		end,
	},
}
