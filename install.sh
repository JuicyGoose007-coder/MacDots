#!/usr/bin/env bash
# MacDots installer. Safe to re-run: anything it would replace is moved to
# ~/.macdots-backup/<timestamp>/ first, and correct symlinks are left alone.
#
#   ./install.sh            # everything
#   ./install.sh link       # just (re)create symlinks
#   ./install.sh brew|tmux|services

set -euo pipefail

DOTS="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP="$HOME/.macdots-backup/$(date +%Y%m%d-%H%M%S)"

info() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m %s\n' "$*"; }

# Symlink $1 (in repo) to $2, backing up whatever is at $2.
link() {
  local src=$1 dst=$2
  if [[ -L $dst && $(readlink "$dst") == "$src" ]]; then
    return
  fi
  if [[ -e $dst || -L $dst ]]; then
    mkdir -p "$BACKUP"
    mv "$dst" "$BACKUP/"
    warn "backed up $dst -> $BACKUP/"
  fi
  mkdir -p "$(dirname "$dst")"
  ln -s "$src" "$dst"
  info "linked $dst"
}

ensure_brew() {
  if ! command -v brew >/dev/null 2>&1; then
    [[ -x /opt/homebrew/bin/brew ]] || { warn "Homebrew not installed; run bootstrap.sh"; exit 1; }
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
}

do_brew() {
  ensure_brew
  info "brew bundle"
  brew bundle --file="$DOTS/Brewfile"
}

do_link() {
  local f
  for f in "$DOTS"/home/.[!.]* "$DOTS"/home/*; do
    [[ -e $f ]] || continue
    link "$f" "$HOME/$(basename "$f")"
  done
  for f in "$DOTS"/config/*; do
    link "$f" "$HOME/.config/$(basename "$f")"
  done
}

# tmux plugins are plain git clones (no TPM); see config/tmux/tmux.conf.
do_tmux() {
  local dir="$DOTS/config/tmux/plugins" p
  mkdir -p "$dir"
  for p in tmux-resurrect tmux-continuum; do
    if [[ ! -d $dir/$p ]]; then
      info "cloning $p"
      git clone --depth 1 "https://github.com/tmux-plugins/$p" "$dir/$p"
    fi
  done
}

do_services() {
  ensure_brew
  local uid; uid=$(id -u)

  if command -v sketchybar >/dev/null 2>&1; then
    brew services list | grep -q '^sketchybar.*started' || brew services start sketchybar
  fi
  if command -v skhd >/dev/null 2>&1; then
    [[ -f $HOME/Library/LaunchAgents/com.koekeishiya.skhd.plist ]] || skhd --install-service
    skhd --start-service || true
  fi

  # Our own LaunchAgents: templates with __HOME__/__USER__ placeholders.
  local tpl label plist
  mkdir -p "$HOME/Library/LaunchAgents"
  for tpl in "$DOTS"/launchagents/*.plist; do
    [[ -e $tpl ]] || continue
    label="com.$USER.$(basename "$tpl" .plist)"
    plist="$HOME/Library/LaunchAgents/$label.plist"
    sed -e "s|__HOME__|$HOME|g" -e "s|__USER__|$USER|g" "$tpl" > "$plist.new"
    if ! cmp -s "$plist.new" "$plist"; then
      mv "$plist.new" "$plist"
      launchctl bootout "gui/$uid/$label" 2>/dev/null || true
      launchctl bootstrap "gui/$uid" "$plist"
      info "loaded $label"
    else
      rm "$plist.new"
    fi
  done
}

case "${1:-all}" in
  brew)     do_brew ;;
  link)     do_link ;;
  tmux)     do_tmux ;;
  services) do_services ;;
  all)      do_brew; do_link; do_tmux; do_services
            info "done. Open a new shell (or: exec zsh)."
            echo "   First run on a new Mac: grant Accessibility to OmniWM and skhd"
            echo "   (System Settings > Privacy & Security > Accessibility)." ;;
  *)        echo "usage: $0 [all|brew|link|tmux|services]"; exit 1 ;;
esac
