return {
  "xiyaowong/transparent.nvim",
  config = function()
    require("transparent").setup({
      groups = {
        -- Default transparent groups
        "Normal",
        "NormalNC",
        "Comment",
        "Constant",
        "Special",
        "Identifier",
        "Statement",
        "PreProc",
        "Type",
        "Underlined",
        "Todo",
        "String",
        "Function",
        "Conditional",
        "Repeat",
        "Operator",
        "Structure",
        "LineNr",
        "NonText",
        "SignColumn",
        "CursorColumn",
        "CursorLine",
        "EndOfBuffer",
        
        -- Plugin specific
        "NvimTreeNormal",
        "NvimTreeEndOfBuffer",
        "NeoTreeNormal",
        "NeoTreeEndOfBuffer",
        "TelescopeNormal",
        "TelescopeBorder",
        "WhichKeyFloat",
        "LspFloatWinNormal",
        "LspFloatWinBorder",
        "DiagnosticFloatingError",
        "DiagnosticFloatingWarn",
        "DiagnosticFloatingInfo",
        "DiagnosticFloatingHint",
        
        -- Statusline/tabline
        "StatusLine",
        "StatusLineNC",
        "TabLine",
        "TabLineFill",
        "TabLineSel",
        
        -- Popup menus
        "Pmenu",
        "PmenuSel",
        "PmenuSbar",
        "PmenuThumb",
        
        -- Floating windows
        "FloatBorder",
        "NormalFloat",
      },
      
      extra_groups = {
        -- Alpha dashboard
        "AlphaHeader",
        "AlphaButtons",
        "AlphaShortcut",
        "AlphaFooter",
        
        -- FZF
        "FzfLuaNormal",
        "FzfLuaBorder",
        
        -- Lualine
        "lualine_a_normal",
        "lualine_b_normal",
        "lualine_c_normal",
        "lualine_x_normal",
        "lualine_y_normal",
        "lualine_z_normal",
        
        -- Git signs
        "GitSignsAdd",
        "GitSignsChange",
        "GitSignsDelete",
        
        -- Treesitter
        "TreesitterContext",
        "TreesitterContextBottom",
      },
      
      exclude_groups = {
        -- Keep cursor visible
        "Cursor",
        "lCursor",
        "CursorIM",
        "TermCursor",
        "TermCursorNC",
        
        -- Keep selection highlights
        "Visual",
        "VisualNOS",
        
        -- Keep search highlights
        "Search",
        "CurSearch",
        "IncSearch",
        
        -- Keep error/warning highlights for important feedback
        "Error",
        "ErrorMsg",
        "WarningMsg",
        
        -- Keep diff highlights
        "DiffAdd",
        "DiffChange",
        "DiffDelete",
        "DiffText",
      },
    })
    
    -- Enable transparency
    require("transparent").clear_prefix("BufferLine")
    require("transparent").clear_prefix("NeoTree")
    require("transparent").clear_prefix("lualine")
  end,
}