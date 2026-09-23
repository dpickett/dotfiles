#!/usr/bin/env bash

# Shared utility functions for chezmoi dotfiles

# Map a package name (as used by the other package managers) to its
# nixpkgs attribute and the binary it provides.
# Usage: _nix_pkg_info package -> prints "attr bin"
_nix_pkg_info() {
    case "$1" in
        github-cli) echo "gh gh" ;;
        neovim) echo "neovim nvim" ;;
        awscli2) echo "awscli2 aws" ;;
        *) echo "$1 $1" ;;
    esac
}

# Install packages into the user's nix profile, skipping anything already on
# PATH (e.g. provided by the system flake).
_install_packages_nix() {
    local pkg attr bin
    local -a attrs=()
    for pkg in "$@"; do
        read -r attr bin <<<"$(_nix_pkg_info "$pkg")"
        if command -v "$bin" >/dev/null 2>&1; then
            echo "$pkg already available at $(command -v "$bin"), skipping"
        else
            attrs+=("nixpkgs#$attr")
        fi
    done
    [ ${#attrs[@]} -eq 0 ] && return 0
    nix --extra-experimental-features 'nix-command flakes' profile add "${attrs[@]}"
}

# Install packages using the appropriate package manager for the current Linux distribution
# Usage: install_packages package1 package2 package3...
install_packages() {
    if [ $# -eq 0 ]; then
        echo "Usage: install_packages package1 [package2 ...]"
        return 1
    fi

    if [ -e /etc/NIXOS ]; then
        # NixOS - no system package manager to call imperatively
        _install_packages_nix "$@"
    elif command -v pacman >/dev/null 2>&1; then
        # Arch Linux - use yes to auto-answer any remaining prompts
        yes | sudo pacman -S --needed --noconfirm "$@"
    elif command -v apt-get >/dev/null 2>&1; then
        # Debian/Ubuntu
        sudo apt-get update && yes | sudo apt-get install -y "$@"
    elif command -v dnf >/dev/null 2>&1; then
        # Fedora
        yes | sudo dnf install -y "$@"
    elif command -v zypper >/dev/null 2>&1; then
        # openSUSE
        yes | sudo zypper install -y "$@"
    else
        echo "Error: Unsupported Linux distribution. No recognized package manager found."
        echo "Tried: NixOS (nix profile), pacman (Arch), apt-get (Debian/Ubuntu), dnf (Fedora), zypper (openSUSE)"
        return 1
    fi
}
