return {
  "pocco81/auto-save.nvim",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local ignored_filetypes = {
      alpha = true,
      gitcommit = true,
      gitrebase = true,
      harpoon = true,
      help = true,
      lazy = true,
      mason = true,
      ["neo-tree"] = true,
      oil = true,
      qf = true,
      TelescopePrompt = true,
      toggleterm = true,
    }

    require("auto-save").setup({
      enabled = true, -- start auto-save when the plugin is loaded
      execution_message = {
        enabled = false, -- disable save messages to avoid spam
        message = function()
          return ""
        end,
        dim = 0.18,
        cleaning_interval = 1250,
      },
      trigger_events = {
        immediate_save = { "BufLeave", "FocusLost" }, -- save when leaving buffer or losing focus
        defer_save = { "InsertLeave", "TextChanged" }, -- save after changes with delay
        cancel_defered_save = { "InsertEnter" }, -- cancel pending save when entering insert mode
      },
      condition = function(buf)
        local fn = vim.fn
        local filetype = fn.getbufvar(buf, "&filetype")
        local bufname = fn.bufname(buf)

        if ignored_filetypes[filetype] then
          return false
        end

        return fn.getbufvar(buf, "&modifiable") == 1
          and fn.getbufvar(buf, "&readonly") == 0
          and fn.getbufvar(buf, "&buftype") == ""
          and bufname ~= ""
      end,
      write_all_buffers = false, -- only save current buffer
      debounce_delay = 1000, -- delay in ms before saving after text changes (1 second)
      callbacks = {
        enabling = nil,
        disabling = nil,
        before_asserting_save = nil,
        before_saving = nil,
        after_saving = nil,
      },
    })
  end,
}
