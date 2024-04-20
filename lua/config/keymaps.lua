local vim = vim
local utils = require("config.utils")
local map = vim.keymap.set

-- default maps
map("n", "<leader>uf", function()
	LazyVim.format.toggle()
end, { desc = "Toggle Auto Format (Global)" })
map("n", "<leader>uF", function()
	LazyVim.format.toggle(true)
end, { desc = "Toggle Auto Format (Buffer)" })
map("n", "<leader>us", function()
	LazyVim.toggle("spell")
end, { desc = "Toggle Spelling" })
map("n", "<leader>uw", function()
	LazyVim.toggle("wrap")
end, { desc = "Toggle Word Wrap" })
map("n", "<leader>uL", function()
	LazyVim.toggle("relativenumber")
end, { desc = "Toggle Relative Line Numbers" })
map("n", "<leader>ul", function()
	LazyVim.toggle.number()
end, { desc = "Toggle Line Numbers" })
map("n", "<leader>ud", function()
	LazyVim.toggle.diagnostics()
end, { desc = "Toggle Diagnostics" })
local lazyterm = function()
	LazyVim.terminal(nil, { cwd = LazyVim.root() })
end
map("n", "<leader>ft", lazyterm, { desc = "Terminal (Root Dir)" })
map("n", "<leader>fT", function()
	LazyVim.terminal()
end, { desc = "Terminal (cwd)" })
-- lazygit
map("n", "<leader>gg", function()
	LazyVim.lazygit({ cwd = LazyVim.root.git() })
end, { desc = "Lazygit (Root Dir)" })
map("n", "<leader>gG", function()
	LazyVim.lazygit()
end, { desc = "Lazygit (cwd)" })
map("n", "<leader>ww", "<C-W>p", { desc = "Other Window", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
map("n", "<leader>w-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>w|", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
local Base = {
	movement = {
		-- -- move cursor in wrapline paragraph
		-- { { 'n', 'v' }, 'j', "v:count == 0 ? 'gj' : 'j'",                       { expr = true, silent = true, desc = 'go to next wrapline' } },
		-- { { 'n', 'v' }, 'k', "v:count == 0 ? 'gk' : 'k'",                       { expr = true, silent = true, desc = 'go to previous wrapline' } },
		{ { "n", "v" }, "<A-l>", "$", { desc = "go to the end of line" } },
		{ { "n", "v" }, "<A-h>", "^", { desc = "go the begin of line" } },

		-- dont modify <Tab>, which will affect <C-i>
		{
			"n",
			"J",
			function()
				vim.api.nvim_command("bprevious!")
			end,
			{ desc = "go to previous buffer" },
		},
		{
			"n",
			"K",
			function()
				vim.api.nvim_command("bnext!")
			end,
			{ desc = "go to next buffer" },
		},
		{
			{ "n", "v" },
			"<C-j>",
			"<C-w>h",
			{ desc = "move to left window" },
		},
		{
			{ "n", "v" },
			"<C-k>",
			"<C-w>l",
			{ desc = "move to right window" },
		},
		-- <PageUp>
		-- page scroll
		-- { 'n',          'F', math.floor(vim.fn.winheight(0) / 2) .. '<C-u>',    { desc = 'scroll half page forward' } },
		-- { 'n',          'f', math.floor(vim.fn.winheight(0) / 2) .. '<C-d>',    { desc = 'scroll half page backward' } },
	},
	edit = {
		{ "n", "cb", "<leader>bd", { desc = "delete current buffer" } },
		{ "i", "<C-BS>", "<C-w>", { desc = "delete word forward" } },
		{ { "n", "i" }, "<C-s>", "<CMD>w<CR>", { desc = "save file" } },
		-- { 'v', 'y',           '"*ygvy', { desc = 'copy' } },
		-- { 'n', 'yw',          'yiw',    { desc = 'copy the word where cursor locates' } },
		-- { 'n', '<C-S-v>',     '<C-v>',  { desc = 'start visual mode blockwise' } },
		-- { 'v', '>',           '>gv',    { desc = 'indent while keeping virtual mode after ' } },
		-- { 'v', '<',           '<gv',    { desc = 'indent while keeping virtual mode after ' } },
		-- { 'n', '<Backspace>', 'ciw',    { desc = 'delete word and edit in normal mode' } },
		-- { 'v', '<Backspace>', 'c',      { desc = 'delete and edit in visual mode' } },
	},
	cmd = {
		-- { { 'n', 'v' }, ';',         ':',            { nowait = true, desc = 'enter commandline mode' } },
		-- { { 'n', 'v' }, ']',         '*',            { nowait = true, desc = 'search forward for the word where the cursor is located' } },
		-- { { 'n', 'v' }, '[',         '#',            { nowait = true, desc = 'search backward for the word where the cursor is located' } },
		-- { 'n',          '<leader>q', 'q1',           { desc = 'record macro to register 1' } },
		-- { 'n',          '<C-q>',     utils.quit_win, { desc = 'quit window' } },
		-- { 'n',          'Q',         utils.wq_all,   { desc = 'quit all' } },
		{ "n", "fd", utils.format, { desc = "format document" } },
	},
	fold = {
		-- { 'n', '<CR>',          'za', { desc = 'toggle fold' } },
		-- { 'n', '<2-LeftMouse>', 'za', { desc = 'toggle fold' } },
	},
	modeSwitch = {
		-- { 'i', '<ESC>', '<C-O><CMD>stopinsert<CR>', { desc = 'exit to normal mode while keeping cursor location' } },
	},
}

local Plugin = {
	bufdelete = {
		{
			"n",
			"<C-q>",
			function()
				utils.delete_buf_or_quit()
			end,
			{ desc = "delete buffer or quit" },
		},
	},
	fzf = {
		{
			"n",
			"sw",
			function()
				require("fzf-lua").live_grep()
			end,
			{ desc = "search word" },
		},
		{
			"n",
			"sk",
			function()
				require("fzf-lua").keymaps()
			end,
			{ desc = "search keymaps" },
		},

		{
			"n",
			"csw",
			function()
				require("fzf-lua").grep_curbuf()
			end,
			{ desc = "search word in current buffer" },
		},
		{
			"n",
			"cscw",
			function()
				require("fzf-lua").grep_cword()
			end,
			{ desc = "search word in current buffer" },
		},

		{
			"n",
			"sf",
			function()
				require("fzf-lua").files()
			end,
			{ desc = "search file" },
		},
		{
			"n",
			"sd",
			function()
				require("fzf-lua").diagnostics_workspace()
			end,
			{ desc = "search diagnostics" },
		},
		{
			"n",
			"csd",
			function()
				require("fzf-lua").diagnostics_document()
			end,
			{ desc = "search diagnostics in document" },
		},

		{
			"n",
			"sc",
			function()
				require("fzf-lua").commands()
			end,
			{ desc = "search command" },
		},
		{
			"n",
			"sb",
			function()
				require("fzf-lua").buffers()
			end,
			{ desc = "search buffers" },
		},
		{
			"n",
			"std",
			function()
				require("fzf-lua").lsp_definitions()
			end,
			{ desc = "search definition" },
		},
	},
	neotree = {
		--- some keymaps are in neotree.lua
		{ "n", "<leader>t", ":Neotree toggle<CR>", { desc = "toggle neotree" } },
		{ "n", "<A-m>", "<CMD>cd %:h<CR>", { desc = "change root directory" } },
	},
	lspsaga = {
		{
			"n",
			"ga",
			function()
				vim.api.nvim_command("Lspsaga code_action")
			end,
			{ silent = true, desc = "code action" },
		},
		{
			"n",
			"ge",
			function()
				vim.api.nvim_command("Lspsaga show_line_diagnostics")
			end,
			{ desc = "show diagnostics in line" },
		},
		{
			"n",
			"gh",
			function()
				vim.api.nvim_command("Lspsaga hover_doc")
			end,
			{ desc = "get document" },
		},
		{
			"n",
			"gn",
			function()
				vim.api.nvim_command("Lspsaga rename")
			end,
			{ desc = "rename symbol" },
		},
		{
			"n",
			"gd",
			function()
				vim.api.nvim_command("Lspsaga peek_definition")
			end,
			{ desc = "peek definition" },
		},
		{
			"n",
			"gr",
			function()
				vim.api.nvim_command("Lspsaga finder")
			end,
			{ desc = "find reference" },
		},
		{
			"n",
			"gD",
			function()
				vim.api.nvim_command("Lspsaga goto_definition")
			end,
			{ desc = "goto_definition" },
		},
		{
			"n",
			"gP",
			function()
				vim.api.nvim_command("Lspsaga preview_definition")
			end,
			{ desc = "preview definition" },
		},
		{
			"n",
			"gb",
			function()
				vim.api.nvim_command("Lspsaga show_workspace_diagnostics")
			end,
			{ desc = "show workspace diagnostics" },
		},
	},
	-- neogen = {
	--     { 'n', 'go', function() require('neogen').generate() end, { desc = 'generate doc comment' } },
	-- },
	-- neotest = {
	--     { 'n', 'tt', function() require('neotest').run.run() end,     { desc = 'run test' } },
	--     { 'n', 'ts', function() require('neotest').output.open() end, { desc = 'show test output' } },
	-- },
	dap = {
		{
			"n",
			"`",
			function()
				require("dap").toggle_breakpoint()
			end,
			{ desc = "toggle breakpoint" },
		},
		{
			"n",
			"<F1>",
			function()
				require("dap").continue()
			end,
			{ desc = "continue" },
		},
		{
			"n",
			"<F2>",
			function()
				require("dap").step_over()
			end,
			{ desc = "step over" },
		},
		{
			"n",
			"<F3>",
			function()
				require("dap").step_into()
			end,
			{ desc = "step into" },
		},
		{
			"n",
			"<F4>",
			function()
				require("dapui").toggle()
			end,
			{ desc = "toggle debug ui" },
		},
	},
	comment = {},
	flash = {
		-- press '/' to search and jump
		-- {
		-- 	{ "n", "x", "o" },
		-- 	"?",
		-- 	function()
		-- 		require("flash").treesitter()
		-- 	end,
		-- 	{ desc = "search and select in treesitter" },
		-- },
	},
	-- markdown = {
	--     { 'n', '<leader>p', utils.preview_note,  { desc = 'preview markdown' } },
	--     { 'n', 'P',         utils.paste_as_link, { desc = 'paste image as link' } },
	-- },
	-- tmux = {
	--     { 'n', '<C-j>', require('nvim-tmux-navigation').NvimTmuxNavigateDown,   { desc = 'navigate in neovim windows and tmux windows' } },
	--     { 'n', '<C-k>', require('nvim-tmux-navigation').NvimTmuxNavigateUp,     { desc = 'navigate in neovim windows and tmux windows' } },
	--     { 'n', '<C-h>', require('nvim-tmux-navigation').NvimTmuxNavigateLeft,   { desc = 'navigate in neovim windows and tmux windows' } },
	--     { 'n', '<C-l>', require('nvim-tmux-navigation').NvimTmuxNavigateRight,  { desc = 'navigate in neovim windows and tmux windows' } },

	-- },
}

local keyMapper = function(keySet)
	for _, set in pairs(keySet) do
		for _, keymap in ipairs(set) do
			if keymap[4] == nil then
				keymap[4] = { noremap = true, silent = true }
			end
			if keymap[3] ~= nil then
				vim.keymap.set(keymap[1], keymap[2], keymap[3], keymap[4])
			end
		end
	end
end

keyMapper(Base)
keyMapper(Plugin)
