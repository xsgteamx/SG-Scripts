# SG-VPS / proxy

VPS 统一代理控制台。

该模块采用当前生产环境同款结构：

```text
/usr/local/bin/proxy*                     命令分发入口
/usr/local/lib/proxy-tools/proxy-core.sh  核心逻辑
/etc/proxy-tools.conf                     配置文件
```

## 命令入口

`proxy` 根据命令名自动分发：

```text
proxy                  菜单控制台
proxy-on              开启代理
proxy-off             关闭代理
proxy-status          查看状态
proxy-test            查看状态 / 连通性
proxy-use             切换默认源
docker-proxy-on       写入 Docker 代理配置
docker-proxy-off      删除 Docker 代理配置
docker-proxy-restart  重启 Docker
```

## 文件

| 文件 | 作用 |
|---|---|
| `proxy` | `/usr/local/bin/proxy*` 分发器 |
| `proxy-core.sh` | 代理核心逻辑与中文 UI |
| `proxy-tools.conf.example` | `/etc/proxy-tools.conf` 模板 |
| `install.example.sh` | 安装示例 |

## 功能

统一管理：

- 当前 Shell 环境变量
- `/etc/profile.d/proxy-env.sh`
- APT 代理
- Git 全局代理
- Wget 代理段
- Docker daemon systemd drop-in
- BT 面板进程重启，让 BT 继承最新环境变量

## 代理源

默认支持：

```text
mobaxterm    127.0.0.1:7890
mihomo       127.0.0.1:50000
```

## 终端大图预览

### `proxy`

```text
   _____ _____   ____                      _____           _
  / ____/ ____| |  _ \                    / ____|         | |
 | (___| |  __  | |_) | __ ___  ___   _  | |     ___ _ __ | |_ ___ _ __
  \___ \ | |_ | |  __/ "__/ _ \/ __| | | | |    / _ \ "_ \| __/ _ \ "__|
  ____) |__| |  | |  | | | (_) \__ \ |_| | |___|  __/ | | | ||  __/ |
 |_____/_____|  |_|  |_|  \___/|___/\__, |\_____\___|_| |_|\__\___|_|
                                      __/ |
                                     |___/
                  统一代理控制台 · proxy-on / proxy-off / proxy-use / proxy-status

◆ 当前状态
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  总体状态         ● 已开启  当前代理已完整启用
  默认代理源       VPS mihomo
  HTTP 代理        127.0.0.1:50000
  SOCKS 代理       127.0.0.1:50000
  当前端口         127.0.0.1:50000  ● 可连接
  直连规则         局域网 / Docker / WireGuard / EasyTier / 本地域名 / 自定义域名

◆ 代理源
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  [1] MobaXterm      127.0.0.1:7890         ● 可连接     备用
  [2] VPS mihomo     127.0.0.1:50000        ● 可连接     当前使用

◆ 模块状态
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  当前终端           ● 开启 127.0.0.1:50000
  持久终端           ● 开启 127.0.0.1:50000
  APT                ● 开启 127.0.0.1:50000
  Git                ● 开启 127.0.0.1:50000
  Wget               ● 开启 127.0.0.1:50000
  Docker 配置        ● 开启 127.0.0.1:50000
  Docker 运行时      ● 关闭
  BT 面板进程        ● 开启 127.0.0.1:50000

◆ 控制面板
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  1  开启代理        当前终端 + APT + Git + Wget + Docker 配置 + 重启 BT
  2  关闭代理        清理终端 / APT / Git / Wget / Docker 配置 / 重启 BT
  3  切换代理源      MobaXterm / VPS mihomo
  4  重启 Docker     让 Docker 代理配置立即生效
  5  重启 BT 面板    让宝塔重新继承当前环境变量
  6  刷新状态
  0  退出

请选择 >
```

## 隐私处理

公开仓库版本已移除私有域名信息。

默认 `PROXY_NO_PROXY` 只保留：

```text
localhost,127.0.0.1,::1,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,10.8.0.0/24,192.168.50.0/24,.local
```

如果生产环境需要额外直连私有域名，请只写入本机 `/etc/proxy-tools.conf`，不要提交到公开仓库。

## 部署

```sh
cd SG-VPS/proxy
./install.example.sh
```

## 使用

```sh
proxy
proxy-status
proxy-on
proxy-off
proxy-use mihomo
proxy-use mobaxterm
docker-proxy-restart
```

## 注意

- `proxy-on/off` 会按配置决定是否写入 Docker 代理配置。
- Docker daemon 代理配置写入后，需要重启 Docker 才会完全生效。
- `BT_RESTART_ON_CHANGE=true` 时，开启/关闭代理会重启 BT 面板。