# SG-Scripts

个人轻量云 / 家庭网络 / 自托管服务运维脚本仓库。

## 目录

```text
SG-Scripts/
├── SG-Router/
│   ├── wg81/   ASUS WireGuard site-to-site + LAN export
│   ├── cs2fw/  CS2 UDP/TCP NAT repair
│   └── VPS/    SG-VPS wg-easy route recovery notes
└── SG-VPS/
    ├── proxy/       VPS proxy switcher
    └── codex-sudo/  codex sudo controller
```

## 模块入口

- [`SG-Router/wg81`](SG-Router/wg81/)：ASUS Router 侧 WireGuard 运维脚本。
- [`SG-Router/cs2fw`](SG-Router/cs2fw/)：CS2 端口转发回程 SNAT 修复。
- [`SG-Router/VPS`](SG-Router/VPS/)：SG-VPS 侧 wg-easy 与路由自愈注意事项。
- [`SG-VPS/proxy`](SG-VPS/proxy/)：VPS 统一代理控制台。
- [`SG-VPS/codex-sudo`](SG-VPS/codex-sudo/)：codex 用户 sudo 权限严格控制面板。

## 安全原则

- 不提交私钥、PSK、密码、API Key。
- 不提交真实公网 IP、真实私有域名。
- 生产环境参数只放本机配置文件，不写入公开仓库。

具体说明、菜单预览和运维细节请进入对应模块 README。