vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Базовые опции
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.termguicolors = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 300
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false

-- Buffers  
vim.keymap.set('n', '<C-n>', ':bnext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<C-p>', ':bprevious<CR>', { desc = 'Previous buffer' })
vim.keymap.set('n', '<C-d>', ':bdelete<CR>', { desc = 'Delete buffer' })
vim.keymap.set('n', '<C-l>', ':buffers<CR>', { desc = 'List buffers' })

-- Code folding
vim.opt.foldmethod = "expr" -- Использовать treesitter для фолдинга
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99
vim.keymap.set("n", "<leader>z", "za", { silent = true, desc = "Toggle fold" })
vim.keymap.set("n", "<leader>Z", "zA", { silent = true, desc = "Toggle fold recursively" })
vim.keymap.set("n", "<leader>r", "zR", { silent = true, desc = "Open all folds" })
vim.keymap.set("n", "<leader>m", "zM", { silent = true, desc = "Close all folds" })

-- save buffer
vim.keymap.set("n", "<leader>s", ":w<CR>", { noremap = true, silent = true, desc = "Save me" })

-- Trouble
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { noremap = true, desc = "Troble diagnostics" })

-- Cheatsheet
vim.keymap.set("n", "<F1>", function() 
  -- Эта функция теперь в which-keys.lua
end, { desc = "Show keybindings cheatsheet" })
