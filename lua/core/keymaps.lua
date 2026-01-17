-- lua/core/keymaps.lua
local map = vim.keymap.set

map("n", "<leader>p", '"+p', { desc = "Paste from clipboard" })
map("n", "<leader>P", '"+P', { desc = "Paste before cursor" })
map("v", "<leader>p", '"+p', { desc = "Paste over selection" })
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

-- ============================================
-- nvim-lint
-- ============================================
map("n", "<leader>ll", function()
	require("lint").try_lint()
end, { desc = "Trigger linting for current file" })

-- ============================================
-- Harpoon 2
-- ============================================
map("n", "<leader>a", function()
	require("harpoon"):list():add()
end, { desc = "Harpoon: Add file" })

map("n", "<C-e>", function()
	local harpoon = require("harpoon")
	harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon: Toggle menu" })

-- Быстрый переход к файлам 1-4
map("n", "<leader>1", function()
	require("harpoon"):list():select(1)
end, { desc = "Harpoon: File 1" })

map("n", "<leader>2", function()
	require("harpoon"):list():select(2)
end, { desc = "Harpoon: File 2" })

map("n", "<leader>3", function()
	require("harpoon"):list():select(3)
end, { desc = "Harpoon: File 3" })

map("n", "<leader>4", function()
	require("harpoon"):list():select(4)
end, { desc = "Harpoon: File 4" })

-- Навигация по списку
map("n", "[h", function()
	require("harpoon"):list():prev()
end, { desc = "Harpoon: Previous" })

map("n", "]h", function()
	require("harpoon"):list():next()
end, { desc = "Harpoon: Next" })

-- ============================================
-- nvim-surround
-- ============================================
-- Стандартные маппинги (уже встроены в плагин):
-- ys{motion}{char} - добавить окружение
-- ds{char} - удалить окружение
-- cs{old}{new} - изменить окружение
-- В визуальном режиме: S{char} - окружить выделение
--
-- Кастомные окружения:
-- yse - if err != nil { } (Go)
-- ysft - function wrapper
-- yst - HTML tag с классом
--

-- ============================================
-- GitLab MR Navigation in Diff
-- ============================================

-- Основное открытие MR в diffview с комментариями
map("n", "<leader>gD", function()
	require("gitlab").review() -- Открывает MR с diff и комментариями
end, { desc = "Open MR in diffview with comments" })

-- Выбор MR для открытия в diff
map("n", "<leader>gM", function()
	require("gitlab").choose_merge_request() -- Сначала выбираем MR, затем откроется diff
end, { desc = "Choose MR to open in diffview" })

-- Если хотите прямой доступ к diff без комментариев
map("n", "<leader>gd", function()
	require("gitlab").open_in_diffview()
end, { desc = "Open current MR in diffview" })

-- ============================================
-- Навигация внутри diffview (когда diff открыт)
-- ============================================

-- Переключение между файлами в diff
map("n", "<leader>gn", function()
	if package.loaded.diffview then
		require("diffview").actions.select_next_entry()
	end
end, { desc = "Next file in diff" })

map("n", "<leader>gp", function()
	if package.loaded.diffview then
		require("diffview").actions.select_prev_entry()
	end
end, { desc = "Previous file in diff" })

-- Навигация по изменениям (hunks) в текущем файле
map("n", "<leader>gj", function()
	if package.loaded.diffview then
		require("diffview").actions.next_conflict()
	end
end, { desc = "Next change in diff" })

map("n", "<leader>gk", function()
	if package.loaded.diffview then
		require("diffview").actions.prev_conflict()
	end
end, { desc = "Previous change in diff" })

-- Переключение между diff layout
map("n", "<leader>gt", function()
	if package.loaded.diffview then
		require("diffview").actions.cycle_layout()
	end
end, { desc = "Toggle diff layout" })

-- ============================================
-- Навигация по комментариям GitLab в diff режиме
-- ============================================

-- Когда diff открыт через gitlab.nvim, используйте эти сочетания:
map("n", "]c", function()
	-- Перейти к следующему комментарию
	vim.cmd("GitlabNextComment")
end, { desc = "Next GitLab comment" })

map("n", "[c", function()
	-- Перейти к предыдущему комментарию
	vim.cmd("GitlabPrevComment")
end, { desc = "Previous GitLab comment" })

-- Ответить на комментарий под курсором
map("n", "<leader>gc", function()
	vim.cmd("GitlabAddComment")
end, { desc = "Add reply to comment" })

-- Approve/Reject MR прямо из diff
map("n", "<leader>ga", function()
	vim.cmd("GitlabPerformAction")
end, { desc = "Approve/Reject MR" })

-- ============================================
-- Быстрые действия с MR
-- ============================================

-- Обновить diff и комментарии
map("n", "<leader>gu", function()
	vim.cmd("GitlabRefresh")
end, { desc = "Refresh MR data" })

-- Закрыть diffview
map("n", "<leader>gq", function()
	if package.loaded.diffview then
		require("diffview").close()
	end
end, { desc = "Close diffview" })

-- Переключение между diff панелями
map("n", "<leader>gh", function()
	if package.loaded.diffview then
		vim.cmd("DiffviewFocusFiles")
	end
end, { desc = "Focus file panel" })

map("n", "<leader>gl", function()
	if package.loaded.diffview then
		vim.cmd("DiffviewToggleFiles")
	end
end, { desc = "Toggle file panel" })
