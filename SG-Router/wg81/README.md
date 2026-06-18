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

## 界面预览

### `wg81 status`

```text
  ____   ____        __        ______ ____  _
 / ___| / ___|       \ \      / / ___|  _ \| |
 \___ \| |  _  _____  \ \ /\ / / |  _| |_) | |
  ___) | |_| ||_____|  \ V  V /| |_| |  __/| |
 |____/ \____|          \_/\_/  \____|_|   |_|
SG-WG81  ASUS Router WireGuard 运维脚本  v1.2
────────────────────────────────────────────
接口         wg81
配置文件     /jffs/wg81/client.conf
WG网段       10.8.0.0/24
家里LAN      192.168.50.0/24
────────────────────────────────────────────
✔ client.conf 存在且字段完整
✔ wg81 接口存在
interface: wg81
  public key: <hidden>
  private key: (hidden)
  listening port: 51771

peer: <hidden>
  endpoint: YOUR_VPS_PUBLIC_IP:51820
  allowed ips: 10.8.0.0/24
  latest handshake: 58 seconds ago
  persistent keepalive: every 30 seconds
✔ SG-VPS 10.8.0.1 可达
✔ 自愈任务已安装
```

### `wg81` 菜单

```text
1) 启动
2) 停止
3) 重启
4) 状态
5) 体检
6) 安装自愈
7) 移除自愈
8) 日志
0) 退出
输入序号：
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