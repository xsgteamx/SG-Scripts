# SG-Router / cs2fw

CS2 WG → LAN NAT 修复模块。

## 作用

用于解决 CS2（或类似 UDP 游戏服务）在以下链路中的回程问题：

```text
SG-VPS → WireGuard → ASUS Router → LAN Game Server
```

## 问题背景

当 VPS 转发 UDP 流量到家里 CS2 服务器时：

- 回包可能走错路由
- NAT 不一致导致连接失败
- 多端口 UDP 不稳定

## 解决方案

通过 ASUS Router 上的 iptables：

- SNAT VPS WG 来源流量
- 强制回包路径稳定

## 默认链路

```text
VPS (10.8.0.1)
  ↓ WG
ASUS (10.8.0.2)
  ↓ NAT
192.168.50.101 (CS2 Server)
```

## 规则逻辑

- iptables NAT POSTROUTING
- 自定义 chain: `SG_CS2FW_SNAT`
- 支持 UDP / TCP
- 支持多端口

## 配置文件

见 `cs2fw.env.example`

## 使用方式

```sh
cs2fw start
cs2fw status
cs2fw restart
cs2fw logs
```

## 界面预览

### `cs2fw status`

```text
   ██████╗███████╗██████╗     ███████╗██╗    ██╗
  ██╔════╝██╔════╝╚════██╗    ██╔════╝██║    ██║
  ██║     ███████╗ █████╔╝    █████╗  ██║ █╗ ██║
  ██║     ╚════██║██╔═══╝     ██╔══╝  ██║███╗██║
  ╚██████╗███████║███████╗    ██║     ╚███╔███╔╝
   ╚═════╝╚══════╝╚══════╝    ╚═╝      ╚══╝╚══╝
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SG-CS2FW  WireGuard → LAN NAT Engine  v1.2
MODE   PROXY-SNAT
CHAIN  SG_CS2FW_SNAT
SRC    10.8.0.1
DST    192.168.50.101
PORT   27015
PROTO  udp tcp
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
配置文件     /jffs/cs2fw/cs2fw.env
启用状态     1
WG接口       wg81
LAN接口      br0
VPS_WG_IPS   10.8.0.1
目标主机     192.168.50.101
路由器LAN    192.168.50.1
端口         27015
协议         udp tcp
NAT链        SG_CS2FW_SNAT
────────────────────────────────────────────
✔ SG_CS2FW_SNAT 存在
✔ POSTROUTING 跳转已安装
✔ 自愈任务已安装
*/5 * * * * /jffs/scripts/cs2-wg-snat.sh watch #sg_cs2fw_watch#
```

## 安全原则

- 不写死公网 IP
- 不存储密钥
- 所有参数通过 env 控制