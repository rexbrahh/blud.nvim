return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },

  config = function()
    local keymap = vim.keymap
    keymap.set(
      "n",
      "<leader>fe",
      "<cmd>Neotree toggle focus left reveal_force_cwd<cr>",
      { desc = "File Explorer (left)" }
    )

    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    require("neo-tree").setup({
      retain_hidden_root_indent = false,
      hide_root_node = true,
      window = {
        position = "left",
      },

      default_component_configs = {
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "󰜌",
          default = "󰈔",
        },
        indent = {
          indent_size = 2,
          marker_start_level = 1,
          -- with_expanders = true,
          -- expander_collapsed = "►",
          -- expander_expanded = "▼",
        },
        modified = {
          symbol = "*",
        },
        diagnostics = {
          symbols = {
            error = "×",
            warn = "▲",
            hint = "•",
            info = "•",
          },
          highlights = {
            hint = "DiagnosticHint",
            info = "DiagnosticInfo",
            warn = "DiagnosticWarn",
            error = "DiagnosticError",
          },
        },
        git_status = {
          symbols = {
            -- Change type
            added = "+",
            deleted = "-",
            modified = "",
            renamed = ">",
            -- Status type
            untracked = "?",
            unstaged = "~",
            ignored = "/",
            staged = "•",
            conflict = "!",
          },
        },
      },

      popup_border_style = "single",
      event_handlers = { -- Close neo-tree when opening a file.
        {
          event = "file_opened",
          handler = function()
            require("neo-tree").close_all()
          end,
        },
      },

      filesystem = {
        filtered_items = {
          visible = true, -- show everything, do not hide entries
          show_hidden_count = false,
          group_empty_dirs = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          always_show = {
            ".env.local",
            ".envrc",
            ".env",
          },
          never_show = {},
        },
        bind_to_cwd = true, -- true creates a 2-way binding between vim's cwd and neo-tree's root
        use_libuv_file_watcher = true,
        window = {
          mappings = {
            ["<C-v>"] = "open_vsplit",
            ["n"] = "toggle_node",
            ["<space>"] = "none",
          },
        },
      },

      renderers = {
        directory = { --> this is for directories
          { "indent" },
          { "icon" }, --> left icon that you want to disable
          { "current_filter" },
          {
            "container",
            content = {
              { "name",      zindex = 10 },
              { "clipboard", zindex = 10 },
              {
                "diagnostics",
                errors_only = true,
                zindex = 20,
                align = "right",
                hide_when_expanded = true,
              },                                                                         --> right icon that you want to config
              { "git_status", zindex = 20, align = "right", hide_when_expanded = true }, --> right icon that you want to config
            },
          },
        },
        file = {  --> this is for files
          { "indent" },
          { "icon" }, --> enable file icons
          {
            "container",
            content = {
              { "name",        zindex = 10 },
              { "clipboard",   zindex = 10 },
              { "bufnr",       zindex = 10 },
              { "modified",    zindex = 20, align = "right" },
              { "diagnostics", zindex = 20, align = "right" }, --> right icon that you want to config
              { "git_status",  zindex = 20, align = "right" }, --> right icon that you want to config
            },
          },
        },
      },
    })

    -- only while debuggin
    -- vim.keymap.set("n", "0", "<cmd>Lazy reload neo-tree.nvim<CR>", { desc = "Reload neo-tree" })
  end,
}
