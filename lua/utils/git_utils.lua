-- lua/utils/git_utils.lua
local M = {}

-- Безопасное выполнение git команд
local safe_git = function(args)
	local cmd = vim.list_extend({ "git" }, args)
	local result = vim.fn.system(cmd)

	if vim.v.shell_error ~= 0 then
		return nil
	end

	-- Убираем только конечные пробелы и переводы строк
	return result:gsub("\n$", ""):gsub("\r$", "")
end

-- Определяем целевую ветку (main/master) автоматически
M.get_base_branch = function()
	local remote_branches = safe_git({ "branch", "-r" })
	if remote_branches then
		if remote_branches:match("origin/main") then
			return "main"
		elseif remote_branches:match("origin/master") then
			return "master"
		end
	end

	local local_branches = safe_git({ "branch" })
	if local_branches then
		if local_branches:match("%* main") or local_branches:match("\nmain") then
			return "main"
		elseif local_branches:match("%* master") or local_branches:match("\nmaster") then
			return "master"
		end
	end

	return "main"
end

M.get_current_branch = function()
	return safe_git({ "branch", "--show-current" }) or ""
end

M.is_git_repo = function()
	return safe_git({ "rev-parse", "--git-dir" }) ~= nil
end

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

	-- Надёжный синтаксис: origin/base...HEAD + --imply-local для LSP в правом окне
	vim.cmd("DiffviewOpen origin/" .. base_branch .. "...HEAD --imply-local")
end

return M
