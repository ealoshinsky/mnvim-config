-- lua/plugins/surround.lua
return {
	"kylechui/nvim-surround",
	version = "*",
	event = "VeryLazy",
	config = function()
		require("nvim-surround").setup({

			-- Кастомные окружения (примеры)
			surrounds = {
				-- Для Go: if err != nil { }
				["e"] = {
					add = function()
						return {
							{ "if err != nil {" },
							{ "}" },
						}
					end,
				},
				-- HTML тег с классом
				["t"] = {
					add = function()
						local tag = vim.fn.input("Tag: ")
						local class = vim.fn.input("Class: ")
						if class ~= "" then
							return {
								{ string.format('<%s class="%s">', tag, class) },
								{ string.format("</%s>", tag) },
							}
						else
							return {
								{ string.format("<%s>", tag) },
								{ string.format("</%s>", tag) },
							}
						end
					end,
				},
				-- Для функции в Go/JS
				["f"] = {
					add = function()
						local name = vim.fn.input("Function name: ")
						local ft = vim.bo.filetype
						if ft == "go" then
							return {
								{ string.format("func %s() {", name) },
								{ "}" },
							}
						else
							return {
								{ string.format("function %s() {", name) },
								{ "}" },
							}
						end
					end,
				},
			},

			-- Настройки по умолчанию
			aliases = {
				["a"] = ">", -- angle brackets
				["b"] = ")", -- braces
				["B"] = "}", -- Braces
				["r"] = "]", -- brackets
				["q"] = { '"', "'", "`" }, -- quotes
			},

			highlight = {
				duration = 0, -- Отключить подсветку (или поставить 500 для 500ms)
			},

			move_cursor = "begin", -- "begin" или "end" или false
		})
	end,
}
