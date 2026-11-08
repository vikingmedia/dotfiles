#!/bin/bash

set -euo pipefail

URL="https://github.com/DefenderOfHyrule/OmniRCM/releases/latest/download/OmniRCM-linux-x64"
DEST_DIR="$HOME/.local/bin"
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

echo "Downloading the latest OmniRCM for Linux x64..."
curl --fail --location --show-error --output "$TEMP_DIR/OmniRCM-linux-x64" "$URL"

mkdir -p "$DEST_DIR"
install -m 0755 "$TEMP_DIR/OmniRCM-linux-x64" "$DEST_DIR/OmniRCM-linux-x64"

echo "Installed OmniRCM to $DEST_DIR/OmniRCM-linux-x64"