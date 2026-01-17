-- lua/core/options.lua
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.wrap = false
vim.opt.breakindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.inccommand = "split"
vim.opt.completeopt = "menuone,noselect"
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.lazyredraw = true
vim.opt.redrawtime = 1000
vim.loader.enable()

vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.copyindent = true

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.spell = true -- По умолчанию выключено
vim.opt.spelllang = { "ru", "en_us" }
vim.opt.spellsuggest = "best,9"
vim.opt.spelloptions = "camel"
vim.opt.spellcapcheck = "" -- Отключаем проверку заглавных букв

-- Создание директории для пользовательского словаря
local spell_dir = vim.fn.stdpath("config") .. "/spell"
if vim.fn.isdirectory(spell_dir) == 0 then
    vim.fn.mkdir(spell_dir, "p")
end
