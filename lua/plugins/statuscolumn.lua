return {
  "JuanBaut/statuscolumn.nvim",
  -- dir = "~/vault/dev/statuscolumn.nvim",
  enabled = false, -- Temporarily disabled due to nil value errors
  event = "VeryLazy",
  config = function()
    vim.defer_fn(function()
      require("statuscolumn").setup({
        enable_border = true,
        gradient_hl = "PreProc",
      })
    end, 100)
  end,
}
