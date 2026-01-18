-- lua/plugins/lsp.lua (для Neovim 0.11+)
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
				ensure_installed = {
					"lua_ls",
					"gopls",
					"ts_ls",
					"html",
					"cssls",
					"jsonls",
				},
			})
		end,
	},
	{
		"hrsh7th/cmp-nvim-lsp",
	},
	{
		"b0o/schemastore.nvim",
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"b0o/schemastore.nvim",
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- ============================================
			-- GOPLS (Go Language Server)
			-- ============================================
			vim.lsp.config("gopls", {
				cmd = { "gopls" },
				filetypes = { "go", "gomod", "gowork", "gotmpl" },
				root_markers = { "go.work", "go.mod", ".git" },
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
							useany = true,
						},
						hints = {
							assignVariableTypes = true,
							compositeLiteralFields = true,
							compositeLiteralTypes = true,
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
							vendor = true,
						},
						semanticTokens = true,
						diagnosticsDelay = "500ms",
						expandWorkspaceToModule = true,
						directoryFilters = {
							"-node_modules",
							"-.git",
							"-build",
							"-vendor",
						},
						matcher = "Fuzzy",
						deepCompletion = true,
						completeFunctionCalls = true,
					},
				},
			})

			-- ============================================
			-- TypeScript/JavaScript (ts_ls)
			-- ============================================
			vim.lsp.config("ts_ls", {
				cmd = { "typescript-language-server", "--stdio" },
				filetypes = {
					"javascript",
					"javascriptreact",
					"javascript.jsx",
					"typescript",
					"typescriptreact",
					"typescript.tsx",
				},
				root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
				capabilities = capabilities,
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

			-- ============================================
			-- HTML
			-- ============================================
			vim.lsp.config("html", {
				cmd = { "vscode-html-language-server", "--stdio" },
				filetypes = { "html", "javascriptreact", "typescriptreact" },
				root_markers = { ".git" },
				capabilities = capabilities,
			})

			-- ============================================
			-- CSS
			-- ============================================
			vim.lsp.config("cssls", {
				cmd = { "vscode-css-language-server", "--stdio" },
				filetypes = { "css", "scss", "less" },
				root_markers = { ".git" },
				capabilities = capabilities,
			})

			-- ============================================
			-- JSON with schemas
			-- ============================================
			vim.lsp.config("jsonls", {
				cmd = { "vscode-json-language-server", "--stdio" },
				filetypes = { "json", "jsonc" },
				root_markers = { ".git" },
				capabilities = capabilities,
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				},
			})

			-- ============================================
			-- Lua (для конфигурации Neovim)
			-- ============================================
			vim.lsp.config("lua_ls", {
				cmd = { "lua-language-server" },
				filetypes = { "lua" },
				root_markers = {
					".luarc.json",
					".luarc.jsonc",
					".luacheckrc",
					".stylua.toml",
					"stylua.toml",
					"selene.toml",
					"selene.yml",
					".git",
				},
				capabilities = capabilities,
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						telemetry = { enable = false },
						hint = { enable = true },
					},
				},
			})

			-- ============================================
			-- Включение LSP для буферов
			-- ============================================
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "go", "gomod", "gowork", "gotmpl" },
				callback = function()
					vim.lsp.enable("gopls")
				end,
			})

			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
				callback = function()
					vim.lsp.enable("ts_ls")
				end,
			})

			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "html" },
				callback = function()
					vim.lsp.enable("html")
				end,
			})

			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "css", "scss", "less" },
				callback = function()
					vim.lsp.enable("cssls")
				end,
			})

			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "json", "jsonc" },
				callback = function()
					vim.lsp.enable("jsonls")
				end,
			})

			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "lua" },
				callback = function()
					vim.lsp.enable("lua_ls")
				end,
			})

			-- ============================================
			-- Общие горячие клавиши для всех LSP
			-- ============================================
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local buf = args.buf
					local client = vim.lsp.get_client_by_id(args.data.client_id)

					local map = function(mode, lhs, rhs, desc)
						vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
					end

					-- Навигация
					map("n", "gd", vim.lsp.buf.definition, "Go to definition")
					map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
					map("n", "gr", vim.lsp.buf.references, "Find references")
					map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
					map("n", "gy", vim.lsp.buf.type_definition, "Go to type definition")

					-- Документация
					map("n", "K", vim.lsp.buf.hover, "Hover documentation")
					map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
					map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature help")

					-- Рефакторинг
					map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
					map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")

					-- Диагностика
					map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
					map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
					map("n", "<leader>e", vim.diagnostic.open_float, "Show diagnostic")
					map("n", "<leader>dl", vim.diagnostic.setloclist, "Diagnostics to loclist")

					-- Символы
					map("n", "<leader>ds", vim.lsp.buf.document_symbol, "Document symbols")
					map("n", "<leader>ws", vim.lsp.buf.workspace_symbol, "Workspace symbols")

					-- Форматирование
					if client.server_capabilities.documentFormattingProvider then
						map("n", "<leader>f", function()
							vim.lsp.buf.format({ async = false })
						end, "Format buffer")
					end

					-- Подсветка символов под курсором
					if client.server_capabilities.documentHighlightProvider then
						local highlight_augroup =
							vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })

						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd("CursorMoved", {
							buffer = buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})
					end

					-- Inlay hints
					if client.server_capabilities.inlayHintProvider then
						vim.lsp.inlay_hint.enable(true, { bufnr = buf })

						map("n", "<leader>th", function()
							local current = vim.lsp.inlay_hint.is_enabled({ bufnr = buf })
							vim.lsp.inlay_hint.enable(not current, { bufnr = buf })
						end, "Toggle inlay hints")
					end

					-- Go-специфичные команды
					if client.name == "gopls" then
						map("n", "<leader>gt", "<cmd>!go test ./...<CR>", "Run all tests")
						map("n", "<leader>gv", "<cmd>!go vet ./...<CR>", "Run go vet")
						map("n", "<leader>gb", "<cmd>!go build<CR>", "Build project")
					end
				end,
			})

			-- ============================================
			-- Настройки диагностики
			-- ============================================
			vim.diagnostic.config({
				virtual_text = {
					prefix = "●",
					spacing = 4,
					source = "if_many",
				},
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				float = {
					border = "rounded",
					source = "always",
					header = "",
					prefix = "",
				},
			})

			-- Символы для диагностики (новый API для Neovim 0.11+)
			vim.diagnostic.config({
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "",
						[vim.diagnostic.severity.WARN] = "",
						[vim.diagnostic.severity.HINT] = "",
						[vim.diagnostic.severity.INFO] = "",
					},
				},
			})

			-- Улучшенные hover-окна
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
				border = "rounded",
				max_width = 80,
			})

			vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
				border = "rounded",
				max_width = 80,
			})
		end,
	},
}
