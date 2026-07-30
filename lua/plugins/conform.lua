local function skip_automatic_format(buf)
  local filetype = vim.bo[buf].filetype
  return vim.b[buf].boundary_autosave
    or vim.b[buf].completion == false
    or filetype == "bigfile"
    or filetype == "c"
    or filetype == "cpp"
end

return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  cmd = "ConformInfo",
  keys = {
    {
      "<leader>mp",
      function()
        require("conform").format({
          lsp_format = "fallback",
          async = false,
          timeout_ms = 2000,
        })
      end,
      desc = "Make pretty",
    },
  },
  opts = {
    notify_on_error = true,
    formatters = {
      biome = { append_args = { "--indent-style=space" } },
      black = { append_args = { "--line-length=80" } },
      sleek = { append_args = { "--indent-spaces=2" } },
      deno_fmt = { append_args = { "--prose-wrap=never" } },
    },
    formatters_by_ft = {
      javascript = { "biome", "rustywind" },
      typescript = { "biome", "rustywind" },
      javascriptreact = { "biome", "rustywind" },
      typescriptreact = { "biome", "rustywind" },
      svelte = { "biome", "rustywind" },
      css = { "biome", "rustywind" },
      html = { "deno_fmt", "rustywind" },
      json = { "biome", "rustywind" },
      yaml = { "biome", "rustywind" },
      graphql = { "biome", "rustywind" },
      zsh = { "shfmt" },
      sh = { "shfmt" },
      htmldjango = { "djlint", "rustywind" },
      jinja = { "djlint", "rustywind" },
      python = { "black" },
      markdown = { "deno_fmt" },
      lua = { "stylua" },
      nix = { "nixfmt" },
      sql = { "sleek" },
      go = { "gofumpt", "goimports" },
      rust = { "rustfmt" },
      toml = { "taplo" },
      terraform = { "terraform_fmt" },
      c = { "clang_format" },
      cpp = { "clang_format" },
      zig = { "zigfmt" },
    },
    format_on_save = function(buf)
      if skip_automatic_format(buf) then
        return nil
      end
      return { lsp_format = "fallback", timeout_ms = 2000 }
    end,
  },
}
