#!/bin/bash

echo "🔑 Installing KeepassXC"
sudo add-apt-repository ppa:phoerious/keepassxc -y
sudo apt-get update
sudo apt-get install keepassxc -y