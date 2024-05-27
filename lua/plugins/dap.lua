return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
		},
		config = function()
			local dap, dapui = require("dap"), require("dapui")
			require("dapui").setup({
				layouts = {
					{
						elements = {
							-- Elements can be strings or table with id and size keys.
							{ id = "scopes", size = 0.35 },
							"breakpoints",
							"stacks",
							"watches",
						},
						size = 0.4,
						position = "right",
					},
					{
						elements = { "repl", "console" },
						size = 0.3, -- 25% of total lines
						position = "bottom",
					},
				},
				floating = {
					max_height = nil, -- These can be integers or a float between 0 and 1.
					max_width = nil, -- Floats will be treated as percentage of your screen.
					border = "single", -- Border style. Can be "single", "double" or "rounded"
					mappings = { close = { "q", "<Esc>" } },
				},
				windows = { indent = 1 },
				controls = { enabled = true },
			})
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open({})
			end
			-- dap.listeners.before.event_terminated["dapui_config"] = function()
			-- 	dapui.close({})
			-- end
			-- dap.listeners.before.event_exited["dapui_config"] = function()
			-- 	dapui.close({})
			-- end

			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					-- CHANGE THIS to your path!
					command = "codelldb",
					args = { "--port", "${port}" },

					-- On windows you may have to uncomment this:
					-- detached = false,
				},
				render = {
					-- Hide variable types as C++'s are verbose
					max_type_length = 0,
				},
			}
			-- dlv debug -l 127.0.0.1:65510 --headless . -- param1 param2 param3 ...
			dap.adapters.delve = {
				type = "server",
				port = "${port}",
				executable = {
					command = "dlv",
					args = { "dap", "-l", "127.0.0.1:${port}" },
				},
			}

			-- dap.adapters.python = function(cb, config)
			-- 	if config.request == "attach" then
			-- 		local port = (config.connect or config).port
			-- 		local host = "127.0.0.1"
			-- 		cb({
			-- 			type = "server",
			-- 			port = assert(port, "`connect.port` is required for a python `attach` configuration"),
			-- 			host = host,
			-- 			options = { source_filetype = "python" },
			-- 		})
			-- 	else
			-- 		cb({
			-- 			type = "executable",
			-- 			command = os.getenv("VIRTUAL_ENV") .. "/bin/python",
			-- 			args = { "-m", "debugpy.adapter" },
			-- 			options = { source_filetype = "python" },
			-- 		})
			-- 	end
			-- end

			-- dap.configurations.python = {
			-- 	{
			-- 		type = "python",
			-- 		request = "launch",
			-- 		name = "Launch file",
			--
			-- 		program = "${file}",
			-- 		pythonPath = function()
			-- 			local cwd = vim.fn.getcwd()
			-- 			if vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
			-- 				return cwd .. "/.venv/bin/python"
			-- 			else
			-- 				return "/usr/bin/python"
			-- 			end
			-- 		end,
			-- 	},
			-- }
			vim.api.nvim_set_hl(0, "DapStopLine", { fg = "#000000", bg = "#e0af68" })
			vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "ErrorMsg" })
			vim.fn.sign_define("DapStopped", {
				text = "",
				texthl = "WarningMsg",
				linehl = "DapStopLine",
			})
			require("nvim-dap-virtual-text").setup({ show_stop_reason = true })
		end,
	},
}
