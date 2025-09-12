return {
  "danymat/neogen",
  dependencies = "nvim-treesitter/nvim-treesitter",
  cmd = "Neogen",
  keys = {
    { "<leader>ld", function() require("neogen").generate() end, desc = "Generate docstring" },
  },
  opts = { snippet_engine = "luasnip" },
}

