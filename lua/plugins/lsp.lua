local function check_version()
	if vim.fn.has("nvim-0.10.0") == 1 then
		return true
	else
		return false
	end
end

local have_inlay_hints = check_version()

return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			{
				"williamboman/mason-lspconfig.nvim",
				opt = { automatic_installation = true },
			},
		},
		opts = {
			inlay_hints = { enabled = true },
			code_lens = { enabled = true },
		},
		config = function()
			local lspconfig = require("lspconfig")
			require("java").setup()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local other_servers = {
				"gopls",
				"pyright",
				"lua_ls",
				"dockerls",
				"bashls",
				"ruff_lsp",
				"jsonls",
				"marksman",
				"clangd",
				"jdtls",
				"bashls",
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
					code_action = "💡",
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
		enabled = have_inlay_hints,
		dependencies = { "neovim/nvim-lspconfig" },
		config = function()
			require("inlay-hints").setup()
		end,
	},
}
