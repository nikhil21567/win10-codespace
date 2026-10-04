#!/bin/bash
# Background daemon - supervises Tiny10, auto-restarts on failure
# This script runs forever in background - don't run directly!
exec >> /tmp/tiny10.log 2>&1

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
AUTO="$SCRIPT_DIR/auto.sh"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  [DAEMON] Started at $(date)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Supervisor loop - keeps Tiny10 alive forever
while true; do
    if ! pgrep -x qemu-system-x86 > /dev/null; then
        echo "[$(date)] [DAEMON] QEMU not running, starting..."
        bash "$AUTO"
    else
        echo "[$(date)] [DAEMON] QEMU running, sleeping..."
    fi
    sleep 20
done