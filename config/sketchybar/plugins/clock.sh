#!/bin/bash

# The $NAME variable is passed from sketchybar and holds the name of
# the item invoking this script:
# https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting
#
# Drives both clock items: "clock" (centred) and "clock_notch" (right of the
# notch). On anything other than the routine tick, it re-checks which
# displays have a notch and shows each copy only on the matching bars.

LABEL="$(date '+%m/%d/%y %-I:%M %p')"

if [ "$SENDER" = "routine" ]; then
  sketchybar --set clock label="$LABEL" --set clock_notch label="$LABEL"
  exit 0
fi

# CGDirectDisplayIDs of screens with a notch (non-zero top safe-area inset).
NOTCHED="$(osascript -l JavaScript -e '
  ObjC.import("AppKit");
  var s = $.NSScreen.screens, ids = [];
  for (var i = 0; i < s.count; i++) {
    var x = s.objectAtIndex(i);
    if (x.safeAreaInsets.top > 0)
      ids.push(ObjC.unwrap(x.deviceDescription.objectForKey("NSScreenNumber")));
  }
  JSON.stringify(ids);' 2>/dev/null)"

# Split sketchybar's arrangement ids into notched / plain, comma-separated.
SPLIT="$(sketchybar --query displays | jq -r --argjson notched "${NOTCHED:-[]}" '
  [map(select(.DirectDisplayID | IN($notched[])) | ."arrangement-id"),
   map(select(.DirectDisplayID | IN($notched[]) | not) | ."arrangement-id")]
  | map(map(tostring) | join(",")) | @tsv')"

NOTCH_IDS="$(printf '%s' "$SPLIT" | cut -f1)"
PLAIN_IDS="$(printf '%s' "$SPLIT" | cut -f2)"

if [ -n "$PLAIN_IDS" ]; then
  center=(drawing=on display="$PLAIN_IDS")
else
  center=(drawing=off)
fi

if [ -n "$NOTCH_IDS" ]; then
  notch=(drawing=on display="$NOTCH_IDS")
else
  notch=(drawing=off)
fi

sketchybar --set clock label="$LABEL" "${center[@]}" \
           --set clock_notch label="$LABEL" "${notch[@]}"
