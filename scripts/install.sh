#!/bin/bash

# copy executables
./install_executables.sh

# run sudo_install
sudo ./sudo_install.sh

# Apply Gnome Settings
gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'brave-browser.desktop', 'eu.betterbird.Betterbird.desktop', 'joplin-desktop_joplin-desktop.desktop', 'codium_codium.desktop']"
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'

