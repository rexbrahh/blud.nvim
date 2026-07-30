return {
  "brenoprata10/nvim-highlight-colors",
  ft = {
    "css",
    "html",
    "javascript",
    "javascriptreact",
    "json",
    "lua",
    "svelte",
    "typescript",
    "typescriptreact",
  },
  config = function()
    require("nvim-highlight-colors").setup({
      render = "virtual",
      virtual_symbol = " ",
      virtual_symbol_suffix = "",
      virtual_symbol_position = "eol",
    })
  end,
}
