return {
  "linux-cultist/venv-selector.nvim",
  ft = "python",
  cmd = { "VenvSelect", "VenvSelectCached" },
  dependencies = { "ibhagwan/fzf-lua", "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>pv", ":VenvSelect<CR>", desc = "Python: select venv" },
  },
  opts = {
    name = { "venv", ".venv", "env", ".env" },
    options = { picker = "fzf-lua" },
  },
}
