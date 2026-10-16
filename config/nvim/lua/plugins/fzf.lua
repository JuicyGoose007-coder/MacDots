local fzf = require("fzf-lua")

fzf.setup({})

-- Route vim.ui.select through fzf so anything that calls it (mini.visits,
-- lsp code actions, etc.) opens a fuzzy picker instead of a cmdline prompt.
fzf.register_ui_select()

local map = function(lhs, fn, desc)
	vim.keymap.set("n", lhs, fn, { silent = true, desc = desc })
end

local root = require("project").root

-- Passing cwd also makes fzf-lua print it in the picker header, so a
-- surprising search root is visible instead of looking like no matches.
local at_root = function(picker)
	return function()
		picker({ cwd = root() })
	end
end

map("<leader>f", at_root(fzf.files), "Find files")
map("<leader>g", at_root(fzf.live_grep), "Live grep")
map("<leader>sb", fzf.buffers, "Buffers")
map("<leader>sh", fzf.helptags, "Help tags")
map("<leader>sd", fzf.diagnostics_document, "Diagnostics")
map("<leader>ss", fzf.lsp_document_symbols, "Symbols")
map("<leader>sk", fzf.keymaps, "Keymaps")
map("<leader>sr", fzf.oldfiles, "Recent files")
map("<leader>sl", fzf.lines, "Lines in open buffers")
map("<leader>z", fzf.zoxide, "Jump to project")
map("<leader>sF", function() fzf.files({ cwd = "~" }) end, "Find files (home)")
map("<leader>sG", function() fzf.live_grep({ cwd = "~" }) end, "Live grep (home)")
map("<leader>/", fzf.blines, "Search Current File")

-- With no word under the cursor grep_cword greps for "", which opens an
-- empty picker and looks broken. Say what happened instead.
map("<leader>*", function()
	if vim.fn.expand("<cword>") == "" then
		vim.notify("No word under cursor", vim.log.levels.WARN)
		return
	end
	fzf.grep_cword({ cwd = root() })
end, "Grep word under cursor (project)")
