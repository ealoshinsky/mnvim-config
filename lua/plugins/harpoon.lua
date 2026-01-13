-- lua/plugins/harpoon.lua
return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")

		-- Обязательная инициализация
		harpoon:setup({
			settings = {
				save_on_toggle = true,
				sync_on_ui_close = true,
				key = function()
					-- Отдельные списки для каждого проекта (git repo)
					return vim.loop.cwd()
				end,
			},
		})
	end,
}
