local function disable_formatting(client)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false
  if client.name == "zls" then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false
capabilities.workspace.didChangeWatchedFiles.relativePatternSupport = false
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = { "documentation", "detail", "additionalTextEdits", "command", "data" },
}

local function jsonls_config()
  local settings = { json = { validate = { enable = true } } }
  if vim.g.use_schemastore ~= false then
    settings.json.schemas = require("schemastore").json.schemas()
  end
  return { settings = settings }
end

local function yamlls_config()
  local yaml = { keyOrdering = false, schemaStore = { enable = false, url = "" } }
  if vim.g.use_schemastore ~= false then
    yaml.schemas = require("schemastore").yaml.schemas()
  end
  return { settings = { yaml = yaml } }
end

local servers = {
  clangd = {
    filetypes = { "c", "cpp", "cuda", "objc", "objcpp", "proto" },
    config = {
      cmd = { "clangd", "--background-index" },
      before_init = function(params)
        -- nvim-lspconfig still advertises this old clangd extension. clangd
        -- 21 uses the standard LSP positionEncodings capability instead.
        params.capabilities.offsetEncoding = nil
      end,
    },
  },
  rust_analyzer = {
    filetypes = { "rust" },
    config = {},
  },
  zls = {
    filetypes = { "zig", "zir" },
    config = {
      root_dir = function(bufnr, on_dir)
        local filename = vim.api.nvim_buf_get_name(bufnr)
        on_dir(
          vim.fs.root(filename, { "zls.json", "build.zig", ".git" }) or vim.fs.dirname(filename)
        )
      end,
      settings = { zls = { semantic_tokens = "none" } },
    },
  },
  gopls = {
    filetypes = { "go", "gomod", "gowork" },
    config = {},
  },
  neocmake = {
    filetypes = { "cmake" },
    config = {},
  },
  nixd = {
    filetypes = { "nix" },
    config = {},
  },
  bashls = {
    filetypes = { "bash", "sh", "zsh" },
    config = {},
  },
  lua_ls = {
    filetypes = { "lua" },
    config = {
      settings = {
        Lua = {
          completion = { callSnippet = "Replace" },
          diagnostics = {
            globals = { "vim", "MiniBufremove", "MiniFiles", "Snacks" },
            disable = { "missing-fields" },
          },
        },
      },
    },
  },
  jsonls = {
    filetypes = { "json", "jsonc" },
    deferred = true,
    config = jsonls_config,
  },
  yamlls = {
    filetypes = { "yaml", "yaml.docker-compose" },
    deferred = true,
    config = yamlls_config,
  },
  taplo = {
    filetypes = { "toml" },
    deferred = true,
    config = {},
  },

  -- Optional languages are configured only when their filetype opens.
  ruff = {
    filetypes = { "python" },
    deferred = true,
    config = {},
  },
  basedpyright = {
    filetypes = { "python" },
    deferred = true,
    config = {
      settings = {
        pyright = { disableOrganizeImports = true },
        python = { analysis = { ignore = { "*" } } },
      },
    },
  },
  tailwindcss = {
    filetypes = {
      "astro",
      "css",
      "html",
      "htmldjango",
      "javascriptreact",
      "jinja",
      "svelte",
      "typescriptreact",
    },
    deferred = true,
    config = function()
      return require("utils.tailwind").lsp
    end,
  },
  html = {
    filetypes = { "html", "htmldjango", "jinja" },
    deferred = true,
    config = { filetypes = { "html", "htmldjango", "jinja" } },
  },
  biome = {
    filetypes = { "css", "javascript", "javascriptreact", "json", "typescript", "typescriptreact" },
    deferred = true,
    config = {},
  },
  eslint = {
    filetypes = { "javascript", "javascriptreact", "svelte", "typescript", "typescriptreact" },
    deferred = true,
    config = {},
  },
  cssls = {
    filetypes = { "css", "less", "scss" },
    deferred = true,
    config = {
      settings = {
        css = { validate = true, lint = { unknownAtRules = "ignore" } },
        scss = { validate = true, lint = { unknownAtRules = "ignore" } },
        less = { validate = true, lint = { unknownAtRules = "ignore" } },
      },
    },
  },
  svelte = { filetypes = { "svelte" }, deferred = true, config = {} },
  astro = { filetypes = { "astro" }, deferred = true, config = {} },
  graphql = { filetypes = { "graphql" }, deferred = true, config = {} },
  prismals = { filetypes = { "prisma" }, deferred = true, config = {} },
  marksman = { filetypes = { "markdown" }, deferred = true, config = {} },
  dockerls = { filetypes = { "dockerfile" }, deferred = true, config = {} },
  docker_compose_language_service = {
    filetypes = { "yaml.docker-compose" },
    deferred = true,
    config = {},
  },
  lemminx = { filetypes = { "xml" }, deferred = true, config = {} },
  terraformls = { filetypes = { "terraform", "terraform-vars" }, deferred = true, config = {} },
  ansiblels = { filetypes = { "yaml.ansible" }, deferred = true, config = {} },
}

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    vim.filetype.add({
      extension = { env = "env" },
      filename = { [".env"] = "env" },
      pattern = { ["%.env%.[%w_.-]+"] = "env" },
    })

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("lsp", { clear = true }),
      callback = function(event)
        local function map(keys, action, description)
          vim.keymap.set("n", keys, action, { buffer = event.buf, desc = description })
        end

        map("K", function()
          vim.lsp.buf.hover({ border = "single" })
        end, "Hover LSP info")
        map("<leader>rn", vim.lsp.buf.rename, "Smart rename")
        map("<leader>d", function()
          vim.diagnostic.open_float({ border = "single" })
        end, "Show line diagnostics")
        map("[d", function()
          vim.diagnostic.jump({ float = { border = "single" }, count = -1 })
        end, "Previous diagnostic")
        map("]d", function()
          vim.diagnostic.jump({ float = { border = "single" }, count = 1 })
        end, "Next diagnostic")
      end,
    })

    vim.diagnostic.config({
      virtual_text = {
        enabled = true,
        prefix = function(diagnostic)
          if diagnostic.severity == vim.diagnostic.severity.ERROR then
            return "🭰× "
          end
          if diagnostic.severity == vim.diagnostic.severity.WARN then
            return "🭰▲ "
          end
          return "🭰• "
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

    local configured = {}
    local missing = {}

    local function notify_missing(name, executable)
      vim.notify_once(
        string.format(
          "Language server '%s' is missing executable '%s'. Activate its Nix package or project shell.",
          name,
          executable
        ),
        vim.log.levels.WARN
      )
    end

    local function configure(name, spec)
      if configured[name] then
        return missing[name] == nil
      end

      local overrides = type(spec.config) == "function" and spec.config() or spec.config
      overrides = vim.tbl_deep_extend("force", {
        capabilities = capabilities,
        filetypes = spec.filetypes,
        on_attach = disable_formatting,
      }, overrides or {})
      vim.lsp.config(name, overrides)
      configured[name] = true

      local resolved = vim.lsp.config[name]
      local command = resolved and resolved.cmd
      local executable = type(command) == "table" and command[1] or nil
      if type(executable) == "string" and vim.fn.executable(executable) ~= 1 then
        missing[name] = executable
        return false
      end

      vim.lsp.enable(name)
      return true
    end

    local function ensure_zls(bufnr)
      -- zls does not currently publish root markers through nvim-lspconfig's
      -- native 0.12 config. Give normal activation a chance, then start it
      -- with the resolved project root if it did not attach.
      vim.defer_fn(function()
        if not vim.api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].filetype ~= "zig" then
          return
        end
        if #vim.lsp.get_clients({ bufnr = bufnr, name = "zls" }) > 0 then
          return
        end

        local config = vim.deepcopy(vim.lsp.config.zls)
        local filename = vim.api.nvim_buf_get_name(bufnr)
        config.root_dir = vim.fs.root(filename, { "zls.json", "build.zig", ".git" })
          or vim.fs.dirname(filename)
        vim.lsp.start(config, { bufnr = bufnr })
      end, 100)
    end

    local by_filetype = {}
    for name, spec in pairs(servers) do
      for _, filetype in ipairs(spec.filetypes) do
        by_filetype[filetype] = by_filetype[filetype] or {}
        by_filetype[filetype][#by_filetype[filetype] + 1] = name
      end
      if not spec.deferred then
        configure(name, spec)
      end
    end

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("lsp_filetype_activation", { clear = true }),
      pattern = vim.tbl_keys(by_filetype),
      callback = function(event)
        if vim.bo[event.buf].filetype == "bigfile" or vim.b[event.buf].completion == false then
          return
        end

        for _, name in ipairs(by_filetype[vim.bo[event.buf].filetype] or {}) do
          local spec = servers[name]
          local available = configure(name, spec)
          if not available then
            notify_missing(name, missing[name])
          elseif name == "zls" then
            ensure_zls(event.buf)
          end
        end
      end,
    })
  end,
}
