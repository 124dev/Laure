#!/bin/bash

# Directories
WALL_DIR="$HOME/Laure/scripts/wallpaper/images"
THEME_CMD="$HOME/Laure/scripts/wallpaper/wal-theme.sh"
CWD="$(pwd)"

# Handle filenames with spaces
IFS=$'\n'

# Show wallpapers in Rofi
SELECTED_WALL=$(
    for file in "$WALL_DIR"/*.jpg "$WALL_DIR"/*.png; do
        [ -f "$file" ] || continue
        printf "%s\0icon\x1f%s\n" "$(basename "$file")" "$file"
    done | "$THEME_CMD" \
        -p "Select Wallpaper" \
        -format s
)

# Exit if nothing was selected
[ -z "$SELECTED_WALL" ] && exit 0

IMAGE="$WALL_DIR/$SELECTED_WALL"

# Ensure the selected file exists
if [ ! -f "$IMAGE" ]; then
    notify-send "Wallpaper" "Selected wallpaper not found."
    exit 1
fi

notify-send "Changing Theme" "Please wait..."

# Set wallpaper
awww img "$IMAGE" \
    --transition-type center \
    --transition-step 1

# Generate pywal colors
wal -i "$IMAGE" -n -s -t -e

# Update Neovim theme
python3 "$HOME/.config/nvim/pywal/chadwal.py"

# Generate Matugen colors
matugen image "$IMAGE"

# Save current wallpaper
mkdir -p "$HOME/Laure/scripts/wallpaper/images/current"
cp "$IMAGE" "$HOME/Laure/scripts/wallpaper/images/current/current.png"

# Restart Waybar
pkill waybar
waybar >/dev/null 2>&1 &

# Restart SwayNC
pkill swaync
swaync >/dev/null 2>&1 &

notify-send "Theme Applied" "Theme successfully applied!"

cd "$CWD" || exit