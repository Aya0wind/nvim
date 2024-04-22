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
		end,
		lazy = false,
	},
	-- {
	-- 	"folke/tokyonight.nvim",
	-- 	lazy = true,
	-- 	priority = 1000,
	-- 	enabled = true,
	-- 	config = function()
	-- 		require("tokyonight").setup({
	-- 			style = "night",
	-- 			styles = {
	-- 				comments = { italic = true },
	-- 				keywords = { italic = true },
	-- 				functions = {},
	-- 				variables = {},
	-- 				sidebars = "transparent",
	-- 				floats = "transparent",
	-- 			},
	--
	-- 			on_colors = function(colors)
	-- 				colors.border = "#565f89"
	-- 				-- colors.bg_statusline = colors.none
	-- 			end,
	-- 			on_highlights = function(hl, c)
	-- 				hl.Folded = {
	-- 					fg = "#7aa2f7",
	-- 					bg = nil,
	-- 				}
	-- 				hl.VerticalSplit = {
	-- 					fg = "#565f89",
	-- 					bg = nil,
	-- 				}
	-- 				-- popup menu transparent
	-- 				hl.Pmenu = {
	-- 					bg = nil,
	-- 				}
	-- 			end,
	-- 		})
	-- 		-- vim.cmd("colorscheme tokyonight")
	-- 	end,
	-- },
	{
		"akinsho/bufferline.nvim",
		dependencies = {
			"folke/tokyonight.nvim",
		},
		event = "UIEnter",
		config = function()
			require("bufferline").setup({
				options = {
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
					enforce_regular_tabs = true,
					tab_size = 14,
					buffer_close_icon = "X",
					close_command = "bdelete %d",
					close_icon = "X",
					indicator = {
						style = "icon",
						icon = " ",
					},
					left_trunc_marker = "",
					modified_icon = "●",
					offsets = { { filetype = "NvimTree", text = "EXPLORER", text_align = "center" } },
					right_mouse_command = "bdelete! %d",
					right_trunc_marker = "",
					show_close_icon = true,
					show_tab_indicators = true,
				},
				highlights = {
					fill = {
						fg = { attribute = "fg", highlight = "Normal" },
						bg = { attribute = "bg", highlight = "StatusLineNC" },
					},
					background = {
						fg = { attribute = "fg", highlight = "Normal" },
						bg = { attribute = "bg", highlight = "StatusLine" },
					},
					buffer_visible = {
						fg = { attribute = "fg", highlight = "Normal" },
						bg = { attribute = "bg", highlight = "Normal" },
					},
					buffer_selected = {
						fg = { attribute = "fg", highlight = "Normal" },
						bg = { attribute = "bg", highlight = "Normal" },
					},
					separator = {
						fg = { attribute = "bg", highlight = "Normal" },
						bg = { attribute = "bg", highlight = "StatusLine" },
					},
					separator_selected = {
						fg = { attribute = "fg", highlight = "Special" },
						bg = { attribute = "bg", highlight = "Normal" },
					},
					separator_visible = {
						fg = { attribute = "fg", highlight = "Normal" },
						bg = { attribute = "bg", highlight = "StatusLineNC" },
					},
					close_button = {
						fg = { attribute = "fg", highlight = "Normal" },
						bg = { attribute = "bg", highlight = "StatusLine" },
					},
					close_button_selected = {
						fg = { attribute = "fg", highlight = "Normal" },
						bg = { attribute = "bg", highlight = "Normal" },
					},
					close_button_visible = {
						fg = { attribute = "fg", highlight = "Normal" },
						bg = { attribute = "bg", highlight = "Normal" },
					},
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
					{
						filter = {
							event = "msg_show",
							find = "nvim-notify",
						},
						opts = { skip = true },
					},
				},
			})
		end,
	},
}
