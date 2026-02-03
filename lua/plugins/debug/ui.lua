local M = {}

function M.setup()
	local vt = require("nvim-dap-virtual-text")
	local ui = require("dapui")

	-- Настройка цветов для знаков отладки
	vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#e51400" })
	vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#f79617" })
	vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#61afef" })
	vim.api.nvim_set_hl(0, "DapStopped", { fg = "#98c379" })

	-- Определение знаков
	vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
	vim.fn.sign_define(
		"DapBreakpointCondition",
		{ text = "◆", texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
	)
	vim.fn.sign_define("DapLogPoint", { text = "◉", texthl = "DapLogPoint", linehl = "", numhl = "" })
	vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" })
	ui.setup({
		-- Иконки
		icons = {
			expanded = "▾",
			collapsed = "▸",
			current_frame = "▸",
		},
		expand_lines = vim.fn.has("nvim-0.7"),
		-- Соответствия клавиш
		mappings = {
			expand = { "<CR>", "<2-LeftMouse>" },
			open = "o",
			remove = "d",
			edit = "e",
			repl = "r",
			toggle = "t",
		},
		-- Макеты (layouts)
		layouts = {
			{
				elements = {
					-- Элементы можно располагать в любом порядке
					{ id = "scopes", size = 0.25 },
					{ id = "breakpoints", size = 0.25 },
					{ id = "stacks", size = 0.25 },
					{ id = "watches", size = 0.25 },
				},
				size = 40, -- Ширина в столбцах
				position = "left", -- или "right"
			},
			{
				elements = {
					{ id = "repl", size = 1.0 },
					--{ id = "console", size = 0.5 },
				},
				size = 10, -- Высота в строках
				position = "bottom", -- или "top"
			},
		},
		-- Плавающие окна
		floating = {
			max_height = nil, -- Максимальная высота
			max_width = nil, -- Максимальная ширина
			border = "single", -- Стиль границы
			mappings = {
				close = { "q", "<Esc>" },
			},
		},

		-- Окна
		windows = { indent = 1 },

		-- Внешний вид
		render = {
			max_type_length = nil, -- Максимальная длина типа
			max_value_lines = 100, -- Максимальное количество строк для значений
		},
	})

	vt.setup({
		-- Включить/выключить плагин (можно переключить командой)
		enabled = true,
		-- Включить команды
		enabled_commands = true,
		-- Подсвечивать измененные переменные
		highlight_changed_variables = true,
		-- Подсвечивать новые переменные как измененные
		highlight_new_as_changed = true,
		-- Показывать причину остановки (например, точка останова)
		show_stop_reason = true,
		-- Комментировать виртуальный текст
		commented = true,
		-- Показывать только первое определение переменной
		only_first_definition = true,
		-- Показывать все ссылки на переменную
		all_references = false,
		-- Очищать виртуальный текст при продолжении выполнения
		clear_on_continue = false,
		-- Позиция виртуального текста
		-- Варианты: 'eol', 'inline', 'overlay', 'right_align'
		virt_text_pos = "eol",
		-- Показывать для всех фреймов (при многофреймовой отладке)
		all_frames = false,
		-- Виртуальные линии вместо текста
		virt_lines = false,
		-- Позиция окна для виртуального текста
		virt_text_win_col = nil,
	})
end

return M
