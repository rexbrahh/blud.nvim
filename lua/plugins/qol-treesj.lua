return {
  "Wansmer/treesj",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  keys = {
    { "gS", function() require("treesj").toggle() end, desc = "Split/Join" },
  },
  opts = { use_default_keymaps = false },
}

