vim.loader.enable()
-- When you do require("foo.bar"), Neovim will try to load one of these file patterns:
-- lua/foo/bar.lua
-- lua/foo/bar/init.lua

require('config.lazy')
require('config.base')
require('config.utils')
require('config.autocmds')
require('config.keymaps')

-- require('keymap')
