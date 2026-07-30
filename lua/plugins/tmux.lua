local function action(name)
  return function()
    require("smart-splits")[name]()
  end
end

return {
  "mrjones2014/smart-splits.nvim",
  keys = {
    { "<A-h>", action("resize_left"), desc = "Resize left" },
    { "<A-j>", action("resize_down"), desc = "Resize down" },
    { "<A-k>", action("resize_up"), desc = "Resize up" },
    { "<A-l>", action("resize_right"), desc = "Resize right" },
    { "<C-h>", action("move_cursor_left"), desc = "Window left" },
    { "<C-j>", action("move_cursor_down"), desc = "Window down" },
    { "<C-k>", action("move_cursor_up"), desc = "Window up" },
    { "<C-l>", action("move_cursor_right"), desc = "Window right" },
    { "<C-\\>", action("move_cursor_previous"), desc = "Previous window" },
  },
  opts = {
    ignored_filetypes = { "minifiles" },
    at_edge = "stop",
    resize_mode = {
      quit_key = "<ESC>",
      resize_keys = { "h", "j", "k", "l" },
      silent = false,
    },
  },
}
