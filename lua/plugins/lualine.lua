local found_cmake, cmake = pcall(require, "cmake-tools")
if not found_cmake then
	cmake = {
		is_cmake_project = function()
			return false
		end,
	}
end
local icons = require("config.icons")
local config = {
	options = { icons_enabled = true, component_separators = "", section_separators = "" },
	sections = {
		lualine_a = { "mode" },
		lualine_b = {},
		lualine_c = {},
		lualine_x = { require("plugins.components.lsp_progress") },
		lualine_y = {},
		lualine_z = {},
	},
}

local colors = {
	bg = "#202328",
	fg = "#bbc2cf",
	yellow = "#ECBE7B",
	cyan = "#008080",
	darkblue = "#081633",
	green = "#98be65",
	orange = "#FF8800",
	violet = "#a9a1e1",
	magenta = "#c678dd",
	blue = "#51afef",
	red = "#ec5f67",
}
-- Inserts a component in lualine_c at left section
local function ins_left(component)
	table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x at right section
local function ins_right(component)
	table.insert(config.sections.lualine_x, component)
end

-- ins_left({
-- 	function()
-- 		return "▊"
-- 	end,
-- 	color = { fg = colors.blue }, -- Sets highlighting of component
-- 	padding = { left = 0, right = 1 }, -- We don't need space before this
-- })
-- ins_left({
-- 	-- mode component
-- 	function()
-- 		return ""
-- 	end,
-- 	color = function()
-- 		-- auto change color according to neovims mode
-- 		local mode_color = {
-- 			n = colors.red,
-- 			i = colors.green,
-- 			v = colors.blue,
-- 			[""] = colors.blue,
-- 			V = colors.blue,
-- 			c = colors.magenta,
-- 			no = colors.red,
-- 			s = colors.orange,
-- 			S = colors.orange,
-- 			[""] = colors.orange,
-- 			ic = colors.yellow,
-- 			R = colors.violet,
-- 			Rv = colors.violet,
-- 			cv = colors.red,
-- 			ce = colors.red,
-- 			r = colors.cyan,
-- 			rm = colors.cyan,
-- 			["r?"] = colors.cyan,
-- 			["!"] = colors.red,
-- 			t = colors.red,
-- 		}
-- 		return { fg = mode_color[vim.fn.mode()] }
-- 	end,
-- 	padding = { right = 1 },
-- })

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
local cmake = {
	-- {
	--     function()
	--         local kit = cmake.get_kit()
	--         return string.format("[%s]", kit)
	--     end,
	--     icon = icons.ui.Pencil,
	--     cond = function()
	--         return cmake.is_cmake_project() and cmake.get_kit()
	--     end,
	--     on_click = function(n, mouse)
	--         if (n == 1) then
	--             if (mouse == "l") then
	--                 vim.cmd("CMakeSelectKit")
	--             elseif (mouse == "r") then
	--                 vim.cmd("edit CMakeKits.json")
	--             end
	--         end
	--     end
	-- },
	{
		function()
			if cmake.has_cmake_preset() then
				local b_preset = cmake.get_build_preset()
				if not b_preset then
					return icons.cmake.CMake
				end
				return icons.cmake.CMake .. string.format(" [%s]", b_preset)
			else
				local b_type = cmake.get_build_type()
				if not b_type then
					return icons.cmake.CMake
				end
				return icons.cmake.CMake .. string.format(" [%s]", b_type)
			end
		end,
		cond = cmake.is_cmake_project,
		on_click = function(n, mouse)
			if n == 1 then
				if mouse == "l" then
					cmake.generate({})
				elseif mouse == "r" then
					if cmake.has_cmake_preset() then
						cmake.select_build_preset()
					else
						cmake.select_build_type()
					end
				end
			end
		end,
	},
	{
		function()
			local b_target = cmake.get_build_target()
			if not b_target or b_target == "all" then
				return icons.cmake.Build
			end
			return icons.cmake.Build .. string.format(" [%s]", b_target)
		end,
		cond = cmake.is_cmake_project,
		on_click = function(n, mouse)
			if n == 1 then
				if mouse == "l" then
					local b_target = cmake.get_build_target()
					if not b_target then
						local l_target = cmake.get_launch_target()
						if l_target then
							cmake.build({ target = l_target })
							return
						end
						cmake.build({ target = "all" })
					else
						cmake.build({})
					end
				elseif mouse == "r" then
					cmake.select_build_target()
				end
			end
		end,
	},
	{
		function()
			return icons.cmake.Debug
		end,
		cond = cmake.is_cmake_project,
		on_click = function(n, mouse)
			if n == 1 then
				if mouse == "l" then
					local l_target = cmake.get_launch_target()
					if not l_target then
						local b_target = cmake.get_build_target()
						if b_target then
							cmake.debug({ target = b_target })
							return
						end
					end
					cmake.debug({})
				elseif mouse == "r" then
					cmake.select_launch_target()
				end
			end
		end,
	},
	{
		function()
			local l_target = cmake.get_launch_target()
			if not l_target then
				return icons.cmake.Run
			end
			return icons.cmake.Run .. string.format(" [%s]", l_target)
		end,
		cond = cmake.is_cmake_project,
		on_click = function(n, mouse)
			if n == 1 then
				if mouse == "l" then
					local l_target = cmake.get_launch_target()
					if not l_target then
						local b_target = cmake.get_build_target()
						if b_target then
							cmake.run({ target = b_target })
							return
						end
					end
					cmake.run({})
				elseif mouse == "r" then
					cmake.select_launch_target()
				end
			end
		end,
	},
}
ins_left({
	"branch",
	icon = "",
	color = { fg = colors.violet, gui = "bold" },
	on_click = function(n, mouse)
		if n == 1 then
			if mouse == "l" then
				LazyVim.lazygit({ cwd = LazyVim.root.git() })
			end
		end
	end,
})

