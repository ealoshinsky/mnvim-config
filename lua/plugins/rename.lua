return {
	"smjonas/inc-rename.nvim",
	cmd = "IncRename",
	config = true,
	keys = {
		{
			"<leader>rn",
			function()
				return ":IncRename " .. vim.fn.expand("<cword>")
			end,
			expr = true,
			desc = "Incremental rename",
		},
	},
}
