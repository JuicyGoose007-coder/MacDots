-- Requirements: lua-language-server on $PATH (/usr/bin/lua-language-server).
return {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".luarc.json", ".stylua.toml", ".git" },
	settings = {
		Lua = {
			-- Nvim embeds LuaJIT, not vanilla Lua 5.1.
			runtime = { version = "LuaJIT" },
			workspace = {
				checkThirdParty = false,
			},
		},
	},
}
