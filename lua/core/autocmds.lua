-- lua/core/autocmds.lua
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({ timeout = 200 })
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "gitcommit", "markdown", "text", "latex", "tex", "rst", "asciidoc" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
        vim.opt_local.spelllang = "en_us,ru"
    end,
})

-- Проверка орфографии в комментариях кода
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "lua", "python", "javascript", "typescript", "go", "rust", "cpp", "java", "c", "csharp", "php", "ruby" },
    callback = function()
        -- Включаем проверку орфографии для комментариев в коде
        vim.opt_local.spell = true
        vim.opt_local.spelllang = "en_us"
    end,
})

-- organize imports для TypeScript/JavaScript
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
    callback = function()
        vim.lsp.buf.code_action({
            context = { only = { "source.organizeImports" } },
            apply = true,
        })
    end,
})
