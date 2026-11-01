#!/bin/bash

echo "🎮 Installing extract-xiso (XBox imgage conversion)"
cd /tmp
git clone https://github.com/XboxDev/extract-xiso.git
cd extract-xiso
mkdir build
cd build
cmake
make
cp extract-xiso /usr/local/bin/