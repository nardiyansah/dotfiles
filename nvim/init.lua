-- README
-- Structure File:
-- 1. Bootstrap lazy.nvim
-- 2. Plugins
-- 3. Keymaps
-- 4. Autocommands
-- 5. Options
--
-- Each section begin with:
-- ### SECTION_NAME ###

-- ### BOOTSTRAP lazy.nvim ###
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

-- ### PLUGINS ###
require("lazy").setup({
  spec = {
    -- add your plugins here
    {
      "folke/lazydev.nvim",
      ft = "lua", -- only load on lua files
      opts = {
        library = {
          -- See the configuration section for more details
          -- Load luvit types when the `vim.uv` word is found
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      },
    },
    {
		"mason-org/mason-lspconfig.nvim",
		opts = {},
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},
	},
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.8',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			require('telescope').setup{
				defaults = require('telescope.themes').get_dropdown()
			}
		end
	},
	{
		'akinsho/toggleterm.nvim',
		version = "*",
		opts = {
			open_mapping = [[<c-\>]],
			direction = 'float'
		}
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {}
	},
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {}
	}
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

-- ### KEYMAPS ###
-- netrw
vim.keymap.set('n', '<leader>e', ':Explore<Enter>', { desc = 'Netrw Explorer' })
-- telescope
local telebuiltin = require('telescope.builtin')

vim.keymap.set('n', '<leader>t', ':Telescope<Enter>', { desc = 'Telescope' })

-- find files
vim.keymap.set('n', '<leader>ff', telebuiltin.find_files, { desc = '[F]ind [F]iles' })
-- grep text in files
vim.keymap.set('n', '<leader>fg', telebuiltin.live_grep, { desc = '[F]ind by [Grep]' })
-- search in current buffer
vim.keymap.set('n', '<leader>fb', telebuiltin.current_buffer_fuzzy_find, { desc = '[F]ind in [B]uffer' })
-- search recent files
vim.keymap.set('n', '<leader>fr', telebuiltin.oldfiles, { desc = '[F]ind [R]ecent files' })

-- Go to definition (lists definitions in Telescope)
vim.keymap.set('n', 'gd', telebuiltin.lsp_definitions, { desc = '[G]oto [D]efinition' })
-- Find references
vim.keymap.set('n', 'gr', telebuiltin.lsp_references, { desc = '[G]oto [R]eferences' })
-- List implementations (for interfaces)
vim.keymap.set('n', 'gi', telebuiltin.lsp_implementations, { desc = '[G]oto [I]mplementation' })
-- LSP diagnostics (errors/warnings)
vim.keymap.set('n', '<leader>fd', telebuiltin.diagnostics, { desc = '[F]ind [D]iagnostics' })
-- LSP symbols (e.g., functions, classes)
vim.keymap.set('n', '<leader>fs', telebuiltin.lsp_document_symbols, { desc = '[F]ind [S]ymbols' })

-- harpoon
local harpoon = require('harpoon')

vim.keymap.set('n', '<leader>h', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = 'Harpoon' })
vim.keymap.set('n', '<leader>a', function() harpoon:list():add() end, { desc = 'Harpoon add' })

-- diagnostic
vim.keymap.set('n', '<leader>sd', vim.diagnostic.open_float, { desc = '[S]how [D]iagnostic in Line' })

-- ### AUTOCOMMANDS ###

-- ### OPTIONS ###
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.scrolloff = 8

-- diagnostic
vim.diagnostic.config({ float = { border = 'rounded' } })

-- netrw
vim.g.netrw_liststyle = 3
