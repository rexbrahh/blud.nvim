return {
  "dmtrKovalenko/fff.nvim",
  build = function()
    -- Downloads a prebuilt binary or builds with rustup if needed.
    require("fff.download").download_or_build_binary()
  end,
  lazy = false, -- plugin self-lazy-loads internally; keep available immediately for keymaps
  keys = {
    { "<leader>ff", function() require("fff").find_files() end, desc = "Find files (fff default)" },
    { "<leader>fF", function() require("fff").find_in_git_root() end, desc = "Find in git root (fff)" },
    { "<leader>fS", function() require("fff").scan_files() end, desc = "Rescan fff index" },
  },
  opts = {
    lazy_sync = true, -- let indexing start when picker opens
    layout = { width = 0.8, height = 0.8, prompt_position = "top", preview_position = "right", preview_size = 0.55 },
    preview = { line_numbers = false, wrap_lines = false },
    logging = { enabled = true },
  },
}
