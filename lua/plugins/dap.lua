return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "leoluz/nvim-dap-go",             
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    "nvim-neotest/nvim-nio",
  },
  keys = {
    -- <F5>     → Continue / Start debugging
    { "<F5>",     function() require("dap").continue() end,                          desc = "Continue / Start" },

    -- <F7>     → Step Into
    { "<F7>",     function() require("dap").step_into() end,                         desc = "Step Into" },

    -- <F8>     → Step Over
    { "<F8>",     function() require("dap").step_over() end,                         desc = "Step Over" },

    -- <F9>     → Step Out
    { "<F9>",     function() require("dap").step_out() end,                          desc = "Step Out" },

    -- Shift+F5 → Stop debugging
    { "<S-F5>",   function() require("dap").terminate() end,                         desc = "Stop" },

    -- leader+b → Toggle breakpoint
    { "<leader>b", function() require("dap").toggle_breakpoint() end,                 desc = "Toggle Breakpoint" },

    -- lader+B → Set conditional breakpoint
    { "<leader>B", function()
      require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, desc = "Conditional Breakpoint" },

    -- <F9> уже занят Step Out, но в GoLand F9 = Resume → у нас это F5 (как в новых версиях)

    -- Debug текущего файла / пакета (как "Debug" в GoLand)
    { "<leader>dd", function() require("dap-go").debug() end,                        desc = "Debug current package" },

    -- Debug последний запуск (как "Rerun" в GoLand)
    { "<leader>dl", function() require("dap-go").debug_last() end,                    desc = "Debug last test/package" },

    -- Debug ближайший тест (очень удобно!)
    { "<leader>dt", function() require("dap-go").debug_test() end,                    desc = "Debug nearest test" },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

     dap.adapters.go = {
      type = "server",
      port = "${port}",
      executable = {
        command = "dlv",
        args = { "dap", "--listen", "127.0.0.1:${port}" },
      }
    }

    
    dap.configurations.go = {
      {
        type = "go",
        name = "Debug",
        request = "launch",
        program = "${file}",
      },
      {
        type = "go",
        name = "Debug with Args",
        request = "launch",
        program = "${file}",
        args = function()
          local args_string = vim.fn.input("Arguments: ")
          return vim.split(args_string, " +")
        end,
      },
      {
        type = "go",
        name = "Debug Test",
        request = "launch",
        mode = "test",
        program = "${file}",
      },
      {
        type = "go",
        name = "Debug Package",
        request = "launch",
        program = "${fileDirname}",
      },
    }

    dapui.setup({
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.25 },
            { id = "breakpoints", size = 0.25 },
            { id = "stacks", size = 0.25 },
            { id = "watches", size = 0.25 },
          },
          size = 40,
          position = "left",
        },
        {
          elements = { "repl", "console" },
          size = 10,
          position = "bottom",
        },
      },
    })

    require("nvim-dap-virtual-text").setup({
      virt_text_pos = "eol",
    })

     dap.set_log_level("DEBUG")
    -- Автоматически открывать/закрывать красивое UI
    dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
    dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
    dap.listeners.before.event_exited["dapui_config"]    = function() dapui.close() end

    -- Иконки в gutter (как в GoLand)
    vim.fn.sign_define("DapBreakpoint",          { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointCondition",{ text = "◆", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped",             { text = "➜", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" })

  end,
}
