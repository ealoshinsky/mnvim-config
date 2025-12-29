-- lua/plugins/gitlab.lua
return {
	{
		"harrisoncramer/gitlab.nvim",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"stevearc/dressing.nvim",
			"nvim-telescope/telescope.nvim",
		},
		build = ":lua require('gitlab.server').build(true)",
		config = function()
			local gitlab = require("gitlab")

			gitlab.setup({
				auth_provider = function()
					-- 1. Получаем remote URL
					local remote_url = vim.fn.systemlist("git config --get remote.origin.url")[1]
					if not remote_url or remote_url == "" then
						vim.notify("Не найден remote.origin.url", vim.log.levels.ERROR)
						return nil, nil
					end

					-- 2. Извлекаем ТОЛЬКО чистый хост (gitlab.x5food.tech)
					local host = remote_url
						:gsub("^git@", "https://") -- git@host:group/repo.git → https://host:group/repo.git
						:gsub("^https?://", "") -- http(s)://host/... → host/...
						:gsub(":.*/", "/") -- host:group/repo.git → host/repo.git (убираем группу после :)
						:gsub("/.*$", "") -- host/repo.git → host (оставляем только домен)
						:gsub(":.+$", "") -- на случай порта host:8080 → host

					vim.notify("Определён GitLab хост: " .. host, vim.log.levels.INFO)

					-- 3. Читаем ~/.netrc
					local netrc_path = vim.fn.expand("~/.netrc")
					if vim.fn.filereadable(netrc_path) == 0 then
						vim.notify(
							"Файл ~/.netrc не найден или недоступен",
							vim.log.levels.ERROR
						)
						return nil, nil
					end

					local lines = vim.fn.readfile(netrc_path)
					local token = nil
					local current_machine = nil

					for _, line in ipairs(lines) do
						line = vim.fn.trim(line)
						if line:match("^machine%s+") then
							current_machine = line:match("^machine%s+(.+)$")
						elseif line:match("^password%s+") and current_machine == host then
							token = line:match("^password%s+(.+)$")
							vim.notify("Токен найден в ~/.netrc для " .. host, vim.log.levels.INFO)
							break
						end
					end

					if not token then
						vim.notify(
							"Токен НЕ найден в ~/.netrc для хоста: " .. host,
							vim.log.levels.WARN
						)
						return nil, nil
					end

					local url = "https://" .. host
					return token, url
				end,
			})
		end,
	},
}
