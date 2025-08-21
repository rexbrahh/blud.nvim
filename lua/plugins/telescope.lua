return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        path_display = { "truncate" },
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
          theme = "dropdown",
          previewer = false,
        },
        oldfiles = {
          theme = "dropdown",
          previewer = false,
        },
        live_grep = {
          -- Enable preview for grep (default behavior, but explicit)
          previewer = true,
          theme = "ivy",
        },
        grep_string = {
          -- Enable preview for grep string search
          previewer = true,
          theme = "ivy",
        },
        buffers = {
          theme = "dropdown",
          previewer = false,
        },
      },
    })

    telescope.load_extension("fzf")

    -- Keymaps
    local keymap = vim.keymap
    keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
    keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
    keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
    keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
  end,
}