#!/bin/bash

# Check if any external monitors are connected
external_monitors=$(hyprctl monitors -j | jq -r '.[] | select(.name != "eDP-1") | .name')

if [[ -n "$external_monitors" ]]; then
    # External monitor(s) present - enable laptop display as secondary
    hyprctl keyword monitor "eDP-1, preferred, auto, auto"
else
    # No external monitors - enable laptop display as primary
    hyprctl keyword monitor "eDP-1, preferred, 0x0, 1"
fi