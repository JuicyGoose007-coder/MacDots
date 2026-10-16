#!/bin/sh

# Shows the system-wide now playing track via media-control
# (brew install media-control). SketchyBar's built-in media_change event
# stopped working in macOS 15.4, so this polls instead. Hidden when nothing
# is loaded; dimmed while paused.

export PATH="/opt/homebrew/bin:$PATH"
source "$CONFIG_DIR/colors.sh"

INFO="$(media-control get 2>/dev/null)"

if [ -z "$INFO" ] || [ "$INFO" = "null" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

TITLE="$(echo "$INFO" | jq -r '.title // empty')"
ARTIST="$(echo "$INFO" | jq -r '.artist // empty')"
PLAYING="$(echo "$INFO" | jq -r '.playing // false')"

if [ -z "$TITLE" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

LABEL="$TITLE"
[ -n "$ARTIST" ] && LABEL="$TITLE - $ARTIST"

if [ "$PLAYING" = "true" ]; then
  ICON="󰏤"
  COLOR=$MAGENTA
else
  ICON="󰐊"
  COLOR=$SUBTEXT1
fi

sketchybar --set "$NAME" drawing=on icon="$ICON" icon.color=$COLOR label="$LABEL"
