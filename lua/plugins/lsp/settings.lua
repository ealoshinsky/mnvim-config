-- LSP server configurations
local M = {}

-- Путь до @vue/language-server, установленного через Mason.
-- Подключается в vtsls как TypeScript-плагин @vue/typescript-plugin.
M.vue_language_server_path = vim.fn.stdpath("data")
	.. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

M.servers = {
	gopls = {
		cmd = { "gopls" },
		filetypes = { "go", "gotmpl" },
		root_markers = { "go.work", "go.mod", ".git" },
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
	},

	-- vtsls вместо ts_ls: Vue Language Server v3 работает только в hybrid mode
	-- и пробрасывает TS-запросы через команду `typescript.tsserverRequest`,
	-- которой нет в typescript-language-server (ts_ls).
	-- Включать ts_ls и vtsls одновременно нельзя.
	vtsls = {
		cmd = { "vtsls", "--stdio" },
		filetypes = {
			"javascript",
			"javascriptreact",
			"javascript.jsx",
			"typescript",
			"typescriptreact",
			"typescript.tsx",
			"vue",
		},
		root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
		settings = {
			vtsls = {
				autoUseWorkspaceTsdk = true,
				experimental = {
					completion = { enableServerSideFuzzyMatch = true },
				},
				tsserver = {
					globalPlugins = {
						{
							name = "@vue/typescript-plugin",
							location = M.vue_language_server_path,
							languages = { "vue" },
							configNamespace = "typescript",
							-- без этого плагин не подключается, когда tsserver
							-- берёт TypeScript из node_modules проекта
							enableForWorkspaceTypeScriptVersions = true,
						},
					},
				},
			},
			typescript = {
				updateImportsOnFileMove = { enabled = "always" },
				suggest = { completeFunctionCalls = true },
				inlayHints = {
					parameterNames = { enabled = "all" },
					parameterTypes = { enabled = true },
					variableTypes = { enabled = true },
					propertyDeclarationTypes = { enabled = true },
					functionLikeReturnTypes = { enabled = true },
					enumMemberValues = { enabled = true },
				},
			},
			javascript = {
				updateImportsOnFileMove = { enabled = "always" },
				suggest = { completeFunctionCalls = true },
				inlayHints = {
					parameterNames = { enabled = "all" },
					parameterTypes = { enabled = true },
					variableTypes = { enabled = true },
					propertyDeclarationTypes = { enabled = true },
					functionLikeReturnTypes = { enabled = true },
					enumMemberValues = { enabled = true },
				},
			},
		},
	},

	-- Vue 3 SFC: template/style + проксирование TS в vtsls.
	-- Обработчик `tsserver/request` берётся из дефолтного конфига nvim-lspconfig
	-- (lsp/vue_ls.lua) — он сам находит клиент vtsls в буфере.
	vue_ls = {
		cmd = { "vue-language-server", "--stdio" },
		filetypes = { "vue" },
		root_markers = { "vite.config.ts", "vite.config.js", "nuxt.config.ts", "package.json", ".git" },
	},

	html = {
		cmd = { "vscode-html-language-server", "--stdio" },
		filetypes = { "html", "javascriptreact", "typescriptreact" },
		root_markers = { ".git" },
	},

	cssls = {
		cmd = { "vscode-css-language-server", "--stdio" },
		filetypes = { "css", "scss", "less" },
		root_markers = { ".git" },
	},

	jsonls = {
		cmd = { "vscode-json-language-server", "--stdio" },
		filetypes = { "json", "jsonc" },
		root_markers = { ".git" },
		settings = {
			json = {
				schemas = function()
					return require("schemastore").json.schemas()
				end,
				validate = { enable = true },
			},
		},
	},

	lua_ls = {
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
	},
}

return M
