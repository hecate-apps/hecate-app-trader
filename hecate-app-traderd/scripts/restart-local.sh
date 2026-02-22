#!/bin/bash
# Restart hecate-app-traderd locally (dev mode)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TRADERD_DIR="$(dirname "$SCRIPT_DIR")"

echo "=== Restarting hecate-app-traderd (local dev) ==="

# Stop if running
RELEASE_DIR="$TRADERD_DIR/_build/default/rel/hecate_app_traderd"
if [ -f "$RELEASE_DIR/bin/hecate_app_traderd" ]; then
    "$RELEASE_DIR/bin/hecate_app_traderd" stop 2>/dev/null || true
    sleep 1
fi

# Clean old socket
SOCKET_PATH="$HOME/.hecate/hecate-app-traderd/sockets/api.sock"
rm -f "$SOCKET_PATH"

# Build
echo "Building..."
cd "$TRADERD_DIR"
rebar3 release

# Start
echo "Starting..."
"$RELEASE_DIR/bin/hecate_app_traderd" daemon

echo ""
echo "=== hecate-app-traderd started ==="
echo "Socket: $SOCKET_PATH"
echo "Health: curl --unix-socket $SOCKET_PATH http://localhost/health"
echo "Stop:   $RELEASE_DIR/bin/hecate_app_traderd stop"
