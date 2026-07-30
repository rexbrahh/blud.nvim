return {
  "saghen/blink.cmp",
  enabled = true,
  event = { "CmdlineEnter", "InsertEnter" },
  dependencies = { "rafamadriz/friendly-snippets" },
  version = "1.*",
  config = function()
    local cmp = require("blink.cmp")

    cmp.setup({
      enabled = function()
        return vim.b.completion ~= false
          and vim.bo.filetype ~= "fzf"
          and vim.bo.filetype ~= "bigfile"
      end,

      sources = {
        default = { "lsp", "snippets", "path", "buffer" },
        providers = {
          path = {
            name = "PATH",
          },
          cmdline = {
            name = "CMD",
          },
          buffer = {
            name = "BUF",
          },
          lsp = {
            name = "LSP",
          },
          snippets = {
            name = "SNIP",
          },
        },
      },

      keymap = {
        ["<C-l>"] = { "snippet_forward", "fallback" },
        ["<C-h>"] = { "snippet_backward", "fallback" },
        ["<C-t>"] = {
          function(list)
            list.show()
          end,
        },
      },

      completion = {
        list = {
          max_items = 20,
          selection = {
            preselect = false,
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = {
            border = "single",
            max_height = 10,
            winhighlight = "Normal:BlinkCmpDoc,FloatBorder:FloatBorder,EndOfBuffer:BlinkCmpDoc",
          },
        },
        ghost_text = {
          enabled = false,
        },
        menu = {
          draw = {
            components = {
              label = {
                width = { max = 30 },
                text = function(ctx)
                  return ctx.label
                end,
                highlight = "@variable",
              },
              source_name = {
                width = { max = 30 },
                text = function(ctx)
                  return ctx.source_name
                end,
                highlight = "Special",
              },
            },
            columns = {
              { "kind_icon", "label", gap = 2, "source_name" },
            },
          },
          border = "single",
          winhighlight = "Normal:BlinkCmpDoc,FloatBorder:FloatBorder,CursorLine:BlinkCmpMenuSelection,Search:None,BlinkCmpKind:Special",
        },
      },

      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "normal",

        kind_icons = {
          Text = "󰦨",
          Method = "󰊕",
          Function = "󰊕",
          Constructor = "󰒓",
          Field = "󰜢",
          Variable = "󰆦",
          Property = "",
          Class = "󱡠",
          Interface = "󱡠",
          Struct = "󱡠",
          Module = "󰅩",
          Unit = "󰪚",
          Value = "",
          Enum = "",
          EnumMember = "",
          Keyword = "󰌋",
          Constant = "󰏿",
          Snippet = "󰅪",
          Color = "󰏘",
          File = "󰈔",
          Reference = "󰬲",
          Folder = "󰉋",
          Event = "󱐋",
          Operator = "󰪚",
          TypeParameter = "",
        },
      },
    })
  end,
  opts_extend = { "sources.default" },
}
