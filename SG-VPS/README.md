# SG-VPS

SG-VPS 运维脚本集合。

## 模块

```text
SG-VPS/
├── proxy/       # VPS 代理统一开关与状态检测
└── codex-sudo/  # codex 用户 sudo 权限开关管理
```

## 目标

把 VPS 上常用但容易散落的运维脚本统一归档，包括：

- APT / Git / Docker / Shell 代理统一管理
- mihomo / MobaXterm 代理源切换
- codex 用户 sudo 权限开关
- sudoers 文件审计与回滚

## 脱敏原则

本目录不包含：

- 真实密码
- API Key
- 私钥
- 真实公网服务凭据

所有配置均使用 `.example` 模板。