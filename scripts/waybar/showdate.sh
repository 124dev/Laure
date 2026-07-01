#!/bin/bash
# When clicked, show date instead of time

WAYBAR_FORMAT='{:%a, %d %b %Y}'
waybar-msg -s clock format "$WAYBAR_FORMAT"
