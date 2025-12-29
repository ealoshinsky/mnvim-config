-- lua/plugins/indent-and-cursor.lua
return {
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			indent = { char = "▏" },
			scope = { enabled = true },
		},
	},
	{
		"yamatsum/nvim-cursorline",
		event = { "BufReadPost", "BufNewFile" },
		config = true,
	},
}
