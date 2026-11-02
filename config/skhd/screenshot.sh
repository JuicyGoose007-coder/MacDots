#!/bin/sh
# Take a screenshot with screencapture (args passed through), save it to
# ~/Pictures/Screenshots and copy the image to the clipboard.
dir="$HOME/Pictures/Screenshots"
mkdir -p "$dir"
file="$dir/shot-$(date +%Y%m%d-%H%M%S).png"

screencapture "$@" "$file"

# Interactive captures leave no file when cancelled with Esc
[ -f "$file" ] || exit 0
osascript -e "set the clipboard to (read (POSIX file \"$file\") as «class PNGf»)"
