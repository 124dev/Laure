#!/bin/bash

# Bluetooth control script using bluetoothctl

print_error() {
    cat <<"EOF"
Usage: ./bluetooth-control.sh <action>

Actions:
    t   -- toggle bluetooth on/off
    c   -- connect paired device
    d   -- disconnect connected device
    s   -- scan devices
    p   -- show paired devices
EOF
    exit 1
}

notify_bt() {
    state=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')

    if [ "$state" = "yes" ]; then
        notify-send "Bluetooth" "Enabled" -i bluetooth-active-symbolic -t 1000 -r 91190
    else
        notify-send "Bluetooth" "Disabled" -i bluetooth-disabled-symbolic -t 1000 -r 91190
    fi
}

toggle_bt() {
    state=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')

    if [ "$state" = "yes" ]; then
        bluetoothctl power off
    else
        bluetoothctl power on
    fi

    notify_bt
}

connect_device() {
    device=$(bluetoothctl devices Paired | rofi -dmenu -p "Connect Device" | awk '{print $2}')

    [ -z "$device" ] && exit 0

    bluetoothctl connect "$device"

    notify-send "Bluetooth" "Connecting..." -i bluetooth-active-symbolic -t 1000 -r 91190
}

disconnect_device() {
    device=$(bluetoothctl devices Connected | rofi -dmenu -p "Disconnect Device" | awk '{print $2}')

    [ -z "$device" ] && exit 0

    bluetoothctl disconnect "$device"

    notify-send "Bluetooth" "Disconnected" -i bluetooth-disabled-symbolic -t 1000 -r 91190
}

scan_devices() {
    notify-send "Bluetooth" "Scanning for devices..." -i bluetooth-active-symbolic -t 1000 -r 91190

    bluetoothctl scan on &
    sleep 10
    pkill -f "bluetoothctl scan on"

    bluetoothctl devices | rofi -dmenu -p "Available Devices"
}

show_paired() {
    bluetoothctl devices Paired | rofi -dmenu -p "Paired Devices"
}

case "${1}" in
    t) toggle_bt ;;
    c) connect_device ;;
    d) disconnect_device ;;
    s) scan_devices ;;
    p) show_paired ;;
    *) print_error ;;
esac