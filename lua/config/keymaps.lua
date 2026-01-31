local map = vim.keymap.set

-- ============================================
-- ОСНОВНЫЕ КОМАНДЫ
-- ============================================
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
map("n", "<leader>Q", "<cmd>qa!<CR>", { desc = "Quit all without saving" })
map("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Быстрое сохранение с Ctrl+S (как в IDE)
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<CR><Esc>", { desc = "Save file" })

-- ============================================
-- РАБОТА С БУФЕРАМИ
-- ============================================
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
map("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>ba", "<cmd>%bd|e#|bd#<CR>", { desc = "Close all buffers except current" })

-- Переключение между буферами (как Ctrl+Tab в браузере)
map("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })

-- ============================================
-- РАБОТА С ОКНАМИ (SPLITS)
-- ============================================
map("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Split vertically" })
map("n", "<leader>sh", "<cmd>split<CR>", { desc = "Split horizontally" })
map("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

-- Навигация между окнами (Ctrl + hjkl)
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Изменение размера окон
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- ============================================
-- РАБОТА С ТЕКСТОМ
-- ============================================
-- Перемещение строк вверх/вниз (как Alt+Up/Down в IDE)
map("n", "<A-j>", "<cmd>m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<CR>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Дублирование строк (как Ctrl+D в IDE)
map("n", "<C-d>", "yyp", { desc = "Duplicate line" })
map("v", "<C-d>", "y'>p", { desc = "Duplicate selection" })

-- Удаление без копирования в буфер
map({ "n", "v" }, "<leader>ddd", '"_d', { desc = "Delete without yanking" })

-- Вставка без замены буфера обмена
map("v", "p", '"_dP', { desc = "Paste without yanking" })

-- ============================================
-- РАБОТА С ОТСТУПАМИ
-- ============================================
map("v", "<", "<gv", { desc = "Decrease indent" })
map("v", ">", ">gv", { desc = "Increase indent" })

-- Tab для отступов в визуальном режиме
map("v", "<Tab>", ">gv", { desc = "Indent right" })
map("v", "<S-Tab>", "<gv", { desc = "Indent left" })

-- ============================================
-- НАВИГАЦИЯ
-- ============================================
-- Центрирование экрана при навигации
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
map("n", "n", "nzzzv", { desc = "Next search result" })
map("n", "N", "Nzzzv", { desc = "Previous search result" })

-- Быстрое перемещение к началу/концу строки
map({ "n", "v" }, "H", "^", { desc = "Go to start of line" })
map({ "n", "v" }, "L", "$", { desc = "Go to end of line" })

-- ============================================
-- РАБОТА С БУФЕРОМ ОБМЕНА (CLIPBOARD)
-- ============================================
-- Копирование в системный буфер
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Copy to clipboard" })
map("n", "<leader>Y", '"+Y', { desc = "Copy line to clipboard" })

-- Вставка из системного буфера
map("n", "<leader>p", '"+p', { desc = "Paste from clipboard" })
map("n", "<leader>P", '"+P', { desc = "Paste before cursor" })
map("v", "<leader>p", '"+p', { desc = "Paste over selection" })

-- Вырезать в системный буфер
map({ "n", "v" }, "<leader>x", '"+x', { desc = "Cut to clipboard" })

-- ============================================
-- TELESCOPE (ПОИСК)
-- ============================================
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Help tags" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "Recent files" })
map("n", "<leader>fc", "<cmd>Telescope commands<CR>", { desc = "Commands" })
map("n", "<leader>fk", "<cmd>Telescope keymaps<CR>", { desc = "Keymaps" })
map("n", "<leader>fw", "<cmd>Telescope grep_string<CR>", { desc = "Find word under cursor" })
map("n", "<leader>fr", "<cmd>Telescope resume<CR>", { desc = "Resume last search" })

-- Альтернативные shortcuts (как в VSCode)
map("n", "<C-p>", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
map("n", "<C-f>", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })

-- ============================================
-- FILE EXPLORER (NVIM-TREE)
-- ============================================
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
map("n", "<leader>ef", "<cmd>NvimTreeFindFile<CR>", { desc = "Find file in explorer" })
map("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" })
map("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })

-- ============================================
-- TROUBLE (DIAGNOSTICS)
-- ============================================
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Toggle Trouble" })
map("n", "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "Buffer diagnostics" })
map("n", "<leader>xs", "<cmd>Trouble symbols toggle focus=false<CR>", { desc = "Symbols (Trouble)" })
map("n", "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<CR>", { desc = "LSP references" })
map("n", "<leader>xq", "<cmd>Trouble qflist toggle<CR>", { desc = "Quickfix list" })

-- ============================================
-- TODO COMMENTS
-- ============================================
map("n", "<leader>ft", "<cmd>TodoTelescope<CR>", { desc = "Find todos" })
map("n", "]t", function()
	require("todo-comments").jump_next()
end, { desc = "Next todo comment" })
map("n", "[t", function()
	require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })

-- ============================================
-- ФОРМАТИРОВАНИЕ (CONFORM)
-- ============================================
map({ "n", "v" }, "<leader>f", function()
	require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format file or range" })

-- ============================================
-- TERMINAL
-- ============================================
-- Открыть терминал
map("n", "<leader>tt", "<cmd>terminal<CR>", { desc = "Open terminal" })
map("n", "<leader>tv", "<cmd>vsplit | terminal<CR>", { desc = "Open terminal (vsplit)" })
map("n", "<leader>th", "<cmd>split | terminal<CR>", { desc = "Open terminal (split)" })

-- Выход из режима терминала
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
map("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Move to left window" })
map("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Move to bottom window" })
map("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Move to top window" })
map("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Move to right window" })

