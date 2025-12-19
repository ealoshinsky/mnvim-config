-- Файл plugins.lua
return {
	-- Git интеграция
	{
		"tpope/vim-fugitive",
		config = function()
			vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Git status" })
			vim.keymap.set("n", "<leader>gd", ":Gvdiffsplit!<CR>", { desc = "Git diff" })
		end,
	},

	-- Diffview для просмотра изменений
	{
		"sindrets/diffview.nvim",
		config = function()
			require("diffview").setup({
				view = {
					merge_tool = {
						layout = "diff3_mixed",
					},
				},
			})
			vim.keymap.set("n", "<leader>gv", ":DiffviewOpen<CR>", { desc = "Open diff view" })
			vim.keymap.set("n", "<leader>gc", ":DiffviewClose<CR>", { desc = "Close diff view" })
		end,
	},

	-- GitHub/GitLab ссылки
	{
		"ruifm/gitlinker.nvim",
		dependencies = "nvim-lua/plenary.nvim",
		config = function()
			require("gitlinker").setup({
				mappings = "<leader>gy",
			})
		end,
	},

	-- Комментирование кода (полезно для ревью)
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},
}
