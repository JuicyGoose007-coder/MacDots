#!/usr/bin/env bash
# Fresh-Mac entry point. Run with:
#   curl -fsSL https://raw.githubusercontent.com/JuicyGoose007-coder/MacDots/main/bootstrap.sh | bash
# Override the clone location with MACDOTS_DIR=..., the repo with MACDOTS_REPO=...

set -euo pipefail

REPO="${MACDOTS_REPO:-https://github.com/JuicyGoose007-coder/MacDots.git}"
DIR="${MACDOTS_DIR:-$HOME/MacDots}"

# Xcode Command Line Tools (provides git). The installer is a GUI dialog.
if ! xcode-select -p >/dev/null 2>&1; then
  echo "==> Installing Xcode Command Line Tools; finish the dialog to continue..."
  xcode-select --install || true
  until xcode-select -p >/dev/null 2>&1; do sleep 5; done
fi

if [[ ! -x /opt/homebrew/bin/brew ]]; then
  echo "==> Installing Homebrew"
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

if [[ ! -d $DIR/.git ]]; then
  git clone "$REPO" "$DIR"
fi

exec "$DIR/install.sh"