-- ============================================
-- КОММЕНТАРИИ
-- ============================================
-- Note: плагин Comment.nvim автоматически настраивает gcc и gc
-- Дополнительные shortcuts:
map("n", "<C-/>", "gcc", { desc = "Toggle comment", remap = true })
map("v", "<C-/>", "gc", { desc = "Toggle comment", remap = true })

-- ============================================
-- СВОРАЧИВАНИЕ (FOLDING)
-- ============================================
map("n", "<leader>z", "za", { desc = "Toggle fold" })
map("n", "<leader>Z", "zA", { desc = "Toggle all folds" })

-- ============================================
-- QUICKFIX И LOCATION LIST
-- ============================================
map("n", "<leader>co", "<cmd>copen<CR>", { desc = "Open quickfix list" })
map("n", "<leader>cc", "<cmd>cclose<CR>", { desc = "Close quickfix list" })
map("n", "[q", "<cmd>cprev<CR>", { desc = "Previous quickfix item" })
map("n", "]q", "<cmd>cnext<CR>", { desc = "Next quickfix item" })

map("n", "<leader>lo", "<cmd>lopen<CR>", { desc = "Open location list" })
map("n", "<leader>lc", "<cmd>lclose<CR>", { desc = "Close location list" })
map("n", "[l", "<cmd>lprev<CR>", { desc = "Previous location item" })
map("n", "]l", "<cmd>lnext<CR>", { desc = "Next location item" })

-- ============================================
-- SPELL CHECKING
-- ============================================
map("n", "<leader>s", "<cmd>set spell!<CR>", { desc = "Toggle spell check" })
map("n", "[s", "[s", { desc = "Previous spelling error" })
map("n", "]s", "]s", { desc = "Next spelling error" })
map("n", "z=", "z=", { desc = "Spelling suggestions" })
map("n", "zg", "zg", { desc = "Add word to dictionary" })
map("n", "zw", "zw", { desc = "Mark word as incorrect" })

-- aerial
map("n", "<leader>a", "<cmd>AerialToggle!<CR>", { desc = "Toggle Aerial outline" })

-- ============================================
-- РАЗНОЕ
-- ============================================
-- Быстрая замена слова под курсором
map("n", "<leader>r", ":%s/\\<<C-r><C-w>\\>//g<Left><Left>", { desc = "Replace word under cursor" })

-- Выделить весь файл
map("n", "<C-a>", "ggVG", { desc = "Select all" })

-- Сохранить и выполнить текущий файл
map("n", "<leader><leader>x", "<cmd>w<CR><cmd>source %<CR>", { desc = "Save and source file" })

-- Переключение между относительными и абсолютными номерами строк
map("n", "<leader>n", "<cmd>set relativenumber!<CR>", { desc = "Toggle relative line numbers" })

-- Открыть конфигурацию Neovim
map("n", "<leader>C", "<cmd>e $MYVIMRC<CR>", { desc = "Edit config" })

