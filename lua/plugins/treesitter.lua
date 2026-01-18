-- lua/plugins/treesitter.lua
return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
		config = function()
			require("nvim-treesitter.config").setup({
				ensure_installed = {
					"lua",
					"vim",
					"vimdoc",
					"go",
					"gomod",
					"gosum",
					"gowork",
					"typescript",
					"javascript",
					"tsx",
					"json",
					"jsonc",
					"yaml",
					"toml",
					"markdown",
					"markdown_inline",
					"html",
					"css",
					"scss",
					"dockerfile",
					"bash",
					"gitignore",
					"gitcommit",
					"proto",
					"sql",
					"regex",
					"comment",
				},
				auto_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				indent = {
					enable = true,
					disable = { "go" }, -- gopls лучше
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<C-space>",
						node_incremental = "<C-space>",
						scope_incremental = false,
						node_decremental = "<bs>",
					},
				},
			})

			-- Folding
			vim.opt.foldmethod = "expr"
			vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
			vim.opt.foldlevel = 99
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-ts-autotag").setup({
				opts = {
					enable_close = true,
					enable_rename = true,
					enable_close_on_slash = false,
				},
			})
		end,
	},
}
