#!/bin/bash

WIFI=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2)
[ -z "$WIFI" ] && WIFI="Disconnected"

BT=$(bluetoothctl devices Connected | cut -d' ' -f3-)
[ -z "$BT" ] && BT="Off"

echo "{\"wifi\": \" $WIFI\", \"bt\": \"󰂯 $BT\"}"