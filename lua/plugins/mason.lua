-- mason.lua
return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"jay-babu/mason-nvim-dap.nvim",
	},
	config = function()
		require("mason").setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		-- Автоматически ставит LSP серверы
		require("mason-lspconfig").setup({
			ensure_installed = {
				"gopls",
				"ts_ls",
				--				"html",
				--	"cssls",
				"jsonls",
				"emmet_ls", -- для React/HTML автодополнения
			},
			automatic_installation = true,
		})

		-- Автоматически ставит delve для отладки
		require("mason-nvim-dap").setup({
			ensure_installed = { "delve" },
			automatic_installation = true,
		})
	end,
}
