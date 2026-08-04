# GitHub Actions Runner for LoongArch (loong64)

<p style="text-align:center"><a href="README.md">English</a> | <a href="README-zh.md">中文</a></p>

Prebuilt Docker images for
running [GitHub Actions self-hosted runners](https://docs.github.com/en/actions/hosting-your-own-runners) on
**LoongArch (loong64)** machines.

## Overview

This project provides ready-to-use Docker images that bundle the GitHub Actions runner binary compiled for LoongArch.
Images are built on **Debian 14** (`lcr.loongnix.cn/debian:14`) with two variants:

| Variant       | Base Image                       | Description          |
|---------------|----------------------------------|----------------------|
| `debian`      | `lcr.loongnix.cn/debian:14`      | Full Debian image    |
| `debian-slim` | `lcr.loongnix.cn/debian:14-slim` | Minimal Debian image |

## Docker Images

Prebuilt images are published to the following registries:

| Registry                | Image Path                                                                  |
|-------------------------|-----------------------------------------------------------------------------|
| Docker Hub              | `kubernetesloong64/actions-runner-loong64`                                  |
| Alibaba Cloud (Qingdao) | `registry.cn-qingdao.aliyuncs.com/kubernetesloong64/actions-runner-loong64` |

### Image Tags

```
# Docker Hub
kubernetesloong64/actions-runner-loong64:v2.336.0-debian
kubernetesloong64/actions-runner-loong64:v2.336.0-debian-slim

# Alibaba Cloud (Qingdao)
registry.cn-qingdao.aliyuncs.com/kubernetesloong64/actions-runner-loong64:v2.336.0-debian
registry.cn-qingdao.aliyuncs.com/kubernetesloong64/actions-runner-loong64:v2.336.0-debian-slim
```

### Load from Release Artifacts

Each release includes `.tar` archives you can download and load directly:

```shell
curl -LO https://github.com/kubernetes-loong64/actions-runner-loong64/releases/download/release-loong64-v2.336.0/actions-runner-loong64-v2.336.0-debian.tar
docker load -i actions-runner-loong64-v2.336.0-debian.tar
```

## Quick Start

### Using Docker Compose

```yaml
services:
  actions-runner:
    # Or use Docker Hub: kubernetesloong64/actions-runner-loong64:v2.336.0-debian-slim
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

Then start the runner:

```shell
docker compose up -d
```

### Using `docker run`

```shell
docker run -d \
  --name actions-runner \
  --restart always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e GITHUB_TOKEN=ghp_xxxxxxxxxxxxxxxxxxxx \
  -e GITHUB_URL=https://github.com/your-org/your-repo \
  -e RUNNER_NAME=my-loong64-runner \
  registry.cn-qingdao.aliyuncs.com/kubernetesloong64/actions-runner-loong64:v2.336.0-debian-slim
# Or use Docker Hub image:
# docker run -d ... kubernetesloong64/actions-runner-loong64:v2.336.0-debian-slim
```

## Environment Variables

| Variable         | Required        | Default              | Description                                                                                                                                                                      |
|------------------|-----------------|----------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `GITHUB_TOKEN`   | Yes (first run) | —                    | GitHub [personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens) or runner registration token |
| `GITHUB_URL`     | Yes (first run) | `https://github.com` | URL of the GitHub repository or organization                                                                                                                                     |
| `RUNNER_NAME`    | No              | `$(hostname)`        | Name for this runner instance                                                                                                                                                    |
| `RUNNER_WORKDIR` | No              | `/home/runner/_work` | Working directory for job execution                                                                                                                                              |
| `RUNNER_LABELS`  | No              | —                    | Extra labels to assign (comma-separated)                                                                                                                                         |
| `RUNNER_GROUP`   | No              | —                    | Runner group to join                                                                                                                                                             |
| `EPHEMERAL`      | No              | —                    | Set to any value to run in ephemeral mode (runner deregisters after a single job)                                                                                                |
| `RUNNER_ONCE`    | No              | —                    | Set to any value to exit after completing one job                                                                                                                                |

## Related Projects

| Project                                                                                                   | Description                                   |
|-----------------------------------------------------------------------------------------------------------|-----------------------------------------------|
| [loong64/runner](https://github.com/loong64/runner)                                                       | GitHub Actions Runner binaries for LoongArch  |
| [kubernetes-loong64/cli-loong64](https://github.com/kubernetes-loong64/cli-loong64)                       | Docker CLI built for LoongArch                |
| [loongson-community/actions-runner-loong64](https://github.com/loongson-community/actions-runner-loong64) | Community-maintained LoongArch actions-runner |

## Verifying Releases

- Releases are signed with GPG.
- Download the public key from [keys.openpgp.org](https://keys.openpgp.org).
- Fingerprint: [FCF8724722CCBF9F51B1FBE376532BE7E3013105](https://keys.openpgp.org/debug?q=FCF8724722CCBF9F51B1FBE376532BE7E3013105)
- [Manual download](https://keys.openpgp.org/vks/v1/by-fingerprint/FCF8724722CCBF9F51B1FBE376532BE7E3013105)

```shell
gpg --keyserver keys.openpgp.org --recv-keys FCF8724722CCBF9F51B1FBE376532BE7E3013105
echo "FCF8724722CCBF9F51B1FBE376532BE7E3013105:6:" | gpg --import-ownertrust
```

Or download the key file manually and import it:

```shell
gpg --import /tmp/xxx
```

## License

[Apache License 2.0](LICENSE)
