local M = {}

function M.setup()
	local dap = require("dap")
	local dapui = require("dapui")

	-- Продолжить/пауза
	vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: conitinue" })

	-- Шаги
	vim.keymap.set("n", "<F7>", dap.step_over, { desc = "Debug: Setp over" })
	vim.keymap.set("n", "<F8>", dap.step_into, { desc = "Debug: Step into" })
	vim.keymap.set("n", "<F9>", dap.step_out, { desc = "Debug: Step out" })

	-- Точки останова
	vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint, { desc = "Debug: toogle breakpoit" })
	vim.keymap.set("n", "<Leader>dB", function()
		dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
	end, { desc = "Debug: breakpoint condition" })

	-- Интерфейс
	vim.keymap.set("n", "<Leader>du", dapui.toggle, { desc = "Debug: toogle ui" })
	vim.keymap.set("n", "<Leader>dh", function()
		require("dap.ui.widgets").hover()
	end, { desc = "Debug: hover widgets" })

	dap.listeners.after.event_initialized["dapui_config"] = function()
		dapui.open({ reset = true })
	end
end

return M
