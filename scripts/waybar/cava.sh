#!/bin/bash

# Unicode bars for visualization
bar="▁▂▃▄▅▆▇█"

# Create a sed dictionary to replace numbers with bars
dict="s/;//g;"
for i in $(seq 0 $((${#bar}-1))); do
    dict="${dict}s/$i/${bar:$i:1}/g;"
done

# Cava config as a HEREDOC (no temporary file needed)
cava_config=$(cat <<-EOF
[general]
bars = 18

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
EOF
)

# Run cava with in-memory config using stdin
echo "$cava_config" | cava -p /dev/stdin | while read -r line; do
    # Convert numeric output to unicode bars
    echo "$line" | sed "$dict"
done &

# Get currently playing song
text=$(playerctl metadata --format '{{artist}} - {{title}}')
maxlength=35

# Truncate if too long
if [ ${#text} -gt $maxlength ]; then
    text=${text:0:$maxlength-3}"..."
fi

# Output JSON for Polybar
playerctl metadata --format '{"text": "'"$text"'", "tooltip": "{{playerName}} : {{artist}} - {{title}}"}'
