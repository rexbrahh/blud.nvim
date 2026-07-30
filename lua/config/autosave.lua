local group = vim.api.nvim_create_augroup("boundary_autosave", { clear = true })

local function can_save(buf)
  if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_buf_is_loaded(buf) then
    return false
  end

  local options = vim.bo[buf]
  return options.buftype == ""
    and options.modifiable
    and not options.readonly
    and options.modified
    and vim.api.nvim_buf_get_name(buf) ~= ""
end

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost" }, {
  group = group,
  callback = function(event)
    local buf = event.buf ~= 0 and event.buf or vim.api.nvim_get_current_buf()
    if not can_save(buf) then
      return
    end

    vim.b[buf].boundary_autosave = true
    local ok, err = pcall(vim.api.nvim_buf_call, buf, function()
      vim.cmd("silent update")
    end)
    vim.b[buf].boundary_autosave = nil

    if not ok then
      vim.notify("Boundary save failed: " .. tostring(err), vim.log.levels.ERROR)
    end
  end,
})
