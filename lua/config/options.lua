-- disable statusline, set splitline for windows
-- vim.o.laststatus = 0
-- local str = string.rep('-', vim.api.nvim_win_get_width(0))
-- vim.o.statusline = '%#VerticalSplit#'..str..'%*'
-- set cmd height, set by noice.nvim
-- vim.o.cmdheight = 0

vim.o.title = true
vim.o.termguicolors = true
vim.o.errorbells = false
vim.o.mouse = "a"

-- split window setting
vim.o.splitright = true

-- hidden conceal char
-- vim.o.conceallevel = 3

vim.o.modifiable = true
-- the refresh time will affect lspsaga's reaction time
vim.o.updatetime = 300
-- case settintg
vim.o.smartcase = true
vim.o.ignorecase = true
vim.o.cursorline = true

vim.o.clipboard = "unnamedplus"

vim.o.scrolloff = 0

-- indent setting
vim.o.autoindent = true
vim.o.smartindent = true

-- no additional files
vim.o.swapfile = false
vim.o.backup = false -- insert mode compeleting menu setting
vim.o.completeopt = "menuone,noinsert,noselect"

-- visual selection mode
vim.o.sel = "inclusive"

-- set tab to 4 spaces, could be override by ftplugin
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
-- show numbers
vim.o.number = true
vim.o.relativenumber = true
vim.o.ignorecase = true
-- save space for window
vim.o.signcolumn = "number"
vim.o.autoread = true
-- wrap line when too long to display
vim.o.wrap = true
vim.g.mapleader = " "
vim.o.viewoptions = "folds,cursor,curdir"

-- save undo history
vim.o.undofile = true

vim.g.python3_host_prog = vim.fn.exepath("python3")
vim.g.autoformat = false
vim.opt.pumblend = 0
vim.opt.termguicolors = true
vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"
vim.opt.scrolloff = 999
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_ruby_provider = 0
