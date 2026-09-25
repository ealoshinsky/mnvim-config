-- Локальные хелперы для пикеров по markdown-файлам.
local function md_find(cwd, title)
    local opts = { prompt_title = title, cwd = cwd }

    if vim.fn.executable("rg") == 1 then
        opts.find_command = { "rg", "--files", "--hidden", "--glob", "!.git", "--glob", "*.md" }
    else
        opts.search_file = ".md"
    end

    require("telescope.builtin").find_files(opts)
end

return {
    -- Рендер markdown прямо в буфере: заголовки, таблицы, чекбоксы, код-блоки.
    -- Привязан к буферу, а не к внешнему окну, поэтому при переключении
    -- файлов ничего не перезапускается и не теряет позицию.
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        ft = { "markdown" },
        opts = {
            -- Сырая разметка показывается только на строке с курсором,
            -- остальной текст остаётся отрендеренным.
            anti_conceal = { enabled = true },
            heading = {
                sign = false,
                width = "block",
                min_width = 40,
                right_pad = 2,
            },
            code = {
                sign = false,
                width = "block",
                min_width = 40,
                right_pad = 2,
                language_pad = 2,
            },
            checkbox = {
                unchecked = { icon = "󰄱 " },
                checked = { icon = "󰱒 " },
            },
            -- Подсказки по ссылкам из marksman в nvim-cmp.
            completions = { lsp = { enabled = true } },
        },
    },

    -- Превью в браузере. combine_preview держит ОДНУ вкладку на все файлы:
    -- при переключении буфера она просто перерисовывается, а не открывается заново.
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = "cd app && npm install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
            vim.g.mkdp_combine_preview = 1
            vim.g.mkdp_combine_preview_auto_refresh = 1
            -- Не закрывать вкладку при уходе из markdown-буфера.
            vim.g.mkdp_auto_close = 0
        end,
        keys = {
            {
                "<leader>mp",
                "<cmd>MarkdownPreviewToggle<CR>",
                desc = "Markdown: превью в браузере",
            },
        },
    },

    -- Пикеры и переходы между md-файлами.
    {
        "nvim-telescope/telescope.nvim",
        optional = true,
        keys = {
            {
                "<leader>mf",
                function()
                    md_find(vim.fn.expand("%:p:h"), "Markdown в этой папке")
                end,
                desc = "Markdown: файлы рядом с текущим",
            },
            {
                "<leader>mF",
                function()
                    md_find(nil, "Markdown в проекте")
                end,
                desc = "Markdown: файлы по всему проекту",
            },
            {
                "<leader>mg",
                function()
                    require("telescope.builtin").live_grep({
                        prompt_title = "Поиск по markdown",
                        type_filter = "md",
                    })
                end,
                desc = "Markdown: поиск по тексту",
            },
            {
                "<leader>ms",
                "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>",
                desc = "Markdown: заголовки по всем файлам (marksman)",
            },
        },
    },
}
