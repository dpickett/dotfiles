#!/bin/bash

# Re-initialize monitors after suspend/resume or when a display doesn't wake up.
# Can be called manually (instant) or via hypridle's after_sleep_cmd (with a leading sleep).

hyprctl dispatch dpms off
sleep 1
hyprctl dispatch dpms on
sleep 1
hyprctl reload
