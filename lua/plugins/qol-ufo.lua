return {
  "kevinhwang91/nvim-ufo",
  event = "BufReadPost",
  dependencies = { "kevinhwang91/promise-async" },
  opts = {
    -- nvim-ufo supports exactly two providers: { main, fallback }
    provider_selector = function(_, _, _)
      return { "lsp", "indent" }
    end,
  },
  init = function()
    -- Show fold column only when needed
    vim.o.foldcolumn = "auto:1"
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
  end,
}
