#!/bin/sh
# Run by `omniwmctl watch windows-changed` (see ~/Library/LaunchAgents/com.juicygoose007.omniwm-reapply-rules.plist).
# OmniWM 0.7.6 skips assignToWorkspace rules for some apps (Electron) at launch,
# so apply rules once to each new window of these apps. Windows already seen are
# left alone, so moving one by hand sticks.

BUNDLE_IDS="com.hnc.Discord"
CTL=/opt/homebrew/bin/omniwmctl
SEEN="${TMPDIR:-/tmp}/omniwm-reapply-rules.seen"

touch "$SEEN"
current=""
for bid in $BUNDLE_IDS; do
  current="$current $("$CTL" query windows --bundle-id "$bid" --fields id --format tsv | tail -n +2 | cut -f1)"
done

for id in $current; do
  grep -qx "$id" "$SEEN" || "$CTL" rule apply --window "$id" >/dev/null
done

# Keep only windows that still exist.
printf '%s\n' $current > "$SEEN"
