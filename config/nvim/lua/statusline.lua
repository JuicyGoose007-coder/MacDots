-- Second field is the highlight group the segment borrows its color from.
local modes = {
	n = { "NORMAL", "Normal" },
	i = { "INSERT", "Identifier" },
	v = { "VISUAL", "String" },
	V = { "V-LINE", "String" },
	["\22"] = { "V-BLOCK", "String" },
	c = { "COMMAND", "Type" },
	t = { "TERMINAL", "Constant" },
	R = { "REPLACE", "Statement" },
	s = { "SELECT", "String" },
	S = { "S-LINE", "String" },
	["\19"] = { "S-BLOCK", "String" },
}

local labels = { " ", " ", " ", " " }
local hls = { "DiagnosticError", "DiagnosticWarn", "DiagnosticInfo", "DiagnosticHint" }

-- The half circles tmux.conf caps its own pills with, so the two bars match.
-- By codepoint, because these do not survive every editor and paste path.
local LEFT, RIGHT = vim.fn.nr2char(0xe0b6), vim.fn.nr2char(0xe0b4)

-- Pairing fg and bg from two unrelated groups only worked by luck: under
-- gruvbox-material PmenuSel.fg and Visual.bg are the same color, which left the
-- mode block unreadable. Normal is the one contrast every colorscheme promises.
local function set_hls()
	local hl = function(name)
		return vim.api.nvim_get_hl(0, { name = name, link = false })
	end

	-- StatusLine keeps the theme's own bg, which is the color tmux draws its bar
	-- with. The half-row spacer in tmux.conf is what keeps the two from fusing.
	local normal, bar = hl("Normal"), hl("StatusLine")

	-- Caps are the same color as the pill they bracket, painted on the bar, so
	-- the fill reads as one rounded shape rather than three cells.
	local pill = function(name, fill, text)
		vim.api.nvim_set_hl(0, name, { fg = text, bg = fill, bold = true })
		vim.api.nvim_set_hl(0, name .. "Cap", { fg = fill, bg = bar.bg })
	end

	for _, m in pairs(modes) do
		pill("Stl" .. m[2], hl(m[2]).fg or normal.fg, normal.bg)
	end

	pill("StlGit", hl("Visual").bg, hl("Directory").fg)
end

function _G._statusline()
	local mode = modes[vim.fn.mode()] or { vim.fn.mode():upper(), "Normal" }

	local pill = function(group, text)
		local cap = "%#" .. group .. "Cap#"
		return cap .. LEFT .. "%#" .. group .. "# " .. text .. " " .. cap .. RIGHT .. "%*"
	end

	-- gitsigns maintains this; the old config shelled out to `git` twice
	-- on every BufEnter to get the same string.
	local head = vim.b.gitsigns_head
	local branch = head and (" " .. pill("StlGit", head)) or ""

	-- cwd-relative, no subprocess.
	local path = vim.fn.expand("%:.")
	if path == "" then
		path = "[No Name]"
	end

	local diag = ""
	local counts = vim.diagnostic.count(0) or {}
	for i = 1, 4 do
		if counts[i] and counts[i] > 0 then
			diag = diag .. "%#" .. hls[i] .. "#" .. labels[i] .. counts[i] .. "%* "
		end
	end

	return pill("Stl" .. mode[2], mode[1]) .. branch .. "  " .. path .. "%m%r%=" .. diag .. vim.bo.filetype .. " %l:%c"
end

vim.api.nvim_create_autocmd("DiagnosticChanged", {
	callback = function()
		vim.cmd("redrawstatus!")
	end,
})

-- The colors above are read out of the active theme, so :colorscheme invalidates them.
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_hls })

set_hls()
vim.o.statusline = "%!v:lua._statusline()"
