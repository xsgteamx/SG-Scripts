# SG-Router / wg81

ASUS Router WireGuard 运维模块

## 作用

该模块用于在 ASUS 原厂固件（SSH 环境）下：

- 手动创建 WireGuard 接口 `wg81`
- 替代 VPN Fusion
- 让路由器主动连接 SG-VPS
- 将家庭局域网（192.168.50.0/24）共享给 VPS

---

## 架构

```text
SG-VPS (10.8.0.1)
   ↑ WireGuard
ASUS Router (10.8.0.2)
   ↑ LAN bridge
192.168.50.0/24
```

---

## 特点

- ❌ 不依赖 DDNS
- ❌ 不依赖 wg-quick
- ❌ 不依赖 VPN Fusion
- ✔ 使用 wg / ip / iptables / cru
- ✔ watchdog 自动恢复

---

## 文件说明

| 文件 | 作用 |
|------|------|
| wg81ctl | 主运维脚本（菜单 + 自动修复） |
| wg81 | 短命令入口 |
| client.conf.example | WireGuard 客户端模板 |

---

## 使用方法

```sh
wg81 start
wg81 status
wg81 restart
wg81 logs
```

---

## 关键配置

必须包含：

- Endpoint = SG-VPS 公网 IP
- AllowedIPs = 10.8.0.0/24
- PersistentKeepalive = 25

---

## 注意事项

- 不要启用 0.0.0.0/0 路由（避免劫持路由器流量）
- ASUS 原厂固件 reboot 后需 watchdog 恢复
- wg81 接口必须与 LAN 转发规则匹配
