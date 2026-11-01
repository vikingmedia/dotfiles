#!/bin/bash

echo "🚀 Installing Appimage Launcher"

# Define the download URL for the latest AppImageLauncher .deb package
# (This URL is for the GitHub releases page; the script will fetch the latest release)
REPO_URL="https://github.com/TheAssassin/AppImageLauncher/releases"

# Create a temporary directory for the download
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR" || exit 1

# Get the latest .deb package URL (this assumes the latest release is at the top)
# Note: This is a simplified approach; for a production script, use GitHub API or parse HTML more robustly.
echo "Fetching the latest AppImageLauncher .deb package..."
LATEST_DEB_URL=$(curl -s "$REPO_URL" | grep -o 'https://github.com/.*appimagelauncher.*\.deb' | head -1)

if [ -z "$LATEST_DEB_URL" ]; then
    echo "Error: Could not find a .deb package URL. Please check the releases page manually."
    exit 1
fi

echo "Downloading $LATEST_DEB_URL..."
wget "$LATEST_DEB_URL" -O appimagelauncher_latest.deb

# Install the package and dependencies
echo "Installing AppImageLauncher..."
sudo dpkg -i appimagelauncher_latest.deb
sudo apt-get install -f

# Clean up
rm -rf "$TEMP_DIR"

echo "AppImageLauncher has been installed successfully."