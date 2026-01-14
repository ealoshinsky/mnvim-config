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

-- Кейбиндинги (общие для Git)
vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Open Neogit" })
vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Open Diffview" })
vim.keymap.set("n", "<leader>gs", "<cmd>Git<cr>", { desc = "Git status" })
vim.keymap.set("n", "<leader>gc", "<cmd>Git commit<cr>", { desc = "Git commit" })
vim.keymap.set("n", "<leader>gl", "<cmd>LazyGit<cr>", { desc = "Open LazyGit" })

-- Для GitLab
vim.keymap.set("n", "<leader>gm", function()
	require("gitlab").choose_merge_request()
end, { desc = "Choice MR" })
vim.keymap.set("n", "<leader>gr", function()
	require("gitlab").review()
end, { desc = "Review MR" })
