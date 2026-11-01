#!/bin/bash

echo "🌨️ Installing Opencloud Desktop"

# Define the download URL for the latest OpenCloud Desktop AppImage
REPO_URL="https://github.com/opencloud-eu/desktop/releases"
DOWNLOAD_DIR="$HOME/Downloads"
INSTALL_DIR="$HOME/.local/bin"

# Create the install directory if it doesn't exist
mkdir -p "$INSTALL_DIR"

# Get the latest AppImage URL (this assumes the latest release is at the top)
echo "Fetching the latest OpenCloud Desktop AppImage..."
LATEST_APPIMAGE_URL=$(curl -s "$REPO_URL" | grep -o 'https://github.com/.*OpenCloud-.*\.AppImage' | head -1)

if [ -z "$LATEST_APPIMAGE_URL" ]; then
    echo "Error: Could not find an AppImage URL. Please check the releases page manually."
    exit 1
fi

echo "Downloading $LATEST_APPIMAGE_URL..."
wget "$LATEST_APPIMAGE_URL" -P "$DOWNLOAD_DIR"

# Move to install directory and make executable
APPIMAGE_FILE=$(basename "$LATEST_APPIMAGE_URL")
ln -sf "$DOWNLOAD_DIR/$APPIMAGE_FILE" "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/$APPIMAGE_FILE"

echo "OpenCloud Desktop AppImage has been installed to $INSTALL_DIR/"
echo "You can now run it with: $APPIMAGE_FILE"
echo "Or, if $INSTALL_DIR is in your PATH, just type: $APPIMAGE_FILE"
