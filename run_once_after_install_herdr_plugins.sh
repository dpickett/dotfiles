#!/usr/bin/env zsh
set -eu

# Installs herdr-annotate (Plannotator) so the plugin keys in
# ~/.config/herdr/config.toml resolve. Runs after that config is applied so the
# check and reload below see the bindings.

export PATH="$HOME/.local/bin:$PATH"

if ! command -v herdr >/dev/null 2>&1; then
    curl -fsSL https://herdr.dev/install.sh | sh
fi

if ! command -v herdr >/dev/null 2>&1; then
    echo "herdr is still not on PATH; skipping herdr-annotate" >&2
    exit 0
fi

# herdr-annotate needs bun. mise owns it (see ~/.config/mise/config.toml), but
# this script runs before mise is activated, so pull bun onto PATH directly.
if ! command -v bun >/dev/null 2>&1 && [[ -x "$HOME/bin/mise" ]]; then
    "$HOME/bin/mise" install bun || true
    if bun_prefix=$("$HOME/bin/mise" where bun 2>/dev/null); then
        export PATH="$bun_prefix/bin:$PATH"
    fi
fi

if ! command -v bun >/dev/null 2>&1; then
    echo "herdr-annotate needs bun; install it, then: herdr plugin install plannotator/herdr-annotate -y" >&2
    exit 0
fi

autoload -Uz is-at-least
version=$(herdr --version | awk '{print $NF}')
if ! is-at-least 0.8.0 "$version"; then
    echo "herdr $version predates the 0.8.0 herdr-annotate needs; run 'herdr update', then rerun this script" >&2
    exit 0
fi

if herdr plugin list | grep -qw annotate; then
    echo "herdr-annotate already installed"
else
    # herdr parses the flag only after the positional argument.
    herdr plugin install plannotator/herdr-annotate -y
fi

herdr config check

if [[ -S "$HOME/.config/herdr/herdr.sock" ]]; then
    herdr server reload-config
fi
