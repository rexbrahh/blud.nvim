return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = {
      enabled = true,
      notify = true,
      size = 1.5 * 1024 * 1024,
      line_length = 1000,
      setup = function(context)
        if vim.fn.exists(":NoMatchParen") ~= 0 then
          vim.cmd("NoMatchParen")
        end
        Snacks.util.wo(0, {
          foldmethod = "manual",
          statuscolumn = "",
          conceallevel = 0,
        })
        vim.b[context.buf].completion = false
        vim.b[context.buf].minianimate_disable = true
        vim.b[context.buf].minihipatterns_disable = true

        vim.schedule(function()
          if not vim.api.nvim_buf_is_valid(context.buf) then
            return
          end
          vim.bo[context.buf].syntax = context.ft
          if package.loaded.ufo then
            require("ufo").detach(context.buf)
          end
        end)
      end,
    },
    quickfile = {
      enabled = true,
      -- Syntax gives an immediate first paint for large systems files. Native
      -- Treesitter highlighting replaces it shortly after startup.
      exclude = { "c", "cpp", "go", "rust", "zig" },
    },
  },
}
