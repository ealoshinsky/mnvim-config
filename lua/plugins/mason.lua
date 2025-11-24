return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",  -- автоматически ставит LSP
    "jay-babu/mason-nvim-dap.nvim",       -- автоматически ставит DAP (delve и др.)
  },
  config = function()
    require("mason").setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    -- Автоматически ставит gopls
    require("mason-lspconfig").setup({
      ensure_installed = { "gopls" },
      automatic_installation = true,
    })

    -- Автоматически ставит delve для отладки
    require("mason-nvim-dap").setup({
      ensure_installed = { "delve" },
      automatic_installation = true,
    })
  end,
}
