return {
  "echasnovski/mini.bufremove",
  version = "*",
  keys = {
    {
      "<leader>bd",
      function() require("mini.bufremove").delete(0, false) end,
      desc = "Delete buffer",
    },
    {
      "<leader>bw",
      function() require("mini.bufremove").wipeout(0, false) end,
      desc = "Wipeout buffer",
    },
  },
  opts = {},
}

