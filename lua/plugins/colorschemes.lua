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

  -- Additional themes (loaded at startup to allow live preview switching)
  { "folke/tokyonight.nvim", lazy = false, priority = 999 },
  { "catppuccin/nvim", name = "catppuccin", lazy = false, priority = 999 },
  { "rose-pine/neovim", name = "rose-pine", lazy = false, priority = 999 },
  { "ellisonleao/gruvbox.nvim", lazy = false, priority = 999 },
  { "rebelot/kanagawa.nvim", lazy = false, priority = 999 },
}
