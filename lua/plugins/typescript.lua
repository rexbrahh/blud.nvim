vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("typescript_tools_keymaps", { clear = true }),
  callback = function(event)
    local ts_filetypes = {
      javascript = true,
      javascriptreact = true,
      typescript = true,
      typescriptreact = true,
    }
    if not ts_filetypes[vim.bo[event.buf].filetype] then
      return
    end

    vim.keymap.set("n", "<leader>li", function()
      vim.notify("Organizing imports...")
      vim.cmd("TSToolsOrganizeImports")
    end, { buffer = event.buf, desc = "Organize imports" })

    vim.keymap.set("n", "<leader>la", function()
      vim.notify("Adding missing imports...")
      vim.cmd("TSToolsAddMissingImports")
    end, { buffer = event.buf, desc = "Add missing imports" })
  end,
})

return {
  "pmizio/typescript-tools.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  opts = {
    on_attach = function(client)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
  },
}
