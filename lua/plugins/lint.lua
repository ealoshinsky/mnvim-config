-- lua/plugins/lint.lua
return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		-- Настройка линтеров для каждого языка
		lint.linters_by_ft = {
			go = { "golangcilint" },
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			python = { "pylint" },
			dockerfile = { "hadolint" },
			yaml = { "yamllint" },
			markdown = { "markdownlint" },
		}

		-- Автоматический запуск линтера
		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				-- Запускаем только если файл существует и не слишком большой
				local max_filesize = 100 * 1024 -- 100 KB
				local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(0))
				if ok and stats and stats.size > max_filesize then
					return
				end

				lint.try_lint()
			end,
		})

		-- Кастомная настройка golangci-lint (опционально)
		lint.linters.golangcilint.args = {
			"run",
			"--out-format",
			"json",
			"--show-stats=false",
			"--print-issued-lines=false",
			"--print-linter-name=false",
			"--fast",
			"--enable-all",
		}
	end,
}
