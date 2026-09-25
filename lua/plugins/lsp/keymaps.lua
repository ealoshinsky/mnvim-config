-- LSP keybindings
local M = {}

function M.setup(buf, client)
	local map = function(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
	end

	-- ============================================
	-- НАВИГАЦИЯ
	-- ============================================
	map("n", "gd", vim.lsp.buf.definition, "Go to definition")
	map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
	map("n", "gr", vim.lsp.buf.references, "Find references")
	map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
	map("n", "gy", vim.lsp.buf.type_definition, "Go to type definition")

	-- ============================================
	-- ДОКУМЕНТАЦИЯ
	-- ============================================
	-- В Neovim 0.11 рамка задаётся прямо в вызове (vim.lsp.handlers больше не используются)
	local float_opts = { border = "rounded", max_width = 80 }
	map("n", "K", function()
		vim.lsp.buf.hover(float_opts)
	end, "Hover documentation")
	map({ "n", "i" }, "<C-k>", function()
		vim.lsp.buf.signature_help(float_opts)
	end, "Signature help")

	-- ============================================
	-- РЕФАКТОРИНГ
	-- ============================================
	map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
	map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")

	-- ============================================
	-- ДИАГНОСТИКА
	-- ============================================
	map("n", "[d", function()
		vim.diagnostic.jump({ count = -1, float = true })
	end, "Previous diagnostic")
	map("n", "]d", function()
		vim.diagnostic.jump({ count = 1, float = true })
	end, "Next diagnostic")
	map("n", "<leader>ee", vim.diagnostic.open_float, "Show diagnostic")
	map("n", "<leader>dl", vim.diagnostic.setloclist, "Diagnostics to loclist")

	-- ============================================
	-- СИМВОЛЫ
	-- ============================================
	map("n", "<leader>ds", vim.lsp.buf.document_symbol, "Document symbols")
	map("n", "<leader>ws", vim.lsp.buf.workspace_symbol, "Workspace symbols")

	-- Форматирование (<leader>f) — через conform.nvim, см. plugins/conform.lua

	-- ============================================
	-- INLAY HINTS
	-- ============================================
	if client.server_capabilities.inlayHintProvider then
		vim.lsp.inlay_hint.enable(true, { bufnr = buf })

		map("n", "<leader>th", function()
			local current = vim.lsp.inlay_hint.is_enabled({ bufnr = buf })
			vim.lsp.inlay_hint.enable(not current, { bufnr = buf })
		end, "Toggle inlay hints")
	end

	-- ============================================
	-- GO-СПЕЦИФИЧНЫЕ КОМАНДЫ
	-- ============================================
	if client.name == "gopls" then
		map("n", "<leader>gt", "<cmd>!go test ./...<CR>", "Run all tests")
		map("n", "<leader>gv", "<cmd>!go vet ./...<CR>", "Run go vet")
		map("n", "<leader>gb", "<cmd>!go build<CR>", "Build project")
		map("n", "<leader>gr", "<cmd>!go run .<CR>", "Run main.go")
		map("n", "<leader>gm", "<cmd>!go mod tidy<CR>", "Go mod tidy")
	end
end

return M
