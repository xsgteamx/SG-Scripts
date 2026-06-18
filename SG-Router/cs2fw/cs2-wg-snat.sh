#!/bin/sh

PATH="/usr/sbin:/usr/bin:/sbin:/bin:/jffs/cs2fw:/jffs/scripts"
export PATH

APP="SG-CS2FW"
VER="1.1"

ENV_FILE="/jffs/cs2fw/cs2fw.env"

ENABLED="1"
WG_IF="wg81"
LAN_IF="br0"
VPS_WG_IPS="10.8.0.1"
TARGET_LAN_IPS="192.168.50.101"
ROUTER_LAN_IP="192.168.50.1"
PORTS="27015"
PROTOS="udp tcp"
NAT_CHAIN="SG_CS2FW_SNAT"
CRON_NAME="sg_cs2fw_watch"
WATCH_CRON="*/5 * * * *"
LOG_FILE="/tmp/sg-cs2fw.log"
MAX_LOG_LINES="200"
LOG_TAG="sg-cs2fw"

IPT="/usr/sbin/iptables"
IP="/usr/sbin/ip"
CRU="/usr/sbin/cru"
LOGGER="/usr/bin/logger"
[ -x "$LOGGER" ] || LOGGER="/bin/logger"

load_env() {
  [ -f "$ENV_FILE" ] && . "$ENV_FILE"
}

logi() {
  TS="$(date '+%Y-%m-%d %H:%M:%S' 2>/dev/null || date)"
  printf "%s [%s] %s\n" "$TS" "$LOG_TAG" "$*" >> "$LOG_FILE"
  [ -x "$LOGGER" ] && "$LOGGER" -t "$LOG_TAG" "$*"
}

ensure_chain() {
  $IPT -t nat -N "$NAT_CHAIN" 2>/dev/null || true
}

remove_jump() {
  while $IPT -t nat -D POSTROUTING -j "$NAT_CHAIN" 2>/dev/null; do :; done
}

start() {
  load_env
  ensure_chain
  remove_jump
  $IPT -t nat -F "$NAT_CHAIN"

  for SRC in $VPS_WG_IPS; do
    for DST in $TARGET_LAN_IPS; do
      for PORT in $PORTS; do
        for PROTO in $PROTOS; do
          $IPT -t nat -A "$NAT_CHAIN" \
            -s "$SRC" -d "$DST" -p "$PROTO" --dport "$PORT" \
            -j SNAT --to-source "$ROUTER_LAN_IP"
        done
      done
    done
  done

  $IPT -t nat -I POSTROUTING 1 -j "$NAT_CHAIN"
  logi "enabled"
}

stop() {
  remove_jump
  $IPT -t nat -F "$NAT_CHAIN" 2>/dev/null || true
  $IPT -t nat -X "$NAT_CHAIN" 2>/dev/null || true
  logi "disabled"
}

status() {
  echo "CHAIN=$NAT_CHAIN"
  $IPT -t nat -L "$NAT_CHAIN" -n -v 2>/dev/null || echo "not found"
}

case "$1" in
  start) start ;;
  stop) stop ;;
  restart) stop; start ;;
  status) status ;;
  *) echo "usage: $0 {start|stop|restart|status}" ;;
esac
