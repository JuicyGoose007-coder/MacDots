return {
  {
    "pisgahk/muted.nvim",
    lazy = false,
    priority = 1000,
    init = function()
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          for _, group in ipairs({ "Normal", "NormalNC", "SignColumn", "LineNr", "FoldColumn", "EndOfBuffer" }) do
            vim.api.nvim_set_hl(0, group, vim.tbl_extend("force",
              vim.api.nvim_get_hl(0, { name = group, link = false }), { bg = "NONE" }))
          end
        end,
      })
    end,
  },
  { "LazyVim/LazyVim", opts = { colorscheme = "muted_water" } },
}
