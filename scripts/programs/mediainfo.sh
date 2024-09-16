#!/bin/bash

echo "👁️ Installing Mediainfo"
cd /tmp
wget https://mediaarea.net/repo/deb/repo-mediaarea_1.0-24_all.deb
sudo dpkg -i repo-mediaarea_1.0-24_all.deb
apt update
sudo apt install mediainfo-gui -y


