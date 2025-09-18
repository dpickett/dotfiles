#!/usr/bin/env zsh

{{- if eq .chezmoi.os "linux" }}
# Source shared utilities from chezmoi source directory
source "{{ .chezmoi.sourceDir }}/dot_local/lib/chezmoi/utils.sh"

# Install starship
install_packages starship
{{- else }}
brew install starship
{{- end }}