vim.lsp.enable({
	"lua_ls",
	"bashls",
	"pyright",
	"ruff",
	"ts_ls",
	"gopls",
	"clangd",
	"rust_analyzer",
	"jdtls",
	"csharp_ls",
	"jsonls",
	"yamlls",
	"html",
	"cssls",
	"marksman",
	"taplo",
})

vim.diagnostic.config({
	virtual_text = false,
	severity_sort = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "E",
			[vim.diagnostic.severity.WARN] = "W",
			[vim.diagnostic.severity.INFO] = "I",
			[vim.diagnostic.severity.HINT] = "H",
		},
	},
})

vim.api.nvim_create_autocmd("LspAttach", {
	desc = "LSP actions",
	callback = function(event)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
			buffer = event.buf,
			desc = "Go to definition",
		})

		-- snacks.words ships no keymaps. Buffer-local so the builtin
		-- ]]/[[ section motions survive everywhere without an LSP.
		vim.keymap.set("n", "]]", function()
			Snacks.words.jump(vim.v.count1)
		end, { buffer = event.buf, desc = "Next reference" })

		vim.keymap.set("n", "[[", function()
			Snacks.words.jump(-vim.v.count1)
		end, { buffer = event.buf, desc = "Prev reference" })
	end,
})
