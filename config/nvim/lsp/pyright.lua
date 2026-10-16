-- Type inference only; ruff owns linting and import organization.
return {
	cmd = { "pyright-langserver", "--stdio" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "setup.py", "requirements.txt", ".git" },
	settings = {
		pyright = { disableOrganizeImports = true },
		python = { analysis = { ignore = { "*" } } },
	},
}
