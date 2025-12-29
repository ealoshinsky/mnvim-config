-- lua/plugins/git.lua
return {
	-- Fugitive (базовые Git команды)
	{
		"tpope/vim-fugitive",
		config = function()
			-- Автоматические команды не нужны, используем keymaps ниже
		end,
	},

	-- Gitsigns (знаки в gutter, hunk actions)
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "│" },
					change = { text = "│" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
				},
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns

					vim.keymap.set("n", "]c", function()
						if vim.wo.diff then
							return "]c"
						end
						vim.schedule(function()
							gs.next_hunk()
						end)
						return "<Ignore>"
					end, { expr = true, buffer = bufnr, desc = "Next hunk" })

					vim.keymap.set("n", "[c", function()
						if vim.wo.diff then
							return "[c"
						end
						vim.schedule(function()
							gs.prev_hunk()
						end)
						return "<Ignore>"
					end, { expr = true, buffer = bufnr, desc = "Prev hunk" })

					vim.keymap.set("n", "<leader>hs", gs.stage_hunk, { buffer = bufnr, desc = "Stage hunk" })
					vim.keymap.set("n", "<leader>hr", gs.reset_hunk, { buffer = bufnr, desc = "Reset hunk" })
					vim.keymap.set("n", "<leader>hp", gs.preview_hunk, { buffer = bufnr, desc = "Preview hunk" })
					vim.keymap.set(
						"n",
						"<leader>hb",
						gs.toggle_current_line_blame,
						{ buffer = bufnr, desc = "Toggle blame" }
					)
				end,
			})
		end,
	},

	-- Diffview (для детального diff и history)
	{
		"sindrets/diffview.nvim",
		dependencies = "nvim-lua/plenary.nvim",
		config = function()
			require("diffview").setup({
				enhanced_diff_hl = true,
			})
		end,
	},
}
