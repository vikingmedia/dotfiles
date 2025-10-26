#!/bin/bash

echo "🎮 OPL Manager V24 (PS2)"

# Set variables
URL="https://static2.oplmanager.com/releases/OPL_Manager_V24.zip"
DEST_DIR="$HOME/.oplmanager"
ZIP_FILE="OPL_Manager_V24.zip"

# Download the ZIP file
echo "Downloading OPL Manager V24..."
curl -L -o "$ZIP_FILE" "$URL"

# Check if download was successful
if [ $? -ne 0 ]; then
    echo "Error: Download failed."
    exit 1
fi

# Create destination directory
mkdir -p "$DEST_DIR"

# create directory for PS2 files
mkdir -p "$HOME/Documents/OPLManager"

# Unzip the file
echo "Unzipping into $DEST_DIR..."
unzip -q "$ZIP_FILE" -d "$DEST_DIR"

# Check if unzip was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to unzip the file."
    exit 1
fi

# Optional: remove the ZIP file after extraction
rm "$ZIP_FILE"

echo "✅ Download and extraction complete! Files are in: $DEST_DIR"

# create OPL Manager Config file
echo "LANGUAGE=de
AUTOUPDATE=True
TRACK_ID=68013613239c6
MODE=0
OPL_FOLDER=C:\users\zking\Documents\OPLManager\
MainSplitterPos=1510
HDL_VERSION=hdl_dump_086.exe
BATCH_ART_SHARE_IGNORED_GAMES=" | tee "$DEST_DIR/OPLManager.ini" > /dev/null

# create OPL manager script
echo "export WINEPREFIX=~/.wine32
cd $DEST_DIR
wine OPL_Manager.exe" | tee $HOME/.local/bin/opl-manager.sh
chmod +x $HOME/.local/bin/opl-manager.sh

# create desktop shortcut
echo "#!/usr/bin/env xdg-open
[Desktop Entry]
Version=24
Type=Application
Terminal=false
Exec=$DEST_DIR/oplmanager.sh
Name=OPL Manager
Icon=$HOME/share/icons/oplmanager.jpg" | tee $HOME/share/applications/oplmanager.desktop > /dev/null 

