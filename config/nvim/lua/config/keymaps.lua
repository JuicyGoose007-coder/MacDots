-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>ob", function()
  vim.system({ "open", "-a", "Google Chrome", vim.fn.expand("%:p") })
end, { desc = "Open file in Chrome" })
