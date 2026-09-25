-- Подсветка при копировании
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({ timeout = 200 })
    end,
})

-- Organize Imports перед сохранением (только для TypeScript/JavaScript/Go)
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.ts", "*.tsx", "*.js", "*.jsx", "*.go" },
    callback = function()
        local params = vim.lsp.util.make_range_params()
        params.context = { only = { "source.organizeImports" } }

        local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)

        if not result or vim.tbl_isempty(result) then
            return
        end

        for _, res in pairs(result) do
            for _, action in pairs(res.result or {}) do
                if action.edit then
                    vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
                end
            end
        end
    end,
})

-- Комфортное чтение/правка markdown + переходы по ссылкам
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown" },
    callback = function(ev)
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
        vim.opt_local.breakindent = true
        vim.opt_local.spell = true
        -- gf по ссылкам вида [текст](./other) — без расширения
        vim.opt_local.suffixesadd:prepend(".md")
        -- В пределах папки текущего файла ищем соседние заметки
        vim.opt_local.path:prepend(vim.fn.expand("%:p:h"))

        local map = function(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc, silent = true })
        end

        -- Переход по ссылке в новом split, чтобы исходный файл остался виден
        map("<leader>ml", "<C-w>vgf", "Markdown: открыть ссылку в сплите")
        -- Назад по истории переходов
        map("<BS>", "<C-o>", "Markdown: назад")
    end,
})
