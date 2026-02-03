local M = {}

M.adapters = {
	go = {
		adapter = {
			type = "server",
			port = "${port}",
			executable = {
				command = "dlv",
				args = {
					"dap",
					"-l",
					"127.0.0.1:${port}",
					"--log",
					"--log-output=dap",
				},
			},
			options = {
				initialize_timeout_sec = 15,
			},
		},
		configuration = {
			{
				type = "go",
				name = "Debug test (file)",
				request = "launch",
				mode = "test",
				program = "${file}",
				console = "integratedTerminal",
				showLog = true,
			},
			{
				type = "go",
				name = "Debug test (package)",
				request = "launch",
				mode = "test",
				program = "./${relativeFileDirname}",
				console = "integratedTerminal",
				showLog = true,
			},
			{
				type = "go",
				name = "Debug current test",
				request = "launch",
				mode = "test",
				program = "${file}",
				args = { "-test.run", "${fileBasenameNoExtension}" },
				showLog = true,
			},
			{
				type = "go",
				name = "Attach to process",
				request = "attach",
				processId = require("dap.utils").pick_process,
				console = "integratedTerminal",
				showLog = true,
			},
		},
	},
}
return M
