return {
	{
		"EdenEast/nightfox.nvim",
		config = function()
			require("nightfox").setup({
				options = {
					transparent = true,
					styles = {
						comments = "italic",
						keywords = "bold",
						types = "italic,bold",
					},
				},
			})
			vim.cmd("colorscheme carbonfox")
		end,
		lazy = false,
	},
	{
		"folke/tokyonight.nvim",
		lazy = true,
		priority = 1000,
		enabled = true,
		config = function()
			require("tokyonight").setup({
				style = "night",
				styles = {
					comments = { italic = true },
					keywords = { italic = true },
					functions = {},
					variables = {},
					sidebars = "transparent",
					floats = "transparent",
				},

				on_colors = function(colors)
					colors.border = "#565f89"
					-- colors.bg_statusline = colors.none
				end,
				on_highlights = function(hl, c)
					hl.Folded = {
						fg = "#7aa2f7",
						bg = nil,
					}
					hl.VerticalSplit = {
						fg = "#565f89",
						bg = nil,
					}
					-- popup menu transparent
					hl.Pmenu = {
						bg = nil,
					}
				end,
			})
			-- vim.cmd("colorscheme tokyonight")
		end,
	},
	{
		"akinsho/bufferline.nvim",
		dependencies = {
			"folke/tokyonight.nvim",
		},
		event = "UIEnter",
		config = function()
			require("bufferline").setup({
				options = {
					close_command = "Bdelete %d",
					indicator = {
						style = "none",
					},
					name_formatter = function(buf)
						if buf.name:match("%.*") then
							return vim.fn.fnamemodify(buf.name, ":t:r")
						end
					end,
					diagnostics = "nvim_lsp",
					diagnostics_indicator = function(count, level, diagnostics_dict, context)
						local icon = level:match("error") and " " or " "
						return icon .. count
					end,
					offsets = { { filetype = "neo-tree", text = "Neotree", text_align = "center" } },
					enforce_regular_tabs = true,
					tab_size = 14,
				},
			})
		end,
	},
	{
		"akinsho/toggleterm.nvim",
		opts = {
			direction = "float",
		},
		lazy = false,
	},
	{
		"folke/noice.nvim",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		event = "UIEnter",
		config = function()
			require("noice").setup({
				-- cmdline = {
				-- 	view = "cmdline",
				-- },
				lsp = { progress = { enabled = false }, diagnostics = { enabled = false } },
				messages = {
					view = "mini",
				},
				notify = {
					enabled = true,
				},
				presets = {
					bottom_search = true, -- use a classic bottom cmdline for search
					lsp_doc_border = false, -- add a border to hover docs and signature help
				},
				routes = {
					{
						filter = {
							event = "msg_show",
							kind = "",
							find = "written",
						},
						opts = { skip = true },
					},
					{
						filter = {
							event = "msg_show",
							find = "gitsigns",
						},
						opts = { skip = false },
					},
				},
			})
		end,
	},
}
