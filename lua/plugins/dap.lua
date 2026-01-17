-- plugins/dap.lua
return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"leoluz/nvim-dap-go",
		"rcarriga/nvim-dap-ui",
		"theHamsta/nvim-dap-virtual-text",
		"nvim-neotest/nvim-nio",
		"williamboman/mason.nvim",
	},
	keys = {
		{
			"<F5>",
			function()
				require("dap").continue()
			end,
			desc = "Continue",
		},
		{
			"<F7>",
			function()
				require("dap").step_into()
			end,
			desc = "Step Into",
		},
		{
			"<F8>",
			function()
				require("dap").step_over()
			end,
			desc = "Step Over",
		},
		{
			"<F9>",
			function()
				require("dap").step_out()
			end,
			desc = "Step Out",
		},
		{
			"<S-F5>",
			function()
				require("dap").terminate()
				require("dapui").close()
			end,
			desc = "Terminate",
		},
		{
			"<leader>b",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "Toggle Breakpoint",
		},
		{
			"<leader>B",
			function()
				require("dap").set_breakpoint(vim.fn.input("Condition: "))
			end,
			desc = "Conditional BP",
		},
		{
			"<leader>dr",
			function()
				require("dap").repl.toggle()
			end,
			desc = "REPL",
		},

		-- Go-specific
		{
			"<leader>dt",
			function()
				require("dap-go").debug_test()
			end,
			desc = "Debug nearest test",
		},
		{
			"<leader>dd",
			function()
				require("dap-go").debug()
			end,
			desc = "Debug package",
		},
		{
			"<leader>dl",
			function()
				require("dap-go").debug_last()
			end,
			desc = "Debug last",
		},

		-- UI management
		{
			"<leader>du",
			function()
				require("dapui").toggle()
			end,
			desc = "Toggle DAP UI",
		},
		{
			"<leader>df",
			function()
				require("dapui").float_element("scopes")
			end,
			desc = "Float element",
		},
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		-- Иконки в gutter (исправленные)
		local signs = {
			DapBreakpoint = { text = "●", texthl = "DiagnosticError", linehl = "", numhl = "" },
			DapBreakpointCondition = { text = "◆", texthl = "DiagnosticWarn", linehl = "", numhl = "" },
			DapStopped = { text = "→", texthl = "DiagnosticInfo", linehl = "CursorLine", numhl = "" },
			DapLogPoint = { text = "◆", texthl = "DiagnosticInfo", linehl = "", numhl = "" },
		}

		for sign, opts in pairs(signs) do
			vim.fn.sign_define(sign, opts)
		end

		-- Безопасная инициализация dapui
		dapui.setup({
			controls = {
				element = "repl",
				enabled = true,
				icons = {
					disconnect = "",
					pause = "",
					play = "",
					run_last = "",
					step_back = "",
					step_into = "",
					step_out = "",
					step_over = "",
					terminate = "",
				},
			},
			floating = {
				border = "rounded",
				mappings = {
					close = { "q", "<Esc>" },
				},
			},
			layouts = {
				{
					elements = {
						{ id = "breakpoints", size = 0.20 },
						{ id = "scopes", size = 0.40 },
						{ id = "stacks", size = 0.20 },
						{ id = "watches", size = 0.20 },
					},
					size = 0.35,
					position = "left",
				},
				{
					elements = {
						{ id = "repl", size = 0.35 },
						{ id = "console", size = 0.65 },
					},
					size = 0.30,
					position = "bottom",
				},
			},
			icons = {
				collapsed = "",
				current_frame = "",
				expanded = "",
			},
			mappings = {
				expand = { "<CR>", "<2-LeftMouse>" },
				open = "o",
				remove = "d",
				edit = "e",
				repl = "r",
				toggle = "t",
			},
			render = {
				indent = 1,
				max_value_lines = 100,
			},
		})

		-- Виртуальный текст
		require("nvim-dap-virtual-text").setup({
			virt_text_pos = "eol",
			all_frames = false,
			commented = true,
		})

		-- Безопасные листенеры
		dap.listeners.after.event_initialized["dapui_config"] = function()
			-- Проверяем, что сессия существует
			local session = dap.session()
			if session and session.initialized then
				vim.schedule(function()
					dapui.open({ reset = true })
				end)
			end
		end

		dap.listeners.before.event_terminated["dapui_config"] = function()
			vim.schedule(function()
				local ok, _ = pcall(function()
					dapui.close()
				end)
				if not ok then
					-- Если не удалось закрыть нормально, пробуем принудительно
					pcall(function()
						require("dapui").close()
					end)
				end
			end)
		end

		dap.listeners.before.event_exited["dapui_config"] = dap.listeners.before.event_terminated["dapui_config"]

		-- Адаптер для Go
		dap.adapters.delve = {
			type = "server",
			port = "${port}",
			executable = {
				command = "dlv",
				args = { "dap", "-l", "127.0.0.1:${port}" },
			},
			options = {
				initialize_timeout_sec = 30,
			},
		}

		-- Настройка для Go
		require("dap-go").setup({
			delve = {
				port = "${port}",
				initialize_timeout_sec = 30,
				args = { "--check-go-version=false" },
			},
		})

		-- Базовые конфигурации для Go
		dap.configurations.go = {
			{
				type = "delve",
				name = "Debug",
				request = "launch",
				program = "${file}",
				cwd = vim.fn.getcwd(),
			},
			{
				type = "delve",
				name = "Debug test",
				request = "launch",
				mode = "test",
				program = "${file}",
				cwd = vim.fn.getcwd(),
			},
			{
				type = "delve",
				name = "Debug package",
				request = "launch",
				mode = "test",
				program = "./${relativeFileDirname}",
				cwd = vim.fn.getcwd(),
			},
		}

		-- Функция для безопасной загрузки launch.json
		local function safe_load_launch_json()
			local function try_load()
				local ok, vscode = pcall(require, "dap.ext.vscode")
				if ok then
					-- Загружаем только если есть файл
					local launch_path = vim.fn.getcwd() .. "/.vscode/launch.json"
					if vim.fn.filereadable(launch_path) == 1 then
						vscode.load_launchjs(nil, {
							go = { "delve" },
							python = { "python" },
							cpp = { "lldb" },
							rust = { "lldb" },
							javascript = { "pwa-node" },
							typescript = { "pwa-node" },
						})
						vim.notify("Loaded .vscode/launch.json", vim.log.levels.INFO)
					end
				end
			end

			-- Пробуем загрузить с защитой от ошибок
			local ok, err = pcall(try_load)
			if not ok then
				vim.notify("Failed to load launch.json: " .. err, vim.log.levels.WARN)
			end
		end

		-- Команда для ручной загрузки
		vim.api.nvim_create_user_command("DapLoadLaunchJson", safe_load_launch_json, {})

		-- Автозагрузка при старте
		vim.defer_fn(safe_load_launch_json, 1000)

		-- Утилиты для работы с UI
		local function safe_toggle_ui()
			local ok, err = pcall(function()
				if dapui.is_open() then
					dapui.close()
				else
					dapui.open()
				end
			end)

			if not ok then
				vim.notify("UI toggle failed: " .. err, vim.log.levels.ERROR)
			end
		end

		-- Функция для принудительной очистки
		local function cleanup_dap()
			pcall(function()
				dapui.close()
			end)
			pcall(function()
				require("dap").terminate()
			end)
		end

		-- Ключ для очистки
		vim.keymap.set("n", "<leader>dc", cleanup_dap, { desc = "Cleanup DAP" })

		-- Автокоманды для предотвращения ошибок
		vim.api.nvim_create_autocmd("VimLeavePre", {
			callback = cleanup_dap,
		})

		-- Отладка: логирование состояния DAP
		vim.keymap.set("n", "<leader>ds", function()
			local session = dap.session()
			if session then
				print("DAP Session: " .. vim.inspect({
					initialized = session.initialized,
					stopped_thread = session.stopped_thread_id,
				}))
			else
				print("No DAP session active")
			end
		end, { desc = "Show DAP status" })
	end,
}
