return {
	{
		"ibhagwan/fzf-lua",
		lazy = false,
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
