require("which-key").setup({
	preset = "modern",
	delay = 0,
	spec = {
		{ "<leader>c", group = "code" },
		{ "<leader>h", group = "git hunk" },
		{ "<leader>s", group = "search" },
		{ "<leader>x", group = "diagnostics" },
	},
})

-- Only what is local to this buffer: gitsigns' hunk
-- keys, LSP defaults.
vim.keymap.set("n", "<leader>?", function()
	require("which-key").show({ global = false })
end, { silent = true, desc = "Buffer keymaps" })
