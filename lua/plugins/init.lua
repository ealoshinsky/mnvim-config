-- lua/plugins/init.lua
return {
    -- Менеджер плагинов
    {
        "folke/lazy.nvim",
        tag = "stable",
    },

    -- Тема
    {
        "navarasu/onedark.nvim",
        priority = 1000,
        config = function()
            require("onedark").load()
        end,
    },

    -- Иконки
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
    },

    -- Файловый менеджер
    {
        "nvim-tree/nvim-tree.lua",
        config = function()
            require("nvim-tree").setup()
            vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "File explorer" })
        end,
    },

    -- Статусная строка
    {
        "nvim-lualine/lualine.nvim",
        config = function()
            require("lualine").setup({
                options = {
                    theme = "onedark",
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    globalstatus = true,
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff", "diagnostics" },
                    lualine_c = { { "filename", path = 1 } }, -- полный путь как в GoLand
                    lualine_x = { "encoding", "fileformat", "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
            })
        end,
    },

    -- Подсветка цветов
    {
        "norcalli/nvim-colorizer.lua",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("colorizer").setup()
        end,
    },

    -- Встроенный терминал
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        config = function()
            require("toggleterm").setup({
                open_mapping = [[<c-\>]],
                direction = "float",
                float_opts = {
                    border = "rounded",
                },
            })

            vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })
        end,
    },

    -- Автодополнение
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lsp-signature-help", -- подсказка параметров функции прямо в строке
            "onsails/lspkind.nvim",                -- иконки как в IntelliJ
        },
        config = function()
            local cmp = require("cmp")
            local lspkind = require("lspkind")

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },

                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },

                formatting = {
                    format = lspkind.cmp_format({
                        mode = "symbol_text", -- как в GoLand: иконка + тип + имя
                        maxwidth = 60,
                        ellipsis_char = "...",
                    }),
                },

                mapping = cmp.mapping.preset.insert({
                    ["<C-Space>"] = cmp.mapping.complete(),      -- как Ctrl+Space в GoLand
                    ["<CR>"]      = cmp.mapping.confirm({ select = false }), -- только явный выбор
                    ["<C-e>"]     = cmp.mapping.abort(),

                    -- Улучшенная навигация без Tab/S-Tab (они теперь для буферов)
                    ["<C-n>"]     = cmp.mapping(function()
                        if cmp.visible() then
                            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                        elseif require("luasnip").expand_or_jumpable() then
                            require("luasnip").expand_or_jump()
                        end
                    end, { "i", "s" }),

                    ["<C-p>"]     = cmp.mapping(function()
                        if cmp.visible() then
                            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                        elseif require("luasnip").jumpable(-1) then
                            require("luasnip").jump(-1)
                        end
                    end, { "i", "s" }),

                    -- Стрелки для навигации по автодополнению
                    ["<Down>"]    = cmp.mapping.select_next_item(),
                    ["<Up>"]      = cmp.mapping.select_prev_item(),
                }),

                sources = cmp.config.sources({
                    { name = "nvim_lsp",                priority = 1000 },
                    { name = "nvim_lsp_signature_help", priority = 900 }, -- параметры функции
                    { name = "luasnip",                 priority = 800 },
                    { name = "buffer",                  priority = 500 },
                    { name = "path",                    priority = 250 },
                }),

                -- Сортировка как в GoLand: сначала по релевантности LSP, потом по локальности
                sorting = {
                    priority_weight = 2,
                    comparators = {
                        cmp.config.compare.offset,
                        cmp.config.compare.exact,
                        cmp.config.compare.score,
                        cmp.config.compare.kind,
                        cmp.config.compare.sort_text,
                        cmp.config.compare.length,
                        cmp.config.compare.order,
                    },
                },
            })

            -- Подсказка параметров функции (то, что в GoLand появляется серым текстом в строке)
            require("cmp").setup.filetype({ "go" }, {
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "nvim_lsp_signature_help" }, -- вот эта магия
                })
            })
        end,
    },

    -- Snippets
    {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
    },
}
