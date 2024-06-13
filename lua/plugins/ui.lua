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
	-- 	"rcarriga/nvim-notify",
	-- 	config = function()
	-- 		require("notify").setup({
	-- 			background_colour = "#000000",
	-- 		})
	-- 	end,
	-- },
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
					right_mouse_command = "bdelete! %d",
					right_trunc_marker = "",
					show_close_icon = true,
					show_tab_indicators = true,
					offsets = {
						{
							filetype = "NeoTree",
							text = "Files",
							text_align = "center",
							highlight = "Directory",
							separator = true,
						},
					},
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
		-- opts = {
		-- 	direction = "vertical",
		-- },
		config = function()
			require("toggleterm").setup({
				-- size can be a number or function which is passed the current terminal
				size = function(term)
					if term.direction == "horizontal" then
						return 10
					elseif term.direction == "vertical" then
						return vim.o.columns * 0.4
					end
				end,
				open_mapping = [[<F8>]],
				hide_numbers = true, -- hide the number column in toggleterm buffers
				shade_filetypes = {},
				-- shade_terminals = true,
				shading_factor = "1", -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
				start_in_insert = true,
				insert_mappings = true, -- whether or not the open mapping applies in insert mode
				terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
				persist_size = true,
				-- direction = "vertical",
				-- direction = 'vertical',
				close_on_exit = true, -- close the terminal window when the process exits
				-- This field is only relevant if direction is set to 'float'
				float_opts = {
					-- The border key is *almost* the same as 'nvim_open_win'
					-- see :h nvim_open_win for details on borders however
					-- the 'curved' border is a custom border type
					-- not natively supported but implemented in this plugin.
					border = "curved",
					width = 80,
					height = 25,
					winblend = 3,
				},
			})

			-- local Terminal = require('toggleterm.terminal').Terminal

			function _G.set_terminal_keymaps()
				local opts = { buffer = 0 }
				vim.keymap.set("n", "<Esc>", [[<Cmd>quit<CR>]], opts)
				vim.keymap.set("n", "q", [[<Cmd>quit<CR>]], opts)
				vim.keymap.set("n", "<C-c>", [[<Cmd>startinsert<CR><C-c>]], opts)
				vim.keymap.set("n", "<CR>", [[<Cmd>startinsert<CR>]], opts)
				vim.keymap.set("n", "<Up>", [[<Cmd>startinsert<CR><Up>]], opts)
				vim.keymap.set("n", "<Down>", [[<Cmd>startinsert<CR><Down>]], opts)
				vim.keymap.set("n", "<Right>", [[<Cmd>startinsert<CR><Right>]], opts)
				vim.keymap.set("n", "<Left>", [[<Cmd>startinsert<CR><Left>]], opts)
				vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], opts)
				-- vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
				vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
				vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
				vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
				vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
			end

			-- if you only want these mappings for toggle term use term://*toggleterm#* instead
			vim.cmd("autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()")
		end,
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
