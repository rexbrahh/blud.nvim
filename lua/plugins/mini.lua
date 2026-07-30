local function harpoon_slot()
  if not package.loaded.harpoon then
    return ""
  end

  local current = vim.fn.expand("%:p")
  for index, item in ipairs(require("harpoon"):list().items) do
    if vim.fn.fnamemodify(item.value, ":p") == current then
      return "#" .. index
    end
  end
  return ""
end

local function lsp_names()
  local names = {}
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    names[#names + 1] = client.name
  end
  table.sort(names)
  return table.concat(names, ",")
end

local function toggle_files(path, fresh)
  if not fresh and MiniFiles.close() then
    return
  end
  MiniFiles.open(path, not fresh)
end

local function map_split(buf, lhs, command)
  vim.keymap.set("n", lhs, function()
    local entry = MiniFiles.get_fs_entry()
    if not entry or entry.fs_type == "directory" then
      MiniFiles.go_in()
      return
    end

    local target = MiniFiles.get_explorer_state().target_window
    local new_target = vim.api.nvim_win_call(target, function()
      vim.cmd(command)
      return vim.api.nvim_get_current_win()
    end)
    MiniFiles.set_target_window(new_target)
    MiniFiles.go_in({ close_on_file = true })
  end, { buffer = buf, desc = "Open in " .. command })
end

return {
  "echasnovski/mini.nvim",
  lazy = false,
  init = function()
    package.preload["nvim-web-devicons"] = function()
      require("mini.icons").mock_nvim_web_devicons()
      return package.loaded["nvim-web-devicons"]
    end
  end,
  config = function()
    require("mini.pairs").setup()
    require("mini.icons").setup({
      file = {
        [".env"] = { glyph = "󰛸", hl = "MiniIconsYellow" },
        [".env.example"] = { glyph = "󰛸", hl = "MiniIconsBlue" },
      },
    })
    require("mini.bufremove").setup()
    require("mini.files").setup({
      options = { use_as_default_explorer = true },
      windows = {
        preview = true,
        width_focus = 30,
        width_nofocus = 18,
        width_preview = 36,
      },
    })

    local statusline = require("mini.statusline")
    statusline.setup({
      content = {
        active = function()
          local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
          local git = statusline.section_git({ trunc_width = 40 })
          local diff = statusline.section_diff({ trunc_width = 75 })
          local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
          local filename = statusline.section_filename({ trunc_width = 140 })
          local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
          local location = statusline.section_location({ trunc_width = 75 })
          local search = statusline.section_searchcount({ trunc_width = 75 })

          return statusline.combine_groups({
            { hl = mode_hl, strings = { mode } },
            {
              hl = "MiniStatuslineDevinfo",
              strings = { git, diff, diagnostics, lsp_names(), harpoon_slot() },
            },
            "%<",
            { hl = "MiniStatuslineFilename", strings = { filename } },
            "%=",
            { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
            { hl = mode_hl, strings = { search, location, "%P" } },
          })
        end,
      },
      use_icons = true,
    })

    vim.keymap.set("n", "<leader>bd", function()
      MiniBufremove.delete(0, false)
    end, { desc = "Delete buffer" })
    vim.keymap.set("n", "<leader>bw", function()
      MiniBufremove.wipeout(0, false)
    end, { desc = "Wipeout buffer" })
    vim.keymap.set("n", "<leader>fe", function()
      local path = vim.api.nvim_buf_get_name(0)
      toggle_files(path ~= "" and path or vim.uv.cwd(), false)
    end, { desc = "Files: current file" })
    vim.keymap.set("n", "<leader>fE", function()
      toggle_files(vim.uv.cwd(), true)
    end, { desc = "Files: working directory" })

    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesBufferCreate",
      callback = function(event)
        local buf = event.data.buf_id
        map_split(buf, "<C-s>", "belowright horizontal split")
        map_split(buf, "<C-v>", "belowright vertical split")
        map_split(buf, "<C-t>", "tab split")
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesActionRename",
      callback = function(event)
        Snacks.rename.on_rename_file(event.data.from, event.data.to)
      end,
    })
  end,
}
