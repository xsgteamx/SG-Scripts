# SG-VPS / codex-sudo

codex 用户 sudo 权限管理脚本。

## 作用

用于在 VPS 上集中管理 `codex` 用户的 sudo 权限。

目标：

- 默认安全：不开放免密 sudo
- 需要时临时开启 sudo
- 支持 NOPASSWD / PASSWD 两种模式
- 支持关闭 sudo
- 支持状态查看
- 避免手工散落多个 sudoers 文件

## 文件

| 文件 | 作用 |
|---|---|
| `codex-sudo` | 主脚本 |
| `sudoers.example` | sudoers 模板说明 |

## 推荐部署

```sh
sudo install -m 755 codex-sudo /usr/local/sbin/codex-sudo
```

## 使用

```sh
sudo codex-sudo status
sudo codex-sudo off
sudo codex-sudo pass
sudo codex-sudo nopass
```

## 模式说明

### off

删除脚本管理的 sudoers 文件。

```text
codex 不获得脚本授予的 sudo 权限
```

### pass

允许 `codex` 使用 sudo，但需要输入密码。

```text
codex ALL=(ALL:ALL) PASSWD:ALL
```

### nopass

允许 `codex` 免密 sudo。

```text
codex ALL=(ALL:ALL) NOPASSWD:ALL
```

该模式风险较高，只建议临时开启。

## 安全建议

- 默认保持 `off` 或 `pass`
- 不建议长期 `nopass`
- 每次修改后使用 `visudo -cf` 校验
- 避免在多个 `/etc/sudoers.d/*` 文件里重复授予 codex 权限
