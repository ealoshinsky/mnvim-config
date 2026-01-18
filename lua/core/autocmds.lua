-- lua/core/autocmds.lua

-- ============================================
-- Подсветка при копировании
-- ============================================
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({ timeout = 200 })
    end,
})

-- ============================================
-- Настройки для текстовых файлов
-- ============================================
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "gitcommit", "markdown", "text", "latex", "tex", "rst", "asciidoc" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
        vim.opt_local.spelllang = "en_us,ru"
    end,
})

-- ============================================
-- Проверка орфографии в комментариях кода
-- ============================================
vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "lua",
        "python",
        "javascript",
        "typescript",
        "go",
        "rust",
        "cpp",
        "java",
        "c",
        "csharp",
        "php",
        "ruby"
    },
    callback = function()
        vim.opt_local.spell = true
        vim.opt_local.spelllang = "en_us,ru"
    end,
})

-- ============================================
-- Organize Imports (асинхронно!)
-- ============================================
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.ts", "*.tsx", "*.js", "*.jsx", "*.go" },
    callback = function()
        -- Таймаут для предотвращения зависания
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

-- ============================================
-- Форматирование при сохранении (для Go)
-- ============================================
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()
        local params = vim.lsp.util.make_range_params()
        params.context = { only = { "source.organizeImports" } }

        -- Сначала organize imports
        local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
        if result then
            for _, res in pairs(result) do
                for _, action in pairs(res.result or {}) do
                    if action.edit then
                        vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
                    end
                end
            end
        end

        -- Потом форматирование
        vim.lsp.buf.format({ async = false })
    end,
})

-- ============================================
-- Автоматическое закрытие некоторых окон по q
-- ============================================
vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "qf",
        "help",
        "man",
        "notify",
        "lspinfo",
        "startuptime",
        "checkhealth",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
})

-- ============================================
-- Восстановление позиции курсора
-- ============================================
vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- ============================================
-- Автосохранение при потере фокуса
-- ============================================
vim.api.nvim_create_autocmd("FocusLost", {
    callback = function()
        if vim.bo.modified and not vim.bo.readonly and vim.fn.expand("%") ~= "" and vim.bo.buftype == "" then
            vim.cmd("silent! write")
        end
    end,
})

-- ============================================
-- Подсветка trailing whitespace
-- ============================================
vim.api.nvim_create_autocmd({ "BufWinEnter", "InsertLeave" }, {
    callback = function()
        vim.fn.matchadd("ExtraWhitespace", [[\s\+$]])
    end,
})

vim.cmd([[highlight ExtraWhitespace ctermbg=red guibg=#ff5555]])

-- ============================================
-- Автоматическое создание родительских директорий
-- ============================================
vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function(event)
        if event.match:match("^%w%w+://") then
            return
        end
        local file = vim.loop.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
})

-- ============================================
-- Относительные номера строк только в активном окне
-- ============================================
local number_toggle_group = vim.api.nvim_create_augroup("NumberToggle", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
    group = number_toggle_group,
    callback = function()
        if vim.wo.number and vim.fn.mode() ~= "i" then
            vim.wo.relativenumber = true
        end
    end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
    group = number_toggle_group,
    callback = function()
        if vim.wo.number then
            vim.wo.relativenumber = false
        end
    end,
})

-- ============================================
-- Отключение автокомментирования новой строки
-- ============================================
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        vim.opt.formatoptions:remove({ "c", "r", "o" })
    end,
})
