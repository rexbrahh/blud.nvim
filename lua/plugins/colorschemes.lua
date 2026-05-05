return {
  -- Default: Atom One Dark (via onedarkpro)
  {
    "olimorris/onedarkpro.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("onedarkpro").setup({
        options = { cursorline = true },
      })
      vim.cmd.colorscheme("onedark")
    end,
  },

  -- Additional themes are lazy-loaded by :colorscheme when previewing or switching.
  { "folke/tokyonight.nvim", lazy = true },
  { "catppuccin/nvim", name = "catppuccin", lazy = true },
  { "rose-pine/neovim", name = "rose-pine", lazy = true },
  { "ellisonleao/gruvbox.nvim", lazy = true },
  { "rebelot/kanagawa.nvim", lazy = true },
}
