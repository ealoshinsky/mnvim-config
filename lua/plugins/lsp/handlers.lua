-- LSP handlers and UI configuration
local M = {}

function M.setup()
    -- ============================================
    -- НАСТРОЙКИ ДИАГНОСТИКИ
    -- ============================================
    vim.diagnostic.config({
        virtual_text = {
            prefix = "●",
            spacing = 4,
            source = "if_many",
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
        },
    })

    -- Символы для диагностики (новый API для Neovim 0.11+)
    vim.diagnostic.config({
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = "",
                [vim.diagnostic.severity.WARN] = "",
                [vim.diagnostic.severity.HINT] = "",
                [vim.diagnostic.severity.INFO] = "",
            },
        },
    })

    -- ============================================
    -- УЛУЧШЕННЫЕ HOVER-ОКНА
    -- ============================================
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
        max_width = 80,
    })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
        max_width = 80,
    })
end

-- ============================================
-- ПОДСВЕТКА СИМВОЛОВ ПОД КУРСОРОМ
-- ============================================
function M.setup_document_highlight(buf, client)
    if not client.server_capabilities.documentHighlightProvider then
        return
    end

    local highlight_augroup = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })

    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
    })

    vim.api.nvim_create_autocmd("CursorMoved", {
        buffer = buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
    })
end

return M
