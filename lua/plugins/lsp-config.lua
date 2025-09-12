return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "saghen/blink.cmp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "j-hui/fidget.nvim", opts = {} },
  },

  config = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("lsp", { clear = true }),

      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = event.buf, desc = desc })
        end

        map("K", function()
          vim.lsp.buf.hover({ border = "single" })
        end, "Hover LSP info")
        map("<leader>rn", vim.lsp.buf.rename, "Smart rename")

        -- Diagnostics
        map("<leader>d", function()
          vim.diagnostic.open_float({ border = "single" })
        end, "Show line diagnostics")

        map("[d", function()
          vim.diagnostic.jump({ float = { border = "single" }, count = -1 })
        end, "Go to previous diagnostic")

        map("]d", function()
          vim.diagnostic.jump({ float = { border = "single" }, count = -1 })
        end, "Go to next diagnostic")
      end,
    })

    vim.diagnostic.config({
      virtual_text = {
        enabled = true,
        prefix = function(diagnostic)
          if diagnostic.severity == vim.diagnostic.severity.ERROR then
            return "🭰× "
          elseif diagnostic.severity == vim.diagnostic.severity.WARN then
            return "🭰▲ "
          else
            return "🭰• "
          end
        end,
        suffix = "🭵",
      },
      underline = true,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ×",
          [vim.diagnostic.severity.WARN] = " ▲",
          [vim.diagnostic.severity.HINT] = " •",
          [vim.diagnostic.severity.INFO] = " •",
        },
      },
    })

    vim.filetype.add({
      extension = {
        env = "env",
      },
      filename = {
        [".env"] = "env",
      },
      pattern = {
        ["%.env%.[%w_.-]+"] = "env",
      },
    })

    local servers = {
      zls = {
        settings = {
          semantic_tokens = "none",
        },
      },
      gopls = {},
      nil_ls = {},
      bashls = {},

      -- python
      ruff = {},
      basedpyright = {
        settings = {
          pyright = {
            disableOrganizeImports = true,
          },
          python = {
            analysis = {
              ignore = { "*" },
            },
          },
        },
      },

      --filetype list is huge so I moved it
      tailwindcss = require("utils.tailwind").lsp,
      html = {
        filetypes = { "jinja", "htmldjango" },
      },

      biome = {},
      eslint = {},
      jsonls = (function()
        local cfg = { settings = { json = { validate = { enable = true } } } }
        if vim.g.use_schemastore ~= false then
          cfg.settings.json.schemas = require('schemastore').json.schemas()
        end
        return cfg
      end)(),
      cssls = {
        settings = {
          css = {
            validate = true,
            lint = {
              unknownAtRules = "ignore",
            },
          },
          scss = {
            validate = true,
            lint = {
              unknownAtRules = "ignore",
            },
          },
          less = {
            validate = true,
            lint = {
              unknownAtRules = "ignore",
            },
          },
        },
      },

      lua_ls = {
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace",
            },
            diagnostics = {
              globals = { "vim" },
              disable = { "missing-fields" },
            },
          },
        },
      },

      -- Additional Popular LSPs
      rust_analyzer = {
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
            },
            checkOnSave = {
              command = "clippy",
            },
          },
        },
      },
      clangd = {
        cmd = { "clangd", "--background-index", "--clang-tidy" },
      },
      yamlls = (function()
        local yaml = { keyOrdering = false, schemaStore = { enable = false, url = "" } }
        if vim.g.use_schemastore ~= false then
          yaml.schemas = require('schemastore').yaml.schemas()
        end
        return { settings = { yaml = yaml } }
      end)(),
      marksman = {}, -- Markdown
      dockerls = {}, -- Docker
      docker_compose_language_service = {}, -- Docker Compose
      -- pyright intentionally omitted to avoid duplicate with basedpyright

      -- Extra LSPs (safe, common languages)
      svelte = {},
      astro = {},
      graphql = {},
      prismals = {},
      taplo = {}, -- TOML
      lemminx = {}, -- XML
      terraformls = {},
      ansiblels = {},
      cmake = {},
    }

    -- Use Conform for formatting; disable LSP formatters
    local function disable_formatting(client, _)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end

    for server, config in pairs(servers) do
      local old_attach = config.on_attach
      config.on_attach = function(client, bufnr)
        disable_formatting(client, bufnr)
        if old_attach then old_attach(client, bufnr) end
      end
      require("lspconfig")[server].setup(config)
    end
  end,
}
