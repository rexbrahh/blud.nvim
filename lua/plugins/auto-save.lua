return {
  "pocco81/auto-save.nvim",
  config = function()
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
        local utils = require("auto-save.utils.data")

        -- don't save for certain filetypes
        local filetype_blacklist = {
          "oil",
          "alpha",
          "neo-tree",
          "TelescopePrompt",
          "harpoon",
          "toggleterm",
          "lazy",
          "mason",
          "help",
          "qf", -- quickfix
          "gitcommit",
          "gitrebase",
        }

        local filetype = fn.getbufvar(buf, "&filetype")
        local bufname = fn.bufname(buf)
        
        -- check if filetype is not in blacklist
        local filetype_ok = true
        for _, ft in ipairs(filetype_blacklist) do
          if filetype == ft then
            filetype_ok = false
            break
          end
        end

        if filetype_ok then
          -- only save normal files (not special buffers)
          return fn.getbufvar(buf, "&modifiable") == 1 
            and fn.getbufvar(buf, "&readonly") == 0
            and fn.getbufvar(buf, "&buftype") == ""
            and bufname ~= "" -- only save named buffers
        end
        return false
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