#!/bin/bash

# Syncs the ws.<number> pills with OmniWM. Runs on the omniwm_update event,
# which `omniwmctl watch` (started in sketchybarrc) triggers on every
# workspace/window change.
#
# Named workspaces (displayName set in omniwm/settings.toml) are pinned and
# always drawn; unnamed ones only show while they hold windows or are visible.
# Each pill is drawn on the bar of the monitor its workspace lives on.

source "$CONFIG_DIR/colors.sh"

OMNIWMCTL=/Applications/OmniWM.app/Contents/MacOS/omniwmctl

WORKSPACES="$("$OMNIWMCTL" query workspaces --format json 2>/dev/null)" || exit 0

# OmniWM's display:<n> is the CGDirectDisplayID; sketchybar wants its own
# arrangement id for display=.
DISPLAYS="$(sketchybar --query displays | jq -c 'map({key: "display:\(.DirectDisplayID)", value: ."arrangement-id"}) | from_entries')"

args=()
while IFS=$'\t' read -r number name raw display current visible total; do
  if [ "$current" = "true" ]; then
    bg=$BORDER fg=$BASE
  elif [ "$visible" = "true" ]; then
    bg=$SELECTION fg=$FG
  else
    bg=$SURFACE fg=$SUBTEXT1
  fi

  if [ "$name" != "$raw" ] || [ "$total" -gt 0 ] || [ "$visible" = "true" ]; then
    drawing=on
  else
    drawing=off
  fi

  if [ "$name" != "$raw" ]; then
    label=(label="$name" label.drawing=on icon.padding_right=4)
  else
    label=(label.drawing=off icon.padding_right=10)
  fi

  args+=(--set "ws.$number" drawing="$drawing" display="${display:-active}"
         background.color="$bg" icon.color="$fg" label.color="$fg" "${label[@]}")
done < <(jq -r --argjson displays "$DISPLAYS" '
  .result.payload.workspaces[]
  | [.number, .displayName, .rawName, ($displays[.display.id] // ""),
     .isCurrent, .isVisible, .counts.total]
  | @tsv' <<<"$WORKSPACES")

[ ${#args[@]} -gt 0 ] && sketchybar "${args[@]}"
