return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"williamboman/mason.nvim",
		},
		config = function()
			require("mason").setup()
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local other_servers =
				{ "gopls", "pyright", "lua_ls", "dockerls", "bashls", "ruff_lsp", "jsonls", "marksman" }
			for _, server in ipairs(other_servers) do
				lspconfig[server].setup({
					capabilities = capabilities,
				})
			end
			capabilities.offsetEncoding = { "utf-16" }
			lspconfig.clangd.setup({
				capabilities = capabilities,
				cmd = {
					"clangd",
					"--background-index",
					"--compile-commands-dir=build/Debug",
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
		end,
		-- dont use any event, as new created file will not have lsp attached
		lazy = false,
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
					code_action = "󱓈 ",
					colors = {
						normal_bg = "NONE",
					},
				},
				symbol_in_winbar = {
					separator = "›",
					hide_keyword = true,
				},
				lightbulb = {
					virtual_text = false,
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
	-- {
	-- 	"p00f/clangd_extensions.nvim",
	-- 	config = function()
	-- 		require("clangd_extensions").setup({
	-- 			inlay_hints = {
	-- 				inline = vim.fn.has("nvim-0.10") == 1,
	-- 				-- Options other than `highlight' and `priority' only work
	-- 				-- if `inline' is disabled
	-- 				-- Only show inlay hints for the current line
	-- 				only_current_line = false,
	-- 				-- Event which triggers a refresh of the inlay hints.
	-- 				-- You can make this { "CursorMoved" } or { "CursorMoved,CursorMovedI" } but
	-- 				-- not that this may cause  higher CPU usage.
	-- 				-- This option is only respected when only_current_line and
	-- 				-- autoSetHints both are true.
	-- 				only_current_line_autocmd = { "CursorHold" },
	-- 				-- whether to show parameter hints with the inlay hints or not
	-- 				show_parameter_hints = true,
	-- 				-- prefix for parameter hints
	-- 				parameter_hints_prefix = "<- ",
	-- 				-- prefix for all the other hints (type, chaining)
	-- 				other_hints_prefix = "=> ",
	-- 				-- whether to align to the length of the longest line in the file
	-- 				max_len_align = false,
	-- 				-- padding from the left if max_len_align is true
	-- 				max_len_align_padding = 1,
	-- 				-- whether to align to the extreme right or not
	-- 				right_align = false,
	-- 				-- padding from the right if right_align is true
	-- 				right_align_padding = 7,
	-- 				-- The color of the hints
	-- 				highlight = "Comment",
	-- 				-- The highlight group priority for extmark
	-- 				priority = 100,
	-- 			},
	-- 			ast = {
	-- 				-- These are unicode, should be available in any font
	-- 				role_icons = {
	-- 					type = "🄣",
	-- 					declaration = "🄓",
	-- 					expression = "🄔",
	-- 					statement = ";",
	-- 					specifier = "🄢",
	-- 					["template argument"] = "🆃",
	-- 				},
	-- 				kind_icons = {
	-- 					Compound = "🄲",
	-- 					Recovery = "🅁",
	-- 					TranslationUnit = "🅄",
	-- 					PackExpansion = "🄿",
	-- 					TemplateTypeParm = "🅃",
	-- 					TemplateTemplateParm = "🅃",
	-- 					TemplateParamObject = "🅃",
	-- 				},
	-- 				--[[ These require codicons (https://github.com/microsoft/vscode-codicons)
	--            role_icons = {
	--                type = "",
	--                declaration = "",
	--                expression = "",
	--                specifier = "",
	--                statement = "",
	--                ["template argument"] = "",
	--            },
	--
	--            kind_icons = {
	--                Compound = "",
	--                Recovery = "",
	--                TranslationUnit = "",
	--                PackExpansion = "",
	--                TemplateTypeParm = "",
	--                TemplateTemplateParm = "",
	--                TemplateParamObject = "",
	--            }, ]]
	--
	-- 				highlights = {
	-- 					detail = "Comment",
	-- 				},
	-- 			},
	-- 			memory_usage = {
	-- 				border = "none",
	-- 			},
	-- 			symbol_info = {
	-- 				border = "none",
	-- 			},
	-- 		})
	-- 	end,
	-- 	event = "LspAttach",
	-- },
}
