require("nvim-treesitter").install({
	"lua",
	"vim",
	"vimdoc",
	"query",
	"bash",
	"zsh",
	"python",
	"go",
	"gomod",
	"rust",
	"c",
	"cpp",
	"java",
	"c_sharp",
	"toml",
	"json",
	"yaml",
	"markdown",
	"markdown_inline",
	"javascript",
	"typescript",
	"tsx",
	"html",
	"css",
	"diff",
	"git_config",
})

local ie = "v:lua.require'nvim-treesitter'.indentexpr()"

-- No filetype list: get_filetypes is still missing nvim-treesitter's
-- aliases this early, so sh and typescriptreact would be dropped.
-- start() fails harmlessly when a filetype has no parser.
vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		if pcall(vim.treesitter.start, args.buf) then
			vim.bo[args.buf].indentexpr = ie
		end
	end,
})
