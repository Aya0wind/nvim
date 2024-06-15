return {
	"akinsho/bufferline.nvim",
	config = function()
		require("bufferline").setup({
			highlights = require("catppuccin.groups.integrations.bufferline").get(),
			options = {
				custom_areas = {
					right = function()
						return vim.tbl_map(function(item)
							return { text = item }
						end, require("edgy-group.stl").get_statusline("right"))
					end,
				},
				close_command = "bp|sp|bn|bd! %d",
				right_mouse_command = "bp|sp|bn|bd! %d",
				left_mouse_command = "buffer %d",
				buffer_close_icon = "",
				modified_icon = "",
				close_icon = "",
				show_close_icon = false,
				left_trunc_marker = "",
				right_trunc_marker = "",
				max_name_length = 16,
				max_prefix_length = 15,
				tab_size = 12,
				show_tab_indicators = true,
				indicator = {
					style = "underline",
				},
				enforce_regular_tabs = false,
				-- view = "multiwindow",
				show_buffer_close_icons = true,
				separator_style = "thin",
				-- separator_style = "slant",
				always_show_bufferline = true,
				themable = true,
				diagnostics = "nvim_lsp",
				diagnostics_indicator = function(count, level, diagnostics_dict, context)
					local icon = level:match("error") and " " or " "
					return icon .. count
				end,
				custom_filter = function(buf_number, buf_numbers)
					if vim.bo[buf_number].filetype ~= "oil" then
						return true
					end
				end,
				-- offsets = {
				-- 	{
				-- 		filetype = "NeoTree",
				-- 		text = "Files",
				-- 		text_align = "center",
				-- 		highlight = "Directory",
				-- 		separator = true,
				-- 	},
				-- },
			},
		})

		-- Buffers belong to tabs
		local cache = {}
		local last_tab = 0

		local utils = {}

		utils.is_valid = function(buf_num)
			if not buf_num or buf_num < 1 then
				return false
			end
			local exists = vim.api.nvim_buf_is_valid(buf_num)
			return vim.bo[buf_num].buflisted and exists
		end

		utils.get_valid_buffers = function()
			local buf_nums = vim.api.nvim_list_bufs()
			local ids = {}
			for _, buf in ipairs(buf_nums) do
				if utils.is_valid(buf) then
					ids[#ids + 1] = buf
				end
			end
			return ids
		end

		local autocmd = vim.api.nvim_create_autocmd
		local function close_empty_unnamed_buffers()
			-- Get a list of all buffers
			local buffers = vim.api.nvim_list_bufs()
			-- Iterate over each buffer
			for _, bufnr in ipairs(buffers) do
				-- Check if the buffer is empty and doesn't have a name
				if
					vim.api.nvim_buf_is_loaded(bufnr)
					and vim.api.nvim_buf_get_name(bufnr) == ""
					and vim.api.nvim_buf_get_option(bufnr, "buftype") == ""
				then
					-- Get all lines in the buffer
					local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

					-- Initialize a variable to store the total number of characters
					local total_characters = 0

					-- Iterate over each line and calculate the number of characters
					for _, line in ipairs(lines) do
						total_characters = total_characters + #line
					end

					-- Close the buffer if it's empty:
					if total_characters == 0 then
						vim.api.nvim_buf_delete(bufnr, {
							force = true,
						})
					end
				end
			end
		end

		-- Clear the mandatory, empty, unnamed buffer when a real file is opened:
		autocmd("BufReadPost", {
			callback = close_empty_unnamed_buffers,
		})
		autocmd("TabEnter", {
			callback = function()
				local tab = vim.api.nvim_get_current_tabpage()
				local buf_nums = cache[tab]
				if buf_nums then
					for _, k in pairs(buf_nums) do
						vim.api.nvim_buf_set_option(k, "buflisted", true)
					end
				end
			end,
		})
		autocmd("TabLeave", {
			callback = function()
				local tab = vim.api.nvim_get_current_tabpage()
				local buf_nums = utils.get_valid_buffers()
				cache[tab] = buf_nums
				for _, k in pairs(buf_nums) do
					vim.api.nvim_buf_set_option(k, "buflisted", false)
				end
				last_tab = tab
			end,
		})
		autocmd("TabClosed", {
			callback = function()
				cache[last_tab] = nil
			end,
		})
		autocmd("TabNewEntered", {
			callback = function()
				vim.api.nvim_buf_set_option(0, "buflisted", true)
			end,
		})
	end,
}
