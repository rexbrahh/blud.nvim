local function executable_or_warn(name)
  if vim.fn.executable(name) == 1 then
    return true
  end
  vim.notify_once(
    string.format("Debugger adapter '%s' is missing. Activate the Nix systems-tool profile.", name),
    vim.log.levels.ERROR
  )
  return false
end

return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      {
        "<F5>",
        function()
          require("dap").continue()
        end,
        desc = "DAP continue",
      },
      {
        "<F9>",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "DAP toggle breakpoint",
      },
      {
        "<F10>",
        function()
          require("dap").step_over()
        end,
        desc = "DAP step over",
      },
      {
        "<F11>",
        function()
          require("dap").step_into()
        end,
        desc = "DAP step into",
      },
      {
        "<F12>",
        function()
          require("dap").step_out()
        end,
        desc = "DAP step out",
      },
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
        desc = "DAP toggle UI",
      },
    },
    dependencies = { { "theHamsta/nvim-dap-virtual-text", opts = {} } },
    config = function()
      local dap = require("dap")

      dap.listeners.after.event_initialized["dapui_config"] = function()
        local ok, dapui = pcall(require, "dapui")
        if ok then
          dapui.open()
        end
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        local ok, dapui = pcall(require, "dapui")
        if ok then
          dapui.close()
        end
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        local ok, dapui = pcall(require, "dapui")
        if ok then
          dapui.close()
        end
      end

      dap.adapters.codelldb = function(callback)
        if not executable_or_warn("codelldb") then
          return
        end
        callback({
          type = "server",
          port = "${port}",
          executable = {
            command = "codelldb",
            args = { "--port", "${port}" },
          },
        })
      end
      dap.adapters.go = function(callback)
        if not executable_or_warn("dlv") then
          return
        end
        callback({
          type = "server",
          port = "${port}",
          executable = {
            command = "dlv",
            args = { "dap", "-l", "127.0.0.1:${port}" },
          },
        })
      end

      dap.configurations.go = {
        { type = "go", name = "Debug file", request = "launch", program = "${file}" },
      }

      local codelldb = {
        type = "codelldb",
        request = "launch",
        name = "Launch executable",
        program = function()
          return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
      }
      dap.configurations.c = { codelldb }
      dap.configurations.cpp = { codelldb }
      dap.configurations.rust = { codelldb }
      dap.configurations.zig = { codelldb }
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    lazy = true,
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    opts = {},
  },
}
