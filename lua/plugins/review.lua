-- lua/plugins/review.lua
return {
  -- Diff просмотр
  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("diffview").setup({
        enhanced_diff_hl = true,
      })

      -- Простые команды ревью
      vim.keymap.set("n", "<leader>gv", "<cmd>DiffviewOpen<CR>", { desc = "Open diff" })
      vim.keymap.set("n", "<leader>gV", "<cmd>DiffviewClose<CR>", { desc = "Close diff" })

      -- Ревью текущей ветки против main
      vim.keymap.set("n", "<leader>gr", function()
        local branch = vim.fn.system("git branch --show-current"):gsub("\n", "")
        vim.cmd("DiffviewOpen origin/main..." .. branch)
      end, { desc = "Review branch" })
    end,
  },

  -- Git аннотации
  {
    "rhysd/git-messenger.vim",
    config = function()
      vim.keymap.set("n", "<leader>gm", "<cmd>GitMessenger<CR>", { desc = "Git blame" })
    end,
  },
}
