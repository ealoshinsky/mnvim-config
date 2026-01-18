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

-- Навигация по комментариям GitLab в diff режиме

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

-- Быстрые действия с MR

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

-- Функция для переключения проверки орфографии
local function toggle_spell()
	if vim.wo.spell then
		vim.wo.spell = false
		vim.notify("Spellcheck Off", vim.log.levels.INFO, { title = "Spell" })
	else
		vim.wo.spell = true
		vim.bo.spelllang = "ru,en_us"
		vim.notify("Spellcheck On", vim.log.levels.INFO, { title = "Spell" })
	end
end

-- Основное переключение проверки орфографии
map("n", "<leader>ss", toggle_spell, { desc = "[S]pell check On/Off" })

-- Навигация по ошибкам орфографии
map("n", "<leader>sn", "]s", { desc = "[S]pell [N]ext typo" })
map("n", "<leader>sp", "[s", { desc = "[S]pell [P]revious typo" })

-- Работа со словарем
map("n", "<leader>sa", "zg", { desc = "[S]pell [A]dd word to dict" })
map("n", "<leader>sx", "zug", { desc = "[S]pell remove from dict" })
map("n", "<leader>sw", "zw", { desc = "[S]pell mark as [W]rong" })

-- Предложения и исправления
map("n", "<leader>s?", "z=", { desc = "[S]pell show suggestions" })
map("n", "<leader>sl", "1z=", { desc = "[S]pell use first suggestion" })

-- Выбор языка проверки
map("n", "<leader>sru", function()
	vim.bo.spelllang = "ru"
	vim.wo.spell = true
	vim.notify("Spell check: Russian 🇷🇺", vim.log.levels.INFO, { title = "Spell Language" })
end, { desc = "[S]pell [Ru]ssian language" })

map("n", "<leader>sen", function()
	vim.bo.spelllang = "en_us"
	vim.wo.spell = true
	vim.notify("Spell check: English 🇺🇸", vim.log.levels.INFO, { title = "Spell Language" })
end, { desc = "[S]pell [En]glish language" })

map("n", "<leader>srb", function()
	vim.bo.spelllang = "ru,en_us"
	vim.wo.spell = true
	vim.notify("Spell check: Russian + English 🇷🇺🇺🇸", vim.log.levels.INFO, { title = "Spell Language" })
end, { desc = "[S]pell [R]ussian+[B]oth" })

-- Интерактивные предложения с Telescope (если установлен)
map("n", "<leader>st", function()
	local word_under_cursor = vim.fn.expand("<cword>")
	if word_under_cursor and #word_under_cursor > 0 then
		local suggestions = vim.fn.spellsuggest(word_under_cursor, 15)
		if #suggestions > 0 then
			vim.ui.select(suggestions, {
				prompt = "Select replacement:",
				format_item = function(item)
					return "🔤 " .. item
				end,
			}, function(choice)
				if choice then
					vim.cmd("normal! ciw" .. choice)
				end
			end)
		else
			vim.notify("No spelling suggestions found", vim.log.levels.INFO)
		end
	end
end, { desc = "[S]pell [T]elescope suggestions" })

-- Быстрое исправление в режиме вставки
map("i", "<C-s>", "<C-g>u<Esc>[s1z=`]a<C-g>u", { desc = "Quick fix spelling" })

-- -- ============================================
-- -- DAP (Debugging) - основные команды
-- -- ============================================
map("n", "<F5>", function()
	require("dap").continue()
end, { desc = "Debug: Start/Continue" })
map("n", "<F10>", function()
	require("dap").step_over()
end, { desc = "Debug: Step Over" })
map("n", "<F11>", function()
	require("dap").step_into()
end, { desc = "Debug: Step Into" })
map("n", "<F12>", function()
	require("dap").step_out()
end, { desc = "Debug: Step Out" })

map("n", "<leader>db", function()
	require("dap").toggle_breakpoint()
end, { desc = "Toggle Breakpoint" })
map("n", "<leader>dc", function()
	require("dap").continue()
end, { desc = "Continue" })
map("n", "<leader>dt", function()
	require("dap").terminate()
end, { desc = "Terminate" })
map("n", "<leader>du", function()
	require("dapui").toggle()
end, { desc = "Toggle Debug UI" })

-- ============================================
-- Buffer navigation (как в IntelliJ)
-- ============================================
map("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
map("n", "<leader>bo", "<cmd>%bd|e#|bd#<CR>", { desc = "Close other buffers" })

-- ============================================
-- Window management (улучшенное)
-- ============================================
map("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Split vertically" })
map("n", "<leader>sh", "<cmd>split<CR>", { desc = "Split horizontally" })
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close split" })
map("n", "<leader>s=", "<C-w>=", { desc = "Equal split size" })

-- Изменение размера окон
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase height" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase width" })

-- ============================================
-- Quick fix list navigation
-- ============================================
map("n", "<leader>co", "<cmd>copen<CR>", { desc = "Open quickfix" })
map("n", "<leader>cc", "<cmd>cclose<CR>", { desc = "Close quickfix" })
map("n", "[q", "<cmd>cprev<CR>", { desc = "Previous quickfix" })
map("n", "]q", "<cmd>cnext<CR>", { desc = "Next quickfix" })

-- ============================================
-- Better indenting
-- ============================================
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- ============================================
-- Keep cursor centered when scrolling
-- ============================================
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
map("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

-- ============================================
-- LazyGit integration
-- ============================================
map("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "LazyGit" })

-- ============================================
-- Toggle options
-- ============================================
map("n", "<leader>uw", function()
	vim.wo.wrap = not vim.wo.wrap
	vim.notify("Wrap " .. (vim.wo.wrap and "enabled" or "disabled"))
end, { desc = "Toggle wrap" })

map("n", "<leader>un", function()
	vim.wo.number = not vim.wo.number
	vim.notify("Line numbers " .. (vim.wo.number and "enabled" or "disabled"))
end, { desc = "Toggle line numbers" })

map("n", "<leader>ur", function()
	vim.wo.relativenumber = not vim.wo.relativenumber
	vim.notify("Relative numbers " .. (vim.wo.relativenumber and "enabled" or "disabled"))
end, { desc = "Toggle relative numbers" })

-- ============================================
-- LSP specific (добавьте если ещё не добавлены)
-- ============================================
-- Эти маппинги уже создаются в lsp.lua через LspAttach,
-- но можно добавить глобальные команды здесь

-- Диагностика
map("n", "<leader>df", vim.diagnostic.open_float, { desc = "Show diagnostic float" })

-- ============================================
-- Terminal mode mappings
-- ============================================
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
map("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Terminal: Go left" })
map("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Terminal: Go down" })
map("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Terminal: Go up" })
map("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Terminal: Go right" })
