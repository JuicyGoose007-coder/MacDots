require("hlslens").setup()

local map = function(lhs, rhs, desc)
	vim.keymap.set("n", lhs, rhs, { silent = true, desc = desc })
end

-- The count has to go through execute so 3n still means three matches.
-- zzzv is the centring these keys used to get from keymaps.lua.
map("n", [[<Cmd>execute('normal! ' .. v:count1 .. 'nzzzv')<CR><Cmd>lua require('hlslens').start()<CR>]], "Next match")
map("N", [[<Cmd>execute('normal! ' .. v:count1 .. 'Nzzzv')<CR><Cmd>lua require('hlslens').start()<CR>]], "Prev match")

map("*", [[*<Cmd>lua require('hlslens').start()<CR>]], "Next match for word")
map("#", [[#<Cmd>lua require('hlslens').start()<CR>]], "Prev match for word")
map("g*", [[g*<Cmd>lua require('hlslens').start()<CR>]], "Next partial match for word")
map("g#", [[g#<Cmd>lua require('hlslens').start()<CR>]], "Prev partial match for word")
