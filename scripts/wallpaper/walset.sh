#!/bin/bash

# Check for exactly 1 argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <path_to_image>"
    exit 1
fi

IMAGE="$1"

# Notify user
notify-send "Changing Theme" "Please wait..."

# Change wallpaper with swww
awww img "$IMAGE" --transition-type="center" --transition-step=1 

# Apply pywal theme
wal -i "$IMAGE" -n -s -t -e

# Run your custom pywal script
python3 $HOME/.config/nvim/pywal/chadwal.py

# Run matugen on the image
matugen image "$IMAGE"
mkdir -p ~/.config/wall
cp "$IMAGE" $HOME/Laure/scripts/wallpaper/images/current/current.png
# Restart waybar
pkill waybar
waybar > /dev/null 2>&1 &
pkill swaync 
swaync > /dev/null 2>&1 &
# Notify user of success
notify-send "Theme Applied" "Theme successfully applied!"
