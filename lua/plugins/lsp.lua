-- plugins/lsp.lua
return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
	},
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lspconfig = require("lspconfig")
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
			map("n", "R", vim.lsp.buf.rename, "Rename")
			map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")

			-- Go-specific
			if client.name == "gopls" then
				map("n", "<leader>gi", "<cmd>GoImport ", "Go: Add import")
				map("n", "<leader>gt", "<cmd>GoTest -v<CR>", "Go: Run tests")
			end
		end

		-- gopls
		vim.lsp.config("gopls", {
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				gopls = {
					completeUnimported = true,
					usePlaceholders = true,
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
					semanticTokens = true,
					directoryFilters = { "-node_modules", "-.git", "-.env", "-build" },
					codelenses = {
						generate = true,
						gc_details = true,
						test = true,
						tidy = true,
						upgrade_dependency = true,
						run_vulncheck_exp = true,
					},
				},
			},
		})

		-- Конфигурация для TypeScript/JavaScript
		vim.lsp.config("ts_ls", {
			capabilities = capabilities,
			on_attach = function(client, bufnr)
				-- Форматирование при сохранении для TypeScript/JavaScript
				vim.api.nvim_create_autocmd("BufWritePre", {
					buffer = bufnr,
					callback = function()
						vim.lsp.buf.format({
							async = false,
							filter = function(format_client)
								return format_client.name == "tsserver"
							end,
						})
					end,
				})

				-- TypeScript-специфичные команды
				local map = function(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
				end

				map("n", "<leader>to", "<cmd>TSLspOrganize<CR>", "Organize imports")
				map("n", "<leader>tR", "<cmd>TSLspRenameFile<CR>", "Rename file")
				map("n", "<leader>ti", "<cmd>TSLspImportAll<CR>", "Import all")
			end,
			settings = {
				typescript = {
					inlayHints = {
						includeInlayParameterNameHints = "all",
						includeInlayParameterNameHintsWhenArgumentMatchesName = true,
						includeInlayFunctionParameterTypeHints = true,
						includeInlayVariableTypeHints = true,
						includeInlayPropertyDeclarationTypeHints = true,
						includeInlayFunctionLikeReturnTypeHints = true,
						includeInlayEnumMemberValueHints = true,
					},
					suggest = {
						completeFunctionCalls = true,
					},
				},
				javascript = {
					inlayHints = {
						includeInlayParameterNameHints = "all",
						includeInlayParameterNameHintsWhenArgumentMatchesName = true,
						includeInlayFunctionParameterTypeHints = true,
						includeInlayVariableTypeHints = true,
						includeInlayPropertyDeclarationTypeHints = true,
						includeInlayFunctionLikeReturnTypeHints = true,
						includeInlayEnumMemberValueHints = true,
					},
					suggest = {
						completeFunctionCalls = true,
					},
				},
			},
		})

		-- Конфигурация для HTML (React JSX/TSX)
		vim.lsp.config("html-lsp", {
			capabilities = capabilities,
			filetypes = { "html", "javascriptreact", "typescriptreact" },
		})

		-- Конфигурация для CSS
		vim.lsp.config("css_lsp", {
			capabilities = capabilities,
		})

		-- Конфигурация для JSON
		vim.lsp.config("jsonls", {
			capabilities = capabilities,
			settings = {
				json = {
					schemas = require("schemastore").json.schemas(),
					validate = { enable = true },
				},
			},
		})

		-- Настройки диагностики
		vim.diagnostic.config({
			virtual_text = {
				prefix = "●",
				spacing = 4,
			},
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,
			float = {
				border = "rounded",
				source = "always",
			},
		})

		-- Улучшенные ховер-окна
		vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
			border = "rounded",
			focusable = false,
		})

		vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
			border = "rounded",
			focusable = false,
		})
	end,
}
