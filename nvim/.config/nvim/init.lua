-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out,                            "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Options
vim.o.number = true
vim.o.relativenumber = true
vim.o.shiftwidth = 4
vim.o.smarttab = true
vim.o.scrolloff = 10
vim.o.tabstop = 4
vim.o.hidden = true
vim.o.clipboard = 'unnamed'

-- Mappings

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- add your plugins here
		{
			"williamboman/mason.nvim",
			opts = {},
		},
		{
			"neovim/nvim-lspconfig",
			config = function()
				vim.api.nvim_create_autocmd('LspAttach', {
					callback = function(args)
						local client = vim.lsp.get_client_by_id(args.data.client_id)
						if not client then
							return
						end
						if client.supports_method('textDocument/formatting') then
							vim.api.nvim_create_autocmd('BufWritePre', {
								callback = function()
									vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
								end
							})
						end
					end
				})
			end
		},
		{
			"williamboman/mason-lspconfig.nvim",
			opts = function()
				require("mason-lspconfig").setup({
					ensure_installed = { "lua_ls", "pyright" },
				})

				require("mason-lspconfig").setup_handlers {
					function(server_name)
						require("lspconfig")[server_name].setup {}
					end,
				}
			end,
		},
		{
			"folke/lazydev.nvim",
			ft = "lua",
			opts = {
				library = {
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
		{
			"saghen/blink.cmp",
			dependencies = "rafamadriz/friendly-snippets",
			version = "*",
			opts = {
				keymap = {
					preset = "super-tab",
					['<C-j>'] = { 'select_next', 'fallback' },
					['<C-k>'] = { 'select_prev', 'fallback' },
				},
				sources = {
					default = { "lsp", "path", "snippets", "buffer" },
				},
			},
			opts_extend = { "sources.default" }
		},
		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			opts = function()
				local configs = require("nvim-treesitter.configs")

				configs.setup({
					ensure_installed = { "lua", "go", "python" },
					highlight = { enable = true },
					indent = { enable = true },
				})
			end
		},
		{
			"nvim-telescope/telescope.nvim",
			branch = "0.1.x",
			dependencies = {
				"nvim-lua/plenary.nvim"
			},
			config = function()
				local wk = require('which-key')
				wk.add({
					{ '<leader>t',  group = 'telescope' },
					{ '<leader>tf', desc = 'find files', mode = 'n' },
					{ '<leader>tl', desc = 'live grep',  mode = 'n' },
				})

				vim.keymap.set('n', '<leader>tf', require('telescope.builtin').find_files)
				vim.keymap.set('n', '<leader>tl', require('telescope.builtin').live_grep)
			end
		},
		{
			"folke/noice.nvim",
			event = "VeryLazy",
			dependencies = {
				"MunifTanjim/nui.nvim",
				-- OPTIONAL:
				--   `nvim-notify` is only needed, if you want to use the notification view.
				--   If not available, we use `mini` as the fallback
				"rcarriga/nvim-notify",
			},
			opts = {},
		},
		{
			"nvim-tree/nvim-tree.lua",
			version = "*",
			lazy = false,
			dependencies = {
				"nvim-tree/nvim-web-devicons",
			},
			config = function()
				local function my_on_attach(bufnr)
					local api = require("nvim-tree.api")

					api.config.mappings.default_on_attach(bufnr)

					local wk = require('which-key')
					wk.add({
						{ '<leader>d', group = 'nvim-tree', icon = '❐' },
						{ '<leader>dt', desc = 'toggle side tree' }
					})

					vim.keymap.set("n", "<leader>dt", api.tree.toggle)
				end

				require("nvim-tree").setup({
					on_attach = my_on_attach,
				})
			end
		},
		{
			"folke/which-key.nvim",
			event = "VeryLazy",
			opts = {
				preset = 'helix',
			},
		},
		{
			"akinsho/toggleterm.nvim",
			version = "*",
			opts = {
				open_mapping = [[<c-\>]],
				direction = 'float'
			}
		}
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "habamax" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})
