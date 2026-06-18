# SG-Router / VPS 运维注意事项

本目录记录 SG-VPS 侧配合 ASUS Router wg81 的运维重点。

## 目标链路

```text
SG-VPS
  wg-easy / wg0: 10.8.0.1
      ↓ WireGuard
ASUS Router
  wg81: 10.8.0.2
  br0: 192.168.50.1/24
      ↓
Home LAN: 192.168.50.0/24
```

## 1. wg-easy 必须使用 host 网络

推荐：

```yaml
services:
  wg-easy:
    image: ghcr.io/wg-easy/wg-easy:15
    container_name: wg-easy
    restart: unless-stopped
    network_mode: host
    volumes:
      - ./volumes/etc_wireguard:/etc/wireguard
      - /lib/modules:/lib/modules:ro
    cap_add:
      - NET_ADMIN
      - SYS_MODULE
    devices:
      - /dev/net/tun:/dev/net/tun
```

原因：

```text
network_mode: host
```

会让 `wg0` 直接出现在 SG-VPS 宿主机上。这样 Nginx、iptables、端口转发、ping、curl 都能直接走 `wg0` 访问家里 LAN。

如果 wg-easy 使用 bridge 网络，宿主机访问 `192.168.50.0/24` 会复杂很多，不推荐作为生产链路。

---

## 2. ASUS peer 的 Server Allowed IPs

在 wg-easy 中，ASUS Router 这个客户端的服务端 Allowed IPs 必须包含：

```text
10.8.0.2/32, 192.168.50.0/24
```

含义：

```text
10.8.0.2/32       → ASUS Router 的 WG 地址
192.168.50.0/24  → ASUS Router 后面的家里 LAN
```

如果只写：

```text
10.8.0.2/32
```

现象通常是：

```text
SG-VPS 能 ping 通 10.8.0.2
SG-VPS 不能 ping 通 192.168.50.1
```

临时修复命令：

```bash
PEER="$(wg show wg0 allowed-ips | awk '$0 ~ /10\.8\.0\.2\/32/ {print $1; exit}')"
wg set wg0 peer "$PEER" allowed-ips 10.8.0.2/32,192.168.50.0/24
```

---

## 3. SG-VPS 宿主机必须有 LAN 路由

必须存在：

```bash
ip route replace 192.168.50.0/24 dev wg0
```

检查：

```bash
ip route get 10.8.0.2
ip route get 192.168.50.1
ip route | grep -E '10\.8|192\.168\.50'
```

正常：

```text
10.8.0.2 dev wg0 src 10.8.0.1
192.168.50.1 dev wg0 src 10.8.0.1
```

异常：

```text
192.168.50.1 via 默认网关 dev eth0
```

如果出现异常，说明 LAN 流量没有进 WireGuard。

---

## 4. 61 与 81 不能同时宣告同一个 LAN

旧链路和新链路如果都宣告：

```text
192.168.50.0/24
```

会造成路由冲突。

建议：

```bash
systemctl disable --now wg-quick@wg-jcyz-lan 2>/dev/null || true
systemctl mask wg-quick@wg-jcyz-lan 2>/dev/null || true
```

只保留配置文件作为冷备，不要同时 up。

---

## 5. 重启后路由可能丢失

wg-easy 容器重启、SG-VPS 重启、wg0 重建后，手动添加的：

```bash
192.168.50.0/24 dev wg0
```

可能丢失。

建议部署本目录中的：

```text
wg-easy-home-route.sh
```

配合 systemd timer 每分钟兜底恢复。

---

## 6. 常用排障命令

```bash
wg show wg0
wg show wg0 allowed-ips
ip route get 192.168.50.1
ping -c 3 10.8.0.2
ping -c 3 192.168.50.1
curl -m 5 http://192.168.50.101:PORT/
```

## 7. 防火墙 / 安全组

SG-VPS 云厂商安全组需要放行 WireGuard UDP 端口，例如：

```text
UDP 51820
```

wg-easy Web UI 建议只绑定：

```text
127.0.0.1
```

再通过 SSH tunnel 或内网方式访问，避免直接暴露公网。
