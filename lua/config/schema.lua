local M = {}

-- Global toggle (default on)
vim.g.use_schemastore = true

local function restart_lsp()
  for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
    if client.name == "jsonls" or client.name == "yamlls" then
      client.stop(true)
    end
  end
  vim.defer_fn(function()
    vim.cmd("edit")
  end, 50)
end

function M.toggle()
  vim.g.use_schemastore = not vim.g.use_schemastore
  if vim.g.use_schemastore then
    vim.notify("SchemaStore enabled for JSON/YAML", vim.log.levels.INFO)
  else
    vim.notify("SchemaStore disabled for JSON/YAML", vim.log.levels.WARN)
  end
  restart_lsp()
end

vim.api.nvim_create_user_command("SchemaToggle", M.toggle, { desc = "Toggle SchemaStore (JSON/YAML)" })

return M

