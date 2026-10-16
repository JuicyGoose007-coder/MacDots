local trouble = require("trouble")

trouble.setup({})

local map = function(lhs, fn, desc)
	vim.keymap.set("n", lhs, fn, { silent = true, desc = desc })
end

-- <leader>sd (fzf) is a fuzzy jump to one diagnostic; these are the
-- list you work through.
map("<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", "Diagnostics (project)")
map("<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", "Diagnostics (buffer)")
map("<leader>xq", "<cmd>Trouble qflist toggle<cr>", "Quickfix list")
map("<leader>xl", "<cmd>Trouble loclist toggle<cr>", "Location list")
map("<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", "Symbols")
