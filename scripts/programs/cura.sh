#!/bin/bash

echo "🔪 Installing UltiMaker Cura 5.8.1"
(cd /usr/local/bin && curl -O https://github.com/Ultimaker/Cura/releases/download/5.8.1/UltiMaker-Cura-5.8.1-linux-X64.AppImage)
(cd /usr/share/icons && curl -O https://icon-icons.com/download/189596/PNG/512/)
chmod +x /usr/local/bin/UltiMaker-Cura-5.8.1-linux-X64.AppImage
echo "#!/usr/bin/env xdg-open
[Desktop Entry]
Version=5.8.1
Type=Application
Terminal=false
Exec=/usr/local/bin/UltiMaker-Cura-5.8.1-linux-X64.AppImage
Name=Cura
Icon=/usr/share/icons/ultimaker_cura_macos_bigsur_icon_189596.png" >> /usr/share/applications/cura.desktop


