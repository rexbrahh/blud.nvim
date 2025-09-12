return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
  keys = {
    { "<leader>gV", ":DiffviewOpen<CR>", desc = "Diffview: open" },
    { "<leader>gW", ":DiffviewClose<CR>", desc = "Diffview: close" },
    { "<leader>gH", ":DiffviewFileHistory %<CR>", desc = "Diffview: file history" },
  },
}

