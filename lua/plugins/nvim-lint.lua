return {
  "mfussenegger/nvim-lint",
  ft = { "dockerfile", "markdown", "sh", "yaml", "zsh" },
  keys = {
    {
      "<leader>ml",
      function()
        require("lint").try_lint()
      end,
      desc = "Make linting",
    },
  },
  config = function()
    local lint = require("lint")
    local function has(executable)
      return vim.fn.executable(executable) == 1
    end

    lint.linters_by_ft = {
      sh = { "shellcheck" },
      zsh = { "shellcheck" },
      yaml = { "yamllint" },
      dockerfile = { "hadolint" },
      markdown = { "markdownlint", "markdownlint-cli2" },
    }

    local function filename_or_stdin()
      local name = vim.api.nvim_buf_get_name(0)
      if vim.bo.buftype == "" and vim.fn.filereadable(name) == 1 then
        return vim.fn.fnameescape(vim.fn.fnamemodify(name, ":p"))
      end
      return "-"
    end

    if lint.linters.shellcheck then
      lint.linters.shellcheck.args = { "-x", "--format", "json1", filename_or_stdin }
      lint.linters.shellcheck.condition = function()
        return has("shellcheck")
      end
    end
    if lint.linters.yamllint then
      lint.linters.yamllint.args = { "-f", "parsable", filename_or_stdin }
      lint.linters.yamllint.condition = function()
        return has("yamllint")
      end
    end
    if lint.linters.markdownlint then
      lint.linters.markdownlint.args = { "--stdin" }
      lint.linters.markdownlint.condition = function()
        return has("markdownlint")
      end
    end
    if lint.linters["markdownlint-cli2"] then
      lint.linters["markdownlint-cli2"].condition = function()
        return has("markdownlint-cli2")
      end
    end

    vim.api.nvim_create_autocmd("BufWritePost", {
      group = vim.api.nvim_create_augroup("lint", { clear = true }),
      callback = function(event)
        if vim.bo[event.buf].filetype ~= "bigfile" then
          lint.try_lint()
        end
      end,
    })
  end,
}
