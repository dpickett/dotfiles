-- Handle lid switch events
hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("~/.config/hypr/scripts/lid-close.sh"), { locked = true })
hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd("~/.config/hypr/scripts/lid-open.sh"), { locked = true })
