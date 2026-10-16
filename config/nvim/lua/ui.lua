-- vim._core.ui2: the 0.12 message/cmdline redesign (:h ui2).
-- Underscore-private path, so guard the require.
local ok, ui2 = pcall(require, "vim._core.ui2")
if not ok then
	return
end

ui2.enable({
	msg = {
		-- Per-kind routing: long output goes to the pager
		-- window instead of collapsing behind a [+x] spill.
		targets = {
			list_cmd = "pager",
			lua_print = "pager",
		},
	},
})
