-- lua/plugins/review.lua
return {
	-- Diff просмотр
	{
		"sindrets/diffview.nvim",
		dependencies = "nvim-lua/plenary.nvim",
		config = function()
			require("diffview").setup({
				enhanced_diff_hl = true,
			})

			-- Простые команды ревью
			vim.keymap.set("n", "<leader>gv", "<cmd>DiffviewOpen --imply-local<CR>", { desc = "Open diff" }) -- Убрали imply-local из базовой, но оставили опцию
			vim.keymap.set("n", "<leader>gV", "<cmd>DiffviewClose<CR>", { desc = "Close diff" })

			-- Ревью любой ветки через Telescope
			vim.keymap.set("n", "<leader>gr", function()
				require("telescope.builtin").git_branches({
					attach_mappings = function(_, map)
						map("i", "<CR>", function(prompt_bufnr)
							local selection = require("telescope.actions.state").get_selected_entry()
							require("telescope.actions").close(prompt_bufnr)
							require("utils.git_utils").review_branch(selection.value)
						end)
						return true
					end,
				})
			end, { desc = "Review branch" })

			vim.keymap.set("n", "<leader>gf", "<cmd>DiffviewFileHistory %<CR>", { desc = "File history" }) -- Добавили из keymaps.lua для консолидации
		end,
	},

	-- Git аннотации
	{
		"rhysd/git-messenger.vim",
		config = function()
			vim.keymap.set("n", "<leader>gm", "<cmd>GitMessenger<CR>", { desc = "Git blame" })
		end,
	},
}
