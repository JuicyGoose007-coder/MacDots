-- Toggle picks the direction from the node under the cursor, so the
-- separate split and join keys are not worth a binding.
require("treesj").setup({
	use_default_keymaps = false,
})

vim.keymap.set("n", "<leader>m", function()
	require("treesj").toggle()
end, { silent = true, desc = "Split/join node" })

vim.keymap.set("n", "<leader>M", function()
	require("treesj").toggle({ split = { recursive = true } })
end, { silent = true, desc = "Split/join node (recursive)" })
