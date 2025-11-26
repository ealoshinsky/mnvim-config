-- lsp.lua (дополняем существующий файл)
return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- Инициализация Mason
		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = { "gopls", "ts_ls", "html-lsp", "css_lsp", "jsonls" },
			automatic_installation = true,
		})

		-- Улучшенная конфигурация для gopls
		vim.lsp.config("gopls", {
			capabilities = capabilities,
			settings = {
				gopls = {
					completeUnimported = true,
					usePlaceholders = true,
					analyses = {
						unusedparams = true,
						shadow = true,
						nilness = true,
						unusedwrite = true,
						nilfunc = true,
						staticcheck = true,
						unusedvariable = true,
					},
					hints = {
						assignVariableTypes = true,
						compositeLiteralFields = true,
						constantValues = true,
						functionTypeParameters = true,
						parameterNames = true,
						rangeVariableTypes = true,
					},
					gofumpt = true,
					staticcheck = true,
					codelenses = {
						generate = true,
						gc_details = true,
						test = true,
						tidy = true,
					},
					semanticTokens = true,
					diagnosticsDelay = "500ms",
					expandWorkspaceToModule = true,
					buildFlags = {},
					directoryFilters = { "-node_modules", "-.git", "-build" },
					matcher = "fuzzy",
					deepCompletion = true,
					completeFunctionCalls = true,
				},
			},
			flags = {
				debounce_text_changes = 200,
				allow_incremental_sync = true,
			},
			on_attach = function(client, bufnr)
				-- Форматирование при сохранении для Go
				vim.api.nvim_create_autocmd("BufWritePre", {
					buffer = bufnr,
					callback = function()
						vim.lsp.buf.format({
							async = false,
							filter = function(format_client)
								return format_client.name == "gopls"
							end,
						})
					end,
				})

				-- Дополнительные ключевые связки для Go
				local map = function(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
				end

				-- Специфичные для Go команды
				map("n", "<leader>gt", "<cmd>GoTest<CR>", "Run tests")
				map("n", "<leader>gv", "<cmd>GoVet<CR>", "Run go vet")
				map("n", "<leader>t", "<cmd>GoTestFunc<CR>", "Test current function")
				map("n", "<leader>T", "<cmd>GoTestFile<CR>", "Test current file")

				-- Быстрое переключение между тестом и кодом
				map("n", "<leader>ga", "<cmd>GoAlt<CR>", "Switch test/implementation")
			end,
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

		-- Общие горячие клавиши для всех LSP
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local buf = args.buf
				local client = vim.lsp.get_client_by_id(args.data.client_id)

				local map = function(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
				end

				-- Основная навигация
				map("n", "gd", vim.lsp.buf.definition, "Go to definition")
				map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
				map("n", "gr", vim.lsp.buf.references, "Find references")
				map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
				map("n", "K", vim.lsp.buf.hover, "Hover documentation")
				map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature help")

				-- Работа с кодом
				map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
				map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
				map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")

				-- Диагностики
				map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
				map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
				map("n", "<leader>dl", "<cmd>lua vim.diagnostic.setloclist()<CR>", "Show diagnostics list")

				-- Информация о символе
				map("n", "<leader>ds", function()
					vim.lsp.buf.document_symbol()
				end, "Document symbols")

				map("n", "<leader>ws", function()
					vim.lsp.buf.workspace_symbol()
				end, "Workspace symbols")

				-- Форматирование
				if client.server_capabilities.documentFormattingProvider then
					map("n", "<leader>f", vim.lsp.buf.format, "Format buffer")
				end

				-- Подсветка символов под курсором
				if client.server_capabilities.documentHighlightProvider then
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = buf,
						callback = function()
							vim.lsp.buf.document_highlight()
						end,
					})

					vim.api.nvim_create_autocmd("CursorMoved", {
						buffer = buf,
						callback = function()
							vim.lsp.buf.clear_references()
						end,
					})
				end
			end,
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

		-- Символы для диагностики
		local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
		end

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
