return {
    {
        'nvim-telescope/telescope.nvim',
        version = '*',
        -- Кеймапы в config/keymaps.lua вызывают <cmd>Telescope ...<CR>, поэтому
        -- команда должна существовать до загрузки плагина. Без этого фрагмент
        -- с keys в plugins/markdown.lua делает telescope ленивым и :Telescope
        -- падает с E492 до первого обращения к плагину.
        cmd = 'Telescope',
        dependencies = {
            'nvim-lua/plenary.nvim',
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        },
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")

            telescope.setup({
                defaults = {
                    prompt_prefix = " ",
                    selection_caret = " ",
                    path_display = { "truncate" },
                    
                    mappings = {
                        i = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                            ["<Esc>"] = actions.close,
                        },
                    },
                    
                    file_ignore_patterns = {
                        "node_modules",
                        ".git/",
                        "dist/",
                        "build/",
                        "target/",
                    },
                },
                
                pickers = {
                    find_files = {
                        hidden = true,
                        theme = "dropdown",
                    },
                    live_grep = {
                        theme = "ivy",
                    },
                },
            })

            telescope.load_extension("fzf")
        end,
    }
}