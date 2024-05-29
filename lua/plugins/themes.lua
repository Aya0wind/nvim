return {
	"mofiqul/vscode.nvim",
	lazy = false,
	enabled = true,
	config = function()
		local c = require("vscode.colors").get_colors()
		require("vscode").setup({
			-- alternatively set style in setup
			-- style = 'light'

			-- enable transparent background
			transparent = true,

			-- enable italic comment
			italic_comments = true,

			-- underline `@markup.link.*` variants
			underline_links = true,

			-- override highlight groups (see ./lua/vscode/theme.lua)
			group_overrides = {
				-- this supports the same val table as vim.api.nvim_set_hl
				-- use colors from this colorscheme by requiring vscode.colors!
				cursor = { fg = c.vscdarkblue, bg = c.vsclightgreen, bold = true },
			},
		})
		vim.cmd.colorscheme("vscode")
	end,
	-- require("plugins.themes.vscode"),
}
