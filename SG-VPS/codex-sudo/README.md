# SG-VPS / codex-sudo

codex 用户 sudo 权限控制面板 · 严格版。

当前脚本版本：

```text
sg-strict-2026.06.12
```

## 作用

用于在 VPS 上集中管理 `codex` 用户的 sudo 权限，重点解决：

- 临时开启免密 sudo
- 严格撤销 sudo
- 密码 sudo 且控制 sudo 缓存时间
- 审计 sudoers 残留规则
- 防止 `codex` 用户通过 sudo 给自己恢复 sudo 权限

## 文件

| 文件 | 作用 |
|---|---|
| `codex-sudo` | 主控制面板脚本 |
| `sudoers.example` | sudoers 规则示例 |

## 推荐部署

```sh
sudo install -m 755 codex-sudo /usr/local/sbin/codex-sudo
```

## 使用

打开数字菜单：

```sh
sudo codex-sudo
```

直接命令：

```sh
sudo codex-sudo status
sudo codex-sudo on
sudo codex-sudo off
sudo codex-sudo pass
sudo codex-sudo pass 5
sudo codex-sudo audit
sudo codex-sudo shell
```

## 菜单功能

```text
[1] 开启免密 sudo                 危险：codex≈root
[2] 严格撤销 sudo                推荐：清规则 + 清缓存 + 查残留
[3] 密码 sudo：每次都输密码      timestamp_timeout=0
[4] 密码 sudo：缓存 1 分钟       timestamp_timeout=1
[5] 密码 sudo：缓存 5 分钟       timestamp_timeout=5
[6] 密码 sudo：自定义分钟
[7] 安全审计
[8] 进入 codex 安全 shell
[9] 通过 codex 的 sudo 执行命令
[0] 退出
```

## 安全设计

### 防止 codex 自授权

脚本会检查：

```text
SUDO_USER
SUDO_UID
```

如果检测到目标用户正在通过 sudo 运行本脚本，会拒绝创建或恢复 sudo 权限。

### 严格撤销

`codex-sudo off` 会：

- 删除本脚本生成的 sudoers 规则
- 删除已知的 Codex session 免密规则
- 清理文件名包含目标用户且含 NOPASSWD 的 sudoers.d 文件
- 从 sudo/admin/wheel 组移除目标用户
- 清理 sudo 时间戳缓存
- 执行 `visudo -c`
- 执行撤销后审计

### 审计

`codex-sudo audit` 会输出：

- 用户与组
- `sudo -l -U codex`
- `/etc/sudoers` 与 `/etc/sudoers.d` 中相关规则
- 清缓存后的免密 sudo 测试

## 环境变量

默认目标用户是 `codex`：

```sh
sudo codex-sudo
```

也可临时切换目标用户：

```sh
sudo CODEX_SUDO_USER=someuser codex-sudo status
```

## 备份目录

严格撤销时会备份被删除的 sudoers 文件：

```text
/root/sg-backup/codex-sudo/<user>-<timestamp>/
```

## 注意

`sudo` 原生按“分钟”缓存认证，不按“次数”缓存。每次都输密码请使用：

```sh
sudo codex-sudo pass
```

或菜单 `[3]`。