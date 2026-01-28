return {
    {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event= {"BufReadPost", "BufNewFile"},
  cmd = { "TSUpdateSync", "TSUpdate", "TSInstall"},
  config = function()
    require("nvim-treesitter.config").setup({
        -- Установить парсеры для нужных языков
        ensure_installed = {
            "lua", "vim", "vimdoc", -- Обязательные для Neovim
            "python", "javascript", "typescript", "html", "css",
            "json", "yaml", "toml", "markdown", "bash",
             "go", "sql", "dockerfile",
        },

        -- Синхронная установка парсеров (может замедлить запуск)
        sync_install = false,

        -- Автоматически обновлять парсеры при изменении `ensure_installed`
        auto_install = true, -- Очень удобная опция!

        -- Включить подсветку синтаксиса
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false, -- Отключить legacy-подсветку
        },

        -- Включить вкладку (отступы) на основе деревьев
        indent = {
            enable = true,
        },

        -- Включить автозакрытие тегов (для HTML/XML и подобных)
        autotag = {
            enable = true,
        },

        -- Дополнительные модули (опционально)
        incremental_selection = {
            enable = true,
            keymaps = {
            init_selection = "<C-space>", -- Начать выделение
            node_incremental = "<C-space>", -- Расширить выделение
            scope_incremental = "<C-s>", -- Выделить область
            node_decremental = "<C-bs>", -- Сузить выделение
            },
        },
        textobjects = { -- Работа с объектами (функции, классы и т.д.)
            enable = true,
            select = {
                enable = true,
                keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
                },
            },
        },
    })
    	-- Folding
			vim.opt.foldmethod = "expr"
			vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
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
    }
}