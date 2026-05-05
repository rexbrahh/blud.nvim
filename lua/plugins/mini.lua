return {
  "echasnovski/mini.nvim",
  event = "InsertEnter",
  config = function()
    require("mini.pairs").setup()
  end,
}
