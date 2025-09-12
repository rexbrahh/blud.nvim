return {
  "echasnovski/mini.nvim",
  config = function()
    require("mini.pairs").setup()
    require("mini.surround").setup()
  end,
}