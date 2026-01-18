return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"leoluz/nvim-dap-go",
		"rcarriga/nvim-dap-ui",
		"theHamsta/nvim-dap-virtual-text",
		"nvim-neotest/nvim-nio",
		"mxsdev/nvim-dap-vscode-js",
	},
	keys = {},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		-- dap.adapters.go = {
		-- 	type = "server",
		-- 	port = "${port}",
		-- 	initialize_timeout_sec = 20,
		-- 	executable = {
		-- 		command = "dlv",
		-- 		args = { "dap", "--listen", "127.0.0.1:${port}", "--log", "--log-output=dap" },
		-- 	},
		-- }
		--
		require("dap-vscode-js").setup({
			debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
			adapters = { "pwa-node", "pwa-chrome", "node-terminal" },
		})

		require("dap.ext.vscode").load_launchjs(nil, {
			["pwa-node"] = { "javascript", "typescript" },
			["node"] = { "javascript", "typescript" },
			["go"] = { "go" },
		})

		dapui.setup({
			icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
			mappings = {
				expand = { "<CR>", "<2-LeftMouse>" },
				open = "o",
				remove = "d",
				edit = "e",
				repl = "r",
				toggle = "t",
			},
			layouts = {
				{
					elements = {
						{ id = "scopes", size = 0.35 },
						{ id = "breakpoints", size = 0.15 },
						{ id = "stacks", size = 0.35 },
						{ id = "watches", size = 0.15 },
					},
					size = 50,
					position = "left",
				},
				{
					elements = {
						{ id = "repl", size = 0.45 },
						{ id = "console", size = 0.55 },
					},
					size = 10,
					position = "bottom",
				},
			},
			controls = {
				enabled = true,
				element = "repl",
				icons = {
					pause = "",
					play = "",
					step_into = "",
					step_over = "",
					step_out = "",
					step_back = "",
					run_last = "↻",
					terminate = "□",
				},
			},
			floating = {
				max_height = 0.9,
				max_width = 0.5,
				border = "rounded",
				mappings = {
					close = { "q", "<Esc>" },
				},
			},
			windows = { indent = 1 },
			render = {
				max_type_length = nil,
				max_value_lines = 100,
			},
		})

		require("nvim-dap-virtual-text").setup({
			enabled = true,
			enabled_commands = true,
			highlight_changed_variables = true,
			highlight_new_as_changed = false,
			show_stop_reason = true,
			commented = false,
			only_first_definition = true,
			all_references = false,
			clear_on_continue = false,
			virt_text_pos = "eol",
		})

		dap.set_log_level("TRACE")
		-- Открываем UI, но НЕ закрываем автоматически
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end

		-- Показываем уведомление вместо закрытия
		dap.listeners.after.event_exited.dapui_config = function(_, body)
			vim.notify(
				string.format(
					"Program exited with code %s. Check console for output.",
					tostring(body and body.exitCode or "unknown")
				),
				vim.log.levels.WARN
			)
		end

		vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
		vim.fn.sign_define(
			"DapBreakpointCondition",
			{ text = "◆", texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
		)
		vim.fn.sign_define("DapStopped", { text = "➜", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" })

		local dapgo = require("dap-go")
		dapgo.setup({
			delve = {
				initialize_timeout_sec = 20,
				port = "${port}",
			},
		})
	end,
}
