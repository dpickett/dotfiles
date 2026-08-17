#!/bin/bash

# Check if any external monitors are connected
external_monitors=$(hyprctl monitors -j | jq -r '.[] | select(.name != "eDP-1") | .name')

if [[ -n "$external_monitors" ]]; then
    # External monitor(s) present - enable laptop display as secondary
    hyprctl eval 'hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto", scale = "auto" })'
else
    # No external monitors - enable laptop display as primary
    hyprctl eval 'hl.monitor({ output = "eDP-1", mode = "preferred", position = "0x0", scale = 1 })'
fi