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
     {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
    },
}