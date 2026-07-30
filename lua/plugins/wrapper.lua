return {
  "andrewferrier/wrapping.nvim",
  ft = { "gitcommit", "markdown", "rst", "text" },
  config = function()
    require("wrapping").setup({
      set_nvim_opt_defaults = false,
    })
  end,
}
