return {
	"kristijanhusak/vim-dadbod-ui",
	dependencies = {
		{ "tpope/vim-dadbod", lazy = true },
		{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true }, -- Optional
	},
	cmd = {
		"DBUI",
		"DBUIToggle",
		"DBUIAddConnection",
		"DBUIFindBuffer",
	},
	init = function()
		vim.g.db_ui_use_nerd_fonts = 1 -- Использовать Nerd Fonts для иконок
		vim.g.db_ui_show_database_icon = 1 -- Показывать иконки БД
		vim.g.db_ui_win_position = "left" -- Позиция окна (left, right, top, bottom)
		vim.g.db_ui_winwidth = 40 -- Ширина окна
		vim.g.db_ui_save_location = "~/.config/db_ui" -- Сохранение истории запросов
		vim.g.db_ui_auto_execute_table_helpers = 1 -- Автовыполнение помощников для таблиц
		vim.g.vim_dadbod_completion_mark = "✓"
	end,
}
