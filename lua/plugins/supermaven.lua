return {
  "supermaven-inc/supermaven-nvim",
  event = "InsertEnter",
  config = function()
    require("supermaven-nvim").setup({
      -- Keep inline AI suggestions, but keep keymaps off Blink/CMP bindings.
      keymaps = {
        accept_suggestion = "<C-y>",
        accept_word = "<M-y>",
        clear_suggestion = "<C-]>",
      },
      ignore_filetypes = { "neo-tree" },
      log_level = "off",
      disable_inline_completion = false,
    })
  end,
}
