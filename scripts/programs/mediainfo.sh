#!/bin/bash

echo "👁️ Installing Mediainfo"
cd /tmp
wget https://mediaarea.net/repo/deb/repo-mediaarea_1.0-26_all.deb 
dpkg -i repo-mediaarea_1.0-26_all.deb 
apt update
sudo apt install mediainfo-gui -y