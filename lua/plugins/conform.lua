return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
        {
            "<leader>f",
            function()
                require("conform").format({ async = true, lsp_fallback = true })
            end,
            mode = { "n", "v" },
            desc = "Format buffer",
        },
    },
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                -- Go
                go = { "goimports", "gofumpt" },

                -- Lua
                lua = { "stylua" },

                -- JavaScript/TypeScript
                javascript = { "prettier" },
                typescript = { "prettier" },
                javascriptreact = { "prettier" },
                typescriptreact = { "prettier" },

                -- Web
                json = { "prettier" },
                jsonc = { "prettier" },
                yaml = { "prettier" },
                html = { "prettier" },
                css = { "prettier" },
                scss = { "prettier" },
                markdown = { "prettier" },

                -- Python
                python = { "isort", "black" },

                -- Rust
                rust = { "rustfmt" },

                -- Shell
                sh = { "shfmt" },
                bash = { "shfmt" },
            },

            -- Форматирование при сохранении
            format_on_save = function(bufnr)
                -- Отключить для определённых файлов
                local bufname = vim.api.nvim_buf_get_name(bufnr)
                if bufname:match("/node_modules/") then
                    return
                end

                return {
                    timeout_ms = 500,
                    lsp_fallback = true,
                }
            end,

            -- Настройки форматтеров
            formatters = {
                shfmt = {
                    prepend_args = { "-i", "2", "-ci" },
                },
                prettier = {
                    prepend_args = {
                        "--tab-width", "2",
                        "--print-width", "100",
                    },
                },
            },

            -- Уведомления
            notify_on_error = true,
        })

        -- Команда для просмотра доступных форматтеров
        vim.api.nvim_create_user_command("FormatDisable", function(args)
            if args.bang then
                -- FormatDisable! - отключить для всех буферов
                vim.b.disable_autoformat = true
                vim.g.disable_autoformat = true
            else
                vim.b.disable_autoformat = true
            end
        end, {
            desc = "Disable autoformat-on-save",
            bang = true,
        })

        vim.api.nvim_create_user_command("FormatEnable", function()
            vim.b.disable_autoformat = false
            vim.g.disable_autoformat = false
        end, {
            desc = "Re-enable autoformat-on-save",
        })
    end,
}