# GitHub Actions Runner for LoongArch (loong64)

<p style="text-align:center"><a href="README.md">English</a> | <a href="README-zh.md">中文</a></p>

在 **LoongArch (loong64)**
机器上运行 [GitHub Actions 自托管运行器](https://docs.github.com/zh/actions/hosting-your-own-runners)的预构建 Docker 镜像。

## 概述

本项目提供开箱即用的 Docker 镜像，包含为 LoongArch 编译的 GitHub Actions Runner 二进制文件。镜像基于 **Debian 14**
(`lcr.loongnix.cn/debian:14`) 构建，提供两种变体：

| 变体          | 基础镜像                         | 说明             |
|---------------|----------------------------------|------------------|
| `debian`      | `lcr.loongnix.cn/debian:14`      | 完整 Debian 镜像 |
| `debian-slim` | `lcr.loongnix.cn/debian:14-slim` | 精简 Debian 镜像 |

## Docker 镜像

预构建镜像发布到以下容器仓库：

| 仓库           | 镜像路径                                                                    |
|----------------|-----------------------------------------------------------------------------|
| Docker Hub     | `kubernetesloong64/actions-runner-loong64`                                  |
| 阿里云（青岛） | `registry.cn-qingdao.aliyuncs.com/kubernetesloong64/actions-runner-loong64` |

### 镜像标签

```
# Docker Hub
kubernetesloong64/actions-runner-loong64:v2.336.0-debian
kubernetesloong64/actions-runner-loong64:v2.336.0-debian-slim

# 阿里云（青岛）
registry.cn-qingdao.aliyuncs.com/kubernetesloong64/actions-runner-loong64:v2.336.0-debian
registry.cn-qingdao.aliyuncs.com/kubernetesloong64/actions-runner-loong64:v2.336.0-debian-slim
```

### 从发布包加载

每个发布版本包含 `.tar` 压缩包，可直接下载并加载：

```shell
curl -LO https://github.com/kubernetes-loong64/actions-runner-loong64/releases/download/release-loong64-v2.336.0/actions-runner-loong64-v2.336.0-debian.tar
docker load -i actions-runner-loong64-v2.336.0-debian.tar
```

## 快速开始

### 使用 Docker Compose

```yaml
services:
  actions-runner:
    # 也可使用 Docker Hub: kubernetesloong64/actions-runner-loong64:v2.336.0-debian-slim
    image: registry.cn-qingdao.aliyuncs.com/kubernetesloong64/actions-runner-loong64:v2.336.0-debian-slim
    container_name: actions-runner
    restart: always
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      GITHUB_TOKEN: ghp_xxxxxxxxxxxxxxxxxxxx
      GITHUB_URL: https://github.com/your-org/your-repo
      RUNNER_NAME: my-loong64-runner
```

启动运行器：

```shell
docker compose up -d
```

### 使用 `docker run`

```shell
docker run -d \
  --name actions-runner \
  --restart always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e GITHUB_TOKEN=ghp_xxxxxxxxxxxxxxxxxxxx \
  -e GITHUB_URL=https://github.com/your-org/your-repo \
  -e RUNNER_NAME=my-loong64-runner \
  registry.cn-qingdao.aliyuncs.com/kubernetesloong64/actions-runner-loong64:v2.336.0-debian-slim
# 也可使用 Docker Hub 镜像：
# docker run -d ... kubernetesloong64/actions-runner-loong64:v2.336.0-debian-slim
```

## 环境变量

| 变量             | 必需           | 默认值               | 说明                                                                                                                                                       |
|------------------|----------------|----------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `GITHUB_TOKEN`   | 是（首次运行） | —                    | GitHub [个人访问令牌](https://docs.github.com/zh/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)或运行器注册令牌 |
| `GITHUB_URL`     | 是（首次运行） | `https://github.com` | GitHub 仓库或组织的 URL                                                                                                                                    |
| `RUNNER_NAME`    | 否             | `$(hostname)`        | 此运行器实例的名称                                                                                                                                         |
| `RUNNER_WORKDIR` | 否             | `/home/runner/_work` | 作业执行的工作目录                                                                                                                                         |
| `RUNNER_LABELS`  | 否             | —                    | 额外的标签（逗号分隔）                                                                                                                                     |
| `RUNNER_GROUP`   | 否             | —                    | 要加入的运行器组                                                                                                                                           |
| `EPHEMERAL`      | 否             | —                    | 设置为任意值以启用临时模式（运行器执行完一个作业后自动注销）                                                                                               |
| `RUNNER_ONCE`    | 否             | —                    | 设置为任意值以在完成一个作业后退出                                                                                                                         |

## 相关项目

| 项目                                                                                                      | 说明                                              |
|-----------------------------------------------------------------------------------------------------------|---------------------------------------------------|
| [loong64/runner](https://github.com/loong64/runner)                                                       | LoongArch 架构的 GitHub Actions Runner 二进制文件 |
| [kubernetes-loong64/cli-loong64](https://github.com/kubernetes-loong64/cli-loong64)                       | LoongArch 架构的 Docker CLI                       |
| [loongson-community/actions-runner-loong64](https://github.com/loongson-community/actions-runner-loong64) | 社区维护的 LoongArch actions-runner               |

## 验证发布

- 发布文件使用 GPG 签名。
- 从 [keys.openpgp.org](https://keys.openpgp.org) 下载公钥。
- 指纹：[FCF8724722CCBF9F51B1FBE376532BE7E3013105](https://keys.openpgp.org/debug?q=FCF8724722CCBF9F51B1FBE376532BE7E3013105)
- [手动下载](https://keys.openpgp.org/vks/v1/by-fingerprint/FCF8724722CCBF9F51B1FBE376532BE7E3013105)

```shell
gpg --keyserver keys.openpgp.org --recv-keys FCF8724722CCBF9F51B1FBE376532BE7E3013105
echo "FCF8724722CCBF9F51B1FBE376532BE7E3013105:6:" | gpg --import-ownertrust
```

或者，手动下载公钥文件后导入：

```shell
gpg --import /tmp/xxx
```

## 许可证

[Apache License 2.0](LICENSE)
