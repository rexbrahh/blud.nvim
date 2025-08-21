return {
  "nvim-tree/nvim-web-devicons",
  enabled = true, -- Fallback icon pack
  config = function()
    require("nvim-web-devicons").setup({
      -- Enable strict mode to show all available icons
      strict = true,
      -- Override icons
      override = {
        zsh = {
          icon = "",
          color = "#428850",
          cterm_color = "65",
          name = "Zsh"
        },
        bash = {
          icon = "",
          color = "#89e051",
          cterm_color = "113",
          name = "Bash"
        },
        env = {
          icon = "󰛸",
          color = "#faf743",
          cterm_color = "227",
          name = "Env"
        },
      },
      -- Enable color highlighting
      color_icons = true,
      -- Default icon for unknown files
      default = true,
    })
  end,
}