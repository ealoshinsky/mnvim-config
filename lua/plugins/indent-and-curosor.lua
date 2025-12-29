-- lua/plugins/indent-and-cursor.lua
return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = { char = "▏" },
      scope = { enabled = true },
    },
  },
  {
    "yamatsum/nvim-cursorline",
    config = true,
  },
}
