#!/usr/bin/env zsh

function sesh-sessions() {
  {
    exec </dev/tty
    exec <&1
    local session
    session=$(sesh list -t -c | gum filter --limit 1 --no-sort --fuzzy --placeholder 'Pick a sesh' --height 50 --prompt='⚡' --no-strip-ansi)
    zle reset-prompt > /dev/null 2>&1 || true
    [[ -z "$session" ]] && return
    sesh connect $session
  }
}

zle     -N             sesh-sessions
bindkey -M emacs '^t' sesh-sessions
bindkey -M vicmd '^t' sesh-sessions
bindkey -M viins '^t' sesh-sessions

