return {
  "stevearc/overseer.nvim",
  cmd = {
    "OverseerOpen",
    "OverseerClose",
    "OverseerToggle",
    "OverseerRun",
    "OverseerShell",
    "OverseerTaskAction",
  },
  keys = {
    { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Tasks: run" },
    { "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Tasks: toggle" },
    { "<leader>oa", "<cmd>OverseerTaskAction<cr>", desc = "Tasks: action" },
    { "<leader>os", "<cmd>OverseerShell<cr>", desc = "Tasks: shell command" },
  },
  opts = {
    dap = true,
    task_list = {
      direction = "bottom",
      max_height = { 20, 0.3 },
      min_height = 8,
    },
    component_aliases = {
      default = {
        "on_exit_set_status",
        {
          "on_output_quickfix",
          open_on_exit = "failure",
          set_diagnostics = true,
        },
        "on_result_diagnostics",
        "on_complete_notify",
        {
          "on_complete_dispose",
          require_view = { "FAILURE" },
          timeout = 300,
        },
      },
    },
  },
  config = function(_, opts)
    require("overseer").setup(opts)
    require("config.overseer_systems").register()
  end,
}
