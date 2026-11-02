-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>ob", function()
  vim.system({ "open", "-a", "Google Chrome", vim.fn.expand("%:p") })
end, { desc = "Open file in Chrome" })

vim.keymap.set("n", "<leader>df", function()
  vim.ui.input({ prompt = "Diff against file in: ", default = vim.fn.getcwd() .. "/", completion = "dir" }, function(dir)
    if not dir or dir == "" then
      return
    end
    Snacks.picker.files({
      cwd = vim.fn.expand(dir),
      hidden = true,
      confirm = function(picker, item)
        picker:close()
        vim.cmd("vert diffsplit " .. vim.fn.fnameescape(Snacks.picker.util.path(item)))
      end,
    })
  end)
end, { desc = "Diff current file with..." })
