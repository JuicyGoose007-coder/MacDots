-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Core Nvim configuration
require("options")
require("ui")
-- require("statusline")
require("autocmds")
require("keymaps")

-- Install
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind

		if name == "nvim-treesitter" and kind ~= "delete" then
			-- On install this fires before the plugin is on rtp.
			if not ev.data.active then
				vim.cmd.packadd("nvim-treesitter")
			end
			require("nvim-treesitter").update()
		end
	end,
})

local gh = function(x)
	return "https://github.com/" .. x
end

vim.pack.add({
	gh("sainnhe/gruvbox-material"),
	gh("savq/melange-nvim"),
	{
		src = gh("nvim-treesitter/nvim-treesitter"),
		version = "main",
	},
	gh("pisgahk/muted.nvim"),
	gh("nvim-mini/mini.icons"),
	gh("nvim-mini/mini.pairs"),
	gh("nvim-mini/mini.visits"),
	gh("nvim-mini/mini.files"),
	gh("ibhagwan/fzf-lua"),
	gh("jiaoshijie/undotree"),
	gh("lewis6991/gitsigns.nvim"),
	gh("stevearc/conform.nvim"),
	{
		src = gh("Saghen/blink.cmp"),
		version = vim.version.range("1.*"),
	},
	gh("folke/which-key.nvim"),
	gh("folke/lazydev.nvim"),
	gh("folke/snacks.nvim"),
	gh("folke/trouble.nvim"),
	gh("folke/flash.nvim"),
	gh("christoomey/vim-tmux-navigator"),
	-- Default mappings are <C-h/j/k/l>, which is what ~/.config/tmux/tmux.conf
	-- hands over when the pane's foreground command is nvim.
	gh("rachartier/tiny-cmdline.nvim"),
	gh("rachartier/tiny-inline-diagnostic.nvim"),
	gh("wansmer/treesj"),
	gh("abecodes/tabout.nvim"),
	gh("kevinhwang91/nvim-hlslens"),
	gh("akinsho/bufferline.nvim"),
	gh("nvim-lualine/lualine.nvim"),
	{ src = "https://codeberg.org/comfysage/jamjar.nvim" },
})

-- Plugins
require("colorscheme")
require("plugins.icons")
require("plugins.pairs")
require("plugins.files")
require("plugins.treesitter")
require("plugins.fzf")
require("plugins.visits")
require("plugins.undotree")
require("plugins.gitsigns")
require("plugins.conform")
require("plugins.blink")
require("plugins.hlslens")
require("plugins.treesj")
require("plugins.tabout")
require("plugins.whichkey")
require("plugins.lazydev")
require("plugins.trouble")
require("plugins.flash")
require("plugins.snacks")
require("plugins.tiny-inline-diagnostic")
require("plugins.jamjar")
require("plugins.bufferline")
require("plugins.lualine")

-- Lsp
require("lsp")
