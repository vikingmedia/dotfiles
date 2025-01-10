#!/bin/bash

echo "💻 Installing OpenCBM (XUM 1541)"
echo 'deb http://download.opensuse.org/repositories/home:/strik/xUbuntu_23.04/ /' | sudo tee /etc/apt/sources.list.d/home:strik.list
curl -fsSL https://download.opensuse.org/repositories/home:strik/xUbuntu_23.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_strik.gpg > /dev/null
sudo apt update
sudo apt install opencbm
