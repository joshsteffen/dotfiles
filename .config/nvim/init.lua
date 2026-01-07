--
-- mini.nvim
--

local mini_path = vim.fn.stdpath("data") .. "/site/pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/echasnovski/mini.nvim",
		mini_path,
	})
	vim.cmd("packadd mini.nvim | helptags ALL")
end

--
-- Plugins that just work
--

require("mini.deps").setup({})
require("mini.diff").setup({})
require("mini.icons").setup({})
require("mini.statusline").setup({})
require("mini.tabline").setup({})
MiniDeps.add({ source = "tpope/vim-sleuth" })
MiniDeps.add({ source = "dstein64/vim-startuptime" })

MiniDeps.later(function()
	require("mini.ai").setup({})
	require("mini.bracketed").setup({})
	require("mini.extra").setup({})
	require("mini.files").setup({})
	require("mini.git").setup({})
	require("mini.pick").setup({})
	require("mini.trailspace").setup({})
	MiniDeps.add({ source = "OXY2DEV/markview.nvim" })
	MiniDeps.add({ source = "kevinhwang91/nvim-bqf" })
	MiniDeps.add({ source = "tpope/vim-surround" })
	MiniDeps.add({ source = "folke/which-key.nvim" })
end)

--
-- Plugins that need some configuration
--

require("mini.basics").setup({
	extra_ui = true,
})
vim.o.cursorline = false

MiniDeps.later(function()
	require("mini.misc").setup({})
	MiniMisc.setup_auto_root()
	MiniMisc.setup_restore_cursor()
	MiniMisc.setup_termbg_sync()
end)

-- nvim-treesitter
MiniDeps.add({ source = "nvim-treesitter/nvim-treesitter" })
require("nvim-treesitter.configs").setup({
	ensure_installed = { "c", "lua", "markdown", "python", "rust" },
	highlight = { enable = true },
	indent = { enable = true },
})

MiniDeps.later(function()
	-- blink.cmp
	MiniDeps.add({
		source = "saghen/blink.cmp",
		depends = { "rafamadriz/friendly-snippets" },
		checkout = "v1.8.0",
	})
	require("blink.cmp").setup({
		keymap = { preset = "super-tab" },
		signature = { enabled = true },
	})

	-- fidget
	MiniDeps.add({ source = "j-hui/fidget.nvim" })
	require("fidget").setup({})

	-- flash
	MiniDeps.add({ source = "folke/flash.nvim" })
	require("flash").setup({
		modes = {
			search = { enabled = true },
			char = { enabled = false },
		},
	})

	-- neogit
	MiniDeps.add({
		source = "NeogitOrg/neogit",
		depends = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
	})
	require("neogit").setup({})

	-- lazydev
	MiniDeps.add({ source = "folke/lazydev.nvim" })
	require("lazydev").setup({
		library = {
			{ path = "${3rd}/luv/library" },
		},
	})

	-- mason / lspconfig
	MiniDeps.add({ source = "williamboman/mason.nvim" })
	MiniDeps.add({ source = "williamboman/mason-lspconfig.nvim" })
	MiniDeps.add({ source = "neovim/nvim-lspconfig" })
	require("mason").setup()
	require("mason-lspconfig").setup()

	-- multicursor.nvim
	MiniDeps.add({ source = "jake-stewart/multicursor.nvim" })
	require("multicursor-nvim").setup({})

	-- nvim-autopairs
	MiniDeps.add({ source = "windwp/nvim-autopairs" })
	require("nvim-autopairs").setup({
		ignored_next_char = "%S",
	})
end)

--
-- LSP
--

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = { disable = { "missing-fields" } },
		},
	},
})

vim.lsp.config("pylsp", {
	settings = {
		pylsp = {
			plugins = {
				autopep8 = { enabled = false },
				black = { enabled = true },
				isort = { enabled = false },
				pycodestyle = { maxLineLength = 88 },
			},
		},
	},
})

vim.lsp.config("rust_analyzer", {
	settings = {
		["rust-analyzer"] = {
			check = { command = "clippy" },
		},
	},
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = event.buf,
			callback = function()
				if not vim.g.disable_autoformat then
					vim.lsp.buf.format({ id = event.data.client_id })
				end
			end
		})
	end,
})

--
-- Key bindings
--

vim.g.maplocalleader = vim.g.mapleader

vim.keymap.set("n", "<C-p>", "<Cmd>Pick files<CR>")

vim.keymap.set("n", "<Leader>b", "<Cmd>Pick buffers<CR>", { desc = "Find buffer" })
vim.keymap.set("n", "<Leader>c", "<Cmd>bdelete<CR>", { desc = "Close buffer" })
vim.keymap.set("n", "<Leader>C", "<Cmd>edit $MYVIMRC<CR>", { desc = "Edit config" })
vim.keymap.set("n", "<Leader>g", "<Cmd>Pick grep_live<CR>", { desc = "Grep" })

vim.keymap.set("n", "\\f", function()
	vim.g.disable_autoformat = not vim.g.disable_autoformat
end, { desc = "Toggle autoformat" })

vim.keymap.set("n", "\\i", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle inlay hints" })

vim.keymap.set("n", "\\o", function()
	MiniDiff.toggle_overlay(0)
end, { desc = "Toggle diff overlay" })

vim.keymap.set("t", "<C-[><C-[>", "<C-\\><C-n>")

-- Multiple cursors
MiniDeps.later(function()
	local mc = require("multicursor-nvim")

	vim.keymap.set({ "n", "x" }, "<Up>", function() mc.lineAddCursor(-1) end)
	vim.keymap.set({ "n", "x" }, "<Down>", function() mc.lineAddCursor(1) end)
	vim.keymap.set({ "n", "x" }, "<Leader>m", mc.operator,
		{ desc = "Multiple cursor operator" })
	vim.keymap.set({ "n", "x" }, "<Leader>n", function() mc.matchAddCursor(1) end,
		{ desc = "Add cursor at next match" })
	vim.keymap.set({ "n", "x" }, "<Leader>N", function() mc.matchAddCursor(-1) end,
		{ desc = "Add cursor at previous match" })
	vim.keymap.set({ "n", "x" }, "<C-q>", mc.toggleCursor)

	vim.keymap.set("n", "<M-LeftMouse>", mc.handleMouse)
	vim.keymap.set("n", "<M-LeftDrag>", mc.handleMouseDrag)
	vim.keymap.set("n", "<M-LeftRelease>", mc.handleMouseRelease)

	mc.addKeymapLayer(function(layerSet)
		layerSet({ "n", "x" }, "<Left>", mc.prevCursor)
		layerSet({ "n", "x" }, "<Right>", mc.nextCursor)
		layerSet({ "n", "x" }, "<Leader>a", mc.alignCursors, { desc = "Align cursors" })
		layerSet({ "n", "x" }, "<Leader>x", mc.deleteCursor, { desc = "Delete cursor" })
		layerSet("n", "<Esc>", function()
			if not mc.cursorsEnabled() then
				mc.enableCursors()
			else
				mc.clearCursors()
			end
		end)
	end)
end)

--
-- Miscellaneous
--

vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.softtabstop = 4

-- Only highlight matches while searching
vim.o.hlsearch = false
vim.api.nvim_create_autocmd("CmdLineEnter", { pattern = "/,\\?", command = "set hlsearch" })
vim.api.nvim_create_autocmd("CmdLineLeave", { pattern = "/,\\?", command = "set nohlsearch" })

-- Persist colorscheme
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		pcall(vim.cmd.colorscheme, vim.g.COLORSCHEME)
	end
})
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function(args)
		vim.g.COLORSCHEME = args.match
	end
})
