local M = {}

--- The directory a buffer belongs to, walked up to its repo root.
--- @param buf integer|nil buffer number, defaults to the current buffer
--- @return string
function M.root(buf)
	buf = buf or 0

	local dir
	local name = vim.api.nvim_buf_get_name(buf)
	-- Skip minifiles://, fugitive:// and friends: not paths anything can walk.
	if name ~= "" and not name:match("^%a[%w+.-]*://") then
		dir = vim.fs.dirname(name)
	end

	dir = dir or vim.uv.cwd()
	return vim.fs.root(dir, { ".git", ".hg", ".svn" }) or dir
end

return M
