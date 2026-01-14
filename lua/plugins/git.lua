-- ~/.config/nvim/lua/plugins/git.lua

-- Функция для парсинга ~/.netrc и извлечения PAT
local function get_pat_from_netrc(host)
	local home = os.getenv("HOME")
	local netrc_path = home .. "/.netrc"
	local file = io.open(netrc_path, "r")
	if not file then
		print("Ошибка: ~/.netrc не найден")
		return nil
	end

	local machine, password
	for line in file:lines() do
		if line:match("^machine") then
			machine = line:match("^machine%s+(.+)")
		elseif line:match("^password") and machine == host then
			password = line:match("^password%s+(.+)")
			break
		end
	end
	file:close()

	if password then
		return password
	else
		print("Ошибка: PAT для " .. host .. " не найден в ~/.netrc")
		return nil
	end
end

return {
	-- Общая Git-интеграция
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"nvim-telescope/telescope.nvim", -- Опционально для поиска
		},
		config = function()
			require("neogit").setup({
				integrations = { diffview = true }, -- Интеграция с diffview
			})
		end,
	},
	{
		"sindrets/diffview.nvim",
		config = function()
			require("diffview").setup({})
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "│" },
					change = { text = "│" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
				},
				current_line_blame = true, -- Показывать blame на текущей строке
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns
					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end
					-- Hunk навигация
					map("n", "]c", function()
						gs.next_hunk()
					end, { desc = "Next hunk" })
					map("n", "[c", function()
						gs.prev_hunk()
					end, { desc = "Prev hunk" })
					-- Действия
					map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
					map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
					map("v", "<leader>hs", function()
						gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "Stage hunk" })
					map("v", "<leader>hr", function()
						gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "Reset hunk" })
					map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage buffer" })
					map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
					map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset buffer" })
					map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
					map("n", "<leader>hb", function()
						gs.blame_line({ full = true })
					end, { desc = "Blame line" })
					map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Toggle blame" })
					map("n", "<leader>hd", gs.diffthis, { desc = "Diff this" })
					map("n", "<leader>hD", function()
						gs.diffthis("~")
					end, { desc = "Diff this ~" })
					map("n", "<leader>td", gs.toggle_deleted, { desc = "Toggle deleted" })
					-- Текст-объекты
					map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
				end,
			})
		end,
	},
	{
		"tpope/vim-fugitive",
		-- Нет нужды в setup, работает из коробки
	},
	{
		"kdheepak/lazygit.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	-- GitLab
	{
		"harrisoncramer/gitlab.nvim",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"stevearc/dressing.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		build = function()
			require("gitlab.server").build(true)
		end, -- Сборка Go-бэкенда
		config = function()
			local plenary = require("plenary")
			local function get_git_remote_host()
				local job = plenary.job:new({ command = "git", args = { "remote", "get-url", "origin" } })
				job:sync()
				local result = job:result()[1]
				if result then
					local host = result:match("git@([^:]+):") -- Для SSH: git@host:repo.git
					return host or "gitlab.com" -- Fallback
				end
				return "gitlab.com"
			end

			local host = get_git_remote_host()
			local gitlab_pat = get_pat_from_netrc(host)
			local base_url = "https://" .. host .. "/"

			require("gitlab").setup({
				-- Авторизация: Динамический PAT и URL
				auth_provider = function()
					if not gitlab_pat then
						return nil, nil, "PAT not found for host: " .. host
					end
					return gitlab_pat, base_url, nil -- token, url, error
				end,
				keymap = {
					dialog = {
						perform_action = "<leader>ga", -- Approve/action
						add_comment = "<leader>gc", -- Add comment
					},
				},
			})
		end,
	},
}
