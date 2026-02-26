#!/bin/bash

# Log execution for debugging
logger "lid-close.sh: Script executed"

# Check if plugged into power
on_power=$(cat /sys/class/power_supply/A*/online 2>/dev/null | grep -q 1 && echo true || echo false)

# Check if any external monitors are connected
external_monitors=$(hyprctl monitors -j | jq -r '.[] | select(.name != "eDP-1") | .name')

logger "lid-close.sh: on_power=$on_power, external_monitors=$external_monitors"

if [[ "$on_power" == "true" && -n "$external_monitors" ]]; then
    # Plugged into power AND external monitor connected - disable laptop monitor
    logger "lid-close.sh: Disabling internal monitor"
    hyprctl keyword monitor "eDP-1, disable"
else
    # Either not on power OR no external monitor - lock and suspend
    logger "lid-close.sh: Attempting suspend"
    loginctl lock-session
    # Use systemctl suspend directly (not --user)
    systemctl suspend
fi