local picker_opts = {
  header = false,
  file_icons = false,
  git_icons = false,
  color_icons = false,
}

local function picker(name, opts)
  return function()
    require("fzf-lua")[name](vim.tbl_extend("force", picker_opts, opts or {}))
  end
end

return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  keys = {
    { "<leader>za", picker("builtin"), desc = "FZF fallback" },
    {
      "<leader>zf",
      picker("files", {
        cmd = "rg --files --hidden --ignore --glob='!.git' --sortr=modified",
        fzf_opts = { ["--scheme"] = "path", ["--tiebreak"] = "index" },
      }),
      desc = "Files (fzf fallback)",
    },
    { "<leader>sh", picker("help_tags"), desc = "Help" },
    { "<leader>sb", picker("buffers"), desc = "Buffers" },
    { "<leader>sr", picker("oldfiles", { include_current_session = true }), desc = "Recent files" },
    { "<leader>zv", picker("grep_visual"), desc = "Grep visual (fzf fallback)", mode = "x" },
    { "<leader>zc", picker("grep_cword"), desc = "Current word (fzf fallback)" },
    { "<leader>zg", picker("live_grep_native"), desc = "Grep text (fzf fallback)" },
    { "<leader>sd", picker("diagnostics_document"), desc = "Diagnostics" },
    { "gd", picker("lsp_definitions", { jump1 = true }), desc = "LSP definitions" },
    {
      "<leader>lr",
      picker("lsp_references", { includeDeclaration = false, ignore_current_line = true }),
      desc = "LSP references",
    },
    { "<leader>lc", picker("lsp_code_actions"), desc = "LSP code actions" },
    { "<leader>lt", picker("lsp_typedefs"), desc = "LSP type definitions" },
    { "<leader>lI", picker("lsp_implementations"), desc = "LSP implementations" },
    {
      "<C-e>",
      function()
        require("fzf-lua.win").toggle_fullscreen()
        require("fzf-lua.win").toggle_preview()
      end,
      desc = "Toggle FZF fullscreen",
      mode = { "c", "i", "t" },
    },
  },
  config = function()
    local fzf = require("fzf-lua")
    fzf.register_ui_select()
    fzf.setup({
      hls = {
        prompt = "Constant",
        title = "FloatBorder",
        border = "FloatBorder",
        preview_border = "FloatBorder",
      },
      keymap = { fzf = { ["ctrl-y"] = "toggle+down", ["ctrl-i"] = "up+toggle" } },
      actions = {
        files = {
          ["ctrl-v"] = fzf.actions.file_vsplit,
          ["ctrl-t"] = fzf.actions.file_tabedit,
          ["alt-q"] = fzf.actions.file_sel_to_qf,
          ["alt-Q"] = fzf.actions.file_sel_to_ll,
          ["alt-i"] = fzf.actions.toggle_ignore,
          ["alt-h"] = fzf.actions.toggle_hidden,
          ["alt-f"] = fzf.actions.toggle_follow,
          ["enter"] = fzf.actions.file_edit_or_qf,
        },
      },
      fzf_colors = {
        ["bg"] = { "bg", "FloatBorder" },
        ["bg+"] = { "bg", "FloatBorder" },
        ["fg"] = { "fg", "Comment" },
        ["fg+"] = { "fg", "PreProc" },
        ["hl"] = { "fg", "Constant" },
        ["hl+"] = { "fg", "Constant" },
        ["spinner"] = { "fg", "Label" },
        ["marker"] = { "fg", "PreProc" },
        ["pointer"] = { "fg", "PreProc" },
        ["prompt"] = { "fg", "Special" },
        ["info"] = { "fg", "Special" },
        ["header"] = { "fg", "Normal" },
        ["separator"] = { "fg", "Normal" },
        ["scrollbar"] = { "fg", "Normal" },
      },
      winopts = {
        border = "single",
        height = 15,
        width = 76,
        row = 0.2,
        col = 0.5,
        preview = { hidden = true },
      },
    })
  end,
}
