require("options")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

-- Убедимся, что lazy загружен правильно
local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
	vim.notify("Failed to load lazy.nvim", vim.log.levels.ERROR)
	return
end

lazy.setup("plugins", {
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"tarPlugin",
				"tohtml",
				"zipPlugin",
			},
		},
	},
})
