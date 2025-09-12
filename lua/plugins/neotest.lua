return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-neotest/neotest-jest",
    "nvim-neotest/neotest-go",
    "nvim-neotest/neotest-python",
    "rouge8/neotest-rust",
  },
  keys = {
    { "<leader>xx", function() require("neotest").summary.toggle() end, desc = "Tests: summary" },
    { "<leader>xr", function() require("neotest").run.run() end, desc = "Tests: run nearest" },
    { "<leader>xR", function() require("neotest").run.run(vim.fn.expand('%')) end, desc = "Tests: run file" },
    { "<leader>xo", function() require("neotest").output.open({ enter = true }) end, desc = "Tests: output" },
    { "<leader>xs", function() require("neotest").run.stop() end, desc = "Tests: stop" },
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-jest")({}),
        require("neotest-go")({}),
        require("neotest-python")({}),
        require("neotest-rust")({}),
      },
    })
  end,
}

