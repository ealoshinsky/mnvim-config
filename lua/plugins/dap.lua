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
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		-- Иконки в gutter
		vim.fn.sign_define({
			{ name = "DapBreakpoint", text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" },
			{
				name = "DapBreakpointCondition",
				text = "◆",
				texthl = "DapBreakpointCondition",
				linehl = "",
				numhl = "",
			},
			{
				name = "DapStopped",
				text = "➜",
				texthl = "DapStopped",
				linehl = "DapStoppedLine",
				numhl = "",
			},
			{
				name = "DapLogPoint",
				text = "◆",
				texthl = "DapLogPoint",
				linehl = "",
				numhl = "",
			},
		})

		-- dap-ui
		dapui.setup({
			layouts = {
				{
					elements = { { id = "breakpoints", size = 0.25 }, { id = "scopes", size = 0.75 } },
					size = 65,
					position = "left",
				},
				{
					elements = { "repl" },
					size = 13,
					position = "bottom",
				},
			},
		})

		require("nvim-dap-virtual-text").setup({ virt_text_pos = "eol" })

		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end

		dap.adapters.delve = {
			type = "server",
			port = "${port}",
			executable = {
				command = "dlv",
				args = { "dap", "-l", "127.0.0.1:${port}", "--log", "--log-output=dap" },
			},
		}

		-- Конфигурации (можно расширять)
		dap.configurations.go = {
			{
				name = "Launch file",
				type = "delve",
				request = "launch",
				program = "${file}",
			},
			{
				name = "Launch package",
				type = "delve",
				request = "launch",
				program = "${fileDirname}",
			},
			{
				name = "Launch file with args",
				type = "delve",
				request = "launch",
				program = "${file}",
				args = function()
					local arg_str = vim.fn.input("Args: ")
					return vim.split(arg_str, " ")
				end,
			},
			{
				name = "Attach to process",
				type = "delve",
				request = "attach",
				processId = require("dap.utils").pick_process,
				mode = "local",
			},
		}

		-- nvim-dap-go — лучшая интеграция
		require("dap-go").setup({
			delve = {
				port = "${port}", -- автоматически подхватит наш server-адаптер
			},
		})
	end,
}
