require("mini.files").setup({
	mappings = {
		go_in = "L",
		go_in_plus = "l",
	},
})

vim.keymap.set("n", "<leader>e", function()
	local buf_name = vim.api.nvim_buf_get_name(0)
	local path = vim.uv.fs_stat(buf_name) and buf_name or nil
	require("mini.files").open(path)
end, { desc = "Open mini.files at current file" })
