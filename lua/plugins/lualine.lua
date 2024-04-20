-- Eviline config for lualine
-- Author: shadmansaleh
-- Credit: glepnir
local lualine = require("lualine")

-- Color table for highlights
-- stylua: ignore
local colors = {
  bg       = '#202328',
  fg       = '#bbc2cf',
  yellow   = '#ECBE7B',
  cyan     = '#008080',
  darkblue = '#081633',
  green    = '#98be65',
  orange   = '#FF8800',
  violet   = '#a9a1e1',
  magenta  = '#c678dd',
  blue     = '#51afef',
  red      = '#ec5f67',
}

local conditions = {
	buffer_not_empty = function()
		return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
	end,
	hide_in_width = function()
		return vim.fn.winwidth(0) > 80
	end,
	check_git_workspace = function()
		local filepath = vim.fn.expand("%:p:h")
		local gitdir = vim.fn.finddir(".git", filepath .. ";")
		return gitdir and #gitdir > 0 and #gitdir < #filepath
	end,
}

-- Config
local config = {
	options = {
		-- Disable sections and component separators
		component_separators = "",
		section_separators = "",
		theme = {
			-- We are going to use lualine_c an lualine_x as left and
			-- right section. Both are highlighted by c theme .  So we
			-- are just setting default looks o statusline
			normal = { c = { fg = colors.fg, bg = colors.bg } },
			inactive = { c = { fg = colors.fg, bg = colors.bg } },
		},
	},
	sections = {
		-- these are to remove the defaults
		lualine_a = {},
		lualine_b = {},
		lualine_y = {},
		-- These will be filled later
		lualine_c = {},
		lualine_z = {},
		lualine_x = {},
	},
	inactive_sections = {
		-- these are to remove the defaults
		lualine_a = {},
		lualine_b = {},
		lualine_y = {},
		lualine_z = {},
		lualine_c = {},
		lualine_x = {},
	},
}

-- Inserts a component in lualine_c at left section
local function ins_left(component)
	table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x at right section
local function ins_right(component)
	table.insert(config.sections.lualine_x, component)
end

ins_left({
	function()
		return "▊"
	end,
	color = { fg = colors.blue }, -- Sets highlighting of component
	padding = { left = 0, right = 1 }, -- We don't need space before this
})

ins_left({
	-- mode component
	function()
		return ""
	end,
	color = function()
		-- auto change color according to neovims mode
		local mode_color = {
			n = colors.red,
			i = colors.green,
			v = colors.blue,
			[""] = colors.blue,
			V = colors.blue,
			c = colors.magenta,
			no = colors.red,
			s = colors.orange,
			S = colors.orange,
			[""] = colors.orange,
			ic = colors.yellow,
			R = colors.violet,
			Rv = colors.violet,
			cv = colors.red,
			ce = colors.red,
			r = colors.cyan,
			rm = colors.cyan,
			["r?"] = colors.cyan,
			["!"] = colors.red,
			t = colors.red,
		}
		return { fg = mode_color[vim.fn.mode()] }
	end,
	padding = { right = 1 },
})

ins_left({
	-- filesize component
	"filesize",
	cond = conditions.buffer_not_empty,
})

ins_left({
	"filename",
	cond = conditions.buffer_not_empty,
	color = { fg = colors.magenta, gui = "bold" },
})

ins_left({ "location" })

ins_left({ "progress", color = { fg = colors.fg, gui = "bold" } })

ins_left({
	"diagnostics",
	sources = { "nvim_diagnostic" },
	symbols = { error = " ", warn = " ", info = " " },
	diagnostics_color = {
		color_error = { fg = colors.red },
		color_warn = { fg = colors.yellow },
		color_info = { fg = colors.cyan },
	},
})
local cmake = require("cmake-tools")
-- Insert mid section. You can make any number of sections in neovim :)
-- for lualine it's any number greater then 2
ins_left({
	function()
		local c_preset = cmake.get_configure_preset()
		return "CMake: [" .. (c_preset and c_preset or "No Configure") .. "]"
	end,
	cond = function()
		return cmake.is_cmake_project() and cmake.has_cmake_preset()
	end,
	on_click = function(n, mouse)
		if n == 1 then
			if mouse == "l" then
				vim.cmd("CMakeSelectConfigurePreset")
			end
		end
	end,
})

ins_left({
	function()
		local type = cmake.get_build_type()
		return "CMake: [" .. (type and type or "") .. "]"
	end,
	cond = function()
		return cmake.is_cmake_project() and not cmake.has_cmake_preset()
	end,
	on_click = function(n, mouse)
		if n == 1 then
			if mouse == "l" then
				vim.cmd("CMakeSelectBuildType")
			end
		end
	end,
})

