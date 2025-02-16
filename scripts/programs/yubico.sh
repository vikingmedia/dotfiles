#!/bin/bash

echo "🕵️ Installing Yubico Authenticator"
cd /tmp
curl -OL https://developers.yubico.com/yubioath-flutter/Releases/yubico-authenticator-latest-linux.tar.gz
sudo tar -xf yubico-authenticator-latest-linux.tar.gz -C /opt
cd /opt/yubico*
./desktop_integration.sh -i

