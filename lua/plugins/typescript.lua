-- plugins/typescript.lua
return {
  {
    "dmmulroy/tsc.nvim",
    ft = { "typescript", "typescriptreact" },
    config = function()
      require("tsc").setup({
        auto_open_qflist = false,
        use_trouble_qflist = true,
      })
      
      -- Клавиши для TypeScript Compiler
      vim.keymap.set("n", "<leader>tc", "<cmd>TSC<CR>", { desc = "TypeScript: Compile project" })
      vim.keymap.set("n", "<leader>tw", "<cmd>TSCWatch<CR>", { desc = "TypeScript: Watch mode" })
    end
  },
  {
    "axelvc/template-string.nvim",
    ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
    config = function()
      require("template-string").setup({
        remove_template_string = true,
        restore_quotes = {
          normal = [[']],
          jsx = [["]],
        },
      })
    end
  },
  {
    "b0o/schemastore.nvim", -- JSON schemas для TypeScript конфигураций
    ft = "json"
  }
}
