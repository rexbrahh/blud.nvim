vim.loader.enable()
vim.opt.mouse = "a"

-- Show the mode in the statusline instead of the command line.
vim.opt.showmode = false

-- folds
vim.opt.foldenable = false
vim.opt.foldmethod = "manual"

-- wrap
vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.breakat = " "
vim.opt.textwidth = 80

-- remove eof character
vim.opt.fillchars = { eob = " " }

-- Save undo history
vim.opt.undofile = true

-- always number line
vim.opt.nu = true

-- incremental search
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- term colors
vim.opt.termguicolors = true

-- Keep nearby context without forcing the cursor into the screen center.
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

vim.opt.updatetime = 300

-- better indentation
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

-- Enable break indent
vim.opt.breakindent = true

-- Split direction
vim.opt.splitright = true
vim.opt.splitbelow = true

-- indent symbols
-- tab cannot be less than 2
vim.opt.list = true
vim.opt.listchars = { tab = "  ", trail = "·", nbsp = "␣" }
