#!/bin/bash
# ZERO COMMANDS launcher - backgrounds everything, returns immediately
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Ensure workspace exists
mkdir -p /workspaces/.windows

# Kill any old daemon (idempotent restart)
pkill -f "win10-codespace/scripts/daemon.sh" 2>/dev/null
pkill -f "win10-codespace/scripts/auto.sh" 2>/dev/null
sleep 1

# Start background daemon - THIS IS THE KEY
# nohup + setsid + disown = truly background, survives shell exit
nohup setsid bash "$SCRIPT_DIR/daemon.sh" > /tmp/tiny10.log 2>&1 < /dev/null &
disown

# Wait briefly for daemon to start
sleep 2

# Show user what to do next (no action needed, just info)
cat << 'EOF'

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✅ Tiny10 setup STARTED in background
  ⏱️  Wait 2-3 min, then open port 6080
  🖥️  PORTS tab -> click "Open Tiny10 Desktop"
  📄 Logs: /tmp/tiny10.log
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF