-- lua/utils/git_utils.lua
local M = {}

-- Безопасное выполнение git команд
local safe_git = function(args)
	local cmd = vim.list_extend({ "git" }, args)
	local result = vim.fn.system(cmd)

	if vim.v.shell_error ~= 0 then
		return nil
	end

	-- Убираем пробелы и переводы строк
	result = result:gsub("%s+", "")
	return result
end

-- Определяем целевую ветку (main/master) автоматически
M.get_base_branch = function()
	-- Сначала проверяем удалённо
	local remote_branches = safe_git({ "branch", "-r" })
	if remote_branches then
		for line in remote_branches:gmatch("[^\n]+") do
			if line:match("origin/main$") then
				return "main"
			elseif line:match("origin/master$") then
				return "master"
			end
		end
	end

	-- Проверяем локально
	local local_branches = safe_git({ "branch", "-a" })
	if local_branches then
		for line in local_branches:gmatch("[^\n]+") do
			-- Убираем указатель текущей ветки
			local branch = line:gsub("^%*%s*", ""):gsub("^remotes/origin/", "")

			if branch == "main" then
				return "main"
			elseif branch == "master" then
				return "master"
			end
		end
	end

	-- Дефолтное значение
	return "main"
end

-- Получить текущую ветку
M.get_current_branch = function()
	local branch = safe_git({ "branch", "--show-current" })
	return branch or ""
end

-- Проверить, находимся ли мы в git репозитории
M.is_git_repo = function()
	local result = safe_git({ "rev-parse", "--git-dir" })
	return result ~= nil
end

-- Открыть diff текущей ветки против базовой
M.review_current_branch = function()
	if not M.is_git_repo() then
		vim.notify("Not in a git repository", vim.log.levels.WARN)
		return
	end

	local current_branch = M.get_current_branch()
	local base_branch = M.get_base_branch()

	if current_branch == "" or current_branch == base_branch then
		vim.notify("Not on a feature branch or already on base branch", vim.log.levels.WARN)
		return
	end

	vim.cmd("DiffviewOpen origin/" .. base_branch .. "..." .. current_branch)
end

return M
