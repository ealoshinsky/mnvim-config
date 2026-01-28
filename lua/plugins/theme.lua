return {
    {
        "navarasu/onedark.nvim",
        priority = 1000,
        config = function()
            require("onedark").setup({
                style = "dark", -- dark, darker, cool, deep, warm, warmer
                transparent = false,
                term_colors = true,
                ending_tildes = false,
                cmp_itemkind_reverse = false,
                
                -- Кастомные цвета для улучшенной подсветки
                colors = {},
                highlights = {
                    -- LSP Semantic Tokens
                    ["@lsp.type.type"] = { fg = "#61afef" },
                    ["@lsp.type.struct"] = { fg = "#61afef" },
                    ["@lsp.type.interface"] = { fg = "#61afef" },
                    ["@lsp.type.parameter"] = { fg = "#abb2bf" },
                    ["@lsp.type.variable"] = { fg = "#abb2bf" },
                    ["@lsp.type.function"] = { fg = "#61afef" },
                    ["@lsp.type.method"] = { fg = "#61afef" },
                    ["@lsp.type.namespace"] = { fg = "#e5c07b" },
                    ["@lsp.type.comment"] = { fg = "#5c6370", italic = true },
                    
                    -- Inlay hints (серый цвет)
                    LspInlayHint = { fg = "#5c6370", bg = "NONE", italic = true },
                },
                
                code_style = {
                    comments = "italic",
                    keywords = "none",
                    functions = "none",
                    strings = "none",
                    variables = "none"
                },
                
                diagnostics = {
                    darker = true,
                    undercurl = true,
                    background = true,
                },
            })
            require("onedark").load()
        end,
    },
}