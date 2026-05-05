return {
  "dmtrKovalenko/fff.nvim",
  lazy = true,
  build = function()
    -- Downloads a prebuilt binary or builds with rustup if needed.
    require("fff.download").download_or_build_binary()
  end,
  cmd = {
    "FFFFind",
    "FFFScan",
    "FFFRefreshGit",
    "FFFClearCache",
    "FFFHealth",
    "FFFDebug",
    "FFFOpenLog",
  },
  keys = {
    { "<leader>sf", function() require("fff").find_files() end, desc = "Search files" },
    {
      "<leader>sF",
      function()
        local root = vim.fs.root(0, ".git") or vim.uv.cwd()
        require("fff").find_files_in_dir(root)
      end,
      desc = "Search project files",
    },
    { "<leader>sg", function() require("fff").live_grep() end, desc = "Search text" },
    {
      "<leader>sG",
      function()
        require("fff").live_grep({ grep = { modes = { "fuzzy", "plain" } } })
      end,
      desc = "Search text fuzzy",
    },
    {
      "<leader>sc",
      function()
        require("fff").live_grep({ query = vim.fn.expand("<cword>") })
      end,
      desc = "Search word",
    },
    {
      "<leader>sv",
      function()
        local lines = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = vim.fn.mode() })
        require("fff").live_grep({ query = table.concat(lines, " ") })
      end,
      desc = "Search selection",
      mode = "x",
    },
    { "<leader>sS", function() require("fff").scan_files() end, desc = "Rescan search index" },
    { "<leader>sH", "<cmd>FFFHealth<cr>", desc = "Search health" },
  },
  opts = {
    lazy_sync = true, -- let indexing start when picker opens
    layout = {
      width = 0.8,
      height = 0.8,
      prompt_position = "top",
      preview_position = "right",
      preview_size = 0.55,
      path_shorten_strategy = "middle",
    },
    preview = { line_numbers = false, wrap_lines = false },
    frecency = { enabled = true },
    history = { enabled = true },
    grep = {
      max_file_size = 10 * 1024 * 1024,
      max_matches_per_file = 100,
      smart_case = true,
      time_budget_ms = 150,
      modes = { "plain", "regex", "fuzzy" },
    },
    logging = { enabled = false },
  },
}
