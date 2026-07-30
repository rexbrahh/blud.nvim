return {
  "windwp/nvim-ts-autotag",
  ft = {
    "astro",
    "html",
    "javascriptreact",
    "jinja",
    "svelte",
    "typescriptreact",
  },
  config = function()
    require("nvim-ts-autotag").setup({
      aliases = {
        ["jinja"] = "html",
      },
      opts = {
        enable_close = true, -- Auto close tags
        enable_rename = false, -- Auto rename pairs of tags
        enable_close_on_slash = true, -- Auto close on trailing </
      },
    })
  end,
}
