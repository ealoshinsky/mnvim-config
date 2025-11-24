return {
  {
    "akinsho/flutter-tools.nvim",
    ft = "dart",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("flutter-tools").setup({
        lsp = {
          -- Используем настройки из lspconfig
          color = {
            enabled = true,
            background = true,
          },
          settings = {
            showTodos = true,
            completeFunctionCalls = true,
            renameFilesWithClasses = "prompt",
            enableSnippets = true,
          }
        },
        widget_guides = {
          enabled = true,
        },
        closing_tags = {
          highlight = "ErrorMsg",
          prefix = "// ",
          enabled = true
        },
        dev_log = {
          enabled = true,
          open_cmd = "tabnew",
        },
      })
    end
  },
  {
    "dart-lang/dart-vim-plugin",
    ft = "dart"
  }
}
