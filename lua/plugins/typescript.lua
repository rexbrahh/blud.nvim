local filetypes = {
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
}

return {
  "pmizio/typescript-tools.nvim",
  ft = filetypes,
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  opts = {
    on_attach = function(client, buf)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false

      vim.keymap.set("n", "<leader>li", function()
        vim.notify("Organizing imports")
        vim.cmd("TSToolsOrganizeImports")
      end, { buffer = buf, desc = "Organize imports" })

      vim.keymap.set("n", "<leader>la", function()
        vim.notify("Adding missing imports")
        vim.cmd("TSToolsAddMissingImports")
      end, { buffer = buf, desc = "Add missing imports" })
    end,
  },
}
