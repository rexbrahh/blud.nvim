return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "DAP Continue" },
      { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "DAP Toggle Breakpoint" },
      { "<F10>", function() require("dap").step_over() end, desc = "DAP Step Over" },
      { "<F11>", function() require("dap").step_into() end, desc = "DAP Step Into" },
      { "<F12>", function() require("dap").step_out() end, desc = "DAP Step Out" },
      {
        "<leader>du",
        function()
          local dapui = require("dapui")
          if dapui.is_open() then
            dapui.close()
          else
            dapui.open()
          end
        end,
        desc = "DAP Toggle UI",
      },
    },
    dependencies = {
      { "theHamsta/nvim-dap-virtual-text", opts = {} },
    },
    config = function()
      local dap = require("dap")

      dap.listeners.after.event_initialized["dapui_config"] = function()
        local ok, dapui = pcall(require, "dapui")
        if ok then dapui.open() end
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        local ok, dapui = pcall(require, "dapui")
        if ok then dapui.close() end
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        local ok, dapui = pcall(require, "dapui")
        if ok then dapui.close() end
      end

      dap.configurations.javascript = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
      }
      dap.configurations.typescript = dap.configurations.javascript
      dap.configurations.javascriptreact = dap.configurations.javascript
      dap.configurations.typescriptreact = dap.configurations.javascript

      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch current file",
          program = "${file}",
          console = "integratedTerminal",
        },
      }

      dap.configurations.go = {
        {
          type = "go",
          name = "Debug",
          request = "launch",
          program = "${file}",
        },
      }

      local codelldb_config = {
        type = "codelldb",
        request = "launch",
        name = "Launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
      }
      dap.configurations.c = { codelldb_config }
      dap.configurations.cpp = { codelldb_config }
      dap.configurations.rust = { codelldb_config }
      dap.configurations.zig = { codelldb_config }
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    lazy = true,
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    opts = {},
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    cmd = { "DapInstall", "DapUninstall" },
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
    opts = {
      ensure_installed = { "codelldb", "delve", "python", "js" },
      handlers = {},
      automatic_installation = true,
    },
  },
}
