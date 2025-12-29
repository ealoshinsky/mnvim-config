-- lua/core/keymaps.lua
local map = vim.keymap.set

-- Основные
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
map("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "Clear search" })

-- Навигация по окнам
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Перемещение строк
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Telescope (основные)
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Help tags" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "Recent files" })
map("n", "<leader>fc", "<cmd>Telescope commands<CR>", { desc = "Commands" })
map("n", "<leader>fk", "<cmd>Telescope keymaps<CR>", { desc = "Keymaps" })

-- Telescope: Выбор и checkout git-ветки (local + remote)
map("n", "<leader>gb", function()
	require("telescope.builtin").git_branches({
		attach_mappings = function(_, map)
			map("i", "<CR>", function(prompt_bufnr)
				local selection = require("telescope.actions.state").get_selected_entry()
				require("telescope.actions").close(prompt_bufnr)
				vim.cmd("Git checkout " .. selection.value)
			end)
			map("n", "<CR>", function(prompt_bufnr)
				local selection = require("telescope.actions.state").get_selected_entry()
				require("telescope.actions").close(prompt_bufnr)
				vim.cmd("Git checkout " .. selection.value)
			end)
			return true
		end,
	})
end, { desc = "Git: Select and checkout branch" })

-- Альтернатива: переключение только между буферами с ревью gitlab.nvim и обычным кодом
map("n", "<leader>gr", function()
	local current = vim.fn.bufname("%")
	if current:match("gitlab%.nvim") or current:match("GitLab Review") then
		-- Если мы в ревью — вернуться к предыдущему (код)
		vim.cmd("b#")
	else
		-- Если в коде — найти и открыть буфер ревью
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			local name = vim.api.nvim_buf_get_name(buf)
			if name:match("gitlab%.nvim") or name:match("GitLab") then
				vim.api.nvim_set_current_buf(buf)
				return
			end
		end
		vim.notify("Ревью-буфер не найден", vim.log.levels.WARN)
	end
end, { desc = "Toggle between code and GitLab review buffer" })

-- Fugitive (основные Git-команды)
map("n", "<leader>gs", "<cmd>Git<CR>", { desc = "Git status" })
map("n", "<leader>gc", "<cmd>Git commit<CR>", { desc = "Git commit" })
map("n", "<leader>gd", "<cmd>Gdiffsplit<CR>", { desc = "Git diff (vertical split)" })
map("n", "<leader>gl", "<cmd>Git log<CR>", { desc = "Git log" })
map("n", "<leader>gB", "<cmd>Git blame<CR>", { desc = "Git blame (fugitive)" }) -- если хотите fugitive-blame, иначе удалите и используйте gitsigns

-- Git fetch
map("n", "<leader>gF", "<cmd>Git fetch --all<CR>", { desc = "Git fetch all" })

-- Diffview
map("n", "<leader>gv", "<cmd>DiffviewOpen<CR>", { desc = "Diffview: Open (review changes)" })
map("n", "<leader>gV", "<cmd>DiffviewClose<CR>", { desc = "Diffview: Close" })
map("n", "<leader>gf", "<cmd>DiffviewFileHistory %<CR>", { desc = "Diffview: File history" })

-- GitLab.nvim (ревью MR)
map("n", "<leader>glm", function()
	require("gitlab").choose_merge_request()
end, { desc = "GitLab: Choose MR to review (Telescope list)" })

map("n", "<leader>glr", "<cmd>Gitlab review<CR>", { desc = "GitLab: Start/continue review current branch" })
map("n", "<leader>gla", "<cmd>Gitlab approve<CR>", { desc = "GitLab: Approve MR" })
map("n", "<leader>glR", "<cmd>Gitlab revoke<CR>", { desc = "GitLab: Revoke approve" })
map("n", "<leader>glc", "<cmd>Gitlab create_comment<CR>", { desc = "GitLab: Create general comment" })
map("n", "<leader>gls", "<cmd>Gitlab summary<CR>", { desc = "GitLab: Add summary comment" })

-- Trouble
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Trouble: Diagnostics" })
map("n", "<leader>xw", "<cmd>Trouble workspace_diagnostics toggle<CR>", { desc = "Trouble: Workspace" })
map("n", "<leader>xd", "<cmd>Trouble document_diagnostics toggle<CR>", { desc = "Trouble: Document" })

-- Code folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99
map("n", "<leader>z", "za", { silent = true, desc = "Toggle fold" })
map("n", "<leader>Z", "zA", { silent = true, desc = "Toggle fold recursively" })
map("n", "<leader>r", "zR", { silent = true, desc = "Open all folds" })
map("n", "<leader>m", "zM", { silent = true, desc = "Close all folds" })

-- NvimTree
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "File explorer" })
