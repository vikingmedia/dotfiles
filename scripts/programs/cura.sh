#!/bin/bash

echo "🔪 Installing UltiMaker Cura"
(cd /usr/local/bin && sudo curl -OL https://github.com/Ultimaker/Cura/releases/download/4.13.1/Ultimaker_Cura-4.13.1.AppImage)
(cd /usr/share/icons && sudo curl -O https://cdn.icon-icons.com/icons2/3053/PNG/64/ultimaker_cura_macos_bigsur_icon_189596.png)
sudo chmod +x /usr/local/bin/Ultimaker_Cura-4.13.1.AppImage
echo "#!/usr/bin/env xdg-open
[Desktop Entry]
Version=4.13.1
Type=Application
Terminal=false
Exec=/usr/local/bin/Ultimaker_Cura-4.13.1.AppImage
Name=Cura
Icon=/usr/share/icons/ultimaker_cura_macos_bigsur_icon_189596.png" | sudo tee /usr/share/applications/cura.desktop > /dev/null 


