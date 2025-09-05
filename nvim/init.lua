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
		opts = {
			ensure_installed = { 'gopls', 'lua_ls' },
		},
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},
	},
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.8',
		dependencies = { 'nvim-lua/plenary.nvim' },
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
	},
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		opts = {}
	},
	{
		'nvim-treesitter/nvim-treesitter',
	    lazy = false,
		branch = 'master',
		build = ':TSUpdate',
	},
	{
		"LintaoAmons/bookmarks.nvim",
		tag = "3.2.0",
		dependencies = {
			 {"kkharji/sqlite.lua"},
			 {"nvim-telescope/telescope.nvim"},
			 {
				 "ahmedkhalf/project.nvim",
				 config = function()
					 require("project_nvim").setup{}
				 end
			 }
		 },
		 config = function()
			 local opts = {}
			 require("bookmarks").setup(opts)
		 end
	 },
	 {
		 'stevearc/oil.nvim',
		 opts = {
			 view_options = { show_hidden = true }
		 },
		 lazy = false,
	 },
	 {
		 'folke/noice.nvim',
		 event = 'VeryLazy',
		 opts = {}
	 }
  },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

require 'nvim-treesitter.configs'.setup {
	ensure_installed = { 'lua', 'go' },
	highlight = { enable = true }
}

-- go setting
local lspconfig = require('lspconfig')
lspconfig.gopls.setup({
	settings = {
		gopls = {
			gofumpt = true
		}
	}
})

-- ### KEYMAPS ###
-- trigger omni autocomplete
vim.keymap.set('i', '<C-Space>', '<C-x><C-o>', { desc = 'Autocomplete' })

-- for jump backward and forward
vim.keymap.set('n', '<D-[>', '<C-o>', { desc = 'Jump Backward' })
vim.keymap.set('n', '<D-]>', '<C-i>', { desc = 'Jump Forward' })

-- remove some keymaps because I don't like it. see lsp-defaults
vim.keymap.del('n','grn')
vim.keymap.del('n','grr')
vim.keymap.del('n','gra')
vim.keymap.del('n','gri')
-- netrw
vim.keymap.set('n', '<leader>e', ':Oil<Enter>', { desc = 'Oil Explorer' })
-- telescope
local telebuiltin = require('telescope.builtin')

vim.keymap.set('n', '<leader>t', ':Telescope<Enter>', { desc = 'Telescope' })

-- find files
vim.keymap.set('n', '<leader>ff', telebuiltin.find_files, { desc = '[F]ind [F]iles' })
-- grep text in files
vim.keymap.set('n', '<D-S-f>', telebuiltin.live_grep, { desc = 'Find grep' })
-- search in current buffer
vim.keymap.set('n', '<D-f>', telebuiltin.current_buffer_fuzzy_find, { desc = 'Find in current buffer' })
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

-- bookmarks
vim.keymap.set({'v','n'}, '<leader>mm', '<cmd>BookmarksMark<cr>', { desc = 'Mark Add' })
vim.keymap.set({'v','n'}, '<leader>ml', '<cmd>BookmarksGoto<cr>', { desc = 'Mark List' })
vim.keymap.set({'v','n'}, '<leader>md', function() require('bookmarks.commands').delete_mark_of_current_file() end, { desc = 'Mark Clear' })

-- ### AUTOCOMMANDS ###
-- autocompletion
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})

vim.api.nvim_create_autocmd({ "VimEnter", "BufEnter" }, {
	group = vim.api.nvim_create_augroup("BookmarksGroup", {}),
    pattern = { "*" },
	callback = function()
	  local project_root = require("project_nvim.project").get_project_root()
	  if not project_root then
		return
	  end

	  local project_name = string.gsub(project_root, "^" .. os.getenv("HOME") .. "/", "")
	  local Service = require("bookmarks.domain.service")
	  local Repo = require("bookmarks.domain.repo")
	  local bookmark_list = nil

	  for _, bl in ipairs(Repo.find_lists()) do
		if bl.name == project_name then
		  bookmark_list = bl
		  break
		end
	  end

	  if not bookmark_list then
		bookmark_list = Service.create_list(project_name)
	  end
	  Service.set_active_list(bookmark_list.id)
	  require("bookmarks.sign").safe_refresh_signs()
	end
})

-- set auto import and formatting from go official: https://go.dev/gopls/editor/vim#neovim-imports
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = {only = {"source.organizeImports"}}
    -- buf_request_sync defaults to a 1000ms timeout. Depending on your
    -- machine and codebase, you may want longer. Add an additional
    -- argument after params if you find that you have to write the file
    -- twice for changes to be saved.
    -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format({async = false})
  end
})

-- ### OPTIONS ###
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.scrolloff = 8
vim.opt.winborder = 'rounded'

-- diagnostic
vim.diagnostic.config({ float = { border = 'rounded' } })

-- netrw
vim.g.netrw_liststyle = 3

-- select option for autocompletion
vim.cmd("set completeopt+=fuzzy,noinsert")

-- colorscheme
vim.cmd[[colorscheme habamax]]

