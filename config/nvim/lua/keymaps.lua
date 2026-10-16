-- Write and quit
vim.keymap.set("n", "<leader>w", ":w<cr>", { silent = true, desc = "Write" })
vim.keymap.set("n", "<leader>q", ":q<cr>", { silent = true, desc = "Quit" })

-- Redo
vim.keymap.set("n", "U", "<c-r>", { silent = true, desc = "Redo" })

-- Restart
vim.keymap.set("n", "<leader>R", ":restart<cr>", { silent = true, desc = "Restart" })

-- Pack update
vim.keymap.set("n", "<leader>u", "<cmd>lua vim.pack.update()<cr>", { silent = true, desc = "Update Packages" })

-- vim.ui.open returns (cmd, err): the handler is only known to have
-- worked once it exits 0, so wait on it like Nvim's own gx does.
local function open_uri(uri)
	local cmd, err = vim.ui.open(uri)
	local rv = cmd and cmd:wait(1000) or nil
	if cmd and rv and rv.code ~= 0 then
		err = ("vim.ui.open: command %s (%d): %s"):format(
			rv.code == 124 and "timeout" or "failed",
			rv.code,
			vim.inspect(cmd.cmd)
		)
	end
	return err
end

-- Nvim's gx falls back to the filename under the cursor and hands it to
-- xdg-open, which has no handler here and forks a headless nvim that
-- never exits. Local paths open in this editor instead.
vim.keymap.set("n", "gx", function()
	for _, target in ipairs(require("vim.ui")._get_urls()) do
		if target:match("^%a[%w+.-]*:") then
			local err = open_uri(target)
			if err then
				vim.notify(err, vim.log.levels.ERROR)
			end
		elseif target ~= "" then
			local path = vim.fn.fnamemodify(target, ":p")
			if vim.uv.fs_stat(path) then
				vim.cmd.edit(vim.fn.fnameescape(path))
			else
				vim.notify("No such file: " .. target, vim.log.levels.WARN)
			end
		end
	end
end, { silent = true, desc = "Open URL, or file under cursor" })

-- Window moves are <C-w>h/j/k/l. Do NOT map <C-h/j/k/l>:
-- Herdr binds those as direct chords for pane focus and
-- they never reach nvim. Same for <C-b>, its prefix.

-- Deletes feed the system clipboard now that clipboard=unnamedplus,
-- so keep an explicit way to throw text away instead.
vim.keymap.set({ "n", "v" }, "<leader>D", '"_d', { desc = "Delete to void" })

-- Visual P already leaves the registers alone (:h v_P), and unlike the
-- usual "_dP it also gets the last line right.
vim.keymap.set("x", "p", "P", { desc = "Paste without yanking" })

-- Keep the cursor and the selection where they were.
vim.keymap.set("n", "J", "mzJ`z", { silent = true, desc = "Join lines" })
vim.keymap.set("x", "<", "<gv", { silent = true })
vim.keymap.set("x", ">", ">gv", { silent = true })

-- Centre the viewport on big jumps.
vim.keymap.set("n", "<C-d>", "<C-d>zz", { silent = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { silent = true })

-- A count still means real lines; a bare j/k walks the wrapped line.
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

vim.keymap.set("n", "<Esc>", function()
	vim.cmd.nohlsearch()
	vim.api.nvim_buf_clear_namespace(0, vim.api.nvim_create_namespace("nvim.multicursor"), 0, -1)
end, { silent = true, desc = "Clear search highlight and multicursors" })

-- Move lines.
vim.keymap.set("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { silent = true, desc = "Move line down" })
vim.keymap.set("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { silent = true, desc = "Move line up" })
vim.keymap.set(
	"v",
	"<A-j>",
	":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv",
	{ silent = true, desc = "Move selection down" }
)
vim.keymap.set(
	"v",
	"<A-k>",
	":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv",
	{ silent = true, desc = "Move selection up" }
)

-- Quicker than the builtin ]b/[b, which stay available.
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { silent = true, desc = "Prev buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { silent = true, desc = "Next buffer" })

-- Close buffers
vim.keymap.set("n", "<leader>bd", function()
	Snacks.bufdelete()
end, { desc = "Delete buffer" })
vim.keymap.set("n", "<leader>bo", function()
	Snacks.bufdelete.other()
end, { desc = "Delete other buffer" })

-- c_CTRL-R_CTRL-W pulls in the word under the cursor, so no feedkeys
-- dance. Lands on the cmdline with the cursor between the slashes.
vim.keymap.set("n", "<leader>rw", ":%s/\\<<C-r><C-w>\\>//gI<Left><Left><Left>", {
	desc = "Replace word under cursor",
})
