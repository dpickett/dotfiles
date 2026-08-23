#!/usr/bin/env zsh

# Runs after ~/.config/mise/config.toml is applied so mise knows which global
# versions to install. The node.corepack setting there enables corepack for us.
~/bin/mise install

export PNPM_HOME="$HOME/.local/share/pnpm"
mkdir -p "$PNPM_HOME"

~/bin/mise exec -- corepack prepare pnpm@latest --activate
~/bin/mise exec -- pnpm config set global-dir "$PNPM_HOME"
~/bin/mise exec -- pnpm config set global-bin-dir "$PNPM_HOME"
