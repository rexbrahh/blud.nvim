return {
  "kevinhwang91/nvim-ufo",
  keys = {
    {
      "zR",
      function()
        require("ufo").openAllFolds()
      end,
      desc = "Open all folds",
    },
    {
      "zM",
      function()
        require("ufo").closeAllFolds()
      end,
      desc = "Close all folds",
    },
    {
      "zr",
      function()
        require("ufo").openFoldsExceptKinds()
      end,
      desc = "Open folds",
    },
    {
      "zm",
      function()
        require("ufo").closeFoldsWith()
      end,
      desc = "Close folds",
    },
  },
  dependencies = { "kevinhwang91/promise-async" },
  opts = {
    -- nvim-ufo supports exactly two providers: { main, fallback }
    provider_selector = function(_, _, _)
      return { "lsp", "indent" }
    end,
  },
  config = function(_, opts)
    require("ufo").setup(opts)
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype == "bigfile" then
        require("ufo").detach(buf)
      end
    end
  end,
  init = function()
    -- Show fold column only when needed
    vim.o.foldcolumn = "auto:1"
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
  end,
}
