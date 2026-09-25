-- Main LSP configuration (for Neovim 0.11+)

-- Серверы из mason, для которых хватает дефолтного конфига nvim-lspconfig
local default_servers = { "yamlls", "dockerls", "bashls", "marksman" }

return {
    {
        "mason-org/mason.nvim",
        -- грузим сразу: mason добавляет свой bin/ в PATH, без этого LSP не находятся
        lazy = false,
        opts = {
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        },
    },
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
        opts = {
            ensure_installed = {
                "lua_ls",
                "gopls",
                "vtsls",
                "vue_ls",
                "html",
                "cssls",
                "jsonls",
                "yamlls",
                "dockerls",
                "bashls",
                "emmet_ls",
                -- markdown: переходы по ссылкам между файлами, символы-заголовки
                "marksman",
            },
            -- Серверы включаются явно ниже через vim.lsp.enable.
            -- ts_ls не ставим: он конфликтует с vtsls, а vue_ls (v3) работает только через vtsls.
            automatic_enable = false,
        },
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
            "mason-org/mason.nvim",
            "mason-org/mason-lspconfig.nvim",
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
            -- ВКЛЮЧЕНИЕ LSP СЕРВЕРОВ
            -- ============================================
            -- vim.lsp.enable сам подключает сервер к буферам по его filetypes.
            -- Для .vue стартуют оба: vtsls (<script>, через @vue/typescript-plugin)
            -- и vue_ls (<template>/<style>).
            vim.lsp.enable(vim.list_extend(vim.tbl_keys(lsp_settings.servers), default_servers))

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
