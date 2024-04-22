return {
	{
		"numToStr/Comment.nvim",
		opts = {
			{
				---Add a space b/w comment and the line
				padding = false,
				---Whether the cursor should stay at its position
				sticky = false,
				---Lines to be ignored while (un)comment
				ignore = nil,
				---LHS of toggle mappings in NORMAL mode
				---Enable keybindings
				toggler = {
					---Line-comment toggle keymap
					line = "gcc",
					---Block-comment toggle keymap
					block = "<C-,>",
				},
				---NOTE: If given `false` then the plugin won't create any mappings
				mappings = {
					---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
					basic = false,
					---Extra mapping; `gco`, `gcO`, `gcA`
					extra = false,
				},
				---Function to call before (un)comment
				pre_hook = nil,
				---Function to call after (un)comment
				post_hook = nil,
			},
		},
	},
	{
		"windwp/nvim-autopairs",
		config = true,
		event = { "InsertEnter" },
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = true,
		event = { "VeryLazy" },
	},
	{
		"danymat/neogen",
		config = true,
	},
	{
		"kylechui/nvim-surround",
		config = function()
			require("nvim-surround").setup({
				keymaps = {
					visual = "fv",
					normal = "fs",
					delete = "fd",
					change = "fc",
				},
				surrounds = {
					["("] = {
						add = { "(", ")" },
						find = function()
							return M.get_selection({ motion = "a(" })
						end,
						delete = "^(.?)().-(?.)()$",
					},
					["{"] = {
						add = { "{", "}" },
						find = function()
							return M.get_selection({ motion = "a{" })
						end,
						delete = "^(.?)().-(?.)()$",
					},
					["["] = {
						add = { "[", "]" },
						find = function()
							return M.get_selection({ motion = "a[" })
						end,
						delete = "^(.?)().-(?.)()$",
					},
					["<"] = {
						add = { "<", ">" },
						find = function()
							return M.get_selection({ motion = "a<" })
						end,
						delete = "^(.?)().-(?.)()$",
					},
				},
			})
		end,
		event = "VeryLazy",
	},
}
