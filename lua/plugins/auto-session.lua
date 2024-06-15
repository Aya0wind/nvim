return {
	{
		"rmagatti/auto-session",
        lazy = false,
		config = function()
			require("auto-session").setup({
				log_level = "error",
				auto_session_enable_last_session = false,
				auto_session_enabled = true,
				auto_restore_enabled = true,
				post_cwd_changed_hook = function() -- example refreshing the lualine status line _after_ the cwd changes
					require("lualine").refresh() -- refresh lualine so the new session name is displayed in the status bar
				end,
				post_restore_cmds = { "Neotree dir=" .. vim.fn.getcwd() },
				auto_clean_after_session_restore = false,
			})
		end,
	},
	{
		"rmagatti/session-lens",
        lazy = false,
		requires = { "rmagatti/auto-session", "nvim-telescope/telescope.nvim" },
		config = function()
			require("session-lens").setup({--[[your custom config--]]
			})
		end,
	},
}
