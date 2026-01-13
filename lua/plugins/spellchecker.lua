-- lua/plugins/spellchecker.lua
return {
	"lewis6991/spellsitter.nvim",
	event = "VeryLazy",
	config = function()
		require("spellsitter").setup({
			enable = false, -- По умолчанию выключено
			hl = "SpellBad",
			captures = { "comment", "string" },
		})

		-- Настройка горячих клавиш и функций
		local function toggle_spell()
			if vim.wo.spell then
				vim.wo.spell = false
				vim.notify("Проверка орфографии ВЫКЛЮЧЕНА", vim.log.levels.INFO)
			else
				vim.wo.spell = true
				vim.wo.spelllang = "ru,en_us" -- Русский + Английский (US)
				vim.notify("Проверка орфографии ВКЛЮЧЕНА (ru+en)", vim.log.levels.INFO)
			end
		end

		-- Клавиши для управления
		vim.keymap.set(
			"n",
			"<leader>ss",
			toggle_spell,
			{ desc = "Вкл/выкл проверку орфографии" }
		)
		vim.keymap.set("n", "<leader>sn", "]s", { desc = "Следующая ошибка" })
		vim.keymap.set("n", "<leader>sp", "[s", { desc = "Предыдущая ошибка" })
		vim.keymap.set("n", "<leader>sa", "zg", { desc = "Добавить слово в словарь" })
		vim.keymap.set(
			"n",
			"<leader>s?",
			"z=",
			{ desc = "Предложить варианты исправления" }
		)
		vim.keymap.set(
			"n",
			"<leader>sw",
			"zw",
			{ desc = "Пометить слово как неправильное" }
		)

		-- Выбор языка
		vim.keymap.set("n", "<leader>sru", function()
			vim.wo.spelllang = "ru"
			vim.wo.spell = true
			vim.notify("Язык проверки: Русский", vim.log.levels.INFO)
		end, { desc = "Язык: Русский" })

		vim.keymap.set("n", "<leader>sen", function()
			vim.wo.spelllang = "en_us"
			vim.wo.spell = true
			vim.notify("Язык проверки: Английский (US)", vim.log.levels.INFO)
		end, { desc = "Язык: Английский" })

		vim.keymap.set("n", "<leader>srb", function()
			vim.wo.spelllang = "ru,en_us"
			vim.wo.spell = true
			vim.notify("Язык проверки: Русский+Английский", vim.log.levels.INFO)
		end, { desc = "Язык: Русский+Английский" })
	end,
}
