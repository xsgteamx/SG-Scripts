#!/usr/bin/env bash
set -euo pipefail

# Restore SG-VPS host route for home LAN through wg-easy/wg0.
# Safe to run repeatedly from systemd timer.

WG_IF="${WG_IF:-wg0}"
ROUTER_WG_IP="${ROUTER_WG_IP:-10.8.0.2}"
HOME_LAN="${HOME_LAN:-192.168.50.0/24}"

for _ in $(seq 1 60); do
  if ip link show "$WG_IF" >/dev/null 2>&1; then
    break
  fi
  sleep 1
done

if ! ip link show "$WG_IF" >/dev/null 2>&1; then
  echo "ERROR: $WG_IF not found"
  exit 1
fi

PEER="$(wg show "$WG_IF" allowed-ips | awk -v ip="${ROUTER_WG_IP}/32" '$0 ~ ip {print $1; exit}')"

if [ -n "${PEER:-}" ]; then
  wg set "$WG_IF" peer "$PEER" allowed-ips "${ROUTER_WG_IP}/32,${HOME_LAN}"
else
  echo "WARN: peer for ${ROUTER_WG_IP}/32 not found; skip wg set"
fi

ip route replace "$HOME_LAN" dev "$WG_IF"

echo "OK: $HOME_LAN -> $WG_IF"
ip route get "${HOME_LAN%/*}" || true
