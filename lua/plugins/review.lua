return {
  "sindrets/diffview.nvim",
  "lewis6991/gitsigns.nvim", 
  "rhysd/git-messenger.vim",
  config = function()
    -- Настройка gitsigns
    require('gitsigns').setup({
      signs = {
        add          = { text = '│' },
        change       = { text = '│' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },
      signcolumn = true,
      numhl      = false,
      linehl     = false,
      word_diff  = false,
      watch_gitdir = {
        follow_files = true
      },
      auto_attach = true,
      attach_to_untracked = false,
      current_line_blame = false,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol',
        delay = 1000,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil,
      max_file_length = 40000,
      preview_config = {
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
      },
      yadm = {
        enable = false
      },
    })

    -- Настройка diffview
    require("diffview").setup({
      enhanced_diff_hl = true,
      view = {
        merge_tool = {
          layout = "diff3_mixed",
        },
      },
    })

    -- Клавиши для ревью
    vim.keymap.set("n", "<leader>gr", "<cmd>DiffviewOpen<CR>", { desc = "Review: Open diff view" })
    vim.keymap.set("n", "<leader>gc", "<cmd>DiffviewClose<CR>", { desc = "Review: Close diff view" })
    vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory<CR>", { desc = "Review: File history" })
    vim.keymap.set("n", "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<CR>", { desc = "Review: Toggle blame" })
    vim.keymap.set("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", { desc = "Review: Preview hunk" })
    vim.keymap.set("n", "<leader>gP", "<cmd>Gitsigns preview_hunk_inline<CR>", { desc = "Review: Preview hunk inline" })
    vim.keymap.set("n", "<leader>gn", "<cmd>Gitsigns next_hunk<CR>", { desc = "Review: Next hunk" })
    vim.keymap.set("n", "<leader>gN", "<cmd>Gitsigns prev_hunk<CR>", { desc = "Review: Previous hunk" })
    vim.keymap.set("n", "<leader>gs", "<cmd>Gitsigns stage_hunk<CR>", { desc = "Review: Stage hunk" })
    vim.keymap.set("n", "<leader>gS", "<cmd>Gitsigns stage_buffer<CR>", { desc = "Review: Stage buffer" })
    vim.keymap.set("n", "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<CR>", { desc = "Review: Undo stage hunk" })
    vim.keymap.set("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", { desc = "Review: Reset hunk" })
    vim.keymap.set("n", "<leader>gR", "<cmd>Gitsigns reset_buffer<CR>", { desc = "Review: Reset buffer" })
    vim.keymap.set("n", "<leader>gd", "<cmd>Gitsigns diffthis<CR>", { desc = "Review: Diff current file" })
    vim.keymap.set("n", "<leader>gm", "<cmd>GitMessenger<CR>", { desc = "Review: Git messenger" })
  end
}
