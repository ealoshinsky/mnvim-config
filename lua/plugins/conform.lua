return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  config = function()
    require("conform").setup({
      formatters_by_ft = { go = { "goimports", "gofumpt" }, lua = {"stylue"} },
      format_on_save = { timeout_ms = 500, lsp_fallback = true },
    })

    -- organize imports перед сохранением
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.go",
      callback = function()
        vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
      end,
    })
  end,
}
