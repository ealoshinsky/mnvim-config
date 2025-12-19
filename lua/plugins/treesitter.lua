-- treesitter.lua
return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"go",
				"gomod",
				"gowork",
				"gosum",
				"typescript",
				"javascript",
				"tsx",
				"html",
				"css",
				"json",
				"jsonc",
			},
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = { "gotmpl" },
			},
			indent = { enable = true },
			autotag = {
				enable = true,
				filetypes = {
					"html",
					"javascript",
					"typescript",
					"javascriptreact",
					"typescriptreact",
				},
			},
		})
	end,
	-- Указываем правильные имена парсеров
	dependencies = {
		"nvim-treesitter/nvim-treesitter-angular", -- для JSX/TSX
	},
}
