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

-- Буферы
map("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })

-- Перемещение строк
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Git (простые команды)
map("n", "<leader>gs", "<cmd>Git<CR>", { desc = "Git status" })
map("n", "<leader>gd", "<cmd>Gdiffsplit<CR>", { desc = "Git diff" })
map("n", "<leader>gb", "<cmd>Git blame<CR>", { desc = "Git blame" })
map("n", "<leader>gl", "<cmd>Git log<CR>", { desc = "Git log" })

-- Code Review
map("n", "<leader>gv", "<cmd>DiffviewOpen<CR>", { desc = "Open diff view" })
map("n", "<leader>gV", "<cmd>DiffviewClose<CR>", { desc = "Close diff view" })
map("n", "<leader>gf", "<cmd>DiffviewFileHistory %<CR>", { desc = "File history" })

-- Telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Help tags" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "Recent files" })
map("n", "<leader>fc", "<cmd>Telescope commands<CR>", { desc = "Commands" })
map("n", "<leader>fk", "<cmd>Telescope keymaps<CR>", { desc = "Keymaps" })

-- LSP
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "gr", vim.lsp.buf.references, { desc = "References" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })

-- DAP Debugging
map("n", "<F5>", function()
	require("dap").continue()
end, { desc = "Debug: Continue" })
map("n", "<F7>", function()
	require("dap").step_into()
end, { desc = "Debug: Step Into" })
map("n", "<F8>", function()
	require("dap").step_over()
end, { desc = "Debug: Step Over" })
map("n", "<F9>", function()
	require("dap").step_out()
end, { desc = "Debug: Step Out" })
map("n", "<S-F5>", function()
	require("dap").terminate()
end, { desc = "Debug: Terminate" })
map("n", "<leader>b", function()
	require("dap").toggle_breakpoint()
end, { desc = "Debug: Toggle Breakpoint" })
map("n", "<leader>B", function()
	require("dap").set_breakpoint(vim.fn.input("Condition: "))
end, { desc = "Debug: Conditional BP" })
map("n", "<leader>dr", function()
	require("dap").repl.toggle()
end, { desc = "Debug: REPL" })

-- Go-specific Debugging
map("n", "<leader>dt", function()
	require("dap-go").debug_test()
end, { desc = "Debug: Go test" })
map("n", "<leader>dd", function()
	require("dap-go").debug()
end, { desc = "Debug: Go package" })
map("n", "<leader>dl", function()
	require("dap-go").debug_last()
end, { desc = "Debug: Go last" })

-- Trouble
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Trouble: Diagnostics" })
map("n", "<leader>xw", "<cmd>Trouble workspace_diagnostics toggle<CR>", { desc = "Trouble: Workspace" })
map("n", "<leader>xd", "<cmd>Trouble document_diagnostics toggle<CR>", { desc = "Trouble: Document" })

-- Code folding
vim.opt.foldmethod = "expr" -- Использовать treesitter для фолдинга
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99
map("n", "<leader>z", "za", { silent = true, desc = "Toggle fold" })
map("n", "<leader>Z", "zA", { silent = true, desc = "Toggle fold recursively" })
map("n", "<leader>r", "zR", { silent = true, desc = "Open all folds" })
map("n", "<leader>m", "zM", { silent = true, desc = "Close all folds" })

-- NvimTree
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "File explorer" })
