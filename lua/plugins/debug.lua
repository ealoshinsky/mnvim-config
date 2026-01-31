return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"leoluz/nvim-dap-go",
		"rcarriga/nvim-dap-ui",
		"theHamsta/nvim-dap-virtual-text",
		"nvim-neotest/nvim-nio",
		"mxsdev/nvim-dap-vscode-js",
	},
	config = function()
		local adapters = require("plugins.debug.adapters")
		local ui = require("plugins.debug.ui")
		local km = require("plugins.debug.keymaps")

		for lang, config in pairs(adapters.adapters) do
			for field, item in pairs(config) do
				if field == "adapter" then
					require("dap").adapters[lang] = item
				end
				if field == "configuration" then
					require("dap").configurations[lang] = item
				end
			end
		end

		ui.setup()
		km.setup()
	end,
}
