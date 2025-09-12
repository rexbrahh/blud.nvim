return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  opts = {},
  keys = {
    { "<leader>qs", function() require("persistence").load() end, desc = "Session: restore" },
    { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Session: last" },
    { "<leader>qd", function() require("persistence").stop() end, desc = "Session: stop" },
  },
}

