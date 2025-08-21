---returns the specific hex code from a selected highlight
---@param name string
---@param option string
---@return string | nil
function Get_hl_hex(name, option)
  if type(name) ~= "string" or (option ~= "fg" and option ~= "bg") then
    error("Invalid arguments. Usage: highlight(name: string, option: 'fg' | 'bg')")
  end
  local hl = vim.api.nvim_get_hl(0, { name = name })
  local color = hl[option]
  if not color then
    print("No " .. option .. " color found for highlight group: " .. name)
    return nil
  end
  local hex_color = string.format("#%06x", color)
  return hex_color
end

local function hex_to_rgb(hex)
  hex = hex:gsub("#", "")
  return tonumber("0x" .. hex:sub(1, 2)),
    tonumber("0x" .. hex:sub(3, 4)),
    tonumber("0x" .. hex:sub(5, 6))
end

local function rgb_to_hex(r, g, b)
  return string.format("#%02x%02x%02x", r, g, b)
end

---darkens a hex value, with a factor of 0(black) to 1(unchanged)
---@param hex string | nil
---@param factor number | nil
---@return string | nil
function Darken_hex(hex, factor)
  if hex == nil then
    error("Nil value passed as hex, verify hex source")
    return
  end
  factor = factor or 0.15
  if factor > 1 or factor < 0 then
    factor = 0.15
    warn("Can't darken hex values with a factor higher than 1 or less than 0, defaulting to 0.15")
  end
  local r, g, b = hex_to_rgb(hex)
  local color = rgb_to_hex(math.floor(r * factor), math.floor(g * factor), math.floor(b * factor))
  return color
end

---shorter function call
---@param highlight string
---@param options table
local function set_hl(highlight, options)
  vim.api.nvim_set_hl(0, highlight, options)
end

vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
  group = vim.api.nvim_create_augroup("Color", {}),
  pattern = "*",
  callback = function()
    local hint_color = Get_hl_hex("DiagnosticHint", "fg")
    local warn_color = Get_hl_hex("DiagnosticWarn", "fg")
    local error_color = Get_hl_hex("DiagnosticError", "fg")

    set_hl("DiagnosticVirtualTextHint", { fg = hint_color, bg = Darken_hex(hint_color) })
    set_hl("DiagnosticVirtualTextWarn", { fg = warn_color, bg = Darken_hex(warn_color) })
    set_hl("DiagnosticVirtualTextError", { fg = error_color, bg = Darken_hex(error_color) })

    -- syntax highlights
    set_hl("Type", { link = "String" })
    set_hl("Delimiter", { link = "Variable" })
    set_hl("Statement", { fg = Get_hl_hex("Identifier", "fg"), italic = true })

    -- searches and flash highlights
    set_hl("Search", { fg = Get_hl_hex("Special", "fg") })
    set_hl("Substitute", { bg = Get_hl_hex("String", "fg"), fg = Get_hl_hex("Normal", "bg") })

    set_hl("DiagnosticUnnecessary", { underline = true })
    set_hl("WinSeparator", { link = "FloatBorder" })

    set_hl("NeoTreeNormal", { link = "NormalFloat" })
    set_hl("NeoTreeDirectoryIcon", { fg = Get_hl_hex("Identifier", "fg") })
    set_hl("NeoTreeDirectoryName", { fg = Get_hl_hex("Identifier", "fg") })
    set_hl("NeoTreeGitUnstaged", { link = "Changed" })
    set_hl("NeoTreeGitModified", { link = "Changed" })
    set_hl("NeoTreeGitUntracked", { link = "Added" })
    set_hl("NeoTreeGitRenamed", { link = "Added" })
    set_hl("NeoTreeGitConflict", { link = "Removed" })
    
    -- Force transparency overrides
    set_hl("Normal", { bg = "NONE" })
    set_hl("NormalNC", { bg = "NONE" })
    set_hl("LineNr", { bg = "NONE" })
    set_hl("SignColumn", { bg = "NONE" })
    set_hl("StatusLine", { bg = "NONE" })
    set_hl("StatusLineNC", { bg = "NONE" })
    set_hl("TabLine", { bg = "NONE" })
    set_hl("TabLineFill", { bg = "NONE" })
    set_hl("TabLineSel", { bg = "NONE" })
    set_hl("FloatBorder", { bg = "NONE" })
    set_hl("NormalFloat", { bg = "NONE" })
    set_hl("Pmenu", { bg = "NONE" })
    set_hl("PmenuSel", { bg = "NONE" })
    set_hl("EndOfBuffer", { bg = "NONE" })
    set_hl("NonText", { bg = "NONE" })
    
    -- Plugin specific transparency
    set_hl("NeoTreeNormal", { bg = "NONE" })
    set_hl("NeoTreeEndOfBuffer", { bg = "NONE" })
    set_hl("TelescopeNormal", { bg = "NONE" })
    set_hl("TelescopeBorder", { bg = "NONE" })
    set_hl("AlphaHeader", { bg = "NONE" })
    set_hl("AlphaButtons", { bg = "NONE" })
    set_hl("AlphaFooter", { bg = "NONE" })
    
    -- Lualine transparency
    set_hl("lualine_a_normal", { bg = "NONE" })
    set_hl("lualine_b_normal", { bg = "NONE" })
    set_hl("lualine_c_normal", { bg = "NONE" })
    
    -- Keep important highlights visible
    -- Cursor stays visible (don't touch Cursor, lCursor, etc.)
    -- Visual selection stays visible (don't touch Visual)
    -- Search stays visible (don't touch Search, IncSearch)
  end,
})

-- highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})
