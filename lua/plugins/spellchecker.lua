-- lua/plugins/spellchecker.lua
return {
	"lewis6991/spellsitter.nvim",
	event = "VeryLazy",
	config = function()
		require("spellsitter").setup({
			enable = true, -- По умолчанию включено
			hl = "SpellBad",
			captions = { "comment", "string" },
		})

		-- Настройка горячих клавиш и функций
		local function toggle_spell()
			if vim.wo.spell then
				vim.wo.spell = false
				vim.notify("Spellcheck Off", vim.log.levels.INFO)
			else
				vim.wo.spell = true
				vim.bo.spelllang = "ru,en_us"
				vim.notify("Spellcheck On", vim.log.levels.INFO)
			end
		end

		-- Клавиши для управления
		vim.keymap.set("n", "<leader>ss", toggle_spell, { desc = "On/Off spell check" })
		vim.keymap.set("n", "<leader>sn", "]s", { desc = "Next typos" })
		vim.keymap.set("n", "<leader>sp", "[s", { desc = "Prev typos" })
		vim.keymap.set("n", "<leader>sa", "zg", { desc = "Add word to dict" })
		vim.keymap.set("n", "<leader>s?", "z=", { desc = "Show me fix" })
		vim.keymap.set("n", "<leader>sw", "zw", { desc = "Mark word as wrond" })

		-- Выбор языка
		vim.keymap.set("n", "<leader>sru", function()
			vim.bo.spelllang = "ru" -- Исправлено: vim.bo для опции буфера
			vim.wo.spell = true
			vim.notify("Lang check: Ru", vim.log.levels.INFO)
		end, { desc = "Lang: Ru" })

		vim.keymap.set("n", "<leader>sen", function()
			vim.bo.spelllang = "en_us" -- Исправлено: vim.bo для опции буфера
			vim.wo.spell = true
			vim.notify("Lang check: En", vim.log.levels.INFO)
		end, { desc = "Lang: En" })

		vim.keymap.set("n", "<leader>srb", function()
			vim.bo.spelllang = "ru,en_us" -- Исправлено: vim.bo для опции буфера
			vim.wo.spell = true
			vim.notify("Lang check: Ru+En", vim.log.levels.INFO)
		end, { desc = "Lang: Ru+En" })
	end,
}
