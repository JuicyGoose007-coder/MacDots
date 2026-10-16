-- Harpoon-style pinned files, built on mini.visits.
--
-- mini.visits tracks every file you open and ranks them by "frecency"
-- (frequency + recency). It also lets you attach labels to paths. The
-- numbered slots below use labels: one label per slot, one file per label.
--
-- Slots are per-project, tied to the working directory.
require("mini.visits").setup({ silent = true })

local map = function(lhs, fn, desc)
	vim.keymap.set("n", lhs, fn, { silent = true, desc = desc })
end

local SLOTS = 4

local function slot_paths(slot)
	return MiniVisits.list_paths(nil, { filter = "slot" .. slot })
end

local function pin(slot)
	local path = vim.api.nvim_buf_get_name(0)
	if path == "" or path:match("^%a[%w+.-]*://") then
		vim.notify("Not a file buffer", vim.log.levels.WARN)
		return
	end

	-- A slot holds one file, so clear whoever held it before.
	for _, old in ipairs(slot_paths(slot)) do
		MiniVisits.remove_label("slot" .. slot, old)
	end

	MiniVisits.add_label("slot" .. slot, path)
	vim.notify(("Slot %d: %s"):format(slot, vim.fn.fnamemodify(path, ":.")))
end

local function jump(slot)
	local paths = slot_paths(slot)
	if #paths == 0 then
		vim.notify(("Slot %d is empty"):format(slot), vim.log.levels.WARN)
		return
	end
	vim.cmd.edit(vim.fn.fnameescape(paths[1]))
end

for i = 1, SLOTS do
	map("<leader>" .. i, function() jump(i) end, ("Jump to slot %d"):format(i))
	map("<leader>v" .. i, function() pin(i) end, ("Pin file to slot %d"):format(i))
end

-- Unpin the current file from whichever slot holds it.
map("<leader>vd", function()
	local path = vim.api.nvim_buf_get_name(0)
	local cleared = {}
	for i = 1, SLOTS do
		if slot_paths(i)[1] == path then
			MiniVisits.remove_label("slot" .. i, path)
			cleared[#cleared + 1] = i
		end
	end
	if #cleared == 0 then
		vim.notify("This file is not pinned", vim.log.levels.WARN)
	else
		vim.notify("Cleared slot " .. table.concat(cleared, ", "))
	end
end, "Unpin current file")

-- Frecency-ranked visited files. select_path() goes through vim.ui.select,
-- which fzf-lua takes over via register_ui_select().
map("<leader>vv", function() MiniVisits.select_path() end, "Visited files (project)")
map("<leader>vV", function() MiniVisits.select_path("") end, "Visited files (everywhere)")
