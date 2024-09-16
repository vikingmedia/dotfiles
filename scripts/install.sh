#!/bin/bash

# Copy dotfiles
./copy.sh

# Update Ubuntu and get standard repository programs
sudo apt update && sudo apt full-upgrade -y

function apt_install {
  which $1 &> /dev/null

  if [ $? -ne 0 ]; then
    echo "APT-Installing: ${1}..."
    sudo apt install -y $1
  else
    echo "Already installed: ${1}"
  fi
}

function snap_install {
  which $1 &> /dev/null

  if [ $? -ne 0 ]; then
    echo "SNAP-Installing: ${1}..."
    sudo snap install $1
  else
    echo "Already installed: ${1}"
  fi
}

# Apply Gnome Settings
gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'brave-browser.desktop', 'codium_codium.desktop']"
gsettings set org.gnome.desktop.interface color-scheme prefer-dark

# APT Install Basics
apt_install build-essential
apt_install file
apt_install git
apt_install net-tools
apt_install curl
apt_install exfatprogs
apt_install zsh
apt_install joe
apt_install htop
apt_install wget
apt_install gnome-tweak-tool
apt_install backintime-qt 
apt_install audacity
apt_install calibre
apt_install flatpak
 
# SNAP Install Basics
snap_install vlc
snap_install joplin-desktop
snap_install chromium 
snap_install chromium-ffmpeg 

# Run all scripts in programs/
for f in programs/*.sh; do bash "$f" -H; done

# Get all upgrades
sudo apt upgrade -y
sudo apt autoremove -y

