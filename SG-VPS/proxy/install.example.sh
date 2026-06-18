#!/usr/bin/env bash
set -euo pipefail

# Example installer for proxy-tools.
# Review before running on production machines.

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="/usr/local/bin"
LIB_DIR="/usr/local/lib/proxy-tools"
CONF_FILE="/etc/proxy-tools.conf"

sudo install -d -m 0755 "$LIB_DIR"
sudo install -m 0644 "$SRC_DIR/proxy-core.sh" "$LIB_DIR/proxy-core.sh"
sudo install -m 0755 "$SRC_DIR/proxy" "$BIN_DIR/proxy"

if [ ! -f "$CONF_FILE" ]; then
  sudo install -m 0644 "$SRC_DIR/proxy-tools.conf.example" "$CONF_FILE"
fi

for name in proxy-on proxy-off proxy-status proxy-test proxy-use docker-proxy-on docker-proxy-off docker-proxy-restart; do
  sudo ln -sf "$BIN_DIR/proxy" "$BIN_DIR/$name"
done

echo "proxy-tools installed."
echo "Config: $CONF_FILE"
