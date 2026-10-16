-- root_markers only matches exact names, and .sln/.csproj files are named
-- after the project, so match on the extension instead.
return {
	cmd = { "csharp-ls" },
	filetypes = { "cs" },
	root_dir = function(bufnr, on_dir)
		local path = vim.api.nvim_buf_get_name(bufnr)
		on_dir(vim.fs.root(path, function(name)
			return name:match("%.sln$") ~= nil
		end) or vim.fs.root(path, function(name)
			return name:match("%.csproj$") ~= nil
		end))
	end,
}
