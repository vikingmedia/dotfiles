#!/bin/bash

echo "🔪 Installing UltiMaker Cura 5.8.1"
(cd /usr/local/bin && sudo curl -OL https://github.com/Ultimaker/Cura/releases/download/5.8.1/UltiMaker-Cura-5.8.1-linux-X64.AppImage)
(cd /usr/share/icons && sudo curl -O https://cdn.icon-icons.com/icons2/3053/PNG/64/ultimaker_cura_macos_bigsur_icon_189596.png)
sudo chmod +x /usr/local/bin/UltiMaker-Cura-5.8.1-linux-X64.AppImage
echo "#!/usr/bin/env xdg-open
[Desktop Entry]
Version=5.8.1
Type=Application
Terminal=false
Exec=/usr/local/bin/UltiMaker-Cura-5.8.1-linux-X64.AppImage
Name=Cura
Icon=/usr/share/icons/ultimaker_cura_macos_bigsur_icon_189596.png" | sudo tee /usr/share/applications/cura.desktop > /dev/null 


