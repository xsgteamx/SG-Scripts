# SG-Router

ASUS Router 与 SG-VPS 联动运维脚本集合。

## 模块

```text
SG-Router/
├── wg81/   # ASUS Router WireGuard 客户端与 LAN 共享
├── cs2fw/  # CS2 WG → LAN 回程 SNAT 修正
└── VPS/    # SG-VPS wg-easy 运维注意事项与路由自愈
```

## 总体拓扑

```text
Internet
  ↓
SG-VPS
  wg0: 10.8.0.1
  ↓ WireGuard
ASUS Router
  wg81: 10.8.0.2
  br0: 192.168.50.1/24
  ↓
Home LAN: 192.168.50.0/24
```

## 核心原则

- ASUS 主动连接 SG-VPS，避免家里公网 IP / DDNS 变化导致链路断开。
- ASUS 原厂固件不依赖 `wg-quick`，使用 `wg + ip + iptables + cru`。
- SG-VPS 侧必须把 `192.168.50.0/24` 路由到 `wg0`。
- wg-easy 中 ASUS peer 的 Server Allowed IPs 必须包含家庭 LAN 网段。

## 脱敏说明

仓库内所有地址均为示例值：

- `YOUR_VPS_PUBLIC_IP` 表示 VPS 公网 IP
- `YOUR_PRIVATE_KEY` / `YOUR_PUBLIC_KEY` 表示 WireGuard 密钥占位符
- `10.8.0.1` / `10.8.0.2` 是示例隧道地址
- `192.168.50.0/24` 是示例家庭 LAN 网段
