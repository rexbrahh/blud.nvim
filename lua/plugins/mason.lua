return {
  "williamboman/mason.nvim",
  event = { "BufReadPre", "BufNewFile" },
  cmd = "Mason",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    require("mason").setup({
      ui = {
        width = 0.95,
        height = 0.9,
        border = "single",
        icons = {
          package_installed = "¤",
          package_pending = "»",
          package_uninstalled = "×",
        },
      },
    })

    -- Auto-install popular language servers
    require("mason-lspconfig").setup({
      ensure_installed = {
        -- Web Development
        -- typescript handled by typescript-tools; avoid ts_ls duplication
        "biome", -- Already configured
        "eslint", -- Already configured
        "html", -- Already configured
        "cssls", -- Already configured
        "tailwindcss", -- Already configured
        "jsonls", -- Already configured
        
        -- Popular Languages
        "lua_ls", -- Already configured
        "gopls", -- Already configured
        "basedpyright", -- Already configured
        "ruff", -- Already configured
        "bashls", -- Already configured
        "zls", -- Zig
        
        -- Additional Popular LSPs
        "rust_analyzer", -- Rust
        "clangd", -- C/C++
        "pyright", -- Alternative Python LSP
        "yamlls", -- YAML
        "marksman", -- Markdown
        "dockerls", -- Docker
        "docker_compose_language_service", -- Docker Compose

        -- Extra popular LSPs (safe additions)
        "svelte", -- Svelte
        "astro", -- Astro
        "graphql", -- GraphQL
        "prismals", -- Prisma
        "taplo", -- TOML
        "lemminx", -- XML
        "terraformls", -- Terraform
        "ansiblels", -- Ansible
        "cmake", -- CMake
      },
      automatic_installation = true,
    })
  end,
}
