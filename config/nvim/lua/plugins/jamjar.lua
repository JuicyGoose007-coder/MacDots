local toggle = require("jamjar").make("main")

vim.keymap.set({ "n", "t" }, "<c-space>j", toggle, { desc = "toggle scratch terminal" })
