return {
  "linux-cultist/venv-selector.nvim",
  branch = "regexp",
  cmd = { "VenvSelect", "VenvSelectCached" },
  dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>pv", ":VenvSelect<CR>", desc = "Python: select venv" },
  },
  opts = {
    name = { "venv", ".venv", "env", ".env" },
  },
}

