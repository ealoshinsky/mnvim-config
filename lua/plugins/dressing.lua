return {
  "stevearc/dressing.nvim",
  config = {
    input = {
      enabled = true,
      default_prompt = "➤ ",
      prompt_align = "left",
      border = "rounded",  -- "none", "single", "shadow", "rounded"
      relative = "cursor", -- Позиция окна ("cursor" или "editor")
      min_width = 30,
    },
    select = {
      enabled = true,
      backend = { "telescope", "builtin" }, -- Автоматически использует Telescope если он установлен
      builtin = {
        border = "rounded",
        highlight_options = {
          backgroundColor = "#1e222a",
        },
      },
    },
  }
}