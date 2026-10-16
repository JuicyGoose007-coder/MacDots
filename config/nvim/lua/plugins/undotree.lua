require("undotree").setup({})

-- g-/g+ already walk undo states by time; this is for the branches
-- they cannot reach. <leader>u is :packupdate, so the tree takes U.
vim.keymap.set("n", "<leader>U", require("undotree").toggle, {
	silent = true,
	desc = "Undo tree",
})
