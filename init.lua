-- ============================================
-- БАЗОВАЯ КОНФИГУРАЦИЯ NEOVIM
-- ============================================

-- Загрузка основных настроек
require('config.opts')
require('config.autocmds')
require('config.keymaps')

-- ============================================
-- LAZY.NVIM - МЕНЕДЖЕР ПЛАГИНОВ
-- ============================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Настройка Lazy.nvim
require("lazy").setup({
    spec = {
        { import = "plugins" },
    },
    install = { colorscheme = { "onedark" } },
    checker = { enabled = true, notify = false },
    change_detection = {
        enabled = true,
        notify = false,
    },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})

-- ============================================
-- ПОЛЕЗНЫЕ КОМАНДЫ
-- ============================================

-- Команда для обновления плагинов
vim.api.nvim_create_user_command("PluginUpdate", function()
    require("lazy").sync()
end, { desc = "Update all plugins" })

-- Команда для очистки неиспользуемых плагинов
vim.api.nvim_create_user_command("PluginClean", function()
    require("lazy").clean()
end, { desc = "Clean unused plugins" })

-- Команда для проверки состояния плагинов
vim.api.nvim_create_user_command("PluginStatus", function()
    require("lazy").home()
end, { desc = "Show plugin status" })
