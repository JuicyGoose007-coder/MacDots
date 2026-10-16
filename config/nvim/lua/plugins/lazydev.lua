-- lua_ls only knows about $VIMRUNTIME on its own, so plugin symbols
-- resolve to nothing. lazydev adds a plugin's path the moment a file
-- requires it, instead of indexing all of them up front.
require("lazydev").setup()
