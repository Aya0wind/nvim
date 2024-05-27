return {
	{ "trouble.nvim", enabled = false },
	{ "nvim-tree/nvim-tree.lua", enabled = false },
	{
		"ibhagwan/fzf-lua",
		lazy = false,
		enabled = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("fzf-lua").setup({
				winopts = {
					preview = {
						layout = "horizontal",
					},
				},
			})
		end,
	},
}
