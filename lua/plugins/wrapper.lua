return {
  "andrewferrier/wrapping.nvim",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("wrapping").setup({
      set_nvim_opt_defaults = false,
    })
  end,
}
