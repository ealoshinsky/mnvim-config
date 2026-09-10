return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {},
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    },
    config = function() 
        require("mason").setup({
            ui = {
                icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗"
                }
            }
            })

            require("mason-lspconfig").setup({
            ensure_installed = {
                "gopls",
                "vtsls",
                "vue_ls",
                "html",
                "cssls",
                "jsonls",
                "yamlls",
                "dockerls",
                "bashls",
                "lua_ls"
            },
            automatic_installation = true,
            -- ts_ls конфликтует с vtsls, а vue_ls (v3) работает только через vtsls
            automatic_enable = { exclude = { "ts_ls" } },
            })
    end
    },
}

