return {
    "mfussenegger/nvim-dap",
    dependencies = {
        'rcarriga/nvim-dap-ui',            -- UI для отладчика
        'theHamsta/nvim-dap-virtual-text', -- Показ значений переменных
        'nvim-neotest/nvim-nio',           -- Зависимость для dap-ui
        'leoluz/nvim-dap-go',              -- Go адаптер
        'mxsdev/nvim-dap-vscode-js',       -- TypeScript/JavaScript адаптер
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")

        dap.adapters.go = {
            type = "server",
            port = "${port}",
            executable = {
                command = "dlv",
                args = { "dap", "--listen", "127.0.0.1:${port}", "--log", "--log-output=dap" },
            },
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
                        { id = "breakpoints", size = 0.25 },
                        { id = "scopes",      size = 0.75 },
                        --	{ id = "stacks", size = 0.25 },
                        --	{ id = "watches", size = 0.25 },
                    },
                    size = 50,
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

        dap.set_log_level("TRACE")
        -- Модифицированные listeners
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end

        -- При завершении показываем уведомление, но НЕ закрываем UI
        dap.listeners.after.event_terminated.dapui_config = function()
            vim.notify("Debug session terminated. Console output preserved.", vim.log.levels.WARN)
        end

        dap.listeners.after.event_exited.dapui_config = function(session, body)
            local exit_code = body and body.exitCode or "unknown"
            vim.notify("Program exited with code: " .. tostring(exit_code), vim.log.levels.WARN)
        end

        -- Иконки в gutter (как в GoLand)
        vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
        vim.fn.sign_define(
            "DapBreakpointCondition",
            { text = "◆", texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
        )
        vim.fn.sign_define("DapStopped", { text = "➜", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" })
    end,
}
