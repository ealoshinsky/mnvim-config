-- lua/plugins/treesitter.lua
return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.config").setup({
                ensure_installed = {
                    "lua",
                    "go",
                    "typescript",
                    "javascript",
                    "json",
                    "yaml",
                    "markdown",
                    "html",
                    "css",
                    "dockerfile",
                    "bash",
                    "gitignore",
                    "proto",
                },
                highlight = { enable = true },
                indent = { enable = true },
                autotag = {
                    enable = true,
                    filetypes = {
                        "html",
                        "javascript",
                        "typescript",
                        "javascriptreact",
                        "typescriptreact",
                    },
                },
            })
        end,
    },
}
