# SG-Scripts

个人轻量云 / 家庭网络 / 自托管服务运维脚本仓库。

## 当前架构

```text
SG-Scripts/
└── SG-Router/
    ├── README.md
    ├── wg81/   (ASUS WireGuard site-to-site + LAN export)
    ├── cs2fw/  (CS2 UDP/TCP NAT repair)
    └── VPS/    (SG-VPS wg-easy operations and route recovery)
```

## SG-Router / wg81

功能：

- ASUS Router 原厂固件 SSH 手动 WireGuard 管理
- 替代 VPN Fusion
- 路由器主动连接 SG-VPS（10.8.0.0/24）
- 将 192.168.50.0/24 LAN 共享到 VPS

关键设计：

- 不使用 DDNS
- 不依赖 wg-quick
- 使用 wg + ip + iptables + cru
- watchdog 自动恢复

## SG-Router / cs2fw

功能：

- 修复 CS2 UDP/TCP 转发回程问题
- SG-VPS → WG → ASUS → LAN
- SNAT 保证游戏服务器回包路径稳定

关键设计：

- iptables nat 自定义 chain
- 支持多端口（27015 默认）
- 支持 env 配置化

## SG-Router / VPS

功能：

- 记录 SG-VPS wg-easy 运维注意事项
- 固化 `192.168.50.0/24 dev wg0` 路由恢复方案
- 说明 wg-easy Server Allowed IPs 的关键配置
- 避免旧 61 链路和新 81 链路同时宣告家庭 LAN

## 安全原则

- 不存储私钥
- 不存储公网 IP
- 不存储 PSK
- 不写死生产环境参数

## 部署环境

- ASUS RT-AX86U Pro（原厂固件）
- /jffs 可写
- 支持 wg / ip / iptables / cru
- SG-VPS 使用 wg-easy host network 模式

## 网络拓扑

```text
Internet
   ↓
SG-VPS (wg0: 10.8.0.1)
   ↓
ASUS Router (wg81: 10.8.0.2)
   ↓
LAN: 192.168.50.0/24
```
