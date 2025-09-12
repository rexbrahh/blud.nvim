return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
    {
      "nvim-telescope/telescope-file-browser.nvim",
    },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        prompt_prefix = "   ",
        selection_caret = " ",
        entry_prefix = "  ",
        path_display = { "smart", filename_first = true },
        layout_strategy = "horizontal",
        layout_config = {
          width = 0.8,
          height = 0.65,
          prompt_position = "top",
          preview_width = 0.55,
        },
        sorting_strategy = "ascending",
        selection_strategy = "reset",
        scroll_strategy = "limit",
        file_ignore_patterns = {
          "node_modules",
          "__pycache__",
          ".git/",
          ".DS_Store",
        },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<C-p>"] = require("telescope.actions.layout").toggle_preview,
          },
          n = {
            ["<C-p>"] = require("telescope.actions.layout").toggle_preview,
          },
        },
      },
      pickers = {
        find_files = {
          previewer = true,
          layout_strategy = "horizontal",
          layout_config = { preview_width = 0.55 },
        },
        oldfiles = {
          previewer = true,
          layout_strategy = "horizontal",
          layout_config = { preview_width = 0.55 },
          sorting_strategy = "ascending",
          selection_strategy = "reset",
          scroll_strategy = "limit",
        },
        live_grep = {
          previewer = true,
          layout_strategy = "horizontal",
          layout_config = { preview_width = 0.55 },
        },
        grep_string = {
          previewer = true,
          layout_strategy = "horizontal",
          layout_config = { preview_width = 0.55 },
        },
        buffers = {
          previewer = true,
          layout_strategy = "horizontal",
          layout_config = { preview_width = 0.55 },
        },
      },
    })

    telescope.load_extension("fzf")
    pcall(telescope.load_extension, "file_browser")

    -- Keymaps
    local keymap = vim.keymap
    keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
    keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
    keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
    keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
    keymap.set("n", "<leader>fb", "<cmd>Telescope file_browser<cr>", { desc = "Browse files (tree-like)" })
  end,
}
