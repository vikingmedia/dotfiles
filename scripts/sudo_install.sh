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

function flatpak_install {
  which $1 &> /dev/null

  if [ $? -ne 0 ]; then
    echo "FLATPAK-Installing: ${1}..."
    sudo flatpak install flathub $1 -y
  else
    echo "Already installed: ${1}"
  fi
}


# APT Install Basics
apt_install dbus-x11
apt_install build-essential
apt_install software-properties-common
apt_install apt-transport-https curl
apt_install libfuse2
apt_install file
apt_install git
apt_install xz-utils
apt_install net-tools
apt_install curl
apt_install exfatprogs
apt_install zsh
apt_install joe
apt_install htop
apt_install wget
apt_install gnome-tweaks
apt_install backintime-qt 
apt_install audacity
apt_install calibre
apt_install flatpak
apt_install rhythmbox
apt_install meld
apt_install steam-installer
apt_install steam-devices
apt_install gparted
apt_install usb-creator-gtk
apt_install ncdu
apt_install vice # for c1541 command line tool
apt_install pkg-config
# imagemagick and support libraries
apt_install libpng-dev 
apt_install libjpeg-dev
apt_install libtiff-dev
apt_install imagemagick
#
apt_install cmake
# apt_install minigalaxy # GOG Client
apt_install sqlite3
apt_install wipe


# SNAP Install Basics
snap_install vlc
snap_install joplin-desktop
snap_install chromium 
snap_install chromium-ffmpeg 
snap_install freecad
snap_install transmission
snap_install signal-desktop

# FLATPAK INSTALL
flatpak_install org.prismlauncher.PrismLauncher
flatpak_install com.heroicgameslauncher.hgl

# Run all scripts in programs/
for f in programs/*.sh; do bash "$f" -H; done

# Get all upgrades
sudo apt upgrade -y
sudo apt autoremove -y

# Apply Gnome Settings
gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'brave-browser.desktop', 'eu.betterbird.Betterbird.desktop', 'joplin-desktop_joplin-desktop.desktop', 'codium_codium.desktop']"
gsettings set org.gnome.desktop.interface color-scheme prefer-dark

