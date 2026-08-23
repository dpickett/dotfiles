#!/bin/bash

# Re-initialize monitors after suspend/resume or when a display doesn't wake up.
# Can be called manually (instant) or via hypridle's after_sleep_cmd (with a leading sleep).

hyprctl dispatch 'hl.dsp.dpms({ action = "off" })'
sleep 1
hyprctl dispatch 'hl.dsp.dpms({ action = "on" })'
sleep 1
hyprctl reload
