-- plugins/go-extras.lua
return {
  {
    "fatih/vim-go",
    ft = "go",
    config = function()
      -- Отключаем LSP из vim-go, т.к. используем lspconfig
      vim.g.go_doc_keywordprg_enabled = 0
      vim.g.go_def_mapping_enabled = 0
      vim.g.go_code_completion_enabled = 0
    end
  },
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    config = function()
      require("gopher").setup()
    end,
    build = function()
      vim.cmd [[silent! GoInstallDeps]]
    end,
  }
}
