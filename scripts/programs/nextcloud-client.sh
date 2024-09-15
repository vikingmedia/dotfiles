#!/bin/bash

echo "🌨️ Installing Nextcloud Client"
sudo add-apt-repository ppa:nextcloud-devs/client -y
sudo apt update
sudo apt install nautilus-nextcloud -y
mkdir /home/$USER/Documents/Vikingmedia

