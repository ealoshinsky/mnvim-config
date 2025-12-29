-- lua/core/autocmds.lua
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.hl.on_yank({ timeout = 200 })
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.lua", "*.go", "*.js", "*.ts", "*.jsx", "*.tsx" },
	callback = function()
		vim.lsp.buf.format({ async = false })
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

-- organize imports перед сохранением для Go
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.go",
	callback = function()
		vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
	end,
})

-- organize imports для TypeScript
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
	callback = function()
		vim.lsp.buf.code_action({
			context = { only = { "source.organizeImports" } },
			apply = true,
		})
	end,
})
