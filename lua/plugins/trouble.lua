return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("trouble").setup({
			position = "bottom",
			height = 10,
			auto_open = false,
			auto_close = true,
			use_diagnostic_signs = true,
		})

		-- Добавляем маппинги для trouble
		vim.keymap.set(
			"n",
			"<leader>xx",
			"<cmd>Trouble diagnostics toggle<cr>",
			{ desc = "Toggle trouble diagnostics" }
		)
	end,
}
