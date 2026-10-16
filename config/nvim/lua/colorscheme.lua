-- Clear editor backgrounds so kitty's transparency shows through.
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		for _, group in ipairs({ "Normal", "NormalNC", "SignColumn", "LineNr", "FoldColumn", "EndOfBuffer" }) do
			vim.api.nvim_set_hl(
				0,
				group,
				vim.tbl_extend("force", vim.api.nvim_get_hl(0, { name = group, link = false }), { bg = "NONE" })
			)
		end
	end,
})

-- vim.g.gruvbox_material_foreground = "original"
-- vim.cmd.colorscheme("gruvbox-material")

-- vim.cmd.colorscheme("melange")
vim.cmd.colorscheme("muted_water")
