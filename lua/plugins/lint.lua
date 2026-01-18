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

		-- Кастомная настройка golangci-lint с упрощенными параметрами
		lint.linters.golangcilint = {
			cmd = "golangci-lint",
			stdin = false, -- golangci-lint не работает через stdin
			args = {
				"run",
				"--out-format=json",
				"--issues-exit-code=0", -- Не падать с кодом 3 если есть проблемы
				"--print-issued-lines=false",
				"--print-linter-name=false",
			},
			stream = "stdout",
			ignore_exitcode = true, -- Игнорировать exit code
			parser = function(output, bufnr)
				if output == "" then
					return {}
				end

				local ok, decoded = pcall(vim.json.decode, output)
				if not ok then
					return {}
				end

				local diagnostics = {}
				local issues = decoded.Issues or {}

				for _, issue in ipairs(issues) do
					table.insert(diagnostics, {
						lnum = (issue.Pos.Line or 1) - 1,
						col = (issue.Pos.Column or 1) - 1,
						end_lnum = (issue.Pos.Line or 1) - 1,
						end_col = (issue.Pos.Column or 1) - 1,
						severity = vim.diagnostic.severity.WARN,
						message = issue.Text,
						source = "golangci-lint",
						code = issue.FromLinter,
					})
				end

				return diagnostics
			end,
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

				-- Обработка ошибок линтера
				local success, err = pcall(lint.try_lint)
				if not success then
					-- Не показывать ошибку если линтер просто не установлен
					if not err:match("not found") and not err:match("executable not found") then
						vim.notify("Linter error: " .. err, vim.log.levels.WARN)
					end
				end
			end,
		})
	end,
}
