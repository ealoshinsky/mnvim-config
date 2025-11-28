-- plugins/go-extras.lua
return {
	{
		"fatih/vim-go",
		ft = "go",
		config = function()
			-- Отключаем LSP из vim-go, т.к. используем lspconfig
			vim.g.go_doc_keywordprg_enabled = 0
			vim.g.go_def_mapping_enabled = 0
			vim.g.go_code_completion_enabled = 0
		end,
	},
	{
		"olexsmir/gopher.nvim",
		ft = "go",
		config = function()
			require("gopher").setup()
		end,
		build = function()
			vim.cmd([[silent! GoInstallDeps]])
		end,
	},
	{
		"dmmulroy/tsc.nvim",
		ft = { "typescript", "typescriptreact" },
		config = function()
			require("tsc").setup({
				auto_open_qflist = false,
				use_trouble_qflist = true,
			})

			-- Клавиши для TypeScript Compiler
			vim.keymap.set("n", "<leader>tc", "<cmd>TSC<CR>", { desc = "TypeScript: Compile project" })
			vim.keymap.set("n", "<leader>tw", "<cmd>TSCWatch<CR>", { desc = "TypeScript: Watch mode" })
		end,
	},
	{
		"axelvc/template-string.nvim",
		ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
		config = function()
			require("template-string").setup({
				remove_template_string = true,
				restore_quotes = {
					normal = [[']],
					jsx = [["]],
				},
			})
		end,
	},
	{
		"b0o/schemastore.nvim", -- JSON schemas для TypeScript конфигураций
		ft = "json",
	},
}
