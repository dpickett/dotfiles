#!/usr/bin/env bash

# Shared utility functions for chezmoi dotfiles

# Install packages using the appropriate package manager for the current Linux distribution
# Usage: install_packages package1 package2 package3...
install_packages() {
    if [ $# -eq 0 ]; then
        echo "Usage: install_packages package1 [package2 ...]"
        return 1
    fi

    if command -v pacman >/dev/null 2>&1; then
        # Arch Linux
        sudo pacman -S --needed "$@"
    elif command -v apt-get >/dev/null 2>&1; then
        # Debian/Ubuntu
        sudo apt-get update && sudo apt-get install -y "$@"
    elif command -v dnf >/dev/null 2>&1; then
        # Fedora
        sudo dnf install -y "$@"
    elif command -v zypper >/dev/null 2>&1; then
        # openSUSE
        sudo zypper install -y "$@"
    else
        echo "Error: Unsupported Linux distribution. No recognized package manager found."
        echo "Tried: pacman (Arch), apt-get (Debian/Ubuntu), dnf (Fedora), zypper (openSUSE)"
        return 1
    fi
}