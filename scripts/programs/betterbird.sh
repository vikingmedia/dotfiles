#!/bin/bash

echo "📨 Installing Betterbird"
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
sudo flatpak install flathub eu.betterbird.Betterbird -y

