#!/bin/bash

# Check if plugged into power
on_power=$(cat /sys/class/power_supply/A*/online 2>/dev/null | grep -q 1 && echo true || echo false)

# Check if any external monitors are connected
external_monitors=$(hyprctl monitors -j | jq -r '.[] | select(.name != "eDP-1") | .name')

if [[ "$on_power" == "true" && -n "$external_monitors" ]]; then
    # Plugged into power AND external monitor connected - disable laptop monitor
    hyprctl keyword monitor "eDP-1, disable"
else
    # Either not on power OR no external monitor - suspend
    systemctl suspend
fi