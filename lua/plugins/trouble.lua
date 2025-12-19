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
			-- Настройки для отображения
			multiline = true, -- Показывать многострочные сообщения
			fold_open = "",
			fold_closed = "",
			padding = false,
			-- Настройки группировки
			group = true,
			cycle_results = true,
			-- Настройки индикаторов
			icons = true,
			severity = nil,
			title = true,
		})

		-- Добавляем маппинги для trouble
		vim.keymap.set(
			"n",
			"<leader>xx",
			"<cmd>Trouble diagnostics toggle<cr>",
			{ desc = "Toggle trouble diagnostics" }
		)
		vim.keymap.set(
			"n",
			"<leader>xw",
			"<cmd>Trouble workspace_diagnostics toggle<cr>",
			{ desc = "Toggle workspace diagnostics" }
		)
		vim.keymap.set(
			"n",
			"<leader>xd",
			"<cmd>Trouble document_diagnostics toggle<cr>",
			{ desc = "Toggle document diagnostics" }
		)
	end,
}
