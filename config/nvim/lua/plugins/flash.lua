require("flash").setup({
	modes = {
		search = { enabled = false },
		char = { enabled = false },
	},
})

local map = function(lhs, fn, desc)
	vim.keymap.set({ "n", "x", "o" }, lhs, fn, { silent = true, desc = desc })
end

map("s", function()
	require("flash").jump()
end, "Flash jump")

map("S", function()
	require("flash").treesitter()
end, "Flash treesitter select")
