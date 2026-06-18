# SG-VPS / proxy

VPS 代理统一管理脚本。

## 作用

统一管理 VPS 上常见代理场景：

- Shell 环境变量
- APT 代理
- Git 全局代理
- Docker systemd 代理
- 代理连通性测试

## 代理源

默认支持两个代理源：

```text
moba    → MobaXterm / 本机转发代理，例如 127.0.0.1:7890
mihomo  → VPS 本机 mihomo，例如 127.0.0.1:50000 / 50001
```

## 文件

| 文件 | 作用 |
|---|---|
| `proxy` | 主脚本 |
| `proxy.env.example` | 配置模板 |

## 推荐部署

```sh
sudo install -m 755 proxy /usr/local/bin/proxy
sudo install -m 644 proxy.env.example /etc/sg-proxy.env
```

## 使用

```sh
proxy status
proxy on mihomo
proxy on moba
proxy off
proxy test
```

## 注意

脚本会修改：

```text
/etc/profile.d/sg-proxy.sh
/etc/apt/apt.conf.d/99-sg-proxy.conf
~/.gitconfig
/etc/systemd/system/docker.service.d/http-proxy.conf
```

如果启用 Docker 代理，脚本会执行：

```sh
systemctl daemon-reload
systemctl restart docker
```

使用前请确认当前服务是否允许 Docker 重启。