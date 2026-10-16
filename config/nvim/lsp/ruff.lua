-- Lint + import organization + formatting for Python. Pairs with pyright,
-- which is configured to stay out of linting so nothing double-reports.
return {
	cmd = { "ruff", "server" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
}
