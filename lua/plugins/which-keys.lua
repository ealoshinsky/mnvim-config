return {
  "folke/which-key.nvim",
  config = function()
    local wk = require("which-key")
    
    wk.setup({
      plugins = {
        marks = true,
        registers = true,
        spelling = {
          enabled = true,
          suggestions = 20,
        },
        presets = {
          operators = true,
          motions = true,
          text_objects = true,
          windows = true,
          nav = true,
          z = true,
          g = true,
        },
      },
      window = {
        border = "rounded",
        position = "bottom",
        margin = { 1, 0, 1, 0 },
        padding = { 2, 2, 2, 2 },
      },
      ignore_missing = false,
      show_help = true,
      triggers = "auto",
    })

    -- Глобальные маппинги
    local mappings = {
      ["<leader>"] = {
        f = {
          name = "File/Telescope",
          f = "Find files",
          g = "Live grep",
        },
        g = {
          name = "Git/Review",
          r = "Open diff view",
          c = "Close diff view", 
          h = "File history",
          b = "Toggle blame",
          p = "Preview hunk",
          P = "Preview hunk inline",
          n = "Next hunk",
          N = "Previous hunk",
          s = "Stage hunk",
          S = "Stage buffer",
          u = "Undo stage hunk",
          r = "Reset hunk",
          R = "Reset buffer",
          d = "Diff current file",
          m = "Git messenger",
          -- Go-specific (сохраняем существующие)
          t = "Run tests",
          v = "Run go vet", 
          a = "Switch test/implementation",
          d = "Debug current package",
          l = "Debug last test/package",
          t = "Debug nearest test",
        },
        e = "Toggle file tree",
        s = "Save file",
        b = "Toggle breakpoint",
        B = "Conditional breakpoint",
        r = "Open all folds",
        m = "Close all folds", 
        z = "Toggle fold",
        Z = "Toggle fold recursively",
        rn = "Rename symbol",
        ca = "Code action",
        dl = "Show diagnostics list",
        ds = "Document symbols", 
        ws = "Workspace symbols",
        f = "Format buffer",
        xx = "Toggle trouble diagnostics",
      },
      g = {
        d = "Go to definition",
        D = "Go to declaration", 
        r = "Find references",
        i = "Go to implementation",
      },
      K = "Hover documentation",
      ["<C-k>"] = "Signature help",
      ["<C-n>"] = "Next buffer",
      ["<C-p>"] = "Previous buffer", 
      ["<C-d>"] = "Delete buffer",
      ["<C-l>"] = "List buffers",
      ["["] = {
        d = "Previous diagnostic",
      },
      ["]"] = {
        d = "Next diagnostic", 
      },
    }

    -- Debug mappings
    local debug_mappings = {
      ["<F5>"] = "Continue/Start debugging",
      ["<F7>"] = "Step Into", 
      ["<F8>"] = "Step Over",
      ["<F9>"] = "Step Out",
      ["<S-F5>"] = "Stop debugging",
    }

    -- Регистрируем маппинги
    wk.register(mappings)
    
    -- Отдельно регистрируем debug маппинги с описанием
    for key, desc in pairs(debug_mappings) do
      vim.keymap.set("n", key, function() end, { desc = desc })
    end

    -- Автоматическое отображение подсказок при нажатии префикса
    vim.keymap.set("n", "<leader>", "<cmd>WhichKey<CR>", { desc = "Show which-key" })
    
    -- Показывать все хоткеи по F1
    vim.keymap.set("n", "<F1>", function()
      local buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
        "=== NVIM KEYBINDINGS CHEATSHEET ===",
        "",
        "🎯 LEADER KEY MAPPINGS (<space>):",
        "-----------------------------------",
        "File Operations: <leader>s (save), <leader>e (file tree)",
        "Code Navigation: gd (def), gr (ref), gi (impl), K (hover)",
        "Testing: <leader>gt (test), <leader>gv (vet), <leader>ga (switch test/code)",
        "",
        "🔍 CODE REVIEW (Git):",
        "---------------------",
        "<leader>gr - Open diff view",
        "<leader>gc - Close diff view", 
        "<leader>gh - File history",
        "<leader>gb - Toggle line blame",
        "<leader>gp - Preview hunk",
        "<leader>gP - Preview hunk inline",
        "<leader>gn - Next hunk",
        "<leader>gN - Previous hunk", 
        "<leader>gs - Stage hunk",
        "<leader>gS - Stage buffer",
        "<leader>gu - Undo stage hunk",
        "<leader>gr - Reset hunk",
        "<leader>gR - Reset buffer",
        "<leader>gd - Diff current file",
        "<leader>gm - Git messenger (blame popup)",
        "",
        "🐛 DEBUGGING (Go):",
        "-----------------",
        "F5        - Start/Continue debugging",
        "F7        - Step Into", 
        "F8        - Step Over",
        "F9        - Step Out",
        "Shift+F5  - Stop debugging",
        "<leader>b - Toggle breakpoint",
        "<leader>B - Conditional breakpoint",
        "<leader>dd - Debug current package", 
        "<leader>dt - Debug nearest test",
        "<leader>dl - Debug last test",
        "",
        "📁 BUFFERS & NAVIGATION:",
        "------------------------",
        "Ctrl+n    - Next buffer",
        "Ctrl+p    - Previous buffer", 
        "Ctrl+d    - Delete buffer",
        "Ctrl+l    - List buffers",
        "gd        - Go to definition",
        "gr        - Find references",
        "gi        - Go to implementation",
        "K         - Hover documentation",
        "",
        "💡 TROUBLE & DIAGNOSTICS:",
        "-------------------------",
        "<leader>xx - Toggle trouble window",
        "[d        - Previous diagnostic", 
        "]d        - Next diagnostic",
        "<leader>dl - Show diagnostics list",
        "",
        "Press q to close this window",
      })
      
      -- Настраиваем окно
      local width = 85
      local height = 35
      local row = math.floor((vim.o.lines - height) / 2)
      local col = math.floor((vim.o.columns - width) / 2)
      
      local opts = {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
      }
      
      local win = vim.api.nvim_open_win(buf, true, opts)
      
      -- Настраиваем буфер
      vim.api.nvim_buf_set_name(buf, "NVIM_CHEATSHEET")
      vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
      vim.api.nvim_buf_set_option(buf, "modifiable", false)
      vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
      
      -- Клавиша для закрытия
      vim.api.nvim_buf_set_keymap(buf, "n", "q", ":q<CR>", { noremap = true, silent = true })
      vim.api.nvim_buf_set_keymap(buf, "n", "<ESC>", ":q<CR>", { noremap = true, silent = true })
      
      -- Подсветка
      vim.api.nvim_win_set_option(win, "winhl", "Normal:Normal,FloatBorder:Normal")
    end, { desc = "Show all keybindings" })
  end
}
