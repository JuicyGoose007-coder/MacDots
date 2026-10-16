local prettier = { "prettier" }

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		sh = { "shfmt" },
		bash = { "shfmt" },
		python = { "ruff_format" },
		go = { "gofmt" },
		rust = { "rustfmt" },
		javascript = prettier,
		javascriptreact = prettier,
		typescript = prettier,
		typescriptreact = prettier,
		json = prettier,
		jsonc = prettier,
		css = prettier,
		html = prettier,
		markdown = prettier,
		yaml = prettier,
	},

	-- Unlike the old hand-rolled formatting.lua, a missing formatter is
	-- reported instead of silently leaving the buffer untouched.
	format_on_save = function(bufnr)
		if vim.b[bufnr].disable_autoformat then
			return
		end
		return { timeout_ms = 500, lsp_format = "fallback" }
	end,
})

vim.keymap.set({ "n", "v" }, "<leader>cf", function()
	require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer" })

vim.api.nvim_create_user_command("FormatDisable", function()
	vim.b.disable_autoformat = true
end, { desc = "Disable format-on-save for this buffer" })

vim.api.nvim_create_user_command("FormatEnable", function()
	vim.b.disable_autoformat = false
end, { desc = "Re-enable format-on-save for this buffer" })
