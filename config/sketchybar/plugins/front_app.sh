#!/bin/sh

# Shows the app owning OmniWM's focused window. macOS falls back to Finder as
# the frontmost app when nothing is open, so instead of trusting
# front_app_switched's $INFO we ask OmniWM and hide the pill when no window
# has focus. OmniWM keeps reporting the last focused window after switching
# to a windowless app, so the window must also belong to the frontmost app.
# Runs on front_app_switched and omniwm_update (focus changes, window closes).

OMNIWMCTL=/Applications/OmniWM.app/Contents/MacOS/omniwmctl

front="$(lsappinfo info -only bundleid "$(lsappinfo front)" \
         | sed -n 's/.*bundleID="\(.*\)".*/\1/p')"

app="$("$OMNIWMCTL" query focused-window --format json 2>/dev/null \
       | jq -r --arg front "$front" '.result.payload.window.app
                                     | select(.bundleId == $front) | .name')"

if [ -n "$app" ]; then
  sketchybar --set "$NAME" drawing=on label="$app"
else
  sketchybar --set "$NAME" drawing=off
fi