ins_left({
	function()
		local kit = cmake.get_kit()
		return "{" .. (kit and kit or "No Kit") .. "}"
	end,
	cond = function()
		return cmake.is_cmake_project() and not cmake.has_cmake_preset()
	end,
	on_click = function(n, mouse)
		if n == 1 then
			if mouse == "l" then
				vim.cmd("CMakeSelectKit")
			end
		end
	end,
})

ins_left({
	function()
		local b_preset = cmake.get_build_preset()
		return "[" .. (b_preset and b_preset or "No Preset") .. "]"
	end,
	cond = function()
		return cmake.is_cmake_project() and cmake.has_cmake_preset()
	end,
	on_click = function(n, mouse)
		if n == 1 then
			if mouse == "l" then
				vim.cmd("CMakeSelectBuildPreset")
			end
		end
	end,
})

ins_left({
	function()
		local b_target = cmake.get_build_target()
		return "<" .. (b_target and b_target or "No Build Target") .. ">"
	end,
	cond = cmake.is_cmake_project,
	on_click = function(n, mouse)
		if n == 1 then
			if mouse == "l" then
				vim.cmd("CMakeSelectBuildTarget")
			end
		end
	end,
})

ins_left({
	function()
		local l_target = cmake.get_launch_target()
		return "(" .. (l_target and l_target or "No Launch Taget") .. ")"
	end,
	cond = cmake.is_cmake_project,
	on_click = function(n, mouse)
		if n == 1 then
			if mouse == "l" then
				vim.cmd("CMakeSelectLaunchTarget")
			end
		end
	end,
})
ins_left({
	function()
		return "%="
	end,
})

-- ins_left({
-- 	-- Lsp server name .
-- 	function()
-- 		local msg = "No Active Lsp"
-- 		local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
-- 		local clients = vim.lsp.get_active_clients()
-- 		if next(clients) == nil then
-- 			return msg
-- 		end
-- 		for _, client in ipairs(clients) do
-- 			local filetypes = client.config.filetypes
-- 			if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
-- 				return client.name
-- 			end
-- 		end
-- 		return msg
-- 	end,
-- 	icon = " LSP:",
-- 	color = { fg = "#ffffff", gui = "bold" },
-- })
-- function lsp_progress()
--     local colors = {
--   yellow = '#ECBE7B',
--   cyan = '#008080',
--   darkblue = '#081633',
--   green = '#98be65',
--   orange = '#FF8800',
--   violet = '#a9a1e1',
--   magenta = '#c678dd',
--   blue = '#51afef',
--   red = '#ec5f67'
-- }
--
-- local config = {
--   options = {
--     icons_enabled = true,
--     theme = 'gruvbox',
--     component_separators = {'', ''},
--     section_separators = {'', ''},
--     disabled_filetypes = {}
--   },
--   sections = {
--     lualine_a = {'mode'},
--     lualine_b = {'filename'},
--     lualine_c = {},
--     lualine_x = {},
--     lualine_y = {'encoding', 'fileformat', 'filetype'},
--     lualine_z = {'branch'},
--   },
--   inactive_sections = {
--     lualine_a = {},
--     lualine_b = {},
--     lualine_c = {'filename'},
--     lualine_x = {'location'},
--     lualine_y = {},
--     lualine_z = {}
--   },
--   tabline = {},
--   extensions = {}
-- }
--
-- end
-- Add components to right sections
ins_right(require("plugins/components/lsp_progress"))
ins_right({
	"o:encoding", -- option component same as &encoding in viml
	fmt = string.upper, -- I'm not sure why it's upper case either ;)
	cond = conditions.hide_in_width,
	color = { fg = colors.green, gui = "bold" },
})

ins_right({
	"fileformat",
	fmt = string.upper,
	icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
	color = { fg = colors.green, gui = "bold" },
})

ins_right({
	"branch",
	icon = "",
	color = { fg = colors.violet, gui = "bold" },
})

ins_right({
	"diff",
	-- Is it me or the symbol for modified us really weird
	symbols = { added = " ", modified = "󰝤 ", removed = " " },
	diff_color = {
		added = { fg = colors.green },
		modified = { fg = colors.orange },
		removed = { fg = colors.red },
	},
	cond = conditions.hide_in_width,
})

ins_right({
	function()
		return "▊"
	end,
	color = { fg = colors.blue },
	padding = { left = 1 },
})

return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"folke/tokyonight.nvim",
			"folke/noice.nvim",
		},
		event = "UIEnter",
		config = function()
			config.options.them = "tokyonight"
			require("lualine").setup(config)
		end,
	},
}
