#!/bin/bash
WIN_DIR="/workspaces/.windows"
ISO="$WIN_DIR/tiny10.iso"
DISK="$WIN_DIR/disk.qcow2"
INSTALL_FLAG="$WIN_DIR/.installed"

# noVNC start (port 6080 -> 5900)
pkill -f websockify 2>/dev/null || true
websockify --web=/usr/share/novnc 6080 localhost:5900 >/tmp/novnc.log 2>&1 &

# Smart boot: pehli baar CD se, baad me sirf disk
if [ -f "$INSTALL_FLAG" ]; then
    BOOT_FLAGS="-boot order=c"
    CDROM=""
else
    BOOT_FLAGS="-boot order=dc"
    CDROM="-drive file=$ISO,media=cdrom,if=ide,index=1"
fi

# QEMU start (TCG mode - no KVM in Codespaces)
# Optimized for 2-core / 8GB Codespace machine
qemu-system-x86_64 \
    -name "Windows10" \
    -machine accel=tcg \
    -cpu qemu64 \
    -smp 2 -m 2500M \
    -drive file="$DISK",format=qcow2,if=ide,index=0 \
    $CDROM \
    $BOOT_FLAGS \
    -vga std -netdev user,id=net0 -device e1000,netdev=net0 \
    -rtc base=localtime -usb -device usb-tablet \
    -vnc 0.0.0.0:0 -daemonize

echo "================================================="
echo "Windows 10 booting (2-core/2.5GB mode)..."
echo "PORTS tab -> 6080 -> 'Open in Browser' (globe icon)"
echo "URL: https://<your-codespace>-6080.app.github.dev/vnc.html"
echo "================================================="
echo "Install ke baad file create karo:"
echo "  touch $INSTALL_FLAG"
echo "  bash scripts/start.sh"
echo ""
echo "[!] Note: Free tier 2-core/8GB pe Win10 slow chalega (TCG mode)."
echo "[!] For smooth performance, Oracle Cloud free tier (KVM) recommended."