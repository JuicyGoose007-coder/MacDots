return {
  "saghen/blink.cmp",
  opts = {
    sources = {
      providers = {
        snippets = {
          -- HTML snippets start with "<", so accepting one after typing "<" gave "<<div>"
          transform_items = function(ctx, items)
            if ctx.line:sub(ctx.bounds.start_col - 1, ctx.bounds.start_col - 1) ~= "<" then
              return items
            end
            for _, item in ipairs(items) do
              if item.textEdit then
                item.textEdit.newText = item.textEdit.newText:gsub("^<", "")
              end
              if item.insertText then
                item.insertText = item.insertText:gsub("^<", "")
              end
            end
            return items
          end,
        },
      },
    },
  },
}
