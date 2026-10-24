#!/bin/sh
# Run once at login (see ~/Library/LaunchAgents/com.juicygoose007.omniwm-login.plist).
# Waits for OmniWM, lets launching apps settle, then focuses the Main workspace.

CTL=/opt/homebrew/bin/omniwmctl

for _ in $(seq 60); do
  "$CTL" query workspaces >/dev/null 2>&1 && break
  sleep 1
done

sleep 5
"$CTL" command switch-workspace 1
