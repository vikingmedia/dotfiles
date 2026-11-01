#!/bin/bash
#
# Idempotent KVM/QEMU + libvirt setup for a Windows 11 guest (UEFI Secure Boot, TPM 2.0,
# VirtIO, SPICE) on Ubuntu 24.04. After setup the VM can be managed as a normal user.
#
# Usage:
#   ./kvm_windows11.sh                      # host setup only
#   ./kvm_windows11.sh /path/to/Win11.iso   # host setup + create the "win11" VM
#
# Overridable via environment: VM_USER, VM_NAME, VM_RAM_MB, VM_VCPUS, VM_DISK_GB

set -euo pipefail

VM_USER="${VM_USER:-$(id -un)}"
VM_NAME="${VM_NAME:-win11}"
VM_RAM_MB="${VM_RAM_MB:-6144}"
VM_VCPUS="${VM_VCPUS:-4}"
VM_DISK_GB="${VM_DISK_GB:-80}"
WIN_ISO_SRC="${1:-}"

LIBVIRT_URI="qemu:///system"
IMAGES_DIR="/var/lib/libvirt/images"
VIRTIO_ISO="${IMAGES_DIR}/virtio-win.iso"
VIRTIO_URL="https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso"
WIN_ISO="${IMAGES_DIR}/${VM_NAME}-install.iso"
VM_DISK="${IMAGES_DIR}/${VM_NAME}.qcow2"
OVMF_CODE="/usr/share/OVMF/OVMF_CODE_4M.secboot.fd"
OVMF_VARS="/usr/share/OVMF/OVMF_VARS_4M.ms.fd"

PACKAGES=(
  qemu-system-x86
  qemu-utils
  libvirt-daemon-system
  libvirt-clients
  virtinst
  virt-manager
  virt-viewer
  bridge-utils
  cpu-checker
  ovmf
  swtpm
  swtpm-tools
  spice-client-gtk
  gir1.2-spiceclientgtk-3.0
  wget
)

if [[ $EUID -eq 0 ]]; then
  echo "Please run as a normal user; sudo is invoked where needed."
  exit 1
fi

echo "🖥️  Setting up KVM/QEMU for Windows 11"

# --- CPU virtualization -----------------------------------------------------
if ! grep -Eq '(vmx|svm)' /proc/cpuinfo; then
  echo "❌ CPU virtualization (VT-x) not available. Enable it in the BIOS."
  exit 1
fi

# --- Packages ---------------------------------------------------------------
missing=()
for pkg in "${PACKAGES[@]}"; do
  if ! dpkg-query -W -f='${Status}' "$pkg" 2>/dev/null | grep -q "install ok installed"; then
    missing+=("$pkg")
  fi
done

