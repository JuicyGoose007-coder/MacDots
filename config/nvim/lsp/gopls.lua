return {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	-- go.work first so a multi-module workspace wins over the nearest go.mod.
	root_markers = { "go.work", "go.mod", ".git" },
}
