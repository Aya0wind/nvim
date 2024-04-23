local found_cmake, cmake = pcall(require, "cmake-tools")
if not found_cmake then cmake = {is_cmake_project = function() return false end} end
local icons = require("config.icons")

local conditions = {
    buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
    end,
    hide_in_width = function() return vim.fn.winwidth(0) > 80 end,
    check_git_workspace = function()
        local filepath = vim.fn.expand('%:p:h')
        local gitdir = vim.fn.finddir('.git', filepath .. ';')
        return gitdir and #gitdir > 0 and #gitdir < #filepath
    end
}
local c = {
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
                if not b_preset then return icons.cmake.CMake end
                return icons.cmake.CMake .. string.format(" [%s]", b_preset)
            else
                local b_type = cmake.get_build_type()
                if not b_type then return icons.cmake.CMake end
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
        end
    }, {
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
                            cmake.build({target = l_target})
                            return
                        end
                        cmake.build({target = "all"})
                    else
                        cmake.build({})
                    end
                elseif mouse == "r" then
                    cmake.select_build_target()
                end
            end
        end
    }, {
        function() return icons.cmake.Debug end,
        cond = cmake.is_cmake_project,
        on_click = function(n, mouse)
            if n == 1 then
                if mouse == "l" then
                    local l_target = cmake.get_launch_target()
                    if not l_target then
                        local b_target = cmake.get_build_target()
                        if b_target then
                            cmake.debug({target = b_target})
                            return
                        end
                    end
                    cmake.debug({})
                elseif mouse == "r" then
                    cmake.select_launch_target()
                end
            end
        end
    }, {
        function()
            local l_target = cmake.get_launch_target()
            if not l_target then return icons.cmake.Run end
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
                            cmake.run({target = b_target})
                            return
                        end
                    end
                    cmake.run({})
                elseif mouse == "r" then
                    cmake.select_launch_target()
                end
            end
        end
    }
}
local xmake_component = {
    function()
        local xmake = require("xmake.project_config").info
        if xmake.target.tg == "" then return "" end
        return xmake.target.tg .. "(" .. xmake.mode .. ")"
    end,

    cond = function()
        return pcall(require, "xmake.project_config") -- and vim.o.columns > 100
    end,

    on_click = function()
        require("xmake.project_config._menu").init() -- Add the on-click ui
    end
}

local diagnostics = {
    "diagnostics",
    cond = function() return vim.fn.winwidth(0) > 80 end
}
local branch = {
    "branch",
    on_click = function(n, mouse)
        if n == 1 then if mouse == "l" then vim.cmd([[Neogit]]) end end
    end
}
local diff = {"diff", cond = function() return vim.fn.winwidth(0) > 80 end}
local cdate = {"cdate", cond = function() return vim.fn.winwidth(0) > 80 end}
local ctime = {"ctime", cond = function() return vim.fn.winwidth(0) > 80 end}
local encoding = {
    "encoding",
    fmt = string.upper,
    cond = function()
        return vim.fn.winwidth(0) > 80 and "utf-8" ~= vim.o.fileencoding
    end
}
diagnostics.symbols = {
    error = icons.diagnostics.Error,
    warn = icons.diagnostics.Warning,
    info = icons.diagnostics.Information,
    hint = icons.diagnostics.Question
}
branch.icon = icons.git.Branch
diff.symbols = {added = " ", modified = " ", removed = " "}
local config = {
    options = {theme = "vscode"},
    sections = {
        lualine_a = {"mode"},
        lualine_b = {
            branch, diff, diagnostics, c[1], c[2], c[3], c[4],
        },
		lualine_c = {},
		lualine_x = {},
		lualine_y = {require("plugins.components.lsp_progress")},
        lualine_z = {"location",encoding,cdate, ctime, }
    }
}
-- Inserts a component in lualine_c at left section
local function ins_left(component)
    table.insert(config.sections.lualine_b, component)
end

-- Inserts a component in lualine_x at right section
local function ins_right(component)
    table.insert(config.sections.lualine_z, component)
end
ins_right {
    -- filesize component
    'filesize',
    cond = conditions.buffer_not_empty
}
-- Add components to right sections
ins_right({
    "o:encoding", -- option component same as &encoding in viml
    fmt = string.upper, -- I'm not sure why it's upper case either ;)
    cond = conditions.hide_in_width,
    color = {gui = "bold"}
})
return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {"folke/tokyonight.nvim", "folke/noice.nvim"},
        event = "UIEnter",
        config = function() require("lualine").setup(config) end
    }
}