ins_left({
	"diff",
	symbols = { added = " ", modified = "󰝤 ", removed = " " },
	diff_color = {
		added = { fg = colors.green },
		modified = { fg = colors.orange },
		removed = { fg = colors.red },
	},
	cond = conditions.hide_in_width,
})

ins_left(cmake[1])
ins_left(cmake[2])
ins_left(cmake[3])
ins_left(cmake[4])

local xmake_component = {
	function()
		local xmake = require("xmake.project_config").info
		if xmake.target.tg == "" then
			return ""
		end
		return xmake.target.tg .. "(" .. xmake.mode .. ")"
	end,

	cond = function()
		return pcall(require, "xmake.project_config") -- and vim.o.columns > 100
	end,

	on_click = function()
		require("xmake.project_config._menu").init() -- Add the on-click ui
	end,
}

local diagnostics = {
	"diagnostics",
	cond = function()
		return vim.fn.winwidth(0) > 80
	end,
}
diagnostics.symbols = {
	error = icons.diagnostics.Error,
	warn = icons.diagnostics.Warning,
	info = icons.diagnostics.Information,
	hint = icons.diagnostics.Question,
}
ins_left(diagnostics)
ins_right(require('auto-session.lib').current_session_name)
ins_right({
	-- filesize component
	"filesize",
	cond = conditions.buffer_not_empty,
	colors = { fg = colors.violet, gui = "bold" },
})
ins_right({
	"o:encoding", -- option component same as &encoding in viml
	fmt = string.upper, -- I'm not sure why it's upper case either ;)
	cond = conditions.hide_in_width,
	color = { fg = colors.green, gui = "bold" },
})

ins_right({
	"fileformat",
	fmt = string.upper,
	icons_enabled = true, -- i think icons are cool but eviline doesn't have them. sigh
	color = { fg = colors.yellow, gui = "bold" },
})
if pcall(require, "copilot") then
	ins_right("copilot")
end
ins_right({
	"filetype",
	icons_enabled = true, -- i think icons are cool but eviline doesn't have them. sigh
})
ins_right({
	function()
		return "▊"
	end,
	color = { fg = colors.blue },
	padding = { left = 1 },
})
ins_right({
	"location",
	color = { fg = colors.blue },
})
return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "folke/noice.nvim", "AndreM222/copilot-lualine","rmagatti/auto-session" },
		event = "UIEnter",
		config = function()
			require("lualine").setup(config)
		end,
	},
}
