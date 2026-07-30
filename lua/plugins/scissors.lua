return {
  "chrisgrieser/nvim-scissors",
  cmd = { "ScissorsAddNewSnippet", "ScissorsEditSnippet" },
  opts = {
    snippetDir = "$HOME/.config/nvim/snippets/",
    snippetSelection = { picker = "vim.ui.select" },
    editSnippetPopup = {
      height = 0.4,
      width = 0.5,
      border = "single",
    },
  },
}
