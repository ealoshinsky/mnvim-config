local M = {}

function M.setup()
	if vim.fn.executable("dlv") == 0 then
		vim.notify(
			"dlv не найден. Установи: go install github.com/go-delve/delve/cmd/dlv@latest",
			vim.log.levels.WARN,
			{ title = "Debug: Go" }
		)
	end

	-- Базовые конфигурации (Debug, Debug (Arguments), Debug Package, Attach,
	-- Debug test, Debug test (go.mod)) предоставляет nvim-dap-go
	require("dap-go").setup({
		dap_configurations = {
			{
				type = "go",
				name = "Debug main package (cwd)",
				request = "launch",
				program = ".",
				-- stdout/stderr программы в REPL, а не в лог dlv
				outputMode = "remote",
			},
			{
				type = "go",
				name = "Attach remote (dlv --headless :2345)",
				mode = "remote",
				request = "attach",
				host = "127.0.0.1",
				port = 2345,
			},
		},
		delve = {
			path = "dlv",
			-- Сборка большого проекта может идти дольше дефолтных 20 секунд
			initialize_timeout_sec = 60,
			port = "${port}",
			build_flags = "",
			-- dlv не должен умирать вместе с терминальной группой процессов
			detached = vim.fn.has("win32") == 0,
		},
		tests = {
			verbose = true,
		},
	})
end

return M
