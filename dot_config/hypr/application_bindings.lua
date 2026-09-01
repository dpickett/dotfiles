hl.bind("SUPER + ALT + B", hl.dsp.exec_cmd("launch-os-launch-or-focus.sh vivaldi-stable vivaldi-stable"),
    { description = "Browser" })
hl.bind("SUPER + ALT + M", hl.dsp.exec_cmd("launch-os-launch-or-focus.sh Spotify spotify-launcher"),
    { description = "Music" })
hl.bind("SUPER + ALT + W", hl.dsp.exec_cmd("launch-os-launch-or-focus.sh Signal signal-desktop"),
    { description = "Signal" })
hl.bind("SUPER + ALT + P", hl.dsp.exec_cmd("launch-os-launch-or-focus.sh Slack slack"),
    { description = "Slack" })
hl.bind("SUPER + ALT + F", hl.dsp.exec_cmd("launch-os-launch-or-focus.sh Nautilus nautilus"),
    { description = "File explorer" })
hl.bind("SUPER + ALT + K", hl.dsp.exec_cmd("launch-os-launch-or-focus.sh Obsidian obsidian"),
    { description = "Obsidian" })
hl.bind("SUPER + ALT + N", hl.dsp.exec_cmd("waydroid show-full-ui"),
    { description = "Waydroid" })
hl.bind("SUPER + ALT + O", hl.dsp.exec_cmd("launch-os-launch-or-focus.sh Chromium chromium"),
    { description = "Chrome" })

hl.bind("SUPER + SHIFT + space", hl.dsp.exec_cmd("pkill -USR2 -x handy"),
    { description = "Voice to text (toggle)" })
hl.bind("SUPER + SHIFT + period", hl.dsp.exec_cmd("pkill -USR2 -x handy"),
    { description = "Voice to text (toggle)" })

hl.bind("SUPER + ALT + R", hl.dsp.exec_cmd("~/.config/hypr/scripts/fix-monitors.sh"),
    { description = "Fix monitors" })

-- SSB Binds
hl.bind("SUPER + ALT + G",
    hl.dsp.exec_cmd('launch-os-launch-or-focus.sh mail.google.com "vivaldi-stable --app=https://mail.google.com"'),
    { description = "Gmail" })
hl.bind("SUPER + ALT + 0",
    hl.dsp.exec_cmd('launch-os-launch-or-focus.sh calendar.google.com "vivaldi-stable --app=https://calendar.google.com"'),
    { description = "Google Calendar" })
hl.bind("SUPER + ALT + Z",
    hl.dsp.exec_cmd('launch-os-launch-or-focus.sh zoom.us "vivaldi-stable --app=https://zoom.us/wc"'),
    { description = "Zoom" })
