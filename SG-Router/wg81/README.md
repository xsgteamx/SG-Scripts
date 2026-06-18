# SG-Router / wg81

ASUS Router WireGuard 运维模块。

## 作用

该模块用于在 ASUS 原厂固件 SSH 环境下：

- 手动创建 WireGuard 接口 `wg81`
- 替代 ASUS VPN Fusion
- 让路由器主动连接 SG-VPS
- 将家庭局域网共享给 VPS
- 在断网恢复后自动重建隧道

## 架构

```text
SG-VPS
  wg0: 10.8.0.1
      ↓ WireGuard
ASUS Router
  wg81: 10.8.0.2
  br0: 192.168.50.1/24
      ↓
Home LAN: 192.168.50.0/24
```

## 特点

- 不依赖 DDNS
- 不依赖 wg-quick
- 不依赖 VPN Fusion
- 使用 `wg + ip + iptables + cru`
- 自带菜单、状态、体检、日志、自愈任务

## 文件说明

| 文件 | 作用 |
|---|---|
| `wg81ctl` | 主运维脚本 |
| `wg81` | 短命令入口 |
| `client.conf.example` | 客户端配置模板 |

## 部署路径

推荐放置：

```text
/jffs/wg81/wg81ctl
/jffs/wg81/wg81
/jffs/wg81/client.conf
```

## 使用

```sh
wg81
wg81 start
wg81 status
wg81 doctor
wg81 restart
wg81 logs
wg81 install
```

## client.conf 关键要求

客户端配置不要使用全局路由：

```ini
AllowedIPs = 10.8.0.0/24
```

不要写：

```ini
AllowedIPs = 0.0.0.0/0
```

否则可能导致 ASUS 路由器自身默认路由被劫持。

## 路由器侧 iptables 逻辑

脚本会自动维护：

```text
wg81 → br0 FORWARD ACCEPT
br0 → wg81 FORWARD ACCEPT
10.8.0.0/24 → 192.168.50.0/24 MASQUERADE
```

这样 SG-VPS 可以通过 wg81 访问家庭 LAN。

## 自愈

安装自愈任务：

```sh
wg81 install
```

对应 cron：

```text
*/1 * * * * /jffs/wg81/wg81ctl watch
```

## 与 VPS 侧配合

VPS 侧必须满足：

```text
ASUS peer Server Allowed IPs = 10.8.0.2/32, 192.168.50.0/24
VPS route = 192.168.50.0/24 dev wg0
```

详细见：

```text
SG-Router/VPS/README.md
```
