local function check_version()
	if vim.fn.has("nvim-0.10.0") == 1 then
		return true
	else
		return false
	end
end

local icons = require("config.icons")
return {
	{
		"neovim/nvim-lspconfig",
		event = "LazyFile",
		dependencies = {
			"williamboman/mason.nvim",
			{
				"williamboman/mason-lspconfig.nvim",
				opts = { automatic_installation = true },
			},
		},
		opts = {
			inlay_hints = { enabled = true },
			code_lens = { enabled = true },
			diagnostics = {
				underline = true,
				update_in_insert = false,
				virtual_text = {
					spacing = 4,
					source = "if_many",
					prefix = "●",
					-- this will set set the prefix to a function that returns the diagnostics icon based on the severity
					-- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
					-- prefix = "icons",
				},
				severity_sort = true,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
						[vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
						[vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
						[vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
					},
				},
			},
		},
		config = function(_, opts)
			local lspconfig = require("lspconfig")
			if vim.fn.has("nvim-0.10.0") == 0 then
				for severity, icon in pairs(opts.diagnostics.signs.text) do
					local name = vim.diagnostic.severity[severity]:lower():gsub("^%l", string.upper)
					name = "DiagnosticSign" .. name
					vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
				end
			end

			-- inlay hints
			if opts.inlay_hints.enabled then
				LazyVim.lsp.on_attach(function(client, buffer)
					if client.supports_method("textDocument/inlayHint") then
						LazyVim.toggle.inlay_hints(buffer, true)
					end
				end)
			end

			-- code lens
			if opts.codelens.enabled and vim.lsp.codelens then
				LazyVim.lsp.on_attach(function(client, buffer)
					if client.supports_method("textDocument/codeLens") then
						vim.lsp.codelens.refresh()
						--- autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh()
						vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
							buffer = buffer,
							callback = vim.lsp.codelens.refresh,
						})
					end
				end)
			end

			if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
				opts.diagnostics.virtual_text.prefix = vim.fn.has("nvim-0.10.0") == 0 and "●"
					or function(diagnostic)
						local icons = icons.diagnostics
						for d, icon in pairs(icons) do
							if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
								return icon
							end
						end
					end
			end

			vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

			local servers = opts.servers
			local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
			local capabilities = vim.tbl_deep_extend(
				"force",
				{},
				vim.lsp.protocol.make_client_capabilities(),
				has_cmp and cmp_nvim_lsp.default_capabilities() or {},
				opts.capabilities or {}
			)

			local function setup(server)
				local server_opts = vim.tbl_deep_extend("force", {
					capabilities = vim.deepcopy(capabilities),
				}, servers[server] or {})

				if opts.setup[server] then
					if opts.setup[server](server, server_opts) then
						return
					end
				elseif opts.setup["*"] then
					if opts.setup["*"](server, server_opts) then
						return
					end
				end
				require("lspconfig")[server].setup(server_opts)
			end

			-- get all the servers that are available through mason-lspconfig
			local have_mason, mlsp = pcall(require, "mason-lspconfig")
			local all_mslp_servers = {}
			if have_mason then
				all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
			end

			local ensure_installed = {} ---@type string[]
			for server, server_opts in pairs(servers) do
				if server_opts then
					server_opts = server_opts == true and {} or server_opts
					-- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
					if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
						setup(server)
					elseif server_opts.enabled ~= false then
						ensure_installed[#ensure_installed + 1] = server
					end
				end
			end
            if pcall(require, "java") then
                require("java").setup()
            end
			if have_mason then
				mlsp.setup({
					ensure_installed = vim.tbl_deep_extend(
						"force",
						ensure_installed,
						LazyVim.opts("mason-lspconfig.nvim").ensure_installed or {}
					),
					handlers = { setup },
				})
			end
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local other_servers = {
				"lua_ls",
				"bashls",
				"clangd",
			}
			capabilities.offsetEncoding = { "utf-16" }
			for _, server in ipairs(other_servers) do
				lspconfig[server].setup({
					capabilities = capabilities,
				})
			end
			lspconfig.clangd.setup({
				capabilities = capabilities,
				cmd = {
					"clangd",
					"--background-index",
					"--compile-commands-dir=build",
					"--clang-tidy",
					"--header-insertion=iwyu",
					"--completion-style=detailed",
					"--function-arg-placeholders",
					"-j=8",
					"--fallback-style=llvm",
				},
				root_dir = lspconfig.util.root_pattern(
					".clangd",
					".clang-tidy",
					".clang-format",
					"compile_commands.json",
					"compile_flags.txt",
					"configure.ac",
					".git"
				),
				on_new_config = function(new_config, new_cwd)
					local status, cmake = pcall(require, "cmake-tools")
					if status then
						cmake.clangd_on_new_config(new_config)
					end
				end,
				single_file_support = true,
			})
			-- lspconfig.jdtls.setup({
			-- 	capabilities = capabilities,
			-- 	hint = { enable = true },
			-- 	settings = {
			-- 		java = {
			-- 			configuration = {
			-- 				runtimes = {
			-- 					{
			-- 						name = "OpenJDK-17",
			-- 						path = "/usr/bin/java",
			-- 						default = true,
			-- 					},
			-- 				},
			-- 			},
			-- 		},
			-- 	},
			-- })
		end,
		-- dont use any event, as new created file will not have lsp attached
	},
	-- {
	-- 	"nvimtools/none-ls.nvim",
	-- 	config = function()
	-- 		local null_ls = require("null-ls")
	-- 		null_ls.setup({
	-- 			sources = {
	-- 				null_ls.builtins.formatting.prettier,
	-- 				null_ls.builtins.formatting.black,
	-- 				null_ls.builtins.formatting.gofumpt,
	-- 				null_ls.builtins.diagnostics.golangci_lint,
	-- 			},
	-- 		})
	-- 	end,
	-- 	event = "LspAttach",
	-- },
	{
		"glepnir/lspsaga.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lspsaga").setup({
				ui = {
					code_action = "",
					colors = {
						normal_bg = "NONE",
					},
				},
				symbol_in_winbar = {
					separator = "›",
					hide_keyword = true,
				},
				code_action = {
					keys = {
						quit = { "q", "<ESC>" },
						exec = "<CR>",
					},
				},
				definition = {
					keys = {
						edit = "<CR>",
						vsplit = "v",
						split = "s",
						tabe = "t",
						-- can only use string here
						quit = "<ESC>",
					},
				},
				rename = {
					keys = {
						quit = "<ESC>",
						exec = "<CR>",
					},
				},
				finder = {
					max_height = 0.5,
					min_width = 30,
					force_max_height = false,
					keys = {
						jump_to = "g",
						toggle_or_open = "<CR>",
						vsplit = "v",
						split = "s",
						tabe = "t",
						quit = { "q", "<ESC>" },
					},
				},
			})
		end,
		event = "LspAttach",
	},
	{
		"MysticalDevil/inlay-hints.nvim",
		event = "LspAttach",
		enabled = check_version(),
		dependencies = { "neovim/nvim-lspconfig" },
		config = function()
			require("inlay-hints").setup()
		end,
	},
}
