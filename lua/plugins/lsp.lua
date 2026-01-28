-- Main LSP configuration (for Neovim 0.11+)
return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = "williamboman/mason.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "gopls",
                    "ts_ls",
                    "html",
                    "cssls",
                    "jsonls",
                },
            })
        end,
    },
    {
        "hrsh7th/cmp-nvim-lsp",
    },
    {
        "b0o/schemastore.nvim",
    },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "b0o/schemastore.nvim",
        },
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local lsp_settings = require("plugins.lsp.settings")
            local lsp_handlers = require("plugins.lsp.handlers")
            local lsp_keymaps = require("plugins.lsp.keymaps")

            -- Настройка handlers и UI
            lsp_handlers.setup()

            -- ============================================
            -- НАСТРОЙКА LSP СЕРВЕРОВ
            -- ============================================
            for server_name, config in pairs(lsp_settings.servers) do
                config.capabilities = capabilities
                
                -- Обработка schemas для jsonls
                if server_name == "jsonls" and config.settings and config.settings.json then
                    if type(config.settings.json.schemas) == "function" then
                        config.settings.json.schemas = config.settings.json.schemas()
                    end
                end
                
                vim.lsp.config(server_name, config)
            end

            -- ============================================
            -- АВТОМАТИЧЕСКОЕ ВКЛЮЧЕНИЕ LSP ДЛЯ ФАЙЛОВ
            -- ============================================
            local filetypes_to_servers = {
                go = "gopls",
                gomod = "gopls",
                gowork = "gopls",
                gotmpl = "gopls",
                javascript = "ts_ls",
                javascriptreact = "ts_ls",
                typescript = "ts_ls",
                typescriptreact = "ts_ls",
                html = "html",
                css = "cssls",
                scss = "cssls",
                less = "cssls",
                json = "jsonls",
                jsonc = "jsonls",
                lua = "lua_ls",
            }

            for ft, server in pairs(filetypes_to_servers) do
                vim.api.nvim_create_autocmd("FileType", {
                    pattern = ft,
                    callback = function()
                        vim.lsp.enable(server)
                    end,
                })
            end

            -- ============================================
            -- НАСТРОЙКА KEYBINDINGS ПРИ ПОДКЛЮЧЕНИИ LSP
            -- ============================================
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local buf = args.buf
                    local client = vim.lsp.get_client_by_id(args.data.client_id)

                    -- Настройка keymaps
                    lsp_keymaps.setup(buf, client)

                    -- Настройка подсветки символов
                    lsp_handlers.setup_document_highlight(buf, client)
                end,
            })
        end,
    },
}
