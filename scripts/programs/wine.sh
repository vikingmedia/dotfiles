#!/usr/bin/env bash
set -e

# ==============================
# CONFIGURATION
# ==============================
WINEPREFIX="$HOME/.wine32"
WINEARCH="win32"
DOTNET_RUNTIME_URL="https://download.visualstudio.microsoft.com/download/pr/5c5c4bdb-8ef7-4ad7-a3f8-1b8d27e1c2f4/52ad0d6c21a6cb03b75a3ef57984f2f3/windowsdesktop-runtime-6.0.36-win-x86.exe"
DOTNET_INSTALLER="windowsdesktop-runtime-6.0.36-win-x86.exe"

# Winetricks dependencies (non-interactive)
WINETRICKS_DEPS=("vcrun2019" "dotnet48")

# ==============================
# FUNCTIONS
# ==============================

install_wine() {
    echo "🔹 Installing Wine (32-bit support)..."
    sudo dpkg --add-architecture i386
    sudo mkdir -pm755 /etc/apt/keyrings
    sudo wget -q -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
    UBUNTU_VERSION=$(lsb_release -cs)
    sudo wget -q -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/$UBUNTU_VERSION/winehq-$UBUNTU_VERSION.sources
    sudo apt update
    sudo apt install -y --install-recommends winehq-stable winbind cabextract wget unzip
}

install_winetricks() {
    echo "🔹 Installing Winetricks..."
    sudo apt install -y winetricks
}

create_wine_prefix() {
    echo "🔹 Creating 32-bit Wine prefix at $WINEPREFIX..."
    export WINEPREFIX
    export WINEARCH

    # Initialize prefix
    wineboot --init

    # Set Windows version to Windows 10
    echo "🔹 Setting Windows version to Windows 10..."
    REG_FILE=$(mktemp)
    cat > "$REG_FILE" <<EOF
REGEDIT4

[HKEY_CURRENT_USER\Software\Wine\Wine\Version]
"CurrentVersion"="win10"
EOF
    wine regedit "$REG_FILE"
    rm -f "$REG_FILE"
}

install_dotnet_runtime() {
    echo "🔹 Downloading .NET Desktop Runtime 6.0 (x86)..."
    wget -O "$DOTNET_INSTALLER" "$DOTNET_RUNTIME_URL"

    echo "🔹 Installing .NET Desktop Runtime inside Wine prefix..."
    export WINEPREFIX
    export WINEARCH
    wine "$DOTNET_INSTALLER" /quiet /norestart

    echo "✅ .NET Desktop Runtime installed successfully!"
    rm -f "$DOTNET_INSTALLER"
}

install_winetricks_deps() {
    echo "🔹 Installing common Winetricks dependencies (non-interactive)..."
    export WINEPREFIX
    export WINEARCH
    for dep in "${WINETRICKS_DEPS[@]}"; do
        echo "  Installing $dep..."
        winetricks -q "$dep"
    done
}

# ==============================
# MAIN SCRIPT
# ==============================

echo "🍷 Wine (32-bit support)"

install_wine
install_winetricks
create_wine_prefix
install_dotnet_runtime
install_winetricks_deps

echo "✅ All done!"
echo "To use your custom Wine prefix, run:"
echo ""
echo "  export WINEPREFIX=$WINEPREFIX"
echo "  winecfg  # optional to check settings"
echo ""
echo "Prefix location: $WINEPREFIX"
