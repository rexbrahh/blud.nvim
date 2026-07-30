return {
  "folke/todo-comments.nvim",
  cmd = { "TodoFzfLua", "TodoQuickFix", "TodoLocList" },
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {},
  keys = {
    { "<leader>st", ":TodoFzfLua<CR>", desc = "Todos" },
  },
}
