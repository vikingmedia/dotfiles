#!/bin/bash

echo "🍺 Installing Github Desktop"

curl -fsSL https://mirror.mwt.me/shiftkey-desktop/gpgkey | gpg --dearmor --batch --yes | sudo tee /usr/share/keyrings/mwt-desktop.gpg > /dev/null
cat <<EOF | sudo tee /etc/apt/sources.list.d/mwt-desktop.sources
Types: deb
URIs: https://mirror.mwt.me/shiftkey-desktop/deb/
Suites: any
Components: main
Architectures: $(dpkg --print-architecture)
Signed-By: /usr/share/keyrings/mwt-desktop.gpg
EOF
sudo apt update && sudo apt install github-desktop -y  