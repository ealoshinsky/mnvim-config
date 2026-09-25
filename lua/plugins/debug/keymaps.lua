local M = {}

function M.setup()
	local dap = require("dap")
	local dapui = require("dapui")

	-- Продолжить/пауза. Перед запуском сохраняем буферы, иначе dlv соберёт старый код
	vim.keymap.set("n", "<F5>", function()
		vim.cmd("silent! wall")
		dap.continue()
	end, { desc = "Debug: continue" })
	vim.keymap.set("n", "<Leader>dq", function()
		dap.terminate()
		dapui.close()
	end, { desc = "Debug: terminate" })
	vim.keymap.set("n", "<Leader>dr", dap.restart, { desc = "Debug: restart" })
	vim.keymap.set("n", "<Leader>dc", dap.run_to_cursor, { desc = "Debug: run to cursor" })

	-- Шаги
	vim.keymap.set("n", "<F7>", dap.step_over, { desc = "Debug: Step over" })
	vim.keymap.set("n", "<F8>", dap.step_into, { desc = "Debug: Step into" })
	vim.keymap.set("n", "<F9>", dap.step_out, { desc = "Debug: Step out" })

	-- Точки останова
	vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint, { desc = "Debug: toggle breakpoint" })
	vim.keymap.set("n", "<Leader>dB", function()
		dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
	end, { desc = "Debug: breakpoint condition" })

	-- Интерфейс
	vim.keymap.set("n", "<Leader>du", dapui.toggle, { desc = "Debug: toggle ui" })
	vim.keymap.set("n", "<Leader>dh", function()
		require("dap.ui.widgets").hover()
	end, { desc = "Debug: hover widgets" })

	vim.keymap.set({ "n", "v" }, "<Leader>de", dapui.eval, { desc = "Debug: eval expression" })

	-- Go: тест под курсором (через treesitter) и повтор последнего
	vim.keymap.set("n", "<Leader>dt", function()
		vim.cmd("silent! wall")
		require("dap-go").debug_test()
	end, { desc = "Debug: Go nearest test" })
	vim.keymap.set("n", "<Leader>dT", function()
		vim.cmd("silent! wall")
		require("dap-go").debug_last_test()
	end, { desc = "Debug: Go last test" })

	dap.listeners.after.event_initialized["dapui_config"] = function()
		dapui.open({ reset = true })
	end
	dap.listeners.before.event_terminated["dapui_config"] = function()
		dapui.close()
	end
	dap.listeners.before.event_exited["dapui_config"] = function()
		dapui.close()
	end

	-- Не оставлять висящие процессы dlv после выхода из nvim
	vim.api.nvim_create_autocmd("VimLeavePre", {
		group = vim.api.nvim_create_augroup("dap_cleanup", { clear = true }),
		callback = function()
			if dap.session() then
				dap.terminate()
			end
		end,
	})
end

return M
