# MacDots

Dotfiles and setup for macOS (Apple Silicon).

## New Mac

```sh
curl -fsSL https://raw.githubusercontent.com/JuicyGoose007-coder/MacDots/main/bootstrap.sh | bash
```

This installs the Xcode Command Line Tools and Homebrew, clones this repo to
`~/MacDots`, and runs `install.sh`. Afterwards, grant Accessibility access to
OmniWM and skhd in System Settings > Privacy & Security.

## Layout

| Path            | Goes to                                  |
| --------------- | ---------------------------------------- |
| `home/*`        | symlinked into `~` (`.zshrc`, ...)       |
| `config/<app>`  | symlinked to `~/.config/<app>`           |
| `launchagents/` | rendered into `~/Library/LaunchAgents`   |
| `Brewfile`      | `brew bundle`                            |

Because whole directories are symlinked, edits made by apps (or by you in
`~/.config`) land directly in this repo — just commit them.

## install.sh

```sh
./install.sh            # brew + link + tmux plugins + services
./install.sh link       # only (re)create symlinks
./install.sh brew       # only brew bundle
./install.sh tmux       # clone tmux plugins if missing
./install.sh services   # sketchybar, skhd, custom LaunchAgents
```

It is idempotent. Anything it would overwrite is moved to
`~/.macdots-backup/<timestamp>/`.

## Common tasks

- **Add a new app config:** `mv ~/.config/foo config/ && ./install.sh link`
- **Update the Brewfile after installing stuff:** `brew bundle dump --file=Brewfile --force --no-vscode`
- **Remove things not in the Brewfile:** `brew bundle cleanup --file=Brewfile` (add `--force` to actually do it)
- **Machine-specific shell config / secrets:** put them in `~/.zshrc.local` (sourced, not tracked)
