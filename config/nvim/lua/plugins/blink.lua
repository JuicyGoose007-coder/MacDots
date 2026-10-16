require("blink.cmp").setup({
	-- "default" keeps <C-y> to accept and <C-n>/<C-p> to navigate, which is
	-- what the native completion used -- no <CR> map, so mini.pairs (M4)
	-- never conflicts.
	keymap = {
		preset = "default",

		-- Takes the inline ghost text, like ^E in .zshrc.
		-- Works with the menu closed: select_and_accept is
		-- gated on is_visible(), which counts ghost text.
		["<C-e>"] = { "select_and_accept", "fallback" },
		["<C-g>"] = { "cancel", "fallback" },
	},

	appearance = { nerd_font_variant = "mono" },

	completion = {
		documentation = { auto_show = true, auto_show_delay_ms = 200 },
		menu = { border = "rounded" },
		-- zsh-autosuggestions-style inline preview.
		ghost_text = {
			enabled = true,
			show_with_selection = true,
			show_without_selection = true,
			show_without_menu = true,
		},
	},

	signature = { enabled = true, window = { border = "rounded" } },

	-- The multi-source merging that native completion could not do.
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},

	fuzzy = { implementation = "prefer_rust_with_warning" },
})
