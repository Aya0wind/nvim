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
-- lazygio
map("n", "<leader>ww", "<C-W>p", { desc = "Other Window", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
map("n", "<leader>w-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>w|", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })

map("n", "<A-UP>", "<C-W>+", { desc = "windows height up" })
map("n", "<A-DOWN>", "<C-W>-", { desc = "windows height down" })
map("n", "<A-LEFT>", "<C-W><", { desc = "windows width left" })
map("n", "<A-RIGHT>", "<C-W>>", { desc = "windows width right" })

local Base = {
	movement = {
		-- move cursor in wrapline paragraph
		{
			{ "n", "v" },
			"j",
			"v:count == 0 ? 'gj' : 'j'",
			{ expr = true, silent = true, desc = "go to next wrapline" },
		},
		{
			{ "n", "v" },
			"k",
			"v:count == 0 ? 'gk' : 'k'",
			{ expr = true, silent = true, desc = "go to previous wrapline" },
		},
		{ "i", "<A-l>", "<RIGHT>", { desc = "cursor right" } },
		{ "i", "<A-h>", "<LEFT>", { desc = "cursor left" } },
		{ "i", "<A-j>", "<DOWN>", { desc = "cursor down" } },
		{ "i", "<A-k>", "<UP>", { desc = "cursor up" } },
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
		{
			{ "n", "v" },
			"<C-h>",
			"<C-w>j",
			{ desc = "move to below window" },
		},
		{
			{ "n", "v" },
			"<C-l>",
			"<C-w>k",
			{ desc = "move to above window" },
		},
		-- <PageUp>
		-- page scroll
		{ "n", "F", math.floor(vim.fn.winheight(0) / 2) .. "<C-u>", { desc = "scroll half page forward" } },
		{
			"n",
			"f",
			math.floor(vim.fn.winheight(0) / 2) .. "<C-d>",
			{ desc = "scroll half page backward" },
		},
		{ "i", "<C-BS>", "<C-w>", { desc = "delete word forward" } },
		{ { "n", "i" }, "<C-s>", "<CMD>w<CR><CMD>stopinsert<CR>", { desc = "save file" } },
		-- { 'n', 'yw',          'yiw',    { desc = 'copy the word where cursor locates' } },
		-- { 'v', '>',           'gv',    { desc = 'while keeping virtual mode after ' } },
		-- { 'v', '<',           '<gv',    { desc = 'indent while keeping virtual mode after ' } },
		{ "n", "<Backspace>", "ciw", { desc = "delete word and edit in normal mode" } },
		{ "v", "<Backspace>", "c", { desc = "delete and edit in visual mode" } },
	},
	cmd = {
		-- { { 'n', 'v' }, ';',         ':',            { nowait = true, desc = 'enter commandline mode' } },
		-- { { 'n', 'v' }, ']',         '*',            { nowait = true, desc = 'search forward for the word where the cursor is located' } },
		-- { { 'n', 'v' }, '[',         '#',            { nowait = true, desc = 'search backward for the word where the cursor is located' } },
		-- { 'n',          '<leader>q', 'q1',           { desc = 'record macro to register 1' } },
		{ "n", "<C-q>", utils.quit_win, { desc = "quit window" } },

		{
			"n",
			"fd",
			function()
				LazyVim.format()
			end,
			{ desc = "format code" },
		},
		-- { 'n',          'Q',         utils.wq_all,   { desc = 'quit all' } },
	},
	fold = {
		-- { 'n', '<CR>',          'za', { desc = 'toggle fold' } },
		-- { 'n', '<2-LeftMouse>', 'za', { desc = 'toggle fold' } },
	},
	modeSwitch = {
		{ "i", "<ESC>", "<C-O><CMD>stopinsert<CR>", { desc = "exit to normal mode while keeping cursor location" } },
	},
}

local Plugin = {
	bufdelete = {
		-- {
		-- 	"n",
		-- 	"<C-q>",
		-- 	function()
		-- 		utils.delete_buf_or_quit()
		-- 	end,
		-- 	{ desc = "delete buffer or quit" },
		-- },
	},
	fzf = {
		{
			"n",
			"sw",
            "<cmd>Telescope live_grep theme=ivy<cr>",
			{ desc = "search word in workspace" },
		},
		{
			"n",
			"sk",
            "<cmd>Telescope keymaps theme=ivy<cr>",
			{ desc = "search key in workspace" },
		},
		{
			"n",
			"sg",
            "<cmd>Telescope git_commits theme=ivy<cr>",
			{ desc = "search commits in workspace" },
		},
		{
			"n",
			"csg",
            "<cmd>Telescope git_bcommits theme=ivy<cr>",
			{ desc = "search commits in current buffer" },
		},
		{
			"n",
			"ss",
            "<cmd>Telescope lsp_workspace_symbols theme=ivy<cr>",
			{ desc = "search workspace symbols" },
		},
		{
			"n",
			"sS",
            "<cmd>Telescope session-lens search_session theme=ivy<cr>",
			{ desc = "search sessions" },
		},
		{
			"n",
			"css",
            "<cmd>Telescope lsp_document_symbols theme=ivy<cr>",
			{ desc = "search document symbols" },
		},

		{
			"n",
			"csw",
            "<cmd>Telescope current_buffer_fuzzy_find theme=ivy<cr>",
			{ desc = "search word in current buffer" },
		},
		
		{
			"n",
			"sf",
            "<cmd>Telescope find_files theme=ivy<cr>",
			{ desc = "search file" },
		},
		{
			"n",
            "sq",
            "<cmd>Telescope quickfix theme=ivy<cr>",
			{ desc = "search quickfix" },
		},
		{
			"n",
			"sd",
            "<cmd>Telescope diagnostics theme=ivy<cr>",
			{ desc = "search diagnostics" },
		},
		{
			"n",
			"csd",
            "<cmd>Telescope diagnostics bufnr=0 theme=ivy<cr>",
			{ desc = "search diagnostics in document" },
		},

		{
			"n",
			"sc",
            "<cmd>Telescope commands theme=ivy<cr>",
			{ desc = "search command" },
		},
		{
			"n",
			"sb",
            "<cmd>Telescope buffers theme=ivy<cr>",
			{ desc = "search buffers" },
		},
		{
			"n",
			"std",
            "<cmd>Telescope lsp_definitions theme=ivy<cr>",
			{ desc = "search definition" },
		},
		{
			"n",
			"st",
            "<cmd>telescope colorscheme theme=ivy<cr>",
			{ desc = "search colorschemes" },
		},
        {
            "n",
            "sj",
            "<cmd>Telescope jumplist theme=ivy<cr>",
            { desc = "search jumplist" },
        },
        {
            "n",
            "sr",
            "<cmd>Telescope lsp_references theme=ivy<cr>",
            { desc = "search search references" },
        },
	},
	edit = {
		{
			"n",
			"<leader>fd",
			function()
				require("conform").format({ lsp_fallback = true })
			end,
			{ desc = "format document" },
		},
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
			"gr",
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
			"gfr",
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
			"gt",
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
				require("dap.ext.vscode").load_launchjs(nil, { server = { "go" } })
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
	term = {
		{
			"n",
			"<C-\\>",
			"<cmd>ToggleTerm<CR>",
			{ desc = "toggle terminal" },
		},
	},
	tree = {
		{
			{ "n", "v" },
			"t",
			"<cmd>Neotree toggle<CR>",
			{ desc = "toggle neotree" },
		},
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

local found_cmake = pcall(require, "cmake-tools")
if found_cmake then
	vim.keymap.set(
		{ "v", "n", "i", "t" },
		"<F5>",
		"<cmd>wa<CR><cmd>if luaeval('require\"cmake-tools\".is_cmake_project()')|call execute('CMakeRun')|else|call execute('TermExec cmd=!!')|endif<CR>",
		{ silent = true }
	)
	vim.keymap.set(
		{ "v", "n", "i", "t" },
		"<F6>",
		"<cmd>wa<CR><cmd>if luaeval('require\"cmake-tools\".is_cmake_project()')|call execute('CMakeStop')|else|call execute('TermExec cmd=\\<C-c>')|endif<CR>",
		{ silent = true }
	)
else
	vim.keymap.set(
		{ "v", "n", "i", "t" },
		"<F5>",
		"<cmd>wa<CR><cmd>call execute('TermExec cmd=!!<')CR>",
		{ silent = true }
	)
	vim.keymap.set(
		{ "v", "n", "i", "t" },
		"<F6>",
		"<cmd>wa<CR><cmd>call execute('TermExec cmd=\\<C-c>')<CR>",
		{ silent = true }
	)
end
if found_cmake then
	vim.keymap.set(
		{ "v", "n", "i", "t" },
		"<F7>",
		"<cmd>if luaeval('require\"cmake-tools\".is_cmake_project() and require\"dap\".session()==nil')|call execute('CMakeDebug')|else|call execute('DapContinue')|endif<CR>",
		{ silent = true }
	)
	vim.keymap.set(
		{ "v", "n", "i", "t" },
		"<F8>",
		"<cmd>if luaeval('require\"cmake-tools\".is_cmake_project() and require\"dap\".session()==nil')|call execute('CMakeStop')|else|call execute('DapTerminate')|endif<CR>",
		{ silent = true }
	)
	vim.keymap.set(
		{ "v", "n", "i", "t" },
		"<F9>",
		"<cmd>CMakeSelectBuildTarget<CR>",
		{ silent = true, desc = "Select CMake build target" }
	)
	vim.keymap.set(
		{ "v", "n", "i", "t" },
		"<F10>",
		"<cmd>CMakeSelectLaunchTarget<CR>",
		{ silent = true, desc = "Select CMake launch target" }
	)
else
	vim.keymap.set({ "v", "n", "i", "t" }, "<F9>", "<cmd>DapContinue<CR>", { silent = true })
	vim.keymap.set({ "v", "n", "i", "t" }, "<F21>", "<cmd>DapTerminate<CR>", { silent = true })
end
