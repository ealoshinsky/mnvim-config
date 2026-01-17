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
                ensure_installed = { "lua_ls", "gopls", "ts_ls", "html", "cssls", "jsonls" },
            })
        end,
    },
    -- Простой и красивый hover с подчеркиваниями
    {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        config = function()
            require("lsp_lines").setup()
            -- Отключить виртуальный текст (чтобы не дублировалось)
            vim.diagnostic.config({ virtual_text = false })
        end,
    },

    -- Красивые иконки для LSP
    {
        "onsails/lspkind.nvim",
        config = function()
            require("lspkind").init({
                mode = "symbol_text",
                preset = "codicons",
            })
        end,
    },

    -- Дополнительные плагины для красивого отображения
    -- Красивые подсказки сигнатур функций
    {
        "ray-x/lsp_signature.nvim",
        config = function()
            require("lsp_signature").setup({
                bind = true,
                doc_lines = 2, -- Количество строк документации
                max_height = 12, -- Максимальная высота
                max_width = 80, -- Максимальная ширина
                wrap = true, -- Перенос текста
                floating_window = true, -- Плавающее окно
                floating_window_above_cur_line = true, -- Окно над текущей строкой
                floating_window_off_x = 5, -- Смещение по X
                floating_window_off_y = 0, -- Смещение по Y
                close_timeout = 4000, -- Автозакрытие через 4 секунды
                fix_pos = false, -- Фиксированная позиция
                hint_enable = true, -- Показывать подсказки
                hint_prefix = "🐼 ", -- Префикс подсказки
                hint_scheme = "String",
                hi_parameter = "LspSignatureActiveParameter", -- Highlight активного параметра
                handler_opts = {
                    border = "rounded", -- Закругленные границы
                },
                always_trigger = false, -- Всегда показывать
                auto_close_after = nil, -- Автозакрытие после...
                extra_trigger_chars = {}, -- Дополнительные символы для активации
                zindex = 200, -- Z-index окна
                padding = "", -- Отступы
                transparency = 10, -- Прозрачность (если поддерживается)
                shadow_blend = 36, -- Тень
                shadow_guibg = 'Black', -- Цвет тени
                timer_interval = 200, -- Интервал таймера
                toggle_key = nil, -- Клавиша переключения
                select_signature_key = nil, -- Клавиша выбора сигнатуры
            })
        end,
    },

    -- Цветовая схема для диагностик
    {
        "folke/lsp-colors.nvim",
        config = function()
            require("lsp-colors").setup({
                Error = "#db4b4b",
                Warning = "#e0af68",
                Information = "#0db9d7",
                Hint = "#10B981"
            })
        end,
    },

    {
        "b0o/schemastore.nvim",
    },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "b0o/schemastore.nvim",
            "ray-x/lsp_signature.nvim",
            "folke/lsp-colors.nvim",
        },
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local on_attach = function(client, bufnr)
                local map = function(m, lhs, rhs, desc)
                    vim.keymap.set(m, lhs, rhs, { buffer = bufnr, desc = desc })
                end

                -- Настройка lsp_signature при присоединении LSP
                require("lsp_signature").on_attach({
                    bind = true,
                    handler_opts = {
                        border = "rounded"
                    }
                }, bufnr)

                map("n", "K", function()
                    -- Используем красивый hover с границами и дополнительными настройками
                    local params = vim.lsp.util.make_position_params()
                    client.request("textDocument/hover", params, function(err, result, ctx, config)
                        if err then
                            vim.notify("Hover error: " .. err.message, vim.log.levels.WARN)
                            return
                        end
                        if not (result and result.contents) then
                            vim.notify("No documentation available", vim.log.levels.INFO)
                            return
                        end

                        -- Красивое отображение hover
                        local border_opts = {
                            border = "rounded",
                            focusable = false,
                            style = "minimal",
                            title = " 📚 Documentation ",
                            title_pos = "center",
                            max_width = 80,
                            max_height = 25,
                        }

                        -- Используем кастомный обработчик для hover
                        local handler = vim.lsp.with(
                            vim.lsp.handlers.hover,
                            border_opts
                        )

                        handler(err, result, ctx, config)
                    end, bufnr)
                end, "Beautiful Hover Documentation")

                -- Остальные маппинги остаются без изменений
                map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
                map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
                map("n", "gi", vim.lsp.buf.implementation, "Goto Implementation")
                map("n", "gr", vim.lsp.buf.references, "References")
                map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
                map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
                map("n", "<leader>f", function()
                    vim.lsp.buf.format({ async = true })
                end, "Format")

                -- Дополнительные полезные маппинги
                map("n", "<leader>li", "<cmd>LspInfo<cr>", "LSP Info")
                map("n", "<leader>lr", vim.lsp.buf.references, "References")
                map("n", "<leader>ls", vim.lsp.buf.signature_help, "Signature Help")
                map("n", "<leader>lq", vim.diagnostic.setloclist, "Diagnostics to Location List")
            end

            -- Настройка обработчиков для красивого отображения
            local border_opts = {
                border = "rounded",
                focusable = false,
                style = "minimal",
            }

            -- Красивое hover-окно
            vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
                vim.lsp.handlers.hover,
                vim.tbl_extend("force", border_opts, {
                    max_width = 80,
                    max_height = 25,
                    title = " 📚 Documentation ",
                    title_pos = "center",
                })
            )

            -- Красивое окно подсказок сигнатур
            vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
                vim.lsp.handlers.signature_help,
                vim.tbl_extend("force", border_opts, {
                    title = " 🔧 Signature Help ",
                })
            )

            -- Настройки для разных языков
            -- Lua
            vim.lsp.config("lua_ls", {
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    Lua = {
                        runtime = {
                            version = 'LuaJIT',
                        },
                        diagnostics = {
                            globals = { "vim" },
                            disable = { "lowercase-global" }
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                        telemetry = { enable = false },
                        hint = {
                            enable = true,
                        },
                    },
                },
            })

            -- Go
            vim.lsp.config("gopls", {
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    gopls = {
                        completeUnimported = true,
                        usePlaceholders = true,
                        experimentalPostfixCompletions = true,
                        analyses = {
                            unusedparams = true,
                            shadow = true,
                            nilness = true,
                            unusedwrite = true,
                            useany = true,
                            unusedvariable = true,
                            staticcheck = true,
                        },
                        hints = {
                            assignVariableTypes = true,
                            compositeLiteralFields = true,
                            constantValues = true,
                            functionTypeParameters = true,
                            parameterNames = true,
                            rangeVariableTypes = true,
                        },
                        staticcheck = true,
                        gofumpt = true,
                        directoryFilters = { "-node_modules", "-.git", "-.env", "-build" },
                        codelenses = {
                            generate = true,
                            gc_details = true,
                            test = true,
                            tidy = true,
                            upgrade_dependency = true,
                            run_vulncheck_exp = true,
                        },
                        symbolMatcher = "fuzzy",
                        semanticTokens = true,
                        templateExtensions = { "gotmpl", "tmpl", "html" },
                    },
                },
            })

            -- TypeScript/JavaScript
            vim.lsp.config("ts_ls", {
                capabilities = capabilities,
                on_attach = on_attach,
                init_options = {
                    preferences = {
                        importModuleSpecifierPreference = "relative",
                    },
                },
            })

            -- HTML
            vim.lsp.config("html", {
                capabilities = capabilities,
                on_attach = on_attach,
                filetypes = { "html", "javascriptreact", "typescriptreact" },
                init_options = {
                    configurationSection = { "html", "css", "javascript" },
                    embeddedLanguages = {
                        css = true,
                        javascript = true
                    },
                },
            })

            -- CSS
            vim.lsp.config("cssls", {
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    css = {
                        validate = true,
                        lint = {
                            unknownAtRules = "ignore"
                        }
                    },
                    scss = {
                        validate = true,
                        lint = {
                            unknownAtRules = "ignore"
                        }
                    },
                    less = {
                        validate = true,
                        lint = {
                            unknownAtRules = "ignore"
                        }
                    }
                }
            })

            -- JSON
            vim.lsp.config("jsonls", {
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    json = {
                        schemas = require("schemastore").json.schemas(),
                        validate = { enable = true },
                    },
                },
            })

            -- Диагностика с красивым оформлением
            vim.diagnostic.config({
                virtual_text = {
                    prefix = "●",
                    spacing = 4,
                    format = function(diagnostic)
                        local icons = {
                            Error = "",
                            Warn = "",
                            Info = "",
                            Hint = "",
                        }
                        local level = diagnostic.severity
                        local level_name = vim.diagnostic.severity[level]
                        return string.format("%s %s", icons[level_name] or "●", diagnostic.message)
                    end,
                },
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "",
                        [vim.diagnostic.severity.WARN] = "",
                        [vim.diagnostic.severity.INFO] = "",
                        [vim.diagnostic.severity.HINT] = "",
                    },
                    numhl = {
                        [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
                        [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
                        [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
                        [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
                    },
                },
                underline = true,
                update_in_insert = false,
                severity_sort = true,
                float = {
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = function(diagnostic, i, total)
                        local icons = {
                            [vim.diagnostic.severity.ERROR] = " ",
                            [vim.diagnostic.severity.WARN] = " ",
                            [vim.diagnostic.severity.INFO] = " ",
                            [vim.diagnostic.severity.HINT] = " ",
                        }
                        return icons[diagnostic.severity] or ""
                    end,
                    format = function(diagnostic)
                        return string.format("%s [%s] %s",
                            diagnostic.source or "",
                            diagnostic.code or "",
                            diagnostic.message
                        )
                    end,
                },
            })

            -- Настройка цветов диагностик
            vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#db4b4b" })
            vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#e0af68" })
            vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = "#0db9d7" })
            vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = "#10B981" })
            vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = "#db4b4b" })
            vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = "#e0af68" })
            vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = "#0db9d7" })
            vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { undercurl = true, sp = "#10B981" })
            vim.api.nvim_set_hl(0, "SpellBad", { undercurl = true, sp = "#db4b4b" })
            vim.api.nvim_set_hl(0, "SpellCap", { undercurl = true, sp = "#e0af68" })
            vim.api.nvim_set_hl(0, "SpellRare", { undercurl = true, sp = "#0db9d7" })
            vim.api.nvim_set_hl(0, "SpellLocal", { undercurl = true, sp = "#10B981" })
        end,
    },
}
