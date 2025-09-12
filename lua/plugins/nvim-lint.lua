return {
  "mfussenegger/nvim-lint",
  lazy = true,
  enabled = true,
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      sh = { "shellcheck" },
      zsh = { "shellcheck" },
      yaml = { "yamllint" },
      dockerfile = { "hadolint" },
      markdown = { "markdownlint" },
    }

    local function filename_or_stdin()
      local bufname = vim.api.nvim_buf_get_name(0)
      local file = vim.fn.fnameescape(vim.fn.fnamemodify(bufname, ":p"))
      if vim.bo.buftype == "" and vim.fn.filereadable(file) == 1 then
        return file
      end
      return "-"
    end
    lint.linters.shellcheck.args = { "-x", "--format", "json1", filename_or_stdin }
    -- Quiet defaults if tools are missing; nvim-lint will no-op
    if lint.linters.yamllint then
      lint.linters.yamllint.args = { "-f", "parsable", filename_or_stdin }
    end
    if lint.linters.markdownlint then
      lint.linters.markdownlint.args = { "--stdin" }
    end

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd(
      { "BufReadPre", "BufWritePost", "InsertEnter", "InsertLeave", "TextChanged" },
      {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      }
    )

    -- Diagnostics
    vim.keymap.set("n", "<leader>d", function()
      vim.diagnostic.open_float({ border = "single" })
    end, { desc = "Show line diagnostics" })

    vim.keymap.set("n", "<leader>ml", function()
      lint.try_lint()
    end, { desc = "Make Linting" })
  end,
}
