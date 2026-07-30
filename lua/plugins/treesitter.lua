local parsers = {
  "astro",
  "bash",
  "c",
  "cmake",
  "cpp",
  "css",
  "dockerfile",
  "gitignore",
  "go",
  "gomod",
  "gosum",
  "gowork",
  "graphql",
  "hcl",
  "html",
  "javascript",
  "jinja",
  "json",
  "lua",
  "luadoc",
  "make",
  "markdown",
  "markdown_inline",
  "nix",
  "nu",
  "python",
  "query",
  "rust",
  "sql",
  "svelte",
  "terraform",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
  "zig",
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local treesitter = require("nvim-treesitter")
    treesitter.setup({})

    vim.filetype.add({
      extension = { env = "env" },
      filename = { [".env"] = "env" },
      pattern = { ["%.env%.[%w_.-]+"] = "env" },
    })
    vim.treesitter.language.register("bash", "env")
    vim.treesitter.language.register("jinja", "htmldjango")
    -- Main no longer ships a separate jsonc grammar; JSON-with-comments uses
    -- the maintained JSON parser and its inherited queries.
    vim.treesitter.language.register("json", "jsonc")

    -- The legacy branch has setup() but no install(). This guard keeps the
    -- targeted Lazy update usable; main takes this path immediately after it
    -- replaces the locked legacy checkout.
    local install_task
    if treesitter.install then
      install_task = treesitter.install(parsers)
      vim.api.nvim_create_user_command("TSInstallConfigured", function(command)
        install_task = install_task or treesitter.install(parsers)
        if command.bang then
          install_task:wait(300000)
        end
      end, { bang = true, desc = "Install the configured Treesitter parser set" })
    end

    local filetypes = vim.list_extend(vim.deepcopy(parsers), { "env", "htmldjango", "jsonc" })
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
      pattern = filetypes,
      callback = function(event)
        if vim.bo[event.buf].filetype == "bigfile" or vim.b[event.buf].completion == false then
          return
        end
        -- Let quickfile paint the buffer before the initial parse. This keeps
        -- large translation units responsive without changing highlighting
        -- once the first event-loop turn completes.
        vim.defer_fn(function()
          if
            not vim.api.nvim_buf_is_valid(event.buf)
            or vim.bo[event.buf].filetype == "bigfile"
            or vim.b[event.buf].completion == false
          then
            return
          end
          pcall(vim.treesitter.start, event.buf)
        end, 200)
      end,
    })
  end,
}
