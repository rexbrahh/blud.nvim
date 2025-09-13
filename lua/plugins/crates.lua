return {
  "Saecki/crates.nvim",
  event = { "BufRead Cargo.toml" },
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("crates").setup({
      completion = { cmp = false },
    })
  end,
}

