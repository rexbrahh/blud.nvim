require("config.settings")
require("config.keymaps")
require("config.lazy")

require("utils.highlights")
require("utils.tailwind")

if vim.g.neovide then
  vim.o.guifont = "Input Mono,Symbols Nerd Font Mono:h12"
  vim.opt.linespace = 3
  vim.g.neovide_show_border = true
  vim.g.neovide_scroll_animation_lenght = 0.1
end

local should_profile = os.getenv("NVIM_PROFILE")
if should_profile then
  local ok, prof = pcall(require, "profile")
  if ok then
    prof.instrument_autocmds()
    if should_profile:lower():match("^start") then
      prof.start("*")
    else
      prof.instrument("*")
    end
  else
    vim.notify("Profile plugin not installed. Install stevearc/profile.nvim to enable profiling.", vim.log.levels.WARN)
  end
end

local function toggle_profile()
  local ok, prof = pcall(require, "profile")
  if not ok then
    vim.notify("Profile plugin not installed. Install stevearc/profile.nvim to enable profiling.", vim.log.levels.WARN)
    return
  end

  if prof.is_recording() then
    prof.stop()
    vim.ui.input(
      { prompt = "Save profile to:", completion = "file", default = "profile.json" },
      function(filename)
        if filename then
          prof.export(filename)
          vim.notify(string.format("Wrote %s", filename))
        end
      end
    )
  else
    prof.start("blink*")
  end
end
vim.opt.mouse = "a"

vim.keymap.set("", "<f1>", toggle_profile)
