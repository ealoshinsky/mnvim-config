-- lua/utils/git_utils.lua
local M = {}

-- Определяем целевую ветку (main/master) автоматически
M.get_base_branch = function()
	-- Проверяем, какая из веток существует
	local handle = io.popen("git branch -r | grep -E 'origin/(main|master)$' | head -1")
	if handle then
		local result = handle:read("*a"):gsub("%s+", "")
		handle:close()

		if result ~= "" then
			return result:gsub("origin/", "")
		end
	end

	-- Если не нашли удалённо, проверяем локально
	local handle_local = io.popen("git branch -a | grep -E ' (main|master)$' | head -1")
	if handle_local then
		local local_result = handle_local:read("*a"):gsub("%s+", "")
		handle_local:close()

		if local_result ~= "" then
			-- Убираем указатель текущей ветки (*)
			return local_result:gsub("^%*%s*", ""):gsub("^remotes/origin/", "")
		end
	end

	-- Дефолтное значение
	return "main"
end

-- Получить текущую ветку
M.get_current_branch = function()
	local handle = io.popen("git branch --show-current 2>/dev/null")
	if handle then
		local branch = handle:read("*a"):gsub("%s+", "")
		handle:close()
		return branch
	end
	return ""
end

-- Открыть diff текущей ветки против базовой
M.review_current_branch = function()
	local current_branch = M.get_current_branch()
	local base_branch = M.get_base_branch()

	if current_branch == "" or current_branch == base_branch then
		vim.notify("Not on a feature branch or already on base branch", vim.log.levels.WARN)
		return
	end

	vim.cmd("DiffviewOpen origin/" .. base_branch .. "..." .. current_branch)
end

return M
