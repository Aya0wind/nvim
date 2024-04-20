return {
	{
		"famiu/bufdelete.nvim",
		event = "VeryLazy",
	},
	{
		"ojroques/nvim-osc52",
		config = function()
			require("osc52").setup({
				max_length = 0, -- Maximum length of selection (0 for no limit)
				silent = true, -- Disable message on successful copy
				trim = true, -- Trim surrounding whitespaces before copy
			})
		end,
	},
	{
		"nathom/filetype.nvim",
		lazy = true,
		event = "User FileOpened",
		config = function()
			require("filetype").setup({
				overrides = {
					extensions = {
						h = "cpp",
					},
				},
			})
		end,
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		keys = {
			{ "s", false },
		},
		config = function()
			require("flash").setup({
				labels = "abcdefghijklmnopqrstuvwxyz0123456789",
				label = {
					rainbow = {
						enabled = true,
						-- number between 1 and 9
						shade = 5,
					},
					uppercase = true,
				},
				modes = {
					-- options used when flash is activated through
					-- a regular search with `/` or `?`
					search = {
						enabled = true, -- enable flash for search
					},
					-- options used when flash is activated through
					-- `f`, `F`, `t`, `T`, `;` and `,` motions
					char = {
						enabled = false,
					},
					-- options used for treesitter selections
					-- `require("flash").treesitter()`
					treesitter = {
						labels = "abcdefghijklmnopqrstuvwxyz0123456789",
						label = { before = true, after = true, style = "inline" },
						jump = { pos = "range" },
						highlight = {
							backdrop = false,
							matches = false,
						},
					},
					-- options used for remote flash
					remote = {
						remote_op = { restore = true, motion = true },
					},
				},
				-- options for the floating window that shows the prompt,
				-- for regular jumps
				prompt = {
					enabled = false,
				},
				jump = {
					pos = "start",
					autojump = false,
				},
			})
		end,
	},
}
