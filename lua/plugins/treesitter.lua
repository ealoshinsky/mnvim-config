return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        cmd = { "TSInstall", "TSUpdate", "TSUninstall", "TSLog" },
        config = function()
            local ts = require("nvim-treesitter")

            ts.setup({
                -- Парсеры и queries ставятся сюда (каталог добавляется в runtimepath)
                install_dir = vim.fn.stdpath("data") .. "/site",
            })

            -- Список парсеров. Установка асинхронная: недостающие
            -- докачиваются в фоне при первом запуске.
            local parsers = {
                "lua", "vim", "vimdoc", "query", -- Обязательные для Neovim
                "python", "javascript", "typescript", "tsx", "jsdoc",
                "html", "css", "scss", "vue", -- Vue 3 SFC: template/script/style
                "json", "yaml", "toml", "markdown", "markdown_inline",
                "bash", "go", "gomod", "gosum", "sql", "dockerfile",
            }

            local installed = ts.get_installed("parsers")
            local missing = vim.tbl_filter(function(lang)
                return not vim.tbl_contains(installed, lang)
            end, parsers)

            if #missing > 0 then
                ts.install(missing)
            end

            -- Подсветка/отступы/сворачивание включаются вручную:
            -- в ветке main nvim-treesitter больше не делает это сам.
            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
                callback = function(ev)
                    local lang = vim.treesitter.language.get_lang(ev.match)
                    if not lang then
                        return
                    end

                    -- language.add() не бросает ошибку, а возвращает false,
                    -- если парсера нет (gitcommit, git_rebase и т.п.),
                    -- поэтому проверяем именно возвращаемое значение.
                    local ok, added = pcall(vim.treesitter.language.add, lang)
                    if not ok or not added then
                        return
                    end

                    -- Подсветка
                    if not pcall(vim.treesitter.start, ev.buf, lang) then
                        return
                    end

                    -- Отступы
                    vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

                    -- Сворачивание по дереву (только для окна с этим буфером)
                    if vim.api.nvim_get_current_buf() == ev.buf then
                        vim.wo[0][0].foldmethod = "expr"
                        vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
                    end
                end,
            })

            vim.opt.foldlevel = 99
        end,
    },
    {
        "windwp/nvim-ts-autotag",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("nvim-ts-autotag").setup({
                opts = {
                    enable_close = true,
                    enable_rename = true,
                    enable_close_on_slash = false,
                },
            })
        end,
    },
}
