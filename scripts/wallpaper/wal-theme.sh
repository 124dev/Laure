#!/bin/bash

theme="$HOME/Laure/scripts/rofi/themes/wallpaper.rasi"

exec rofi \
    -dmenu \
    -theme "$theme" \
    "$@" \
    