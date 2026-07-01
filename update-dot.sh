#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cp -a "$SCRIPT_DIR/config"/. "$HOME/.config"

hyprctl reload
killall -SIGUSR2 waybar

pkill swaync || true
swaync &

pkill cava || true
cava &

echo "Done!"