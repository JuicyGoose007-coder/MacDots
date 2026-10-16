# Minimalish-Nvim

A Neovim config built on `vim.pack`. No plugin manager, no bootstrap script.

Needs Neovim 0.13-dev.

## Dependencies

```sh
paru -S --needed git fzf ripgrep tree-sitter-cli zoxide wl-clipboard \
  lua-language-server bash-language-server pyright ruff \
  typescript-language-server stylua shfmt prettier
```

A Nerd Font is needed for icons. `zoxide` and `wl-clipboard` are optional.

Language servers for the rest of the enabled languages. Skip any you don't
use; a missing server just never attaches.

```sh
paru -S --needed gopls clang rust-analyzer jdk-openjdk jdtls csharp-ls \
  vscode-json-languageserver vscode-html-languageserver \
  vscode-css-languageserver yaml-language-server marksman taplo-cli
```

## Language servers

Native `vim.lsp`, no nvim-lspconfig or Mason. Each server has a config in
`lsp/<name>.lua` and is turned on in `lua/lsp.lua`. Servers come from the
system package manager.

| Language              | Server                |
| --------------------- | --------------------- |
| Lua                   | lua_ls                |
| Bash                  | bashls                |
| Python                | pyright + ruff        |
| JS / TS               | ts_ls                 |
| Go                    | gopls                 |
| C / C++               | clangd                |
| Rust                  | rust_analyzer         |
| Java                  | jdtls                 |
| C#                    | csharp_ls             |
| JSON / YAML / TOML    | jsonls, yamlls, taplo |
| HTML / CSS / Markdown | html, cssls, marksman |

clangd needs a `compile_commands.json` (CMake:
`-DCMAKE_EXPORT_COMPILE_COMMANDS=ON`) or `compile_flags.txt` in the project.
jdtls keeps a per-project index under `~/.cache/nvim/jdtls/`.

To add a language: install the server, add `lsp/<name>.lua` with `cmd`,
`filetypes` and `root_markers`, then add `<name>` to `vim.lsp.enable` in
`lua/lsp.lua`. Check it with `:checkhealth vim.lsp`.

## Install

Back up an existing config first:

```sh
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
```

Then:

```sh
git clone https://github.com/JuicyGoose007-coder/minimalish-nvim ~/.config/nvim
nvim
```

First launch clones the plugins and builds treesitter parsers. Restart after.

## Plugins

| Plugin                      |                                                |
| --------------------------- | ---------------------------------------------- |
| gruvbox-material            | colorscheme                                    |
| nvim-treesitter             | syntax highlighting and code parsing           |
| mini.icons                  | file and language icons                        |
| mini.pairs                  | auto-close brackets and quotes                 |
| mini.visits                 | harpoon-style file pinning and frecency        |
| fzf-lua                     | fuzzy finder (files, grep, symbols, etc.)      |
| mini.files                  | file explorer — edit directories as buffers    |
| undotree                    | visual undo history                            |
| gitsigns.nvim               | git hunk signs, stage, blame, diff             |
| conform.nvim                | format-on-save (stylua, shfmt, prettier, etc.) |
| blink.cmp                   | completion engine                              |
| which-key.nvim              | keymap popup on leader press                   |
| lazydev.nvim                | lua_ls support for neovim plugin APIs          |
| snacks.nvim                 | dashboard, notifier, word refs, indent guides  |
| trouble.nvim                | diagnostics, quickfix, symbols panel           |
| flash.nvim                  | jump and treesitter-select motions             |
| vim-tmux-navigator          | `<C-h/j/k/l>` pane switching with tmux         |
| tiny-cmdline.nvim           | floating command line                          |
| tiny-inline-diagnostic.nvim | diagnostics as inline messages                 |
| treesj                      | split / join code blocks                       |
| tabout.nvim                 | `<Tab>` jumps out of brackets and quotes       |
| nvim-hlslens                | match count overlay on search                  |

## Keymaps

Leader is `<Space>`. `<leader>?` lists the current buffer's keys.

| Key                                        |                                                             |
| ------------------------------------------ | ----------------------------------------------------------- |
| `<leader>f`                                | find files                                                  |
| `<leader>g`                                | live grep                                                   |
| `<leader>*`                                | grep word under cursor                                      |
| `<leader>/`                                | search this file                                            |
| `<leader>z`                                | jump to project                                             |
| `<leader>sb` `sr` `sh` `sk` `ss` `sd` `sl` | buffers, recent, help, keymaps, symbols, diagnostics, lines |
| `<leader>sF` `sG`                          | files / grep from home                                      |
| `<leader>e`                                | file explorer                                               |
| `gx`                                       | open URL, or file under cursor                              |
| `s` / `S`                                  | flash jump / treesitter select                              |
| `<leader>1-4`                              | jump to pinned slot                                         |
| `<leader>v1-4`                             | pin file to slot                                            |
| `<leader>vd`                               | unpin current file                                          |
| `<leader>vv` `vV`                          | visited files (project / everywhere)                        |
| `]c` `[c`                                  | next / prev hunk                                            |
| `<leader>hs` `hr` `hp` `hb` `hd`           | stage, reset, preview, blame, diff hunk                     |
| `<leader>G`                                | lazygit                                                     |
| `gd`                                       | go to definition                                            |
| `]]` `[[`                                  | next / prev reference                                       |
| `<leader>xx` `xX` `xq` `xl`                | diagnostics project, buffer, quickfix, loclist              |
| `<leader>cs` `cf`                          | symbols, format                                             |
| `<leader>m` `M`                            | split / join node, recursive                                |
| `U` / `<leader>U`                          | redo / undo tree                                            |
| `<A-j>` `<A-k>`                            | move line or selection                                      |
| `<S-h>` `<S-l>`                            | prev / next buffer                                          |
| `<leader>rw`                               | replace word under cursor                                   |
| `<leader>D`                                | delete to void                                              |
| `p` (visual)                               | paste without yanking the selection                         |
| `Q` / `1Q` / `Q` (visual)                  | multicursor here / at every search match / on each line     |
| `q=`                                       | toggle multicursor follow-mode                              |
| `]C` `[C`                                  | next / prev multicursor                                     |
| `<Esc>`                                    | clear search highlight and multicursors                     |
| `<leader>u` `R`                            | update plugins, restart                                     |
| `<leader>n` `N`                            | notification history, dismiss                               |

Completion is blink.cmp on the `default` preset: `<C-n>`/`<C-p>` move, `<C-y>`
accepts, `<C-e>` takes the ghost text, `<C-g>` cancels. `<Tab>`/`<S-Tab>` are
left to tabout.nvim for jumping out of brackets and quotes.

`<C-h/j/k/l>` are used by vim-tmux-navigator for pane switching, which takes
`<C-l>` from Nvim's multicursor clear; `<Esc>` does it instead.

In the file explorer, `l` opens a file and closes the explorer; `L` opens it
and keeps the explorer up.

Some builtins are tweaked: `n` `N` `<C-d>` `<C-u>` recenter, `J` keeps the
cursor in place, and a bare `j`/`k` moves by wrapped line.
