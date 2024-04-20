return {
	{
		"iamcco/markdown-preview.nvim",
		event = "VeryLazy",
		lazy = true,
		ft = "markdown",
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		config = function()
			vim.g.mkdp_browser = "min-browser"
			vim.g.mkdp_auto_close = 0
			vim.g.mkdp_combine_preview = 1
		end,
	},
}