if (( ${#missing[@]} )); then
  echo "📦 Installing: ${missing[*]}"
  sudo apt update
  sudo apt install -y "${missing[@]}"
else
  echo "📦 All packages already installed"
fi

sudo kvm-ok

# --- libvirt daemon ---------------------------------------------------------
if ! systemctl is-enabled --quiet libvirtd || ! systemctl is-active --quiet libvirtd; then
  sudo systemctl enable --now libvirtd
fi

# --- Groups for non-root access ---------------------------------------------
added_group=false
for grp in libvirt kvm; do
  if ! grep -qx "$grp" <<< "$(id -nG "$VM_USER" | tr ' ' '\n')"; then
    echo "👤 Adding ${VM_USER} to group ${grp}"
    sudo usermod -aG "$grp" "$VM_USER"
    added_group=true
  fi
done

# Make virsh/virt-install default to the system connection (as virt-manager does)
for rc in "/home/${VM_USER}/.bashrc" "/home/${VM_USER}/.zshrc"; do
  if [[ -f "$rc" ]] && ! grep -q 'LIBVIRT_DEFAULT_URI' "$rc"; then
    echo "export LIBVIRT_DEFAULT_URI=\"${LIBVIRT_URI}\"" >> "$rc"
  fi
done

# --- Default NAT network ----------------------------------------------------
if ! sudo virsh -c "$LIBVIRT_URI" net-info default &>/dev/null; then
  sudo virsh -c "$LIBVIRT_URI" net-define /usr/share/libvirt/networks/default.xml
fi
if ! grep -qx default <<< "$(sudo virsh -c "$LIBVIRT_URI" net-list --name)"; then
  sudo virsh -c "$LIBVIRT_URI" net-start default
fi
if ! grep -qx default <<< "$(sudo virsh -c "$LIBVIRT_URI" net-list --all --autostart --name)"; then
  sudo virsh -c "$LIBVIRT_URI" net-autostart default
fi

# --- VirtIO drivers ISO -----------------------------------------------------
if [[ ! -s "$VIRTIO_ISO" ]]; then
  echo "💿 Downloading VirtIO drivers ISO"
  sudo wget -O "${VIRTIO_ISO}.part" "$VIRTIO_URL"
  sudo mv "${VIRTIO_ISO}.part" "$VIRTIO_ISO"
else
  echo "💿 VirtIO ISO already present: ${VIRTIO_ISO}"
fi

for f in "$OVMF_CODE" "$OVMF_VARS"; do
  [[ -f "$f" ]] || { echo "❌ Missing OVMF firmware: $f"; exit 1; }
done

# --- Windows 11 VM ----------------------------------------------------------
if sudo virsh -c "$LIBVIRT_URI" dominfo "$VM_NAME" &>/dev/null; then
  echo "🪟 VM '${VM_NAME}' already exists"
elif [[ -z "$WIN_ISO_SRC" ]]; then
  echo "ℹ️  No Windows ISO given; skipping VM creation."
  echo "   Re-run with: $0 /path/to/Win11.iso"
else
  [[ -f "$WIN_ISO_SRC" ]] || { echo "❌ ISO not found: $WIN_ISO_SRC"; exit 1; }

  # libvirt-qemu cannot read files inside the (mode 750) home directory
  if [[ ! -s "$WIN_ISO" ]]; then
    echo "💿 Copying Windows ISO to ${WIN_ISO}"
    sudo cp "$WIN_ISO_SRC" "$WIN_ISO"
  fi

  echo "🪟 Creating VM '${VM_NAME}'"
  sudo virt-install \
    --connect "$LIBVIRT_URI" \
    --name "$VM_NAME" \
    --osinfo win11 \
    --memory "$VM_RAM_MB" \
    --vcpus "$VM_VCPUS" \
    --cpu host-passthrough \
    --machine q35 \
    --features smm.state=on \
    --boot "loader=${OVMF_CODE},loader.readonly=yes,loader.type=pflash,loader.secure=yes,nvram.template=${OVMF_VARS}" \
    --tpm backend.type=emulator,backend.version=2.0,model=tpm-crb \
    --disk "path=${VM_DISK},size=${VM_DISK_GB},format=qcow2,bus=virtio,discard=unmap" \
    --disk "path=${WIN_ISO},device=cdrom,bus=sata" \
    --disk "path=${VIRTIO_ISO},device=cdrom,bus=sata" \
    --network network=default,model=virtio \
    --graphics spice \
    --video qxl \
    --channel spicevmc \
    --sound ich9 \
    --input tablet,bus=usb \
    --noautoconsole
fi

# --- Desktop shortcut -------------------------------------------------------
if sudo virsh -c "$LIBVIRT_URI" dominfo "$VM_NAME" &>/dev/null; then
  apps_dir="/home/${VM_USER}/.local/share/applications"
  icon="/home/${VM_USER}/.local/share/icons/${VM_NAME}.svg"
  mkdir -p "$apps_dir" "$(dirname "$icon")"
  cat > "$icon" <<'EOF'
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 88 88">
  <defs>
    <linearGradient id="g" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0" stop-color="#28AFEA"/>
      <stop offset="1" stop-color="#0063B1"/>
    </linearGradient>
  </defs>
  <rect x="0" y="0" width="42" height="42" fill="url(#g)"/>
  <rect x="46" y="0" width="42" height="42" fill="url(#g)"/>
  <rect x="0" y="46" width="42" height="42" fill="url(#g)"/>
  <rect x="46" y="46" width="42" height="42" fill="url(#g)"/>
</svg>
EOF
  cat > "${apps_dir}/${VM_NAME}.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=Windows 11 (${VM_NAME})
Comment=Start the ${VM_NAME} VM and open its display
Exec=sh -c "virsh -c ${LIBVIRT_URI} start ${VM_NAME} 2>/dev/null; exec virt-viewer -c ${LIBVIRT_URI} --attach --wait ${VM_NAME}"
Icon=${icon}
Terminal=false
Categories=System;Emulator;
EOF
  echo "🔗 Shortcut created: ${apps_dir}/${VM_NAME}.desktop"
fi

echo
echo "✅ Done."
if $added_group; then
  echo "⚠️  Log out and back in (or reboot) so the new group membership takes effect."
fi
cat <<EOF
Start/manage the VM as ${VM_USER} without root:
  virt-manager                        (connection: QEMU/KVM, ${LIBVIRT_URI})
  virsh -c ${LIBVIRT_URI} start ${VM_NAME}
  virt-viewer -c ${LIBVIRT_URI} ${VM_NAME}

During Windows setup, when no disk is shown: "Load driver" -> VirtIO CD ->
  viostor\\w11\\amd64. Afterwards run virtio-win-guest-tools.exe from the VirtIO CD
  (installs network, QXL/SPICE agent and balloon drivers).
EOF
