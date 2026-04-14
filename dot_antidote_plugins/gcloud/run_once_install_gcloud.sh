#!/usr/bin/env bash

set -euo pipefail

INSTALL_DIR="$HOME/google-cloud-sdk"

if [[ -f "$INSTALL_DIR/bin/gcloud" ]]; then
  echo "gcloud already installed at $INSTALL_DIR, skipping."
  exit 0
fi

OS="$(uname -s)"
ARCH="$(uname -m)"

case "$OS" in
  Linux)
    case "$ARCH" in
      x86_64)  TARBALL="google-cloud-cli-linux-x86_64.tar.gz" ;;
      aarch64) TARBALL="google-cloud-cli-linux-arm.tar.gz" ;;
      *)       echo "Unsupported Linux architecture: $ARCH"; exit 1 ;;
    esac
    ;;
  Darwin)
    case "$ARCH" in
      x86_64) TARBALL="google-cloud-cli-darwin-x86_64.tar.gz" ;;
      arm64)  TARBALL="google-cloud-cli-darwin-arm.tar.gz" ;;
      *)      echo "Unsupported macOS architecture: $ARCH"; exit 1 ;;
    esac
    ;;
  *)
    echo "Unsupported OS: $OS"
    exit 1
    ;;
esac

DOWNLOAD_URL="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/$TARBALL"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

echo "Downloading $DOWNLOAD_URL ..."
curl -fsSL "$DOWNLOAD_URL" -o "$TMP_DIR/$TARBALL"

echo "Extracting to $HOME ..."
tar -xf "$TMP_DIR/$TARBALL" -C "$HOME"

echo "Running installer (non-interactive) ..."
"$INSTALL_DIR/install.sh" \
  --quiet \
  --path-update=false \
  --command-completion=false \
  --usage-reporting=false

echo "gcloud installation complete."
echo "Run 'gcloud init' to initialize your configuration."
